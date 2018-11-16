---
layout: post
category: "DS"
title: "关于test数据的省时省力的方法"
---

* content
{:toc}

# 引入
关于测试数据，本来不应该给予过多的关注，但是，很多时候我们在调试数据上面浪费
了很多的时间，下面，这篇文章我将持续的更新，介绍自己方法。

# 打印
首先，写出一个头文件:
```c

#include<stdlib.h>
/*
 *
 * 使用方法，只需在主函数中声明i，j;
 * Right now, i dont have realize extern from "header.h",
 * Only to use "cat macro.h >> filename" ;
 * 2016-03-11
 *
 */
#define print_maritx_int(n,a)	\
	for (i = 0; i < n ;i++)	\
	{			\
		printf("\n");	\
		for (j = 0; j < n; j++) \
			printf("%d\t",a[i][j]); \
	}
```
目前我还没有实现导入外部头文件的方法使用这个宏，我的本意是是在需要的源文件
插入：

> extern print_maritx_int(n,a);

可惜，不给力，每次给我报错误，不知道是哪里的问题。

现在的解决方案很简单，就是这个头文件放在手头上，暂时将需要的宏用命令插进去。

