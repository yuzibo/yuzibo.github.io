---
title: shell的cut用法
category: shell
layout: post
---
* content
{:toc}

好久没记录shell相关的代码了，现在记录一下吧。

# cut
这个命令顾名思义，就是可以裁剪一串字符串，怎么裁剪，当然是根据分隔符。

## -d
后面是分隔符

## -f
打印分割后的相关域

# 实践
```bash

user@host037-ubuntu-1804:~/android/.repo/manifests$ git branch -a
* default
remotes/m/zhimo-mr1 -> origin/zhimo-mr1
remotes/origin/android-clang-dev
remotes/origin/android-llvm
remotes/origin/android-llvm-dev
remotes/origin/aosp/android-10.0.0_r20
remotes/origin/aosp/android-10.0.0_r25
remotes/origin/aosp/android-10.0.0_r29
remotes/origin/eswin-master
remotes/origin/master
remotes/origin/zhimo-aosp
remotes/origin/zhimo-gcc
remotes/origin/zhimo-kernel
remotes/origin/zhimo-mr1
remotes/origin/zhimo-mr1-dev
```
如果只想打印第三行的分支，则可以:
```bash
~/android/.repo/manifests$ git branch -a | cut -d / -f 3
* default
zhimo-mr1 -> origin
android-clang-dev
android-llvm
android-llvm-dev
aosp
aosp
aosp
eswin-master
master
zhimo-aosp
zhimo-gcc
zhimo-kernel
zhimo-mr1
zhimo-mr1-dev
```
