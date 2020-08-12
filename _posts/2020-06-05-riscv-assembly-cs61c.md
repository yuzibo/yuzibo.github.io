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

现在的任务就是在最短的时间内记住这几个寄存器的用途、ABI以及由谁负责保存。

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
<font color="red">memop	reg,  off(bAddr)</font>

### Instructions example
```c
lb t0, 8(sp) # Loads (dereferences) from memory address (sp + 8) into register
              # t0.
			# lb = load byte, lh = load halfword, lw = load word, ld = load doubleword
sb t0, 8(sp) # Stores (dereferences) from register t0 into memory
			# address (sp + 8) sb = store byte, sh = store halfword,
			# sw = store word, sd = store doubleword.
sub a0, t0, t1 #  t0 - t1 ==> a0
mul a0, t0, t1 # t0 * t1  ==> a0

div a1, s3, t3 # s3/t3 ==> a1
rem a1, s3, t3 # s3/t3 ==> a1
and a3, t3, s3 # t3 & s3 ==> a3
or a3, t3, s3  # t3 | s3 ==> a3
xor a3, t3, s3 # t3 ^ s3 ==> a3
```

### pseudo instructions(伪指令)
也就是实际不存在，在实际例子中，会自动转化成已有的指令。

### Floating Point Instruction(浮点指令)
riscv的浮点指令前面加上一个 `f`. 请熟悉以下几个指令:
```c
fld # float load double
fsw # float store word
```
当然还可以通过后缀指定单(.s) 双精度(.d).

```c
# load a double-precision value
flw  ft0, 0(sp)
# ft0 now contains whatever we loaded from memory + 0
flw ft1, 4(sp)
# ft1 now contains whatever we loaded from memory + 4
fadd.s  ft2, ft0, ft1
# ft2 is now ft0 + ft1
```
单双精度之间也可以进行转换: `fcvt.d.s`(convert from single into double)
`fcvt.s.d`(convert from double to single)

### branch instruction
```c
beq # if equal
bne # if not equal
bgt # greater than
bge # greater than or equals
blt # less than
ble # less than or equals
```
下面来看一个例子：
```c
# t0 = 0
li      t0, 0
li      t2, 10
loop_head:
bge     t0, t2, loop_end
# Repeated code goes here
addi    t0, t0, 1
loop_end:
```
对应的代码如下:
```c
for (int i = 0;i < 10;i++) {
    // Repeated code goes here.
}
```

这里具体以beq为例:

[资料](https://inst.eecs.berkeley.edu/~cs61c/resources/su18_lec/Lecture7.pdf)
从 spec 中我们可以得知，branch的指令格式为:
```c
beq rs1, rs2, offset  <==> if (rs1 == rs2) pc += sext(offset)
```
sext的意思是符号位扩展，
如果你具体看一下这条语句的spec的时候，会发现一些有意思的事情，(从右至左)7 bit opcode
,5 bits(offset[4:1]|[11]), 3 bits func3(000暗示BEQ), 5 bits rs1, 5 bits rs2, 7 bits
(offset[12]|[10:5]).

这里的offset你可以看成立即数，12 bit的立即数被编码成了13 bits,但是最低位一直为0，
故我们拆分的是去除最低位后的12 bits，上面括号部分已经指明了这个拆分，因为这个blog
无法上传图片，故需要图片的话，可以访问上面的链接。

### jal(jump and link)
默认为ra。

## Stack
stack被用来存储局部变量，这里有一点需要牢记的是，栈是从栈底（高地址）向栈顶
生长(低地址)
```c
|    |low<---sp(2)
|    |
|____|high<--sp(1)
```
这里的sp并不一定准确，一般来说都是从栈底开始，栈必须以8 bytes的倍数对其。
一个简短的程序段:
```c
addi 	sp, sp, -8
sd 		ra, 0(sp)
call 	printf
ld 		ra, 0(sp)
addi sp, sp, 8
ret
```


# 指令的过程
[here](https://inst.eecs.berkeley.edu/~cs61c/resources/su18_lec/Lecture7.pdf)



