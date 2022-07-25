---
title: Debian hardware 使用
category: debian
layout: post
---
* content
{:toc}

目前因为处理一个s390的ftbfs issue，所以需要一台s390的机器，当然，这是在不考虑qemu的前提下。

# dsa guest account

[参考这里](https://dsa.debian.org/doc/guest-account/)
会给1-2 mothes的时间登陆相关的机器。

# Debian hardware

[hardware list](https://wiki.debian.org/Hardware/Wanted#Available_hardware)这里有很多机器，目前还没有riscv的，需要我们在后面完善。

# s390
可以参考这篇文章： https://etbe.coker.com.au/2020/07/05/debian-s390x-emulation/

我最终借用[dqib](https://gitlab.com/giomasce/dqib)创建了一个s390x的虚拟机。