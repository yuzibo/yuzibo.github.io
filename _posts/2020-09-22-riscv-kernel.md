---
title: riscv与 kernel之间的爱恨情仇
category: kernel
layout: post
---
* content
{:toc}

# 指令等级转换

超级指令与user 指令之间的转换，在riscv中是依赖ecall指令完成的

# 宏/微内核

宏内核简单理解就是所有的功能在内核中实现(与内核相关的)， 而微内核就是
， 比如， 文件系统的一个使用， shell打开文件不是直接使用open或者read
而是使用ipc进行交互

# process

一个进程拥有自己的地址空间， 这个特性是由页表实现的。

xv6 riscv 页表只能38 bits, 大小就是 2^38-1=0x3fffffffff,
