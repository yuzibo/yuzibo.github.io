---
title: c 动态分配内存
category: c/c++
layout: post
---
* content
{:toc}

说来惭愧，认识c语言这么久，这是第一次对c的动态分配内存方式有了一个直观的认识。

# ｃ语言的内存分布
以小端机器为例：
```c
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+ -->high address
|				|==> 命令行参数以及环境变量
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
　　　　　　　　　
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|		stack  		|
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
		|
		V
		^
		|
		|
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|		heap		|
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|	uninitialized dada(bss)	| initialized to zero
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+  by exec

+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|	initialized dada	|----read from program file
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+    by exec
				  /
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+/
|	text 			|
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+ low address
```

##  text segment
我们经常定义的字符串也许就是放在这里，这里我用了**也许**，因为我还没有实验出来，如果证实了，自然不会用这个词了。

## initialized data
这个位置也叫数据段，主要存放全局变量和static关键词变量。注意，这里可以分为可读写data或者只读只写data段注意，这里可以分为可读写data或者只读只写data段

```c
static int i = 0;
// 或者
global int j = 0;
```
will be stored here.

## uninitialized data segment
也叫bss段(block started by symbol),

## heap
这时这篇文章主要介绍的一个知识点

## stack

首先借助一个测试程序进行验证：

```c
#include <stdio.h>

int main()
{
	return 0;
}
```
进行编译后查看文件各段的大小。**size**命令就是查看文件中section的大小，具体可以查看man手册
```c
yubo-2@debian:~/test$ gcc -g memory-layout.c -o memory-layout
yubo-2@debian:~/test$ size memory-layout
   text	   data	    bss	    dec	    hex	filename
   1521	    544	      8	   2073	    819	memory-layout
```
之所以各段这么大，是因为这个可执行文件还具有其他的一些工作也被加载到这个文件中了，我们使用相对数量来反应
这个变化。
我们再看一下汇编文件:
```c
yubo-2@debian:~/test$ cat memory-layout.s
	.file	"memory-layout.c"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	pushq	%rbp //将前面的程序地址压入栈
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp　//将这个函数的地址压入
	.cfi_def_cfa_register 6
	movl	$0, %eax // 传递返回值
	popq	%rbp //返回上面的程序
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	...
```
### 添加全局变量，检查bss
```c
#include <stdio.h>
int global;
int main()
{
	return 0;
}
```
查看size文件变化：
```c
yubo-2@debian:~/test$ size memory-layout
   text	   data	    bss	    dec	    hex	filename
   1521	    544	      8	   2073	    819	memory-layout
```
```c
	.file	"memory-layout.c"
	.comm	global,4,4 //差别就在这里
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	$0, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	...

```
对，就是这个样子，在我的机器上，没有初始化的变量或者初始化为０的全局变量以及静态变量不会增加bss的大小，相反，如果你初始化为非0的
数据，则**data**段会增加。
```c
#include <stdio.h>
int test = 3;
int main(void)
{
	static int i = 3;
	return 0;
}
```
看一下size:

```c
yubo-2@debian:~/test$ size memory-layout
   text	   data	    bss	    dec	    hex	filename
   1521	    552	      8	   2081	    821	memory-layout
```
data增加了两个(int)的大小。

# 结论
**stack**和**heap**在程序运行时进行分配空间，后面三个由编译器决定其空间。啊哈，所以ali 的大神面试我的那个问题就有眉目了，定义多个
变量会影响文件的大小　汗.


# 数组
数组相比大家都熟悉了，这个方式有一个特点，就是数组的大小在编译时就确定了，其存放在

下面是动态分配内存使用的方法分配空间。

```c
#include <stdio.h>
#include <stdlib.h>

int main()
{
    int i, num;
    float *data;

    printf("Enter total number of elements(1 to 100): ");
    scanf("%d", &num);

    // Allocates the memory for 'num' elements.
    data = (float*) calloc(num, sizeof(float));

    if(data == NULL)
    {
        printf("Error!!! memory not allocated.");
        exit(0);
    }

    printf("\n");

    // Stores the number entered by the user.
    for(i = 0; i < num; ++i)
    {
       printf("Enter Number %d: ", i + 1);
       scanf("%f", data + i);
    }

    // Loop to store largest number at address data
    for(i = 1; i < num; ++i)
    {
       // Change < to > if you want to find the smallest number
       if(*data < *(data + i))
           *data = *(data + i);
    }

    printf("Largest element = %.2f", *data);

    return 0;
}
```

https://www.geeksforgeeks.org/memory-layout-of-c-program/

https://www.programiz.com/c-programming/examples/dynamic-memory-allocation-largest

