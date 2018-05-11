---
title: "bpf的简介"
category: bpf
layout: article
---

# 声明
这篇文章主要的聚焦点在BPF,经过2017年的快速发展后，现在到了eBPF阶段。

首先，参考[这里](https://linux.cn/article-9507-1.html)



# BPF vertifier

Rules:

1. Providing a verdict for kernel whether safe to run

2. Simulation of exection of all paths of the program

3. Steps involved(extract):
	1. Control flow graph
	2. Out of range jumps, unreachable instructions
	3. Contxt, initialized memory, stack spill
	4. Pointer checking
	5. Verifying helper function call arguments
	6. Value and aligment tracking for data access
	7. Living analysis register
	8. Reducing verification complexity


# BPF JIT
C -> LLVM -> BPF -> loader -> verifier -> JIT -> tx/XDP -> offload

BPF registers mapped to CPU register 1:1

1. R0 -> return value from helper call
2. R1-R5 -> argument registers for helper call
3. R6-R9 -> callee saved, preserved on helper call



# llvm
The context will be describe in Documents/bpf/bpf_devel_QA.txt llvm section.



# Reference
1. [BPF_AND_XDP](http://schd.ws/hosted_files/ossna2017/da/BPFandXDP.pdf)

2. [内核中高速包过滤](https://cdn.shopify.com/s/files/1/0177/9886/files/phv2017-gbertin.pdf)
讨论了内核中包过滤的几种方式，尤其是bpf and xdp,介绍了DDos防御功能

http://www.brendangregg.com/blog/2015-05-15/ebpf-one-small-step.html

https://blog.yadutaf.fr/2016/03/30/turn-any-syscall-into-event-introducing-ebpf-kernel-probes/
