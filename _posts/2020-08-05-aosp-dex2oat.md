---
title: dex2oat 简单记录
category: aosp
layout: post
---
* content
{:toc}

# What is dex2oat?
dex2oat是一个编译器。首先，由之前的 dex code(APK文件)作为输入文件，在dex2oat这个框架
中，有两条通路经过dex2oat,一条是从入口verify后直接 write elf(这种方式有可能为了使用之间的老代码)，
另一条是从入口的verify之后，dex code 经过 transform产生IR（optimization）,然后产生 （code
generation ）native代码，然后经过输出写入ELF文件，经过 install后得到一个 OAT 文件。

在安卓6的时候，这里有两个编译手段对于dex2oat来说，一个是 quick， 一个是 optimizing,现在的重点就是
optimizing

# 资料
根据[这篇资料整理](https://core.ac.uk/download/pdf/249324963.pdf)
