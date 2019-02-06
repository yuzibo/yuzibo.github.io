---
title: void在c中的使用
category: c
layout: post
---
* content
{:toc}

# void 使用必知一
作为一个c的使用者，void恐怕是你比较喜欢的一个单词，为什么呢？因为简单，记得在 编译原理 这门课中，任课老师特意讲了下 空操作 这个概念，也算学过这门课了，哎！

今天这练习一个内核oops的检测时，遇到了一个有意思的事情：

error: function declaration isn’t a prototype

这个函数是这样定义的：

```c
static void create_oops() {
	*(innt *)0 = 0;
}

static int __init my_oops_init(void)
{
	...
	create_oops();
	...
}

```
注意在下面的使用中，这里给它传递了一个空的参数，以前没有注意到编译器会报这个错，这次编译器就抛出了这个错误。其实，按照目前(有待考证)gcc的特性，如果不想给一个函数传递函数，那么就要在定义的使用使用void(在形参位置)填充，这样就明确的告诉编译器，该函数没有参数。


