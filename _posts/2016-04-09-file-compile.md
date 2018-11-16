---
title: "文件编译过程"
layout: post
category: system
---

* content
{:toc}

# 简单的命令

## gcc -O1 -o p p1.c p2.c
首先，1. c预编译器要扩展里面的#define<file>或者#define

2. 编译器生成p1.S和p2.S的文件

3.汇编器将汇编代码合并成二进制文件p1.o和p2.o，里面全是二进制的表现形式。但是
没有填充全局变量的地址

4.链接器伴随着库函数如(printf)将两个目标文件生成一个可执行程序

## 研究这一块的内容，不要忘记两个工具:

objdump和gdb xx的命令
