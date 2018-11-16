---
title: "debian常用命令"
layout: post
category: debian
---

* content
{:toc}

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

# linux快捷键设置

比如，我想要debian上实现终端快捷键是“Ctrl + Alt + T”,可以这样做：

在xfce4的面板中，单击“应用程序菜单” -> "设置"->“键盘” ->“快捷键设定” ->

![quick-1.png](http://7pum5d.com1.z0.glb.clouddn.com/quick-1.png)

这样也就可以了吧。

# 常用快捷键

这里先说上文中的第一个，因为在Ubuntu中，打开一个终端的命令是“Ctrl”+“Shift”+“T”,然后从主目录登录，具体就是 /home/usr-name. 打开终端后你可以从设置里面在设置，这里的设置是从当前窗口fork一个窗口的资源，目录没有变化，我的是“Ctrl”+“shift”+“N”的快捷键。

在debian xfce上，截屏的快捷键是 xfce4-screenshooter,找到以后绑定。

