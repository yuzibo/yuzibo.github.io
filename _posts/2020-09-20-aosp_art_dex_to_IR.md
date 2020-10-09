---
title: art dex到IR的过程
category: aosp
layout: post
---
* content
{:toc}

我们都知道，aosp中的对java代码的运行与JVM是不一样，这一切都是由一个叫做art的虚拟机完成的(并不包括从java到dex这一过程)。
也就是可以认为， art的输入是dex指令，输出的针对相应平台的汇编代码，

这篇笔记就简单介绍一下这个过程，主要是先介绍概念，然后再介绍aosp中的对应代码名称，用来混个脸熟。主要参考了邓凡平老师的
<<深入理解Android Java虚拟机>>的第六章。看过这本书的都知道， 第六章首先介绍了一些编译原理的概念，比如语法分析、词法分析，
当然，没有实践就没有发言权，这篇文章就不做说明了。 

# DEX
dex文件是由class文件(或者apk文件)经过dx工具生成的。那么，我们就首先从dex文件入手。

...

抱歉，这一部分没啥可说的，如果执意探究下aosp的dex的相关细节， 我也记录了一些，[在这里](http://www.aftermath.cn/2020/06/01/aosp-from-java-oat/)

# IR

按照文章的说法， 编译器在某个阶段产生IR， 比较复杂， 后面补充详细的。

java字节码就是一种单地址的IR， 单地址的IR中指令的操作数和操作结果都存在于栈中。注意一点，art在做编译优化时并不是直接针对dex字节码的，而是使用了
自定义的中间表达式。

# 优化器

art优化器输入的是dex字节码， 输出后的是优化的Hinstruction. 

## 控制流

### 建立CFG

`HGraph`代表CFG。声明在art/compiler/optimizing/nodes.h文件中。

#### 基本块

基本块包含一行或多行代码，没有跳转分支代码。相当于图的结点(node). 在art中的代表是`HBasicBlock`.  `HBasicBlockBuilder`是构造CFG的辅助类。
#### 边

### 循环结构分析

## 数据流

数据流分析依赖于CFG

