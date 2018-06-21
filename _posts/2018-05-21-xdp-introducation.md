---
title: "xdp简介"
category: xdp
layout: article
---

# "SEC的使用"
## Types of maps
To write a proper eBPF program you are going to some common definations and types defined
in linux/bpf.h

	#define <linux/bpf.h>
	#define "bpf_helpers.h"

This is example code from sample/bpf/\*, in kernel source code. The first helper file you
 should be aware of in those headers in the macro "SEC()". It is used to palce data and c
 ode from your eBPF program into specific named sections.

 For instance, all maps need to go into a sections called "maps".This is critical because
 the ELF loader for eBPF programs looks for maps by scanning the ELF sections called "maps".

 Code:

```c
struct bpf_map_def SEC("maps") my_map = {
	.type = BPF_MAP_TYPE_PERCPU_ARRAY,
	.key_size = sizeof(__u32),
	.value_size = sizeof(__u64),
	.max_entries = 256,
};
```

There is where put your main code entry point function into a named section as well.
Certernally, you should not call it: "maps".

```c
SEC("xdp1")
int xdp_prog1(struct xdp_cmd *ctx)
...

SEC("socket1")
int bpf_frog1(struct __sk_buff *skb)

```

## Tail call

If you use the skill into eBPF program, you will different from other eBPF programs.
In good example code is sample/bpf/sockex3_kern.c.

```c
#define PROG(F) SEC("socket/"__stringify(F)) int bpf_func_##F

struct bpf_map_def SEC("maps") jmp_table = {
	.type = BPF_MAP_TYPE_PROG_ARRAY,
	.key_size = sizeof(u32),
	.value_size = sizeof(u32),
	.max_entries = 8,
};

#define PARSE_VLAN 1
#define PARSE_MPLS 2
#define PARSE_IP 3
#define PARSE_IPV6 4
```

How to use it?
This is an odd uages for "##" in GCC.

Here is the dispatch:

```c
static inline void parse_eth_proto(struct __sk_buff *skb, u32 proto)
{
	switch (proto) {
		case ETH_P_8021Q:
		case ETH_P_8021AD:
			bpf_tail_call(skb, &jmp_table, PARSE_VLAN);
			break;
		case ETH_P_MPLS_UC:
		case ETH_P_MPLS_MC:
			bpf_tail_call(skb, &jmp_table, PARSE_MPLS);
			break;
		case ETH_P_IP:
			bpf_tail_call(skb, &jmp_table, PARSE_IP);
			break;
		case ETH_P_IPV6:
			bpf_tail_call(skb, &jmp_table, PARSE_IPV6);
			break;
		}
}

```
The protocol of ethnet is above, wa!

Please you notice, once you call the tail call completes, the entires eBPF program
finishes, it does not continue on from the bpf_tail_call() call site.


# 资源

一种很好的方式提供解决Ddos攻击的思路，来自[csdn](https://blog.csdn.net/dog250/article/details/77993218)

来自[redhat](https://people.netfilter.org/hawk/presentations/OpenSourceDays2017/XDP_DDoS_protecting_osd2017.pdf), 比较好的，值得去看。

很简单的对比，插图有意思[here](https://fosdem.org/2018/schedule/event/xdp/attachments/slides/2220/export/events/attachments/xdp/slides/2220/fosdem18_SdN_NFV_qmonnet_XDPoffload.pdf)

来自官方的文档，不过不是很全[here](https://prototype-kernel.readthedocs.io/en/latest/README.html)


