---
title: debian buildd
category: debian-riscv
layout: post
---
* content
{:toc}


简而言之，Debian作为一个稳定的发行版，那么依靠什么作为release的质量保证呢？随着对Debian了解的深入，现在才发现Debian有一个很意思的项目 [buildd](https://wiki.debian.org/BuilddSetup)和[buildd](https://wiki.debian.org/buildd).  那么，本篇文章的目标就是描述如何搭建buildd，更具体一点就是如何做一些针对 riscv64 的buildd.

# buildd的如何工作的
从[这里](https://www.debian.org/devel/buildd/)我们知道，buildd其实是由几部分组成的：

1. wanna-build: 类似一个数据库，决定了编译什么package以及其构建状态；

2. buildd： 这是一个守护进程，当我们配置好了一切，就可以在规定的时间内build出来并将package上传到某个位置；

3. sbuild: 这个不用多说了，和手工操作一样的。 [build log status](https://buildd.debian.org/).

在build log status中，针对于riscv64的buildd在sid release里面才有的，如果你再仔细看一下[failed](https://buildd.debian.org/status/recent.php?bad_results_only=on&a=all&suite=sid)就能找到当前在 sid中build fail的package了，这就是我们应该重点关注的地方。

未完待续。。。

