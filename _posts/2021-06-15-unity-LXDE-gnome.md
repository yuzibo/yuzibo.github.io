---
title: Unity LXDE Gnome的一些区别
category: tools
layout: post
---
* content
{:toc}

# LXDE

```bash
pcmanFM：文件管理器
lxpanel：桌面面板
lxsession：会话管理工具
lxappearance：gtk+主题更换工具
openbox：轻量窗口管理器
leafpad：轻量级编辑器，类似于记事本
xarchiver：超级轻量的解压（压缩）软件
lxnm：轻量级网络管理器
LXTerminal：模拟终端程序
```

# Gnome

ubuntu18.04.5 LTS 默认使用的gnome 3.28.5
```bash
文件管理 Nautilus
桌面面板 gnome-panel
会话管理工具 gnome-session
窗口管理器 mutter
看图工具 shotwell
编辑器  gedit
网络管理器 network-manager
终端 gnome-termina
```

# Unity

```bash
文件管理  Nautilus
窗口管理器 mutter
编辑器  gedit+leafpad
网络管理器 NetworkManager
终端 gnome-terminal
```

关于桌面系统，Linux下有两个概念

Display Manager：显示管理系统。
Desktop Environment: 桌面环境。
顾名思义，DM负责显示，DE负责创建用户操作的界面。两者都有不同的选项，并且没有强绑定或强依赖的关系，不同的DM可以支持不同的DE。

从用户角度来看，DM提供登录界面，DE提供登录后的桌面。

在Ubuntu18.04上，默认选择的DM是GDM3，DE是Unity，这两者都是相对重量级的系统，资源占用多，加载时间长，当然也带来相对好的视觉效果。



从节省资源的角度出发，可以选择相对轻量的DM和/或DE，当然也需要切换之后也需要使用新的用户体验。



Ubuntu18.04也提供了轻量化的选择：轻量级的DM是lightdm，轻量级的桌面可以选择LXDE。

GDM3+Unity （默认），登录界面：34s， memory cost: 1.4GB

GDM3 + LXDE, 登录界面：34s，memory cost: 1.1GB

Lightdm + Unity, 登录界面：20s，memory cost: 1.2 GB

Lightdm +LXDE: 登录界面：20s，memory cost: 865MB

