---
title: debian autopkgtest usgae
category: debian-riscv
layout: post
---
* content
{:toc}

autopkgtest 是根据[DEP8](https://salsa.debian.org/ci-team/autopkgtest/raw/master/doc/README.package-tests.rst)制定的，本文简单记录下这块的相关用法。

# autopkgtest-build-qemu 
使用qemu创建相关的镜像:
```bash
sudo autopkgtest-build-qemu unstable autopkgtest-unstable.img --mirror=https://mirror.iscas.ac.cn/debian/
```
`--mirror`是根据自己的情况指定相关的mirror,加快速度。那么使用的时候：
```bash
autopkgtest gdk-pixbuf -- qemu autopkgtest-unstable.img
```
其中，gdk-pixbuf是你想测试的package。

[根据这个wiki](https://wiki.debian.org/ContinuousIntegration/autopkgtest)

# 使用chroot
```bash
sudo autopkgtest --apt-upgrade ./xx.dsc -- schroot sid-riscv64-sbuild
```

# debci riscv64 status 

[britney's Job History ](https://ci.debian.net/user/britney/jobs?package=&trigger=&suite%5B%5D=unstable&arch%5B%5D=riscv64)

# autopkgtest(packaging)的一些用法

## warning
在autopkgtest中，原生的warning会被认为FAIL,所以我们在处理这样的情况时(没有warning最好)，可以使用
```bash
Restrictions: allow-stderr
```
进行约束解除。