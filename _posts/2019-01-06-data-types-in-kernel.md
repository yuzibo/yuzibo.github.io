---
title: kernel中的基本数据类型
category: kernel
layout: post
---
* content
{:toc}

# 基础
很简单，这是c语言的或者计算机世界中最基本的知识了，只是自己疏于整理(另一句话就是基础太差劲) 正好，自己在写这个短小的程序时碰到了，故借此机会先记录下内核中的一些基础知识。

## u64
在c语言中，u64的含义就是unsigned 64 bits,与此相似的就是，u32(unsigned 32 bits).目前为止，我使用最多的数据类型可能就是整型(int)、长整型(long int==>long long int)、单精度浮点型(float)、双精度浮点型(double).他们都有一个共同的特点就是--带符号。学过计算机组成原理的同学一定接触过有符号和无符号的区别，暂且不表，这里就是简简单单的列举一下u64的用法。unsigned 就是无符号的含义。

```c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
int main() {
	unsigned long long int message;

	scanf("%llx", &message); //==> 0x1234567890abcdef

	printf("The size of message is %d bytes, %llx\n", sizeof(message), message);

	return 0;
}
```
注意上面的message定义为long long且不带符号，`scanf()`的格式控制符是一个组合：`ll`对应long long，`x`对应十六进制。所以你在键入的时候，在数据的前面添加上0x。在我的机器上，long long int 是8 bytes,那么也就是8 * 8 = 64 bits数据长度。同时，一个字符的大小是4bits，所以message可以存储64/4=16个字符。在我的注释中，正好是16位十六进制数字，如果你多以为，则message就溢出了。

# To char[]
在我有限的c语言知识中，还没有碰到使用u64数据类型的好处，或者说必须使用的场景。好，下面就简单说一下他的一个用法。

考虑到一个由16进制组成的数据：0x1234567890abcdef或者0xe233f61cc9c7，那么，怎么才可以将这个16进制的数据存放到字符数组中呢？

答案就在下面：
```c
len = sprintf(id, "%llx\n", task->id);
```
其中，task->id的数据类型是u64,id的数据类型由char id[18]定义，这样就可以了

