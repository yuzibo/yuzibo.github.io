---
title: "bpf的简介"
category: bpf
layout: post
---

* content
{:toc}

# 声明
这篇文章主要的聚焦点在BPF,经过2017年的快速发展后，现在到了eBPF阶段。

首先，参考[这里](https://linux.cn/post-9507-1.html)

# install
If you install the bcc from source code,now i have some terrible question to resolve it.So, i recommended you install it from package manager.

[here](http://www.brendangregg.com/ebpf.html#bccinstallation) To see section 5.1
bcc tools will be installed under /usr/share/bcc/tools

# run
Way 1: run it under /usr/share/bcc/tools

Way 2: git clone [iovisor](https://github.com/iovisor/bcc), if it does right, you can run command of bcc directly.

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

Generlly, there is two check, The first check is :
check_cfg()(Do you remember DFS?). It is check wheather is DAG(Directed Acyclic Graph).

The second check is do_check(): register, memory, function, branch(<1024),instructions < 96K

# BPF JIT
C -> LLVM -> BPF -> loader -> verifier -> JIT -> tx/XDP -> offload

BPF registers mapped to CPU register 1:1

1. R0 -> return value from helper call

2. R1-R5 -> argument registers for helper call

3. R6-R9 -> callee saved, preserved on helper call

4. R10 -> Read only, as stack pointer

# BPF encoding

[here](https://github.com/iovisor/bpf-docs/blob/master/eBPF.md)

MSB(most significant bit) 最高有效位　
LSB(least significant bit) 最低有效位

From least significant to most significant bit:

MSB<------>LSB

	8 bit opcode
	4 bit destination register (dst)
	4 bit source register (src)
	16 bit offset
	32 bit immediate (imm)

Notes: Most instructions do not use all of these fields. Unused fields should be zeroed.

# llvm
The context will be describe in Documents/bpf/bpf_devel_QA.txt llvm section.


# Reference
1. [BPF_AND_XDP](http://schd.ws/hosted_files/ossna2017/da/BPFandXDP.pdf)

2. [内核中高速包过滤](https://cdn.shopify.com/s/files/1/0177/9886/files/phv2017-gbertin.pdf)
讨论了内核中包过滤的几种方式，尤其是bpf and xdp,介绍了DDos防御功能

http://www.brendangregg.com/blog/2015-05-15/ebpf-one-small-step.html

https://blog.yadutaf.fr/2016/03/30/turn-any-syscall-into-event-introducing-ebpf-kernel-probes/

http://www.brendangregg.com/Slides/Velocity2017_BPF_superpowers.pdf
