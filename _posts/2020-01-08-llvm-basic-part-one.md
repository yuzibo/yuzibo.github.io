---
title: "llvm基础知识"
category: llvm
layout: post
---
* content
{:toc}

2020's new year is very hard for China.It will always be keep in my mind and contribute my best effort
to suort work.

#  llvm
在读书期间，由于自己的研究项目是xdp，该项目必须使用llvm产生bpf架构的代码，所以，也算初步接触了llvm.来到新
的单位，llvm的使用的机会大大增加，所以，必须在最短的时间内能够切入进llvm的开发。

llvm是c++编写的，所以还得夯实自己的c++基础，不管怎样，需要什么就去学习什么。

## 有用的links
[cmu.edu](http://www.cs.cmu.edu/afs/cs/academic/class/15745-s14/public/lectures/L6-LLVM-Part2.pdf)
这篇ppt介绍了llvm的最基本的语法、规则，需要总结。

ibm工程师的一个实践课程[ibm](https://www.ibm.com/developerworks/library/os-createcompilerllvm1/index.html)

# llvm使用选项
根据这篇[article](https://hub.packtpub.com/introducing-llvm-intermediate-representation/)

```c
int sum(int a, int b) {
  return a+b;
}
```
上面代码代码保存为sum.c

1. 如果想要产生bitcode,使用下面的命令：
```bash
clang sum.c -emit-llvm -c -o sum.bc
```

2. 产生汇编代码:
```bash
clang sum.c -emit-llvm -S -c -o sum.ll
```

3. 接着可以使用`llvm-as`汇编代码产生二进制(bitcode)
```bash
llvm-as sum.ll -o sum.bc
```

4. 反着来也行，使用`llvm-dis`
```bash
llvm-dis sum.bc -o sum.ll
```

下面以汇编代码进行简单的分析:
```c
; ModuleID = 'sum.c'
source_filename = "sum.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"
```
llvm所处理的IR最高层的类为```Module```。上面我们可以知道的另外的信息是该计算机的架构为小端（e），
如果为大端的话，则为大写字母E，




