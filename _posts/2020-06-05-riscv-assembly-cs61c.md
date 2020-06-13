---
title: riscv简单指令-cs61c
category: riscv
layout: post
---
* content
{:toc}

# 资源
[here](https://inst.eecs.berkeley.edu//~cs61c/resources/su18_lec/)

# 引入
与其他教科书一样，在介绍一门汇编语言之言，肯定会拿寄存器与内存进行对比。那么，寄存器与
内存相比，到底有哪些好处呢？

很直观的优势:

1. 速度；

2. 还是速度

# registers
riscv的寄存器有多少个？32个(x0-x31)，虽然多一点有可能会保存更多的变量，
但是这样一来所有的变量读取的速度都会降低。

在这张著名的[小册子](https://inst.eecs.berkeley.edu//~cs61c/resources/su18_lec/)
我们可以看出来，riscv的寄存器命名为x0-x31，但是其ABI的名字不一样。

## programmer variables
```c
s0-s1  <==> x8-x9
s2-s11 <==> x18-x31
ABI    <==> registers
```

## temporary variables
```c
t0-t2  <==> x5-x7
t3-t6  <==> x28-x31
```
riscv寄存器没有特定的类型，他的操作取决于自身内部的内容。

在一个计算机系统中，我们大体上可以分为三大部分：
1. 处理器
包括控制和datapath(这里面包括regs)
2. memory
3. devices


# RISCV Instructions

## Instructions Syntax
```c
op dst, src1, src2
```
一个操作一条指令。c语言中的运算符在这里也是可以用的.

## add
Assume  here that the variables a, b, c are assigned to regs
s1, s2, s3.

```c
a = b + c; // C-style
add s1, s2, s3 // riscv assembly
```

## sub
```c
a = b - c ; // c-style
sub s1, s2, s3 // riscv
```

Suppose :
```c
/*
 * a->s0, b->s1, c->s2, d->s3, e->s4
 * to complte :
 * a = (b + c) - (d + e)
 * in riscv
 */
add t1, s1, s2 # t1 = b + c
add t2, s3, s4 # t2 = d + e
sub s0, t1, t2 #
```
riscv的汇编可以使用"#"进行注释。

## x0
这个寄存器很重要，也就是大名鼎鼎的0寄存器，有了它，很多操作就可以
简化了。因为他的内容永远为0，假设，目的地址为这个寄存器的话，操作
就相当于进了黑洞，没有任何影响，其ABI(zero)。
```c
add s3, x0, x0 # c = 0
add s1, s2, x0 # a = b(初始值借用上面的)
```
## immediates
格式：
```c
opi		dst, src, imm
```
很显然，这里在op后面有一个i，意味着操作符的对象为立即数。
```c
addi	s1, s2, 5 # a = b + 5
addi	s3,	s3, 1 # c ++
```
但是没有`subi`,我估计是为了防止减法溢出吧。

## data transfer
主要使用两个store(to) 和 load(from).riscv指令只操作在寄存器上，
如果想借用内存的内容，就得需要store和load指令了。
