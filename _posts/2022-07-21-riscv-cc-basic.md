---
title: 纯手工打造rv编译器
category: riscv
layout: post
---
* content
{:toc}

这个教程是PLCT推出的，强烈推荐。在这篇文章中，我们就简单记录下这个学习过程。

# 资料
https://gist.github.com/sunshaoce/90216c19591581f8997df0109b65c154 这个是RISC-V环境的构建脚本，需要先下载有相应的代码仓库。

riscv elfapi url: https://github.com/riscv-non-isa/riscv-elf-psabi-doc

# 01

[01视频地址](https://m.bilibili.com/video/BV1ga411u7X9)
首先我是在rv硬件上执行这个程序的，所以命令稍微不同，但是效果是一样的。我只是没用交叉编译器嘛。

```bash
#cat tmp.s
        .global main # 声明一个main的段，程序的入口
main:                # 段开始的标志 
        li a0, 42    # a0寄存器就是 返回值
        ret
# compiler cmd:
gcc -s tmp.s
 ./a.out
vimer@unmatched:~/build/rvcc$ echo $?
42
```

# 02

徒手写一个RISC-V编译器 - 第002课

https://www.bilibili.com/video/BV1KS4y1E79u

[完结] 循序渐进，学习开发一个RISC-V上的操作系统 - 汪辰 - 2021春

https://www.bilibili.com/video/BV1Q5411w7z5

可以看看前面一部分的公共知识课，包含了RISC-V的基础指令集的详细的介绍和一些程序执行堆栈的知识

