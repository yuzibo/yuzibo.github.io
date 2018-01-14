---
layout: article
title: "linux下汇编小结"
category: assembly 
---

# 起因
哪有什么起因啊，看着在linux kernel中大行其道的汇编代码，自己只能硬着头皮去找点资料来学习，不成想居然找到这么一个强悍的文章，如果你打算自己写一个编译器，那么这篇文章就是为你准备的，[在这里](http://www3.nd.edu/~dthain/courses/cse40243/fall2008/ia32-intro.html)

## test.c
我们借助一个简单的例子，试着揭开linux下的真面目。
<pre>
int main()
{
	printf("hello,world\n");
	return 0;
}
</pre>
在linux下使用 gcc -S test.c 就会产生test.s文件，我在自己机子上可能由于加了头文件，反正汇编后的代码和博客中的代码不太一样。
<pre>
	.file	"test.c"
	.section	.rodata
.LC0:
	.string	"hello,world!"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	andl	$-16, %esp
	subl	$16, %esp
	movl	$.LC0, (%esp)
	call	puts
	movl	$0, %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Debian 4.7.2-5) 4.7.2"
	.section	.note.GNU-stack,"",@progbits


</pre>
现在我们只需要关注三个不同的元素：

### Directives
以__.__开头的结构信息，__.global main__说明main是一个全局符号可以被其他代码模块引用，.string 暗示一个可以插入到输出代码的字符常量。

### Labels
以*:*结尾。它描述了名字和位置的联系。只要调用.LCO立马找到下面的字符串。main:被调用后，立即执行push %ebp(原文是这样表达的，但是我的不一样)，在Labels前面用一个.开头的是一个由编译器临时产生的局部变量，其他的就是用户可见和全局变量，现在gcc默认是极大优化的)

### Instructions

如果我们把汇编代码弄成可执行代码,使用以下命令：
	
	gcc -m32 test.s -o test

# IA32 and Data Type
六个通用寄存器	
	
	%eax,%ebx,%ecx,%edx,%esi,%edi
 
两个堆栈寄存器

	%esp,%ebp

bits:

	%ah=%al  ==> 8 bits. %ax ==>16 bits. %eax ==> 32 bits.

# Addressing Modes
IA-32是 complex instruction set(CISC),so MOV has many different variants that move different types of data between different cells.
	
	Suffix	Name Size
	B	BYTE 8bits
	W	WORD 16 bits
	L	LONG 32 bits

## 操作数
在这里分为 

	global value
	immediate value:($56)
	register value:(%ebx)
	indirect((%sp),也就是MASM中[bx]),
	base-relative:(-12(%ecx))(这个语句是说这个值在%ecx暗示的地址(%ecx)下面12字节的内存中). 
	-12(%esi,%ebx,4): refers to the value at the address -12+%esi+%ebx*4

	绝对跳转指令和返回指令需要加"*"

## 需要注意的区别

	AT&T	Intel	说明

	Cbtw	Cbw      把%al中的字节值符号扩展到%ax中

	Cwtl	Cwde	把%ax符号扩展到%eax中

	Cwtd	Cwd	把%ax符号扩展到%dx：%eax中

	Cltd	Cdq	把%eax符号扩展到%edx：%eaxAT&T
	

