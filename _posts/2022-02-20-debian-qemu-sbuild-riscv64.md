---
title: debian based qemu with sbuild
category: debian-riscv
layout: post
---
* content
{:toc}

在前面的文章中， 我们使用sbuild创建schroot搭建riscv64的交叉编译环境，其实是ok的。但是在测试[sip](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=978498#39)这个deb时遇到一点麻烦，现象是schroot只有build这个riscv arch的deb有问题，其他的deb没有问题。但是，为了修复这个问题，schroot暂时还没有找到 如何在编译进行中查看的具体的编译产物 的方法，故这里根据 [john](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=978498#44)的提示，记录下如何创建 基于qemu的sbuild.

当然，还需要参考这个[教程](https://wiki.debian.org/SH4/sbuildQEMU)

# 步骤

## 安装依赖环境
```bash
apt-get install sbuild qemu-user-static binfmt-support schroot devscripts debian-ports-archive-keyring
```
执行命令：

## 创建riscv的chroot->rootfs
执行这一步时，一定把路径cd 到`/srv/chroots`下面，当然，不进入那里面问题也不大，只能在当前目录使用吧。

```bash
sudo  debootstrap --no-check-gpg --include=debian-ports-archive-keyring --arch=riscv64 \
  unstable sid-riscv64-sbuild http://ftp.ports.debian.org/debian-ports/
```
参数解析：
`--arch`: Set the target architecture

`--include=alpha,beta`:  Comma separated list of packages which will be added to download and extract lists.

上面的命令得执行一段时间，然后最后就可以看见如下的提示:
```bash
...
I: Configuring libc-bin...
I: Base system installed successfully.
```

这个时候就会在 /srv/chroots 目录下创建了一个 名为`sid-riscv64-sbuild `的rootfs。

```bash
vimer@debian:/srv$ ls
chroots  sid-riscv64-sbuild
# chroots是我之前创建的，可不理会
vimer@debian:/srv$ tree -L 2
.
├── chroots
│   └── sid-sbuild.tgz
└── sid-riscv64-sbuild
    ├── bin -> usr/bin
    ├── boot
    ├── dev
    ├── etc
    ├── home
    ├── lib -> usr/lib
    ├── media
    ├── mnt
    ├── opt
    ├── proc
    ├── root
    ├── run
    ├── sbin -> usr/sbin
    ├── srv
    ├── sys
    ├── tmp
    ├── usr
    └── var
```

添加用户成为sbuild的一员：

```bash
vimer@debian:/srv$ sudo adduser vimer sbuild
The user `vimer' is already a member of `sbuild'.
#因为我也是之前添加过，暂时不必理会
```

将qemu的静态可执行程序移动到对应的rootfs中:

```bash
vimer@debian:/srv$ sudo cp -av /usr/bin/qemu-riscv64-static /srv/chroots/sid-riscv64-sbuild/usr/bin/
'/usr/bin/qemu-riscv64-static' -> '/srv/chroots/sid-riscv64-sbuild/usr/bin/qemu-riscv64-static'
```
进入chroot进行验证:
```bash
vimer@debian:/srv$ sudo chroot sid-riscv64-sbuild
root@debian:/# uname -a
Linux debian 4.19.0-18-amd64 #1 SMP Debian 4.19.208-1 (2021-09-29) riscv64 GNU/Linux
```

## 修改配置文件

```bash
vimer@debian-local:~$ cat /etc/schroot/chroot.d/sid-riscv64-sbuild
[sid-riscv64-sbuild]
description=Debian sid chroot for riscv64
type=directory
directory=/srv/chroots/sid-riscv64-sbuild
#groups=Debian,guest,d-i
#profile=dsa
#aliases=sid
groups=root,sbuild,vimer,buildd
root-groups=root,sbuild,vimer,buildd
#command-prefix=
#source-root-users=glaubitz,sbuild,buildd
#run-setup-scripts=true
#run-exec-scripts=true
```

## 修改（riscv）和sid的源

```bash
#deb http://ftp.ports.debian.org/debian-ports unstable main
deb http://deb.debian.org/debian sid main #视情况打开
deb-src http://deb.debian.org/debian/ sid main
# 以下的ports sources是这次添加进来的，参看上面的解释或者以下的url:
# https://wiki.debian.org/RISC-V#Package_repository
deb http://ftp.ports.debian.org/debian-ports/ sid main
deb http://ftp.ports.debian.org/debian-ports/ unreleased main
deb-src http://ftp.ports.debian.org/debian-ports/ sid main
```
然后就可以chroot这里面做相应的打包测试了。


# 编译riscv debian packages

## chroot下build

因为整个arch为riscv所以可以直接在chroot中直接使用相关的编译命令。

如果source code已经有了完整了 `debian/`目录，我们可以直接使用以下命令:
```bash
root@debian:/home/build_test/sip/sofia-sip-1.12.11+20110422.1# dpkg-buildpackage -rfakeroot -us -uc
```

这个过程中，提示缺少啥就安装啥就可以。

在chroot内部执行编译命令，哪里都好就是速度太慢，巨慢的那种。

## 使用sbuild

上面的基本环境搭建好之后，就可以进行相关的测试了。

首先使用`apt source`命令，下载你要移植的包，比如这个 [tbb](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1002968)

```bash
# 1. apt source tbb
# 2. subild cmd 
sudo sbuild --arch=riscv64 -d sid-riscv64-sbuild
```