---
title: sparse warning from kernel summary
category: kernel
layout: post
---
* content
{:toc}

# 命令

```bash
make C=2 CF=-D__CHECK_ENDIAN__
```

# patch
有关sparse发现的问题，我自己的patch在下面，但是，目前来说没有理解其中的原理
只能先记录下来，后面再总结。

[我的patch](https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/log/?h=staging-next&qt=grep&q=tsu.yubo%40gmail.com)

# rcu

在上面的补丁中，其中就是一个有关rcu的bug.
现在记录一个

[li](https://patchwork.ozlabs.org/patch/1052135/) 其中的一个问题如何从KASAN的log中找到相关的代码线索？

# __le16

嘿嘿，这是有关位操作的黑科技
资源：

[stackoverflow](https://stackoverflow.com/questions/22119935/warnings-thrown-by-sparse)

[linus](http://www.gelato.unsw.edu.au/IA64wiki/SparseAnnotations)

## 待解决的问题

1.
下面这段代码是有问题的，
命令：

```bash
sudo make C=2 M=drivers/net/
```
相关的代码：3241行from[code](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/bonding/bond_main.c)

```c
static inline u32 bond_eth_hash(struct sk_buff *skb)
{
	struct ethhdr *ep, hdr_tmp;

	ep = skb_header_pointer(skb, 0, sizeof(hdr_tmp), &hdr_tmp);
	if (ep)
		return ep->h_dest[5] ^ ep->h_source[5] ^ ep->h_proto;
	return 0;
}
```

其中，ethhdr的定义在[161](https://elixir.bootlin.com/linux/latest/source/include/uapi/linux/if_ether.h#L161)
```c
#if __UAPI_DEF_ETHHDR
struct ethhdr {
	unsigned char	h_dest[ETH_ALEN];	/* destination eth addr	*/
	unsigned char	h_source[ETH_ALEN];	/* source ether addr	*/
	__be16		h_proto;		/* packet type ID field	*/
} __attribute__((packed));
#endif
```
看出问题来了吗？

