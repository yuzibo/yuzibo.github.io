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

其实上面创建`sid-amd64-base.tgz`意义不大，我们直接简单创建一个base chroot。

还可以在chroot很久没更新之后， 执行  `pbuilder update` 来更新下  chroot

```bash
sudo pbuilder create
```

如果在执行这一步之前，把下面的`.pbuilderrc`文件放到/root/，则这个create的chroot的属性就是配置文件制定的。

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
这里很奇怪的问题是，这个配置文件如果直接使用的话，还是传递不到pbuilder的命令里面来的。需要更新配置文件:

```bash
sudo pbuilder update --override-config --configfile ~/.pbuilderrc
```

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



## 指定dsc文件编译binary

```bash
sudo pbuilder build --basetgz /var/cache/pbuilder/base.tgz /tmp/build-area/jimtcl/jimtcl_0.79+dfsg0-3.dsc
```
首先声明的是， base.tgz文件是另外创建的，也是很简单的，使用我们上面提到的amd64的tgz也是可以的。然后，后面跟着的是dsc文件。



# 支持编译riscv64

如果支持riscv64,则basetgz最好使用 base.tgz,可以使用如下配置文件,放到/root/.pbuilderrc文件中:

```bash
MIRRORSITE=https://mirrors.tuna.tsinghua.edu.cn/debian
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ sid main contrib non-free
BASETGZ=/var/cache/pbuilder/base.tgz

PBUILDERSATISFYDEPENDSCMD="/usr/lib/pbuilder/pbuilder-satisfydepends-apt"
```

然后：

```bash
sudo pbuilder create
...
build-essential is already the newest version (12.9).
dpkg-dev is already the newest version (1.21.2).
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
I: Copying back the cached apt archive contents
I: unmounting dev/ptmx filesystem
I: unmounting dev/pts filesystem
I: unmounting dev/shm filesystem
I: unmounting proc filesystem
I: unmounting sys filesystem
I: creating base tarball [/var/cache/pbuilder/base.tgz]
I: cleaning the build env
I: removing directory /var/cache/pbuilder/build/24475 and its subdirectories
```
我们试验下：

```bash
sudo pbuilder build --host-arch riscv64 jimtcl_0.79+dfsg0-3.dsc
```
可以看到log:

```bash
Reading state information...
E: Unable to locate package crossbuild-essential-riscv64
E: Unable to locate package libc-dev:riscv64
E: Unable to locate package libstdc++-11-dev:riscv64
E: Couldn't find any package by regex 'libstdc++-11-dev'
I: Copying back the cached apt archive contents
I: new cache content 'python3.9_3.9.10-2_amd64.deb' added
I: new cache content 'gettext-base_0.21-4_amd64.deb' added
```
这说明我们的riscv64 源文件没有使用 ports。则我们需要对base rootfs进行修改(记住， pbuilder是执行完后就clean环境的)，则需要执行命令:

```bash
sudo pbuilder --login --save-after-login
```

这有什么用呢？ 还记得我们前面使用 sbuild with chroot添加的 debian-ports  sources list吗，同样，我们也需要对里面的源进行配置。

 上面的login之后， 首先安装：

```bash
# 1. install debian-ports-archive-keyring
apt install debian-ports-archive-keyring
# 2.  config source list
deb http://ftp.ports.debian.org/debian-ports/ sid main
deb http://ftp.ports.debian.org/debian-ports/ unreleased main
deb-src http://ftp.ports.debian.org/debian-ports/ sid main
```

注意，以上 debian-ports没有release 的软件，比如安装vim什么的是不行的，所以，还需要安装一个 sid source list.

最后还得更新配置：

```bash
 sudo pbuilder update --distribution sid --override-config
```

## 修改配置文件并使之生效

```bash
针对pbuilder的配置文件直接进行修改是无效的(最少我这里是不符合预期的)，那么，你就可以把配置文件更新下:

```bash
sudo pbuilder update --override-config --configfile ~/.pbuilderrc
```
以上两个开关互相配合，相互使用。

## 编译的产物

目前是放在这个位置,可以修改配置项:
```bash
 ls /var/cache/pbuilder/result/
libotr5-bin-dbgsym_4.1.1-4_armhf.deb  libotr5-dev_4.1.1-4_armhf.deb  libotr_4.1.1-4.dsc              libotr_4.1.1-4_source.changes
libotr5-bin_4.1.1-4_armhf.deb         libotr5_4.1.1-4_armhf.deb      libotr_4.1.1-4_armhf.buildinfo
libotr5-dbgsym_4.1.1-4_armhf.deb      libotr_4.1.1-4.debian.tar.xz   libotr_4.1.1-4_armhf.changes
```
## issue

在上面配置了 ports后我们还是发现:

```bash
Reading state information...
E: Unable to locate package crossbuild-essential-riscv64
I: Copying back the cached apt archive contents
```
我们使用 `sudo apt-cache search crossbuild-essential*`命令搜索一下发现，确实没有riscv64的essential tools。

```bash
vimer@9da75582c670:~/build_test/jimtcl$ sudo apt-cache search crossbuild-essential*
crossbuild-essential-amd64 - Informational list of cross-build-essential packages
crossbuild-essential-arm64 - Informational list of cross-build-essential packages
crossbuild-essential-armel - Informational list of cross-build-essential packages
crossbuild-essential-armhf - Informational list of cross-build-essential packages
crossbuild-essential-i386 - Informational list of cross-build-essential packages
crossbuild-essential-powerpc - Informational list of cross-build-essential packages
crossbuild-essential-ppc64el - Informational list of cross-build-essential packages
crossbuild-essential-s390x - Informational list of cross-build-essential packages
crossbuild-essential-mips - Informational list of cross-build-essential packages
crossbuild-essential-mips64 - Informational list of cross-build-essential packages
crossbuild-essential-mips64el - Informational list of cross-build-essential packages
crossbuild-essential-mips64r6 - Informational list of cross-build-essential packages
crossbuild-essential-mips64r6el - Informational list of cross-build-essential packages
crossbuild-essential-mipsel - Informational list of cross-build-essential packages
crossbuild-essential-mipsr6 - Informational list of cross-build-essential packages
crossbuild-essential-mipsr6el - Informational list of cross-build-essential packages
```
则我们可以想办法，把这个包下载下来然后丢进pbuilder中。

如果还有包无法安装，则我们可以使用大招 `--extrapackages`同`sbuild`。但是目前还是没有运行成功，可以参考:

```bash
Nope, it's not :-), just add:

BINDMOUNTS="/var/cache/pbuilder/result"

and put hook script somewhere:

# cat /var/cache/pbuilder/hooks/D70results
#!/bin/sh
cd /var/cache/pbuilder/result/
/usr/bin/dpkg-scanpackages . /dev/null >> /var/cache/pbuilder/result/Packages
/usr/bin/apt-get update

(But yes, it slows down build process even more...)
```
[link](https://lists.debian.org/debian-devel/2006/05/msg00550.html)
