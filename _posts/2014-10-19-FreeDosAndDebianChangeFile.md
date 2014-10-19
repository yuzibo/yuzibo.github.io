---
layout: article
title: "在虚拟机中解决 FreeDos与宿主机文件交换的问题"
category: tools 
tags: FreeDos
---

最近在看于渊编写的<<自己动手写操作系统>>，里面编写基于 IA32的保护模式下 COM文件，于是乎下载FreeDos iso并在 VirtualBox 安装，其[详细手册请参阅](http://www.freedos.org/wiki/index.php/Main_Page) 

__使用网络__

在活动界面下，键入 auto 打开	AUTOEXEC.BAT
找到REM LH PCNTPK INT=0X60,将REM去掉，只剩下后面的其他

__配置 FTP服务__

`copy C:\FDOS\DOC\MTCP\SAMPLE.CFG C:\FDOS\MTCP.CFG
edit C:\fdos\mtcp.cfg`

激活以下选项

`MTU 1472
ftpsrv_password_file c:\fdos\ftppass.txt
ftpsrv_log_file c:\fdos\ftpsrv.log
FTPSRV_FILEBUFFER_SIZE 16
FTPSRV_TCPBUFFER_SIZE 16
FTPSRV_PACKETS_PER_POLL 2`

 然后创建FTP服务器的密码

 `edit C:\fdos\ftppass.txt`

 编写这个文件时应该按照以下格式
 user  password [none] [any] all
 我的就是
  xx   xx [none] [any] all

 顺便提一下;
 我的虚拟机里 FreeDos的ftp的端口是 21
 这里用的是NAT连接方式real ip is 10.0.2.15，
并且这种方式在后来的 ftpsrv不可用，至于为什么我
也是暂不得知。
后来我改用 桥连 ftpsrv 居然可用，真是不可思议。
后来的ip是 192.168.1.103,我第一次用 桥连 没有成功，当时是在
CMCC-EDU的环境下开启的，后来我在实验室连接路由器可以，是不是和
这个有关呢？

__开始DHCP客户端__

	1.用auto打开
	2.去除"DHCP"前的REM。
	一般的ip地址就在 C:\fdos\mtcp.cfg中

__开始FTP服务__

	ftpsrv
	然后在 宿主机 上就可以使用 ftp软件进行文件传输了。

本着够用即可的原则，就 freedos的文件交换先介绍到这。

