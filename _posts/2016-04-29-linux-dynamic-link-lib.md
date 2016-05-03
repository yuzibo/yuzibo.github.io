---
title: "linux下动态连接库的问题"
layout: article
category: system
---

# 简介
linux下c或者c++编程始终离不开动态动态库"*.so",具体它是怎么产生的、如何使用，
现在就简单介绍一下。

## 动态库的编译
这里用一个简单的例子，比如有三个.c文件so_a.c、so_b.c、so_c.c;一个头文件so_he
ad.h,我们将他们连接编译成一个动态库: libso.so.
文件的内容分别如下：

so_head.h:
```c
#include<stdio.h>
void print_a();
void print_b();
void print_c();
```
so_a.c:
```c
#include "so_head.h"
void print_a()
{
	printf("This is print_a\n");
}
```
so_b.c:
```c
#include "so_head.h"

void print_b()
{
	printf("This is print_b\n");

}

```
这里省略so_c.c的源文件。
将这几个文件编译成一个动态库:libso.so
下面是Makefile:
```bash
SRCS = $(wildcard *.c)

OBJS = libso.so

$(OBJS):
	gcc $(SRCS) -fPIC -shared -o $(OBJS)
```

:-shared

这里的-shared是指定生成的动态链接库，(让链接器生成的T类型的导出符号表，有
时候也生成弱连接w类型的导出符)。不用该标志外部程序无法连接。(为什么呢)

:-fPIC

表示编译为位置独立的代码，不用此选项的编译后的代码是位置相关的，这样在动态载
入时通过代码拷贝的方式来满足不同进程的需要，而不能真正达到代码共享的目的

## 动态库的连接
所谓的连接就是将你所编译成的动态库连接你的可执行文件。

将上面的Makefile改写成:

```bash
SRCS = so_a.c \
       so_b.c \
       so_c.c \
       so_head.h

OBJS = libso.so


PROC = so_test.c
EXE = test
$(EXE): $(OBJS)
	gcc $(PROC) -L. -lso -o $(EXE)
$(OBJS):
	gcc $(SRCS) -fPIC -shared -o $(OBJS)


```
-L.: 

表示要连接到库所在的当前目录。

-lso:

就是查找动态连接库时隐含的命名规则，即在给出的名字前面加上lib，后面加上库的
名称。上面的默认的就是libso.so
这个时候，你使用ldd命令查看一下可执行文件test,里面就包含着libso.so呢。

# 注意
以上步骤完全正确，但有时程序无法执行，也就是找不到so动态库，这时你就要通过
修改LD_LIBRARY_PATH的值来确定了。

>LD_LIBRARY_PATH=.

即可，当然，还有其他的修改方法

# 详细分析这个过程

