---
title: kernel中汇编知识基础
category: kernel
layout: post
---
* content
{:toc}

这篇文章简单介绍下kernel中汇编的一些小的基础知识。

# 基础
1.  **movl 0xc(%ebp), %eax**相当于**eax = *(int32_t *)(ebp+12)**
2. 在32位x86系统中，**ebp**指向寄存器栈底。
3.

## 习题
1. 假定当前是32位X86机器，ebp寄存器的值为12，esp寄存器的值为8，执行完如下代码后esp的值是多少？（答案单位为字节，填入数值即可） pushl %ebp

4

2. 假定当前是32位x86机器，eax寄存器的值为0x1234，ebx寄存器的值为0x4321,执行完如下代码后eax的值是多少？ebx的值是多少？ movl %eax, %ebx


0x1234
 0x1234 - 正确

0x1234
 0x1234 - 正确

3. 下面哪条指令的寻址方式是直接寻址方式？

```c
movb 0x12, %ah
movw $0x123, %ax
movl (%ebx), %edx
movl %eax, %edx
movl %eax, %edx
```
选a.

4. 32 位x86 CPU中，cs:eip指向要执行的指令地址，所以想执行0x123处的代码，我们可以通过mov $0x123, %eip指令来跳转
错误。%eip不能直接寻址，必须经过寄存器传值。

5. 与下面两条指令等价的指令是（）： pushl %ebp movl %esp, %ebp

(enter)
6.  假定当前是32位X86机器，函数的返回值默认使用哪个寄存器来返回给上级函数？比如eax、ebx、ebp、esp、eip、esi、edi等等(eax)


