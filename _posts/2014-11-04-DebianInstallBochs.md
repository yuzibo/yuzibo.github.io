---
layout: article
title:"Debian 安装配置Bochs"
category:Linux
---

#问题阐述
最近安装了很多的软件，总是为了折腾linux而为的，今天晚上不小心把Bochs安装完毕，在此发文纪念一下了。

由于安装这个这个bochs中间因为网站的问题而搁置了好几天，但在linux系统下安装bochs总不能少了那几个软件包的支持，具体是哪几个我忘了。
#步骤
1.首先到bochs.sourceforge.net下载bochs源代码包并解压缩。
2.然后要安装五个软件，否则make，make install时会失败。
__apt-get nstall build-essential xorg-dev bison libgtk2.0-dev libtool libx11-dev xserver-xorg-dev__
3.进入所在目录，开始配置

	__./configure --enable-debugger --enable-disasm__
	两个enable分别表示启用bochs调试和反汇编。
4.	__make__
5.  __make install__

这只是把软件安装上了，最重要的一步还没做：配置bochs的文件。
由于我把bochs文件解压到用户目录下，所以该配置文件.bochsrc就可以放在用户目录下

##tips
网上有教程说配置liunx0.11内核，关键是我不知道这有什么作用，下面是linux0.11网址
[linux 0.11](http://www.oldlinux.org/Linux.old/images/bootimage-0.11-20040305)
6.配置bochs启动文件
*
megs: 32

romimage: file=/home/yubo/bochs/bios/BIOS-bochs-latest

vgaromimage: file=/home/yubo/bochs/bios/VGABIOS-lgpl-latest

vga: extension=vbe

floppya: 1_44=/home/yubo/bochs/bootimage-0.11-20040305,status=inserted  #注意路径一定要写全,我这里把镜像文件放在了用户目录下的bochs中，下同

floppyb: 1_44=/home/yubo/bochs/linux0.11/rootimage-0.11-20040305,status=inserted  #注意路径一定要写全

boot: a

log: bochsout.txt

mouse: enabled=0

*
#Over


