---
title: csapp-信息的表示
category: book
layout: post
---
* content
{:toc}

    首先说明下的是，<<深入理解计算机系统>>可以算是一本计算机科学领域中
的经典教材。其实在本科后半段开始，一直就关注这本书，奈何自己的自制力没有
让自己坚持下来。时至今日，到了2020年的第一周，这个新年新气象如何表示？只有
看书，将过去一段时间浪费的时间补回来，我想，就这样坚持下去一年或者两年看看会
发生什么事情。

    另一个问题是这本书的内容太广泛，在进行总结的时候我竟然找不到一个合适的归类，
你说放到system?这个category本身就有一些问题。新建一个csapp?可以，但是那样导致的
一个问题就是以后其他的书也要新开一个，这样就会导致category的条目过长。

    好吧，经过这个疑虑之后，我先放到book下面，但是命名方式为 书名 + 章节。后期如有
参考，尽量按照这个方式查找。总体而言，这是有关这本书这章节的一个总结。

# 信息的表示
    编译过程序的人都知道，我们的机器码在最底层就是一串数字，但是这个数字是怎么来？这就
需要一个转化的过程。而且，这个过程也需要遵循一定的逻辑规则(或者硬件规则)。

    影响这个数字表示的一个关键因素就是字长(word)，其取决于你的计算机系统。比如，一个int型
在32位系统上占用4个字节（4 * 8bit = 32bits）. 一个指针也为32bits，则指向的地址空间为2^32-1
bits，也就是4GB.

## 编译标准

```c
gcc -std=c99 prog.c
```
指定c的编译标准。

## Hexadecimal Nonation
对于一串二进制来说，从右往左数(right-left)，每4位组成一个十六进制，使用0x表示。比如，01111010(b)对应的
二进制为 0x7A。如果左边不足4位，则补0凑齐。011(b) == 0011(b) ==> 0x3.

说明，```b```代表二进制。

为了方便记忆，最好需要记住三个Hex：

```A``` == ```1010```
```C``` == ```1100```
```F``` == ```1111```
记忆特点，这三个Hex对应的二进制中1的个数为偶数，其相邻的Hex分别加1或者减1.

## Data sizes
如果为了可移植性，可以使用```sizeof(int)```.注意`short int`为2bytes，char为`1byte`.

## 字节序
比如说，一个int型变量x的地址为0x100，在c语言中，这个说法标准的做法是：
```c
	int x = 10;
	int pointer = &x;
	printf("the address of x is %d(decimal) or %x(hex)", x, pointer);
	printf("the address of x is %d(decimal) or 0x%x(hex)\n", x, &x);
```
在我的机器上显示：the address of x is 1876030752(decimal) or 6fd1f520(hex).那么，
一个int型占用的字节为4，那么，x占用的hex连续起来就是6fd1f521、6fd1f522、6fd1f523，
为了解释方便，我们暂时使用0x100、0x101、0x102和0x103表示。假设在0x100的位置上表示的
int型变量代表的值为0x01234567,若：

```c
addiress:0x100---0x101---0x102---0x103
value(hex):01	  23	  45	  67
```
表示方式，则为Big endian.这里补充一点，对于数值0x01234567,最左边的01为最高有效位(Most Significant Bit,
简称MSB),最右边的76为最低有效位(Least Significant Bit,简称LSB),这符合我们人类在书写他们的
方式，尽管不符合人类的阅读习惯.

小端(Little endian)则相反，也就是LSB处于地址的起始地方:

```c
address: 0x100----0x101----0x102----0x103
value(Hex) 67	   45	    23       01
```
这一点对我而言经常容易混，那应该怎么记呢？或者可以去搜搜这个名称的[由来](https://stackoverflow.com/questions/5870311/where-did-endianness-come-from)。

以下代码来自于csapp.
```c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

typedef unsigned char *byte_pointer;

void show_bytes(byte_pointer start, int len){
	int i;
	for(i = 0; i < len; i++){
		printf(" %.2x", start[i]);// 以16进制最少打印两位
	}
	printf("\n");
}

void show_int(int x){
	printf("show int: ");
	show_bytes((byte_pointer) &x, sizeof(int));
}
void show_float(float x){
	printf("show float: ");
	show_bytes((byte_pointer) &x, sizeof(float));
}
void show_pointer(void *x){
	printf("show pointer: ");
	show_bytes((byte_pointer) &x, sizeof(void *));
}

void test_show_bytes(int val)
{
	int ival = val;
	float fval = (float) ival;
	int *pval = &ival;
	show_int(ival);
	show_float(fval);
	show_pointer(pval);
}
int main(){
	int x = 12345;
	test_show_bytes(x);
	return 0;
}

```
在函数`show_bytes`中，我们看到，在将一个指针&x强制转换为`unsigned char *`,按照书上的解释，
这个转换的作用是将指针指向的内容转换为一串字节序而不需要理会这个指针原来的内容。这是一个hint:
比如在操作系统中需要经常知道某个对象的地址，可以使用这个方案去做测试。
输出的结果为:

```c
show int:  39 30 00 00
show float:  00 e4 40 46
show pointer:  38 ec 0a fc fe 7f 00 00
```
十进制数字12345对应的hex为0x3039.说明，我这个测试机器为Little endian.另外，上面的int和float之间的数字
并不是无意义的一串数字，比如,按照我们正常的书写顺序：
```c
0x 00 00 30 39 => 00000000 00000000 00110000 00111001
0x 46 40 e4 00 =>            01000110 01000000 11100100 00000000
                                       ->   ...    <-
```
你会看到这里有几位是匹配的。

