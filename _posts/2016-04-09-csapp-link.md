---
title: "文件编译过程"
layout: post
category: system
---

* content
{:toc}

# 简单的命令

## 1. 预编译
```c
gcc -O1 -o p p1.c p2.c
```
首先， c预编译器使用`cpp`扩展里面的 #define<file>或者 #define，生成`/tmp/main.i`.
## 2. 编译器生成p1.S和p2.S的文件
使用`cc1`将上面生成的.i文件生成.s文件。
```c
cc1 /tmp/main.i -Og [other argument] -o /tmp/main.s
```
## 3.汇编器将汇编代码生成重定位目标文件p1.o和p2.o，
```c
as -o /tmp/p1.o /tmp/p1.s
```
## 4. 链接器生成可执行目标文件
```c
ld -o prog /tmp/p1.o /tmp/p2.o
```
## 5. 加载器(loader)
```bash
./prog
```
这个命令会激活一个loader(加载器)，将第四步产生的可执行二进制文件的代码和数据加载到内存中去。

# 静态连接
为了建立可执行文件，链接器必须执行两个任务:
1. symbol resolution.这个符号重置就是把目标文件中的函数、全局变量或者静态变量找到最初的定义位置。
2. relocation.编译器或者汇编器产生的数据或者代码都是在地址为0的基础上进行的，那么，链接器需要将这些内容重新定位到内存的合理位置，这个任务的完成是由*relocation entries*协助完成的。

这里需要记住的就是，linker所面对的只是一些指令，这些指令彼此毫不相干，另外，链接器需要对目标机器有一个最小化的认识。

# object file
这个词语的中文可以翻译为目标文件，主要有3种形式：

1. 重定位目标文件。彼此间组合重组生成可执行目标文件。
2. 可执行目标文件。包含可以直接加载到内存中运行指令的文件。
3. 共享目标文件。可以动态在运行时或者连接时被其他文件加载进内存的文件。

目标文件有这么几种格式: a.out来自于bell实验室。windows使用pe格式(portable Executable) ,
mac 使用Mach-O格式。x86和一些现代的机器清一色使用的是ELF(Executable and linkable Format)
## 研究这一块的内容，不要忘记两个工具:

objdump和gdb xx的命令
