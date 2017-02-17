---
layout: article
title: "Debian安装Bochs"
category: tools
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

4.__make__

5.__make install__

这只是把软件安装上了，最重要的一步还没做：配置bochs的文件。
由于我把bochs文件解压到用户目录下，所以该配置文件.bochsrc就可以放在用户目录下

##tips
网上有教程说配置liunx0.11内核，关键是我不知道这有什么作用，下面是linux0.11网址
[linux 0.11](http://www.oldlinux.org/Linux.old/images/bootimage-0.11-20040305)

6.配置bochs启动文件

{% highlight bash %}
#how much memory the emulated will have
megs: 32
#filename of ROM images
romimage: file=/home/yubo/bochs/bios/BIOS-bochs-latest

vgaromimage: file=/home/yubo/bochs/bios/VGABIOS-lgpl-latest

#vga: extension=vbe
#what disk image will be used
floppya: 1_44=/home/yubo/a.img,status=inserted  #注意路径一定要写全,我这里把镜像文件放在了用户目录下的中，下同

#floppyb: 1_44=/home/yubo/bochs/linux0.11/rootimage-0.11-20040305,status=inserted  #注意路径一定要写全
#choose the boot disk
boot: floppy

log: bochsout.txt
#disable mouse
mouse: enabled=0

{% endhighlight %}

看到没，我们对Bochs的控制全在这里，包括映像文件的路径和启动顺序，至于a.img是在怎么来的，请看下面的东东，我们将配置文件写好以后，使用命令

__bochs__

会出来选项，直接回车(就是选择6),然后弹出一个窗口，在原来窗口的提示内键入

__c__

这时你再看模拟器窗口，啊，整个世界开朗了。
#Bochs的使用
其实在上面的安装过程中，我可能遗漏了很多组建，默认安装Bochs及其组件可以使用以下命令：

sudo apt-get install vgabios bochs bochs-x bximage

当然，首先推荐使用源码安装这样可以设置一些自己想要的功能，比如调试。

“计算机”安装好了，我们接下来应该怎么办呢？对了，安装硬盘或者软盘，你总得让计算机启动吧，就是使用__bximage__命令。

bximage：

出现以下界面，
<pre>
yubo@debian:~$ bximage
========================================================================
                                bximage
  Disk Image Creation / Conversion / Resize and Commit Tool for Bochs
         $Id: bximage.cc 12364 2014-06-07 07:32:06Z vruppert $
========================================================================

1. Create new floppy or hard disk image
2. Convert hard disk image to other format (mode)
3. Resize hard disk image
4. Commit 'undoable' redolog to base image
5. Disk image info

0. Quit

Please choose one [0] 1
Create image

Do you want to create a floppy disk image or a hard disk image?
Please type hd or fd. [hd] fd

Choose the size of floppy disk image to create, in megabytes.
Please type 160k, 180k, 320k, 360k, 720k, 1.2M, 1.44M, 1.68M, 1.72M, or 2.88M.
 [1.44M]

What should be the name of the image?
[a.img]

Creating floppy image 'a.img' with 2880 sectors

The following line should appear in your bochsrc:
  floppya: image="a.img", status=inserted
</pre>
这时在当前目录下产生了一个 a.img,这就是我们需要的软盘映像(自己想把img文件的格式学习一下，结果网上的资料不是很多)，书上说映像文件是按字节复制，记住，a
.img只是一个软盘，没有任何东西，我们接下来要把编译的二进制文件(引导扇区)写进软盘里
<pre>
yubo@debian:~$ dd if=boot.bin of=a.img bs=512 count=1 conv=notrunc
记录了1+0 的读入
记录了1+0 的写出
512字节(512 B)已复制，9.3823e-05 秒，5.5 MB/秒
</pre>
稍微解释一下这个命令，if是input file的缩写，of是out file的缩写，也就是目标文件，bs是文件的大小，count不是很清楚，conv=notrune是不要截断.
注意路径问题就行
##下面是boot.asm文件，我们使用命令

__nasm boot.asm -o boot.bin__

{% highlight c %}
org 07c00h ;load first instructor notify compile

mov ax,cs
mov ds,ax
mov es,ax

call DispStr ;call char functions

jmp $; loop

DispStr:
	mov ax,BootMessage
	mov bp,ax
	mov cx,16
	mov ax,01301h
	mov bx,000ch
	mov dl,0
	int 10h
	ret
	BootMessage: db "hello,OS world!"
	times 510-($-$$) db 0
	dw 0xaa55
{% endhighlight %}

简单介绍下这个文件的意思，引导扇区，是从0面0磁道1扇区到0xAA55,之间应包含少于512字节的执行码，一旦BIOS发现了引导扇区，就会将这512字节的内容装载到内存地址0000:7c00处，然后跳转到0000:7c00处将控制权交给这段引导代码。
