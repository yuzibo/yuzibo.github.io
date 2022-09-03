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

Docker 环境也有了：

大家好，RVCC 开发环境的 Docker 镜像已经配置好，欢迎大家使用。详情可以参考：https://github.com/ksco/rvcc-env-docker。

提供的是国内阿里云的 registry，下载飞快！

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

接下来，我们再进一步，使用一个 .c 文件：
```bash
vimer@unmatched:~/build/rvcc/02$ cat main.c
#include <stdio.h>
#include <stdlib.h>

int main (int argc, char ** argv){
        if (argc != 2){
                // argc is right
                fprintf(stderr, "%s: invalid number of argcs\n", argv[0]);
                return 1;
        }

        printf("        .global main\n");

        printf("main:\n");
        printf("        li a0, %d\n", atoi(argv[1]));
        printf("        ret\n");
}
```
然后Makefile:

```bash
vimer@unmatched:~/build/rvcc/02$ cat Makefile
# C编译器参数：使用C11标准，生成debug信息，禁止将未初始化的全局变量放入到common段
CFLAGS=-std=c11 -g -fno-common
# 指定C编译器，来构建项目
CC=clang

# rvcc标签，表示如何构建最终的二进制文件，依赖于main.o文件
rvcc: main.o
# 将多个*.o文件编译为rvcc
        $(CC) -o rvcc $(CFLAGS) main.o

# 测试标签，运行测试脚本
test: rvcc
        ./test.sh

# 清理标签，清理所有非源代码文件
clean:
        rm -f rvcc *.o *.s tmp* a.out

# 伪目标，没有实际的依赖文件
.PHONY: test clean

```
这里还有一个test.sh:

```bash
#!/bin/bash

# 声明一个函数
assert() {
  # 程序运行的 期待值 为参数1
  expected="$1"
  # 输入值 为参数2
  input="$2"

  # 运行程序，传入期待值，将生成结果写入tmp.s汇编文件。
  # 如果运行不成功，则会执行exit退出。成功时会短路exit操作
  ./rvcc "$input" > tmp.s || exit
  # 编译rvcc产生的汇编文件
  clang -o tmp tmp.s
  # $RISCV/bin/riscv64-unknown-linux-gnu-gcc -static -o tmp tmp.s

  # 运行生成出来目标文件
  ./tmp
  # $RISCV/bin/qemu-riscv64 -L $RISCV/sysroot ./tmp
  # $RISCV/bin/spike --isa=rv64gc $RISCV/riscv64-unknown-linux-gnu/bin/pk ./tmp

  # 获取程序返回值，存入 实际值
  actual="$?"

  # 判断实际值，是否为预期值
  if [ "$actual" = "$expected" ]; then
    echo "$input => $actual"
  else
    echo "$input => $expected expected, but got $actual"
    exit 1
  fi
}

# assert 期待值 输入值
# [1] 返回指定数值
assert 0 0
assert 42 42

# 如果运行正常未提前退出，程序将显示OK
echo OK
```
执行  `make test`：
```bash
vimer@unmatched:~/build/rvcc/02$ make test
clang -std=c11 -g -fno-common   -c -o main.o main.c
clang -o rvcc -std=c11 -g -fno-common main.o
./test.sh
0 => 0
42 => 42
OK

```

# 02

徒手写一个RISC-V编译器 - 第002课

https://www.bilibili.com/video/BV1KS4y1E79u

[完结] 循序渐进，学习开发一个RISC-V上的操作系统 - 汪辰 - 2021春

https://www.bilibili.com/video/BV1Q5411w7z5

可以看看前面一部分的公共知识课，包含了RISC-V的基础指令集的详细的介绍和一些程序执行堆栈的知识

