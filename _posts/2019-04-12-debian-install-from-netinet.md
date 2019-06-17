---
title: 最小化安装debian
category: debian
layout: post
---

为了节省时间，我在这次安装debian的时候使用了最小化安装的方式，期间遇到了一点小问题，所以记录在这里。

# 配置网络环境-dhcp
首先申明，我这是在windows上安装虚拟机后安装的debianm，形式上这个方式最简单的，这里澄清了我一直以来的几个疑惑。
先说一下，宿主windows系统的环境.

```c
以太网适配器 VirtualBox Host-Only Network:

   连接特定的 DNS 后缀 . . . . . . . :
   本地链接 IPv6 地址. . . . . . . . : fe80::d067:c83c:6978:62ce%10
   IPv4 地址 . . . . . . . . . . . . : 192.168.56.1
   子网掩码  . . . . . . . . . . . . : 255.255.255.0
   默认网关. . . . . . . . . . . . . :

以太网适配器 以太网:

   连接特定的 DNS 后缀 . . . . . . . :
   本地链接 IPv6 地址. . . . . . . . : fe80::8412:4c53:e44b:c829%3
   IPv4 地址 . . . . . . . . . . . . : 10.7.164.59
   子网掩码  . . . . . . . . . . . . : 255.255.255.0
   默认网关. . . . . . . . . . . . . : 10.7.164.254
```
也就是说，debian的外部ip(vbox的网卡显示)已经自动b分配了，一开始我还想着这个ip与内部的debian系统有关系
。就我目前的环境，我才明白，最小化安装方式是没有这种联系的。最小化安装方式里面，已经内置了dhcp协议，你可以直接设置。
登录到debian系统中，首先查看网卡接口，使用__ip a__即可。
接着就可以手动修改网络设置了。打开__/etc/network/interfaces/__文件，这样写:
```c
cat /etc/network/interfaces
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback
auto enp0s3
iface enp0s3 inet dhcp
#address 192.168.56.5
#netmask 255.255.255.0
#gateway 192.168.56.1
#dns-nameserver 8.8.8.8
```
然后重启网络服务：
```c
sudo /etc/init.d/networking restart
```
这个时候你就可以验证一下了:

```c
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:dc:fa:06 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global enp0s3
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fedc:fa06/64 scope link
       valid_lft forever preferred_lft foreveriii
```
其中，enp0s3是我的debian网络接口，这个你可以设置自己的。**#**符号开始的，是针对于固定ip的，这个时候你可以忽略。
。这个linux 的主机ip为  10.0.2.15/24

完成网络设置之后，你就应该更新源了，注意自己系统的代号，我就因为这个耽误了很长时间。
## ssh登录vbox的Linux系统
首先确保虚拟机的系统安装ssh服务器，debian下的ssh为openssh-server.然后再vbox的网络设置里面设置一个网络端口转发。
vbix界面主机IP默认为空(127.0.0.1或者localhost)，主机端口8080(这个你可以自己设置)，子系统IP默认就可以，为linux系统的ip地址: 10.0.2.15/24，挺有意思的默认就可以，为linux系统的ip地址: 10.0.2.15/24，挺有意思的。子系统端口为ssh的默认端口就好:22.

在vbox里设置完成之后，就可以使用终端工具登录内部的linux了。

```c
ssh -p 8080 username@localhost
```

# 局域网访问
局域网访问的意思是，虚拟机里的主机可以被外部访问，宿主操作系统类似一个网桥，对，也就是你在设置虚拟机链接主机的方式为**桥接方式**，然后静态的设置一个属于z你这个网段的ipd即可。当然，真实debian环境也是如此.

```c
cat /etc/network/interfaces
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

# The loopback network interface
source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback
auto enp0s3
#iface enp0s3 inet dhcp
iface enp0s3 inet static
address 10.7.164.78
netmask 255.255.255.0
gateway 10.7.164.254
dns-nameserver 10.7.164.254
```
这里的debian有一点我不是很理解，这里的DNS服务器为网关地址才可以，不知道我的理解对不对。

