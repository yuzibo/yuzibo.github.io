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

这三个方法将SKB作为唯一的参数。

当一个包来临的时候，一个SKB被netdev_alloc_skb()方法分配(或者dev_alloc_skb(),这个方法也是调用netdev_alloc_skb(),但是第一个参数是NULL)。如果遇到包被丢弃的情景，我们将会调用kfree_skb()或者dev_kfree_skb().

在SKB中的一些成员，会被L2层决定，例如，这个pkt_type 就会被eth_type_trans()方法决定，这个方法根据目的的Ethernet地址，如果这个地址是（多播）multicast，就会被设置为PACKET_MULTICASE,如果是(广播)broadcast，则会被设置为PACKET_BROADCASE;如果是本地主机地址，则是PACKET_HOST.绝大多数Ethernet驱动将会在Rx路径调用eth_type_trans()这个方法。这个eth_type_trans()方法也会设置SKB的协议域根据Ethernet的头部。这个方法也会调用skb_pull_inline()提前预付SKB的数据指针，大小为14(ETH_HLEN),这就是Ethernet header的大小。


