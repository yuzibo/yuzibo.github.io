---
title: "debian常用命令"
layout: article
category: debian
---

[原文](http://askubuntu.com/questions/17823/how-to-list-all-installed-packages)

前言。

最近老是在编译新的内核，但是总 boot不起来，问了很多人，还是老样子。尤其是国内的专家，我真不知道是不是应该称他为大神，但是她说了一通，建议我转向其他的发行版。

幸好没有听从他的建议。

debian已经做的非常好了。



# 一

### 列出debian系统已经安装的所有软件

#### Ubuntu 14.04 和 以上版本

	apt list --installed

#### 老的版本

这条命令就是列出你本机上所安装的所有软件，符合题意。

	dpkg --get-selections | grep -v deinstall

搜索一个特定的软件包

	dpkg --get-selections | grep xx

下面一条命令，搞定所有的东东

	dpkg -l

我们要熟悉 dpkg，逐渐抛弃apt-的用法。
