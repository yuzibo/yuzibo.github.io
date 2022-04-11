---
title: Debian 缺陷跟踪系统（BTS）
category: debian-riscv
layout: post
---
* content
{:toc}

最权威的莫过于这个[页面](https://www.debian.org/Bugs/#pkgreport).

还可以参考[这个](https://www.mankier.com/1/bts).

当我们比如说，在FTBFS(https://udd.debian.org/cgi-bin/ftbfs.cgi?arch=riscv64)发现一个build fail时，我们想进一步跟进这个fix。那么，可以首先看一下这个 issue number(以[yubiserver](https://buildd.debian.org/status/package.php?p=yubiserver&suite=sid)为例):

我们单击链接进去之后，会在 [Debian Package Auto-Building](https://buildd.debian.org/status/package.php?p=yubiserver&suite=sid)这个页面上看到顶层有这个几个链接:

1. [Tracker](https://tracker.debian.org/pkg/yubiserver)
    这个是有关pkg(package)一个完整的概括，涉及到了该pkg的方方面面：维护者、action、bugs、link等等。如果你想了解另一个package的基本情况，可以在该页面的右上角进行搜索。

2. [Changelog](http://metadata.ftp-master.debian.org/changelogs/main/y/yubiserver/yubiserver_0.6-3.1_changelog)
    这个数据就是从软件包中的 `debian`目录中的Changelog文件得来的，基本可以清楚的了解到这个package的一个完整的life。

3. [bugs](https://bugs.debian.org/cgi-bin/pkgreport.cgi?src=yubiserver)
    这里我们可以看到目前该包的一些bugs情况，当然，这里我们也是可以看见有开发者对build失败做了patch了，那我们就进行测试或者push这个patch往下发展就行了。[#1002079 yubiserver fails to port with riscv](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1002079)

    这里有很多意外的情况，之所以意外是因为，在一般的社区里，我们提交了patch后会有maintainer进行merge或者review建议什么的，但是在这种Debian（非营利性社区）没有利益的OS发行版里面，肯定会有大量的packages没有人进行维护。也就是有些包没人维护了，成了孤儿了。当然，对于这种情况，我也看到了有一种选择是NMU(non-maintain-upload)，这个后面我们再说。

    还有一种就是[MIA](https://wiki.debian.org/Teams/MIA)，当然今天我们的篇幅不是聚焦在这里，这里暂且记录一下后面再新开一篇进行补充。

    <pabs> ideally the maintainer returns to work on them, failing that they will get orphaned and then anyone who wants to fix them can do that. another option is for someone who uses the package and wants to maintain it to "salvage" the package

    <pabs> links related to that: https://wiki.debian.org/Teams/MIA 

    https://wiki.debian.org/qa.debian.org/MIATeam

    https://wiki.debian.org/PackageSalvaging

4. [packages.d.o](https://packages.debian.org/source/sid/yubiserver)
    我们在使用`apt source`命令进行下载代码的任务时，你会发现他其实第一步是下载的`.dsc`文件，那么这个dsc文件在哪里呢？
    答案就是这里，我们可以点进去发现，有一个dsc文件，有一个orig的源代码文件，还有一个debian tar文件，后面我们会说这些文件是怎么来的以及怎么用。

5. [source](https://sources.debian.org/src/yubiserver/0.6-3.1/)
    可以查看在Debian org上的 code。

以上这几个就是我们常见的有关package的资源。

通过以上的分析，不知道大家有没有注意到一个现象： 目前的Debian bug有很多都没有及时推进，其实很可能就是陷入了上面第三条提到的MIA(Missing in action)，这个问题比较棘手。假设你想拯救一个package的话，首先得成为一名DM，所以，还是最快的速度upload自己维护的pkg，让社区开始接受你。



熟悉BTS的话还得需要掌握 `reportbug`工具的使用，这个会单独出一篇文章或者合并到这里面来。可以首先参考[这里](https://itsfoss.com/bug-report-debian/)

但是如果想要维护一个孤儿包的话，需要使用 `bts`命令。

# bts
是的，这里的`bts`是一个命令，Debian people在一开始就想着把所有的东西通过命令行来解决，包括bug tracker system(BTS)

我们先来看一个[bug #993599](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=993599).

message #5

```bash
From: Didier 'OdyX' Raboud <odyx@debian.org>
To: Debian Bug Tracking System <submit@bugs.debian.org>
Subject: O: jimtcl -- small-footprint implementation of Tcl named Jim
Date: Fri, 03 Sep 2021 16:27:34 +0200
```
这个O是odyx根据`reportbug`进行的report,O就是orphened（弃儿）的代表，可以参考[这里](https://www.debian.org/devel/wnpp/):

那么，如果我想收养这个遗弃的package的话，怎么做呢？  使用 `bts`命令:

```bash
vimer@debian:~$ export DEBEMAIL=tsu.yubo@gmail.com
vimer@debian:~$ bts --mutt retitle 993599 'ITA: jimtcl -- small-footprint implementation of Tcl named Jim' , owner 993599 '!'
```
上面那个变量DEBEMAIL必须设置，否则使用`bts --mutt` 无效。这里多说一点，目前针对bts的配置文件(/etc/devscripts.conf and ~/.devscripts)，相关文档不是特别[完善](https://manpages.debian.org/testing/devscripts/bts.1.en.html)，看看这里的后期是不是一个优化的方向。

`bts`这时候就会激活mutt的窗口，我们可以看到bts是向 `control@bugs.debian.org`发信的，其信件的body是

```bash
retitle 993599 ITA: jimtcl -- small-footprint implementation of Tcl named Jim
owner 993599 !
thanks
```
也就是说，我们只需在body中将bts的命令完成即可。当然，这里bts最喜欢的使用MTA，我这里是使用mutt代替的MTA。
等发信完成后，我们稍等几分钟，就会收到如下的subject:

```bash
Processed: retitle 993599 to ITA: jimtcl -- small-footprint implementation of Tcl named Jim, owner 993599
```
我们再具体看一下回的消息:

```bash
from:	Debian Bug Tracking System <owner@bugs.debian.org>
to:	vimer <tsu.yubo@gmail.com>
cc:	tsu.yubo@gmail.com,
wnpp@debian.org
date:	Mar 3, 2022, 5:54 PM
subject:	Processed: retitle 993599 to ITA: jimtcl -- small-footprint implementation of Tcl named Jim, owner 993599

Processing commands for control@bugs.debian.org:

> retitle 993599 ITA: jimtcl -- small-footprint implementation of Tcl named Jim
Bug #993599 [wnpp] O: jimtcl -- small-footprint implementation of Tcl named Jim
Changed Bug title to 'ITA: jimtcl -- small-footprint implementation of Tcl named Jim' from 'O: jimtcl -- small-footprint implementation of Tcl named Jim'.
> owner 993599 !
Bug #993599 [wnpp] ITA: jimtcl -- small-footprint implementation of Tcl named Jim
Owner recorded as vimer <tsu.yubo@gmail.com>.
> thanks
Stopping processing here.

Please contact me if you need assistance.
--
993599: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=993599
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems
```

这个时候我们在[bug=993599](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=993599)上面看到BTS已经更改了jimtcl的owner:

```bash
Owner recorded as vimer <tsu.yubo@gmail.com>. Request was from vimer <tsu.yubo@gmail.com> to control@bugs.debian.org. (Thu, 03 Mar 2022 09:54:03 GMT) (full text, mbox, link).
```
# 深度
The Debian BTS starting point: [https://bugs.debian.org/](https://bugs.debian.org/). From there, there are two pages that will teach you how to communicate with the server: - [https://www.debian.org/Bugs/server-request](https://www.debian.org/Bugs/server-request) and [https://www.debian.org/Bugs/server-control](https://www.debian.org/Bugs/server-control/)

以上片段摘自[here](https://arnaudr.io/2016/10/01/publishing-a-debian-package-mentors-sponsorship/).