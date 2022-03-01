---
title: Debian 缺陷跟踪系统（BTS）
category: debian-riscv
layout: post
---
* content
{:toc}

最权威的莫过于这个[页面](https://www.debian.org/Bugs/#pkgreport).

当我们比如说，在FTBFS(https://udd.debian.org/cgi-bin/ftbfs.cgi?arch=riscv64)发现一个build fail时，我们想进一步跟进这个fix。那么，可以首先看一下这个 issue number(以[yubiserver](https://buildd.debian.org/status/package.php?p=yubiserver&suite=sid)为例):

我们单击链接进去之后，会在 [Debian Package Auto-Building](https://buildd.debian.org/status/package.php?p=yubiserver&suite=sid)这个页面上看到顶层有这个几个链接:

1. [Tracker](https://tracker.debian.org/pkg/yubiserver)

这个是有关pkg(package)一个完整的概括，涉及到了该pkg的方方面面：维护者、action、bugs、link等等。如果你想了解另一个package的基本情况，可以在该页面的右上角进行搜索。

2. [Changelog](http://metadata.ftp-master.debian.org/changelogs/main/y/yubiserver/yubiserver_0.6-3.1_changelog)

这个数据就是从软件包中的 `debian`目录中的Changelog文件得来的，基本可以清楚的了解到这个package的一个完整的life。

3. [bugs](https://bugs.debian.org/cgi-bin/pkgreport.cgi?src=yubiserver)

这里我们可以看到目前该包的一些bugs情况，当然，这里我们也是可以看见有开发者对build失败做了patch了，那我们就进行测试或者push这个patch往下发展就行了。
[#1002079 yubiserver fails to port with riscv](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1002079)

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
