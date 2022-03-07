---
title: debian pbuilder使用
category: debian-riscv
layout: post
---
* content
{:toc}

今天记录一下debian pbuilder的用法。在前面几篇文章中，我们简单介绍了使用`sbuild`交叉编译deb的问题。

然后，在众多的参考资料中，我们发现，使用`pbuilder`的频次很高，所以，我们也需要对这一工具熟悉起来，掌握起来。

主要参考[Building a Deb package with pbuilder](https://blog.packagecloud.io/building-debian-and-ubuntu-packages-with-pbuilder/)和[https://wiki.debian.org/CrossCompiling#Building_with_pbuilder](https://wiki.debian.org/CrossCompiling#Building_with_pbuilder).

# 安装软件

```bash
sudo apt-get install pbuilder debootstrap devscripts
```

# 创建chroot

一般来说，作为debian的开发者(或者说测试)，所创建的都应该基于unstable版本，目前(2022/03/07)sid就是unstable.

```bash
sudo pbuilder --create \
--distribution sid \
--architecture amd64 \
--basetgz /var/cache/pbuilder/sid-amd64-base.tgz
```

如果不想使用了这个chroot，可以直接`rm`掉就可以了。

首先记住的一点就是，使用pbuilder就是从源码编译deb了，需要有原始的 source code，当然这一点不是让你必须手工打包源码，但是可以使用`deb-src`去下载源码。

安装完了pbuilder后，分别有三个配置文件需要注意:

`/usr/share/pbuilder/pbuilderrc` 这是一个sample file，其后面的配置可以从这个文件copy出来；

`/usr/share/pbuilder/pbuilderrc` 系统级别的配置文件；

`${HOME}/.pbuilderrc` 用户自己的配置文件。


我们首先创建自己的config文件。cat `~/.pbuilderrc`

```bash
vimer@debian:~/build_test$ cat ~/.pbuilderrc
# this is your configuration file for pbuilder.
# the file in /usr/share/pbuilder/pbuilderrc is the default template.
# /etc/pbuilderrc is the one meant for overwriting defaults in
# the default template
#
# read pbuilderrc.5 document for notes on specific options.
#MIRRORSITE=http://deb.debian.org/debian
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
MIRRORSITE=https://mirrors.tuna.tsinghua.edu.cn/debian
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ sid main contrib non-free
BASETGZ=/var/cache/pbuilder/sid-amd64-base.tgz

PBUILDERSATISFYDEPENDSCMD="/usr/lib/pbuilder/pbuilder-satisfydepends-apt"
```
这里很奇怪的问题是，这个配置文件如果直接使用的话，还是传递不到pbuilder的命令里面来的。需要明确的指明:

```bash
sudo pbuilder build --host-arch armhf  --configfile /home/vimer/.pbuilderrc  jimtcl_0.79+dfsg0-3.dsc
```
这样默认的result文件夹是: 

```bash
vimer@debian:~/build_test$ ls /var/cache/pbuilder/result/
jimsh_0.79+dfsg0-3_armhf.deb         jimtcl_0.79+dfsg0-3.debian.tar.xz   libjim0.79-dbgsym_0.79+dfsg0-3_armhf.deb
jimsh-dbgsym_0.79+dfsg0-3_armhf.deb  jimtcl_0.79+dfsg0-3.dsc             libjim-dev_0.79+dfsg0-3_armhf.deb
jimtcl_0.79+dfsg0-3_armhf.buildinfo  jimtcl_0.79+dfsg0-3_source.changes
jimtcl_0.79+dfsg0-3_armhf.changes    libjim0.79_0.79+dfsg0-3_armhf.deb
```
如果我们想让编译的结果离我们近一些的话，是可以指定的。