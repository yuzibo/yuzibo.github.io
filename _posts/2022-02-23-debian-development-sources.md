---
title: Debian 开发资源列表
category: debian-riscv
layout: post
---
* content
{:toc}

涉足Debian社区快两周了，也大体上知道了Debian开发的一些流程。但是某些东西还是停留在纸上，所有的东西都要动手去实践。

Debian社区是比较古老的、比较geek的氛围。尤其是，主导这个社区的是一群德国佬(核心开发者，肯定也有其他地区的)，出于语言、
文化等方面的影响，新人尤其是像我这种新手想要融入进去，一开始还是不少受挫折。老板说的对，脸皮厚，三观正就可以了(.

这篇文章的主要目的是把最后在开发过程中遇到的一些有用的资源放在这里以方便自己后面的工作。通过这些文档或者指南，我还是
认为，在软件行业，只有开源开发者或者 "自由职业者"才会打造经典的作品。


# Port riscv 入门级资料

## debian ports docs

## doc
[ports-news](https://wiki.debian.org/PortsDocs/New)

### official_port
[New#Official_port](https://wiki.debian.org/PortsDocs/New#Official_port)
这里面有几个installer的东西还没有定下来。

## debian machines

https://db.debian.org/machines.cgi

## riscv64-buildd

rv-rr44-01 and rv-mullvad-0x are Unleashed boards

rv-osuosl-0x are Unmatched boards

Other are QEMU VMs.

以上buildd machines的信息在 2023/07/23 以后无效了，或者说早就不存在了。

## uploading packages

https://buildd.debian.org/status/recent.php?pkg=&a=riscv64&suite=sid&limit=250

## debian-port mirrors
### tencent mirrors
```bash
deb https://mirrors.tencent.com/debian-ports sid main non-free
```

### iscas mirrors
```bash
deb  https://mirror.iscas.ac.cn/debian-ports/ unstable main
```

## wiki
1. [debian riscv wiki](https://wiki.debian.org/RISC-V#)
2. [debian cross-compiling](https://wiki.debian.org/CrossCompiling)
3. [debian irc list](https://wiki.debian.org/IRC)

还有几个比较重要的wiki:

4. [WhatIsUnreleased](https://wiki.debian.org/PortsDocs/WhatIsUnreleased?action=show&redirect=DebianPorts%2FWhatIsUnreleased)
5. [DebianUnstable](https://wiki.debian.org/DebianUnstable)

服务器是:`irc.oftc.net`,相关的几个channal:
```bash
#debian-bugs
#debian-buildd: Teams/DebianBuildd
##debian-mentors: Support for new contributors with questions on packaging and Debian infrastructure projects/services. See also the debian-mentors mailing list.
#debian-ports: https://www.ports.debian.org/
#debian-riscv: Debian RISC-V port
#devscripts: devscripts
#debci
#debian-golang
#debian-python
#debian-qa
#debian-rust
#debian-toolchain
#reproducible-builds
#llvm
```
## 符号定义riscv64
[https://wiki.debian.org/ArchitectureSpecificsMemo](https://wiki.debian.org/ArchitectureSpecificsMemo)

## mail list
### Debian ports
在做debian port时，主要会用到以下两个列表：

debian-riscv@lists.debian.org

debian-cross@lists.debian.org


## FTBFS
以下几个资源是展示的目前Debian包在riscv上编译的情况。

1. [btbfs page](https://udd.debian.org/cgi-bin/ftbfs.cgi?arch=riscv64)
这个页面快速直达目前编译riscv有问题的debian packages list.
2. [The UDD provides an overview about patches that we currently have
pending](https://udd.debian.org/cgi-bin/bts-usertags.cgi?user=debian-riscv@lists.debian.org) 带有patch
3. [更全的页面](https://buildd.debian.org/status/architecture.php?a=riscv64)从整个buildd数据库角度看的

### 一些基本规则

比如，这种类型的ftbfs: 
```bash
ceph: FTBFS on riscv64: undefined reference to `__atomic_exchange_1'
```
解决方案是参考 https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=953003

```bash
Description: Link with -pthread instead of -lpthread to fix FTBFS on riscv64
Forwarded: no
Last-Update: 2020-03-01

--- ceph-14.2.7.orig/CMakeLists.txt
+++ ceph-14.2.7/CMakeLists.txt
@@ -28,6 +28,7 @@ list(APPEND CMAKE_MODULE_PATH "${CMAKE_S
 
 if(CMAKE_SYSTEM_NAME MATCHES "Linux")
   set(LINUX ON)
+  set(THREADS_PREFER_PTHREAD_FLAG ON)
   FIND_PACKAGE(Threads)
 elseif(CMAKE_SYSTEM_NAME MATCHES "FreeBSD")
   set(FREEBSD ON)
```

## Debian-installer
[https://lists.debian.org/debian-boot/2019/06/msg00017.html](https://lists.debian.org/debian-boot/2019/06/msg00017.html)

# Debian开发者

## 统计
目前有一个有趣的页面，记录了目前DD作为sponsor upload了多少了package：

[sponsorstats](https://udd.debian.org/sponsorstats.cgi)最惊人的是第一名的gregoa，upload了1663个package，这也就是说，十年的话，每年也得166+。当然，加油啊！

## packaging

### nodejs

[nodejs](https://wiki.debian.org/Javascript)

Email contact: pkg-javascript-devel@lists.alioth.debian.org | Subscribe to mailing list/View archives

IRC: #debian-js on irc.oftc.net network

If you are new to javascript packaging, you can contact Debian Javascript Mentors channel via Matrix https://matrix.to/#/#debian-js-mentors:poddery.com or IRC: #debian-browserify on irc.oftc.net network


## 邮件列表

作为Debian的开发者，还需要订阅以下邮件列表:

### [debian-devel-announce](https://lists.debian.org/debian-devel-announce/)

Announcements of development issues like policy changes, important release issues &c.
Only messages signed by a Debian developer will be accepted by this list.

注意，只有DD发的信才有可能被这个列表接受。

### [debian-news](https://lists.debian.org/debian-news/)

General news about the distribution and the project.
The current events and news about Debian are summarized in the Debian Weekly News, a newsletter regularly posted on this list.

### [debian-mentors](https://lists.debian.org/debian-mentors/)

Helping newbie developers

作为一名潜在的开发人员，还应该订阅这个针对新手打包的列表。

当然，这里还有一个[辅佐材料 Debian Mentors Faq](https://wiki.debian.org/DebianMentorsFaq)可以扩展自己的知识面，加深对Debian的workfolw的理解。



## 如何生成patch

[prepare patches for Debian Packages ](https://raphaelhertzog.com/2011/07/04/how-to-prepare-patches-for-debian-packages/)

## Debian打包教程
这个[wiki](https://wiki.debian.org/Packaging)是一个非常棒的教程: 如何使用Debian官方的方式进行打包，值得一读。

# 开发者手册

## 如何向Debian做贡献

参考这个[网页](https://mentors.debian.net/intro-maintainers/), 两种方式：

1. 构建自己的package
2. 寻找一个[wnpp](https://www.debian.org/devel/wnpp/)的package

都在上面的链接中说明。

## 领养一个package

根据上面的资料，我们在wnpp下可以选择一个Orphand的pkg，可以使用`bts retitle`告诉tracker系统，但是，还有很多东西
去做才可以。

1. [adopting a package](https://www.debian.org/doc/manuals/developers-reference/pkgs.en.html#adopting-a-package)

2. [intro-maintainer](https://mentors.debian.net/intro-maintainers/)

第一件事就是： update Maintainer field in  changelog. 还有就是一定得把2的手册通读、理解彻底。


## NMU或者QA上传

[nmu-qa-upload](https://www.debian.org/doc/manuals/developers-reference/pkgs.html#nmu-qa-upload)

[步骤](http://manpages.ubuntu.com/manpages/jammy/en/man7/dgit-nmu-simple.7.html)

## building the package
[building the package](https://www.debian.org/doc/manuals/maint-guide/build.en.html) with `dpkg-buildpackage` command.

## upload experimental
上传到 experimential后，然后会在一定时间内上传到 [NewQueue](https://wiki.debian.org/NewQueue)

# bts
## [Debian Package Tracking System](https://packages.qa.debian.org/common/index.html)

    The Package Tracking System lets you follow almost everything related to the life of a package. It's of interest for co-maintainers, advanced users, QA members, ...

在这个页面上解释的很清楚，也确实这么做的。但是，我也是在查找某些软件闯进这个网站的，后面补充更高级的用法。

## sponsorship-requests
All [RFS](https://bugs.debian.org/sponsorship-requests) is here. You can see a lot of the RFS.

使用命令行如下：
```bash
reportbug sponsorship-requests
```

# Debian Glossary

在Debain社区有很多自己的词汇，如果我们一开始觉得不那么适应，可以参考[这里](https://mentors.debian.net/intro-maintainers/)

# debci

查看debci system的info:
[system-day](https://ci.debian.net/munin/system-day.html)

# debian-buildd
buildd不止有一个，这里还有一个第三方的平台：

## reproducible-builds.org
https://reproducible-builds.org/contribute/debian/
这是一个有益的补充，后面看看如何添加这个buildd task for riscv64

IRC: #reproducible-builds

和 Debian 相关的： #debian-reproducible
### some fix
一些fixup暂时安排在这里，后面在进行一个page整理。

####  fix build path

The attached patch fixes this by adjusting various Makefiles to set
-ffile-prefix-map in CFLAGS, which avoids embedding the build path in
the compiled binaries.

```bash
This avoids embedding the build path in the resulting binaries.

https://reproducible-builds.org/docs/build-path/
---

diff --git a/Makefile b/Makefile
index 61dade4..2d78375 100644
--- a/Makefile
+++ b/Makefile
@@ -1,5 +1,7 @@
 SUBDIRS = zip libarchive gvfs

+export BUILDPATH = $(CURDIR)
+
 all install clean shared static::
        target=`echo $@ | sed s/-recursive//`; \
        list='$(SUBDIRS)'; for subdir in $$list; do \
diff --git a/gvfs/Makefile b/gvfs/Makefile
index 9c5d759..8bd0c08 100644
--- a/gvfs/Makefile
+++ b/gvfs/Makefile
@@ -9,6 +9,8 @@ CFLAGS =-I. -I/usr/include \
        -Wall -fPIC -O2 -g \
        -DG_DISABLE_DEPRECATED -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_GNU_SOURCE
+# Avoid embedding build path
+CFLAGS += -ffile-prefix-map=$(BUILDPATH)=.
```

## build-portbox
[wiki](https://wiki.debian.org/PortsDocs/BuilddPorterboxSetup?action=show&redirect=PortsDocs%2FBuilddSetup)


# Debian release 
Debian release team是一个很大的团队，这里面有很多事情可以做。作为riscv64 的porter,我们首先需要时刻关注这个
[https://release.debian.org/testing/arch_qualify.html](https://release.debian.org/testing/arch_qualify.html)

这个是成为release的标准:
[https://release.debian.org/testing/arch_policy.html](https://release.debian.org/testing/arch_policy.html).

## debian autoremovel

可以关注这个页面，万一有自己维护的包被 autoremovel:
[#1011268](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1011268) -> [https://udd.debian.org/cgi-bin/autoremovals.cgi](https://udd.debian.org/cgi-bin/autoremovals.cgi)

# Debian-ftp
## dak
Some docs: https://ftp-team.pages.debian.net/dak/docs/

## dinstall

https://ftp-master.debian.org/stat/dinstall.png

https://ftp-master.debian.org/dinstall.status

## removal
https://ftp-master.debian.org/removals.html
# 不同的声音

[go team packaging wiki](https://www.mail-archive.com/debian-go@lists.debian.org/msg01127.html)

* https://salsa.debian.org/onlyjob/notes/-/wikis/no-dep14
* https://salsa.debian.org/onlyjob/notes/-/wikis/no-gbp
* https://salsa.debian.org/onlyjob/notes/-/wikis/bp

# rvlab -- fix

1. 
```bash
mount -o remount,rw /boot
```
解决 `/boot` is ready-only


2. 不升级image
```bash
sudo apt-mark hold linux-image-riscv64
```

# packaging tools

## copyrightReviewtools
[copyrightreviewtools](https://wiki.debian.org/CopyrightReviewTools)

## review list
[review list](https://people.debian.org/~abe/sponsoring/)