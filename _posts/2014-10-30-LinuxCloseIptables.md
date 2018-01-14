---
title: "linux关闭防火墙"
layout: article
category: shell 
---
# 问题
最近在折腾虚拟机，因为两个机器之间的访问而忙的焦头烂额，在弄明白主机与虚拟机之间的联系方式后，有些问题还是让我心存疑惑。其中之一，我就纳闷是不是因为我的虚拟机的防火墙没有关闭，导致主机ping不动主机，于是乎，随手google了一下，将这个问题记录一下。奥，忘了，我的宿主系统及虚拟系统是Debian.所有操作是在root权限执行的。

## 首先确认你的系统已经安装Iptables

__whereis iptables__

## 查看Iptables目前的配置信息

__sudo iptables -L__

如果你第一次安装配置 iptables，会得到如下信息，
`
Chain INPUT (policy ACCEPT)
target prot opt source destination
Chain FORWARD (policy ACCEPT)
target prot opt source destination
Chain OUTPUT (policy ACCEPT)
target prot opt source destination
`

