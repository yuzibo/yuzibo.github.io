---
title: dpkg-buildpackage探索
category: debian-riscv
layout: post
---
* content
{:toc}

我们在[这篇文章](http://www.aftermath.cn/2022/02/20/debian-qemu-sbuild-riscv64/)中，介绍了借助sbuild搭建Debian package的交叉编译环境，如果在这个 `独立的环境`外部，使用`sbuild`命令，即可启动Debian package的整个编译流程。 但是有时候我们需要一步一步滴、chroot到这个独立的环境去编译(最少明确每一步在干什么)，就需要掌握Debian build package的原生命令了。今天我们介绍dpkg-buildpackage的一些用法，更权威的请参考[这里](https://www.debian.org/doc/manuals/maint-guide/build.en.html)

# 解决依赖
在外部使用 `sbuild`命令可以由chroot自己解决软件依赖的问题，但是使用`dpkg-buildpackage`不会这么做。解决自动依赖的命令目前还在探索中，需要后面进行补充。

# build package
具体的命令就是:

```bash
dpkg-buildpackage --sanitize-env -us -uc -b -rfakeroot
```

解析：

`-us`： unsigned source package

`-uc`: unsigned .buildinfo and .changes file


