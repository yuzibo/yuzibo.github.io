---
title: "linux 网络流程"
category: network
layout: article
---

# 参考

[here](https://wiki.linuxfoundation.org/networking/kernel_flow)


# 基本分析

首先记住，linux kernel networking layers 分为L2(link layer)、L3（ipv4、ipv6)、L4(TCP/UDP)

## Network Device

Network device drivers 就在L2中，与此对应的，你应该知道net_device结构，这是对network stack理解的基础。

```c
struct net_device {
	char			name[IFNAMSIZE];
	struct	hlist_node	name_hlist;
	char			*ifalias;
	/* I/O specific fields */
	unsigned long		men_end;
	unsigned long		men_start;
	unsigned long		base_addr;
	int			irq;
	...
	const struct net_device_ops *netdev_ops;
	const struct ethtool_ops *ethtool_ops;

	const struct header_ops *header_ops;

	unsigned int		flags;
	unsigned int		priv_flags;

	unsigned short		gflags;
	unsigned short		padded;

	unsigned char		operstate;
	unsigned char		link_mode;

	unsigned char		if_port;
	unsigned char		dma;

	unsigned int		mtu;
	unsigned int		min_mtu;
	unsigned int		max_mtu;
	unsigned short		type;
	unsigned short		hard_header_len;
	unsigned char		min_header_len;
	...
};

```

最好的方式是阅读源代码的注释。

当promiscuity计数器大于0的时候，网络栈不会丢弃不是发给本地主机的包。

## NAPI

在old版本中的网络内核中，网络设备驱动是工作在中断驱动模式下的，这就意味着当内核接收到一个packet时，就会陷入中断，这种模式，已经被证明是低效的，尤其是在高负载的情况下。

所以，内核就引入了NAPI(New API)模式，这样， 网络就会工作在polling模式下，当接收到一个包，会缓存进入网络buffer，而不是基于中断驱动了。然后再一个一个进行解包。

对于每一个包，网络子系统在处理的时候，会依据路由子系统对包对出相应的处理从而决定是转发还是发送哪一个接口。路由子系统不是影响这个唯一的因素，比如，在netfilter子系统，有5个钩子函数可以被注册。头一个是NF_INET_PRE_ROUTING.当一个packet被一个由宏NF_HOOK()引发的回调函数处理的时候，它将会根据verdict回调函数继续在内核栈中旅行，比如， 如果verdict是NF_DROP，这个包将会被丢弃;如果verdict是NF_ACCEPT,这个包继续往下;netfilter回调是被nf_register_hook()方法或者nf_register_hooks()方法注册的。

除了netfilter钩子函数，IPsec子系统也会影响包的去行。Ipsec提供了一个网络层的安全解决方案，并且它使用ESP和AH协议。IPsec在IPV6中是强制的，在IPv4中是可选的。它有两种操作模式：传输模式和隧道模式。这是实现一些VPN(virtual private network)方案的基础，当然，也有一些非Ipsec实现VPN的VPN。

这里还有其他因素决定网络包的行程。比如， 被转发包中Ipv4中头部ttl的值。当packet被转发一个设备，ttl的值就会减1.当他为0的时候，这个packet就会丢弃，并且一个ICMPv4消息："时间超出"随着"ttl count exceeded"的代码返回。每转发一次，这个ttl就会减1.在Ipv6中ttl被替换为hop_limit.

packet在内核中的旅行有很多的变动：大的包在发送之前会被分拆;另一方面，被分拆的包需要组装。不同的包处理的方式也是不同的，比如，多播packet被一组主机处理(这一点很明显与目的地址是特定的单播packets不同)。多播技术可以用在流媒体，这样可以减少网络资源。在ipv4中，The Internet Group Management Protocol(IGMP)处理多波成员。

为了更好的理解网络的流程，你需要知道sk_buff,无论是Rx，还是Tx，都离不开这个结构。<include/linux/skbuff.h>

```c

/**
 *	struct sk_buff - socket buffer
 *	@next: Next buffer in list
 *	@prev: Previous buffer in list
 *	@tstamp: Time we arrived/left
 *	@rbnode: RB tree node, alternative to next/prev for netem/tcp
 *	@sk: Socket we are owned by
 *	@dev: Device we arrived on/are leaving by
 *	@cb: Control buffer. Free for use by every layer. Put private vars here
 *	@_skb_refdst: destination entry (with norefcount bit)
 *	@sp: the security path, used for xfrm
 *	@len: Length of actual data
 *	@data_len: Data length
 *	@mac_len: Length of link layer header
 *	@hdr_len: writable header length of cloned skb
 *	@csum: Checksum (must include start/offset pair)
 *	@csum_start: Offset from skb->head where checksumming should start
 *	@csum_offset: Offset from csum_start where checksum should be stored
 *	@priority: Packet queueing priority
 *	@ignore_df: allow local fragmentation
 *	@cloned: Head may be cloned (check refcnt to be sure)
 *	@ip_summed: Driver fed us an IP checksum
 *	@nohdr: Payload reference only, must not modify header
 *	@pkt_type: Packet class
 *	@fclone: skbuff clone status
 *	@ipvs_property: skbuff is owned by ipvs
 *	@tc_skip_classify: do not classify packet. set by IFB device
 *	@tc_at_ingress: used within tc_classify to distinguish in/egress
 *	@tc_redirected: packet was redirected by a tc action
 *	@tc_from_ingress: if tc_redirected, tc_at_ingress at time of redirect
 *	@peeked: this packet has been seen already, so stats have been
 *		done for it, don't do them again
 *	@nf_trace: netfilter packet trace flag
 *	@protocol: Packet protocol from driver
 *	@destructor: Destruct function
 *	@_nfct: Associated connection, if any (with nfctinfo bits)
 *	@nf_bridge: Saved data about a bridged frame - see br_netfilter.c
 *	@skb_iif: ifindex of device we arrived on
 *	@tc_index: Traffic control index
 *	@hash: the packet hash
 *	@queue_mapping: Queue mapping for multiqueue devices
 *	@xmit_more: More SKBs are pending for this queue
 *	@ndisc_nodetype: router type (from link layer)
 *	@ooo_okay: allow the mapping of a socket to a queue to be changed
 *	@l4_hash: indicate hash is a canonical 4-tuple hash over transport
 *		ports.
 *	@sw_hash: indicates hash was computed in software stack
 *	@wifi_acked_valid: wifi_acked was set
 *	@wifi_acked: whether frame was acked on wifi or not
 *	@no_fcs:  Request NIC to treat last 4 bytes as Ethernet FCS
 *	@dst_pending_confirm: need to confirm neighbour
  *	@napi_id: id of the NAPI struct this skb came from
 *	@secmark: security marking
 *	@mark: Generic packet mark
 *	@vlan_proto: vlan encapsulation protocol
 *	@vlan_tci: vlan tag control information
 *	@inner_protocol: Protocol (encapsulation)
 *	@inner_transport_header: Inner transport layer header (encapsulation)
 *	@inner_network_header: Network layer header (encapsulation)
 *	@inner_mac_header: Link layer header (encapsulation)
 *	@transport_header: Transport layer header
 *	@network_header: Network layer header
 *	@mac_header: Link layer header
 *	@tail: Tail pointer
 *	@end: End pointer
 *	@head: Head of buffer
 *	@data: Data head pointer
 *	@truesize: Buffer size
 *	@users: User count - see {datagram,tcp}.c
 */

struct sk_buff {
	union {
		struct {
			/* These two members must be first. */
			struct sk_buff		*next;
			struct sk_buff		*prev;

			union {
				ktime_t		tstamp;
				struct skb_mstamp skb_mstamp;
			};
		};
		struct rb_node	rbnode; /* used in netem & tcp stack */
	};
	struct sock		*sk;

	union {
		struct net_device	*dev;
		/* Some protocols might use this space to store information,
		 * while device pointer would be NULL.
		 * UDP receive path is one user.
		 */
		unsigned long		dev_scratch;
	};
	/*
	 * This is the control buffer. It is free to use for every
	 * layer. Please put your private variables there. If you
	 * want to keep them across layers you have to do a skb_clone()
	 * first. This is owned by whoever has the skb queued ATM.
	 */
	char			cb[48] __aligned(8);

	unsigned long		_skb_refdst;
	void			(*destructor)(struct sk_buff *skb);
#ifdef CONFIG_XFRM
	struct	sec_path	*sp;
#endif
#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
	unsigned long		 _nfct;
#endif
#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
	struct nf_bridge_info	*nf_bridge;
#endif
	unsigned int		len,
				data_len;
	__u16			mac_len,
				hdr_len;

	/* Following fields are _not_ copied in __copy_skb_header()
	 * Note that queue_mapping is here mostly to fill a hole.
	 */
	kmemcheck_bitfield_begin(flags1);
	__u16			queue_mapping;

/* if you move cloned around you also must adapt those constants */
#ifdef __BIG_ENDIAN_BITFIELD
#define CLONED_MASK	(1 << 7)
#else
#define CLONED_MASK	1
#endif
#define CLONED_OFFSET()		offsetof(struct sk_buff, __cloned_offset)

	__u8			__cloned_offset[0];
	__u8			cloned:1,
				nohdr:1,
				fclone:2,
				peeked:1,
				head_frag:1,
				xmit_more:1,
				__unused:1; /* one bit hole */
	kmemcheck_bitfield_end(flags1);

	/* fields enclosed in headers_start/headers_end are copied
	 * using a single memcpy() in __copy_skb_header()
	 */
	/* private: */
	__u32			headers_start[0];
	/* public: */

/* if you move pkt_type around you also must adapt those constants */
#ifdef __BIG_ENDIAN_BITFIELD
#define PKT_TYPE_MAX	(7 << 5)
#else
#define PKT_TYPE_MAX	7
#endif
#define PKT_TYPE_OFFSET()	offsetof(struct sk_buff, __pkt_type_offset)

	__u8			__pkt_type_offset[0];
	__u8			pkt_type:3;
	__u8			pfmemalloc:1;
	__u8			ignore_df:1;

	__u8			nf_trace:1;
	__u8			ip_summed:2;
	__u8			ooo_okay:1;
	__u8			l4_hash:1;
	__u8			sw_hash:1;
	__u8			wifi_acked_valid:1;
	__u8			wifi_acked:1;

	__u8			no_fcs:1;
	/* Indicates the inner headers are valid in the skbuff. */
	__u8			encapsulation:1;
	__u8			encap_hdr_csum:1;
	__u8			csum_valid:1;
	__u8			csum_complete_sw:1;
	__u8			csum_level:2;
	__u8			csum_bad:1;

	__u8			dst_pending_confirm:1;
#ifdef CONFIG_IPV6_NDISC_NODETYPE
	__u8			ndisc_nodetype:2;
#endif
	__u8			ipvs_property:1;
	__u8			inner_protocol_type:1;
	__u8			remcsum_offload:1;
#ifdef CONFIG_NET_SWITCHDEV
	__u8			offload_fwd_mark:1;
#endif
#ifdef CONFIG_NET_CLS_ACT
	__u8			tc_skip_classify:1;
	__u8			tc_at_ingress:1;
	__u8			tc_redirected:1;
	__u8			tc_from_ingress:1;
#endif

#ifdef CONFIG_NET_SCHED
	__u16			tc_index;	/* traffic control index */
#endif

	union {
		__wsum		csum;
		struct {
			__u16	csum_start;
			__u16	csum_offset;
		};
	};
	__u32			priority;
	int			skb_iif;
	__u32			hash;
	__be16			vlan_proto;
	__u16			vlan_tci;
#if defined(CONFIG_NET_RX_BUSY_POLL) || defined(CONFIG_XPS)
	union {
		unsigned int	napi_id;
		unsigned int	sender_cpu;
	};
#endif
#ifdef CONFIG_NETWORK_SECMARK
	__u32		secmark;
#endif

	union {
		__u32		mark;
		__u32		reserved_tailroom;
	};

	union {
		__be16		inner_protocol;
		__u8		inner_ipproto;
	};

	__u16			inner_transport_header;
	__u16			inner_network_header;
	__u16			inner_mac_header;

	__be16			protocol;
	__u16			transport_header;
	__u16			network_header;
	__u16			mac_header;

	/* private: */
	__u32			headers_end[0];
	/* public: */

	/* These elements must be at the end, see alloc_skb() for details.  */
	sk_buff_data_t		tail;
	sk_buff_data_t		end;
	unsigned char		*head,
				*data;
	unsigned int		truesize;
	atomic_t		users;
};

```

就捡着重要的知识说一说。你要熟悉SKB的API。

[Update]: sk_buff包含３个联合体，每一个对应着内核网络层。分别是：

```c
transport_header();
/*tcp udp icmp and more  */

network_header();
/*ip ipv6 arp*/

mac_header();
#link layer
```

如果你想使用skb->data,你不应该直接使用它，相反，你应该这样

```c
skb_pull_inline();
/* 或者 */

skb_pull();
```

如果你想fetch L4（transport header）,你应该使用

```c
skb_transport_header();
```

同样， L3(network header),你需要

```c
skb_network_header();
```

如果你想fetch L2(MAC header)

```c
skb_mac_header();
```

这三个方法将SKB作为唯一的参数。分别返回头部的指针。

当一个包来临的时候，一个SKB被netdev_alloc_skb()方法分配(或者dev_alloc_skb(),这个方法也是调用netdev_alloc_skb(),但是第一个参数是NULL)。如果遇到包被丢弃的情景，我们将会调用kfree_skb()或者dev_kfree_skb().

在SKB中的一些成员，会被L2层决定，例如，这个pkt_type 就会被eth_type_trans()方法决定，这个方法根据目的的Ethernet地址，如果这个地址是（多播）multicast，就会被设置为PACKET_MULTICASE,如果是(广播)broadcast，则会被设置为PACKET_BROADCASE;如果是本地主机地址，则是PACKET_HOST.绝大多数Ethernet驱动将会在Rx路径调用eth_type_trans()这个方法。这个eth_type_trans()方法也会设置SKB的协议域根据Ethernet的头部。这个方法也会调用skb_pull_inline()提前预付SKB的数据指针，大小为14(ETH_HLEN),这就是Ethernet header的大小。

请看下面的图片：

![net-1.png](http://yuzibo.qiniudn.com/net-1.png)

每一个SKB有一个dev成员，这是一个net_device结构的实例化。接收和发出的包是不同的。在这个过程中，需要不停的fetch能影响包在内核栈中行程的信息。比如MTU。每一个传输的SKB有一个sock对象赋予它(sk),如果这个包是被转发的包，这个sk为NULL，因为它不是有本地主机生成。


每一个接收的包应该通过网络层协议处理，比如，一个ipv4包应该被ip_rcv()方法处理，ipv6应该是ipv6_rcv(),相反的过程，这二者都需要dev_add_pack()方法去注册协议。ip_rcv()方法检查自己的参数，一切没有问题的话被NF_INET_PRE_ROUTING钩子调用。接下来是ip_rcv_finish()方法。在路由子系统中，会建立一个目的缓存项(dst_entry),同时在dst_entry中会有input和output方法。

```c
int (*input)(struct sk_buff);

int (*output)(struct sk_buff);

```
*input()*可以被下面的函数指定：　ip_local_deliver(),ip_forward(), ip_mr_input(),ip_error()或者dst_discard_in.

*output()* 可以被下面的使用ip_output,ip_mc_output, ip_rt_bug或者dst_discard_out

在这里简单说一下v4和v6的区别。地址空间不说了，v6的header 是40字节，而v4是20～40,这样v6的性能就会提升了一大截;在ICMP中，v6也加入了很多其他的东西。

接收包被网络设备驱动传递给ipv4或者ipv6-网络层，如果是局部传输，他们会被传递给传输层（l4）的监听socket处理。在L4层上，有UDP和TCP两种协议。此外，还有两种新的协议，Stream Control Transmission Protocol(SCTP)，Datagram Congestion Control Protocol(DCCP),这两者结合了tcp和udp的特征。

本地主机产生的packets由L4的TCP或者UDP负责。这些都是Sockets APi可以提供。struct socket是提供给用户空间的接口，struct sock提供L3的接口。

每一个L2网络层接口有一个L2的地址去鉴别它。在Ethernet中，这是一个48位的地址，并且MAC地址被赋予每一个Ethernet网络接口（唯一），每一个Ethernet包以Ethernet header开始，它包含Ethernet 类型（2-bit）， 源MAC地址（6-bit），目的MAC地址（6-bit）.注意，Ethernet 的类型值ipv4是0x0800,ipv6是0x86DD.对于发出的包来讲，一个Ethernet Header也应该被创建，其中的目的MAC地址通过邻居子系统找到。邻居协议被IPv4中的ARP处理(ipv6中的NDISC)，这两者在处理上也有不同的地方。ARP协议依靠于发送广播请求，而NDISC依靠ICMPv6请求，该者实际上是多播请求。

netlink为内核和用户空间之间的交流提供通道。iproute2就是依靠netlink实现的。

# 路由子系统

路由子系统可以帮助我们找到net设备、找到被发送包的目的主机。

```c

static inline int fib_lookup(struct net *net, const struct flowi4 *flp,
			     struct fib_result *res, unsigned int flags)
{
	struct fib_table *tb;
	int err = -ENETUNREACH;

	rcu_read_lock();

	tb = fib_get_table(net, RT_TABLE_MAIN);
	if (tb)
		err = fib_table_lookup(tb, flp, res, flags | FIB_LOOKUP_NOREF);

	if (err == -EAGAIN)
		err = -ENETUNREACH;

	rcu_read_unlock();

	return err;
}
struct fib_table {
	struct hlist_node	tb_hlist;
	u32			tb_id;
	int			tb_num_default;
	struct rcu_head		rcu;
	unsigned long 		*tb_data;
	unsigned long		__data[0];
};
```
这个结构位于include/net/ip_net.h. *FIB*的意思是"Forwarding Information Base"

这里有两个默认的基本表(在没有配置的情况下)，比如，局部表(local FIB table)（ip_fib_local_table: ID 255）和主表(main fib table)(ip_fib_main_table; ID 254)

主路由表可以有３种方式改变：

1.系统命令(route add/ip route) 2. (routing daemons) 3.(ICMP 重定向)

fib_loolup 首先寻找local FIB 表，其次再寻找main　FIB,*route -C*这个命令可以查看缓存。另一种就是*cat /proc/net/rt_cache*,在这样的情况下，地址是十六进制的。

```c

struct rtable {
	struct dst_entry	dst;

	int			rt_genid;
	unsigned int		rt_flags;
	__u16			rt_type;
	__u8			rt_is_input;
	__u8			rt_uses_gateway;

	int			rt_iif;

	/* Info on neighbour */
	__be32			rt_gateway;

	/* Miscellaneous cached information */
	u32			rt_pmtu;

	u32			rt_table_id;

	struct list_head	rt_uncached;
	struct uncached_list	*rt_uncached_list;
};
```
分配一个rtable的实例可以使用*dst_alloc()*方法来进行(net/core/dst.c)。

```c

void *dst_alloc(struct dst_ops *ops, struct net_device *dev,
		int initial_ref, int initial_obsolete, unsigned short flags)
{
	struct dst_entry *dst;

	if (ops->gc && dst_entries_get_fast(ops) > ops->gc_thresh) {
		if (ops->gc(ops))
			return NULL;
	}

	dst = kmem_cache_alloc(ops->kmem_cachep, GFP_ATOMIC);
	if (!dst)
		return NULL;

	dst_init(dst, ops, dev, initial_ref, initial_obsolete, flags);

	return dst;
}
```

# 用户工具

### iputils(ping arping and so on)

### net-tools(ifconfig, netstat, route, arp)

### iproute2(ip)
