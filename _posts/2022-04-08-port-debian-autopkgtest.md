---
title: debian autopkgtest usgae
category: debian-riscv
layout: post
---
* content
{:toc}

autopkgtest 是根据[DEP8](https://salsa.debian.org/ci-team/autopkgtest/raw/master/doc/README.package-tests.rst)制定的，本文简单记录下这块的相关用法。

或者还可以参考这个教程  https://hackmd.io/@fourdollars/By26b5au8

# debci 环境搭建
为了与线上的环境一致，推荐使用 `debci`的方式。
## autopkgtest-build-qemu
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

## 使用chroot
```bash
sudo autopkgtest --apt-upgrade ./xx.dsc -- schroot sid-riscv64-sbuild
```

## debci (online) backned
[here](https://ci.debian.net/doc/file.MAINTAINERS.html#label-How+can+I+reproduce+the+test+run+locally-3F)

```bash
1. $ sudo apt install debci autopkgtest
2. sudo adduser YOUR_USERNAME debci
3. sudo debci setup   或者
sudo env debci_mirror=https://mirror.iscas.ac.cn/debian-ports debci setup(可选)
# 更新源，加速

```
running:

1. 源码：

```bash
$ autopkgtest --user debci --output-dir /tmp/output-dir . \
  -- lxc --sudo autopkgtest-unstable-amd64
```

其中`.`代表源代码的位置。
2. built debian package

```bash
autopkgtest --user debci --output-dir /tmp/output-dir \
  /path/to/PACKAGE_x.y-z_amd64.changes \
  -- lxc --sudo autopkgtest-unstable-amd64
```

可选 `--add-apt-source='deb https://mirror.iscas.ac.cn/debian/ sid main '`

3. 删除lxc的chroot

```bash
sudo lxc-destory autopkgtest-unstable-riscv64
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

## autopkgtest for experimential 
这里有一个页面展示了 experimential 的 autopkgtest 的情况 ：
https://release.debian.org/britney/pseudo-excuses-experimental.html
