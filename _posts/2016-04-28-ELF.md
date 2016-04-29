---
title: "ELF文件介绍"
layout: article
category: system 
---

# ELF 简介
ELF(Executable and Linking Format)是一种对象文件格式,从名字上我们也能窥探出
他的作用来。这里主要三种类型的。

# as 
as输出的目标文件至少有三个section，他们是text,data,bss段。你如果不写出.text
或者.data段，但是目标文件依然会有他们，只不过是空的。

```c

Address 0 ---->|--------------|
               |     .text    |
			   |______________|
               |     .data    |
			   |______________|
			   |     .bss     |
			   |______________|

```


