---
title: art dex到IR的过程
category: aosp
layout: post
---
* content
{:toc}

我们都知道，aosp中的对java代码的运行与JVM是不一样，这一切都是由一个叫做art的虚拟机完成的(并不包括从java到dex这一过程)。
也就是可以认为， art的输入是dex指令，输出的针对相应平台的汇编代码，

具体而言， art编译优化器的输入是APK中的DEX字节码， 输出是优化后的HInstruction.

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

# dex to IR

HInstructionBuilder::Build[art/compiler/optimizing/instruction_builder.cc]
还是先判断下基本块的类型:

```c
if (current_block_->IsEntryBlock()) { // 入口基本块
      InitializeParameters();
      AppendInstruction(new (allocator_) HSuspendCheck(0u)); // 为什么加这条
      AppendInstruction(new (allocator_) HGoto(0u));
      continue;
} else if (current_block_->IsExitBlock()) { // 出口基本块
      AppendInstruction(new (allocator_) HExit());
      continue;
} else if (current_block_->IsLoopHeader()) { // 循环块
      HSuspendCheck* suspend_check = new (allocator_) HSuspendCheck(current_block_->GetDexPc());
      current_block_->GetLoopInformation()->SetSuspendCheck(suspend_check);
      // This is slightly odd because the loop header might not be empty (TryBoundary).
      // But we're still creating the environment with locals from the top of the block.
      InsertInstructionAtTop(suspend_check);
}
```

