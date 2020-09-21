---
title: 结合程序看riscv指令
category: riscv
layout: post
---
* content
{:toc}

其实，对于整个汇编系统而言，在下实在是没有入门，别说riscv了，就是最常用的x86也没有精通一点半星的，
更别说arm了，当然，这里这篇文件介绍 riscv主要是由于工作之中会偶尔遇到，姑且碰上什么就记录什么吧。

```c
(gdb) disassemble  /mr main
Dump of assembler code for function main:
7	{
   0x0000000000027936 <+0>:	41 11	addi	sp,sp,-16

8		int a=10;
9		int b=10;
10		printf("Hello world\n");
   0x000000000002793a <+4>:	17 a5 fe ff	auipc	a0,0xfffea
   0x000000000002793e <+8>:	13 05 f5 bf	addi	a0,a0,-1025 # 0x11539
   0x0000000000027942 <+12>:	97 20 02 00	auipc	ra,0x22
   0x0000000000027946 <+16>:	e7 80 20 a2	jalr	-1502(ra) # 0x49364 <puts(char const*)>

11		printf("int a+b = %d\n", sum(a, b));
   0x000000000002794a <+20>:	17 c5 fe ff	auipc	a0,0xfffec
--Type <RET> for more, q to quit, c to continue without paging--
   0x000000000002794e <+24>:	13 05 55 62	addi	a0,a0,1573 # 0x13f6f
   0x0000000000027952 <+28>:	d1 45	li	a1,20
   0x0000000000027954 <+30>:	97 20 02 00	auipc	ra,0x22
   0x0000000000027958 <+34>:	e7 80 00 98	jalr	-1664(ra) # 0x492d4 <printf(char const*, ...)>

12		return 0;
   0x000000000002795c <+38>:	01 45	li	a0,0
   0x000000000002795e <+40>:	a2 60	ld	ra,8(sp)
   0x0000000000027960 <+42>:	41 01	addi	sp,sp,16
   0x0000000000027962 <+44>:	82 80	ret

```
下面是简单的介绍这个汇编出现的指令。 在这里，在下向各位报一声歉，因为我写文章大部分
都是给自己写的，基本上写到哪里就算哪里了，导致文章大部分残缺不全，这也是今后我需要改进
的部分。

### auipc- Add upper immediate to pc
The AUIPC instruction, which adds a 20-bit upper immediate to the PC, replaces the RDNPC instruction, which only read the current PC value. This results in significant savings for position-independent code.
这个指令的解释也很清楚，但是在这里想愚蠢的问一下，为什么会送到pc中去，虽然都说pc需要存储
下一条执行的地址。
```c
 0x000000000002793a <+4>:	17 a5 fe ff	auipc	a0,0xfffea
```
看这样子是将0xfffea(20 bit)放入a0寄存器中，剩下的位自然是填充0.

### addi sp,sp -32
[here](https://stackoverflow.com/questions/34182330/risc-v-assembly-stack-layout-function-call)
```c
10060:   fe010113            addi    sp,sp,-32  # allocate space
   10064:   00113c23            sd  ra,24(sp)      # save $ra
   10068:   00813823            sd  s0,16(sp)      # save $s0
   1006c:   02010413            addi    s0,sp,32   # set up $s0 as frame pointer
```

