---
title: cross build riscv kernel(debs) 
category: kernel 
layout: post
---
* content
{:toc}

# 
on unmatched:
git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
cd linux
make ARCH=riscv O=build/unmatched defconfig
make ARCH=riscv O=build/unmatched       


7. 交叉编译kernel:
https://www.cnblogs.com/ukylin/p/16039271.html
git submodule update --init --recursive
[个人prefix config ]放到这里了：ls /opt/riscv-toolchains/bin/
否则会报错


--- cross  build
https://stackoverflow.com/questions/55053784/how-to-compile-linux-kernel-4-20-for-risc-v
https://gist.github.com/carloantinarella/d94373ee2d6fb1add3f2474d0af470ad
