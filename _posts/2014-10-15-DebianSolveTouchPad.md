---
layout: article
title: "Debian解决触摸板无法使用的问题"
category: debian
---
# 1.问题描述

自己使用Debian系统也已经很长时间了，触摸板是一直无法使用，感觉没什么大问题也就得过且过，最近发现触摸板上的单击键不太灵敏了，这才觉得这样下去不是办法，于是乎，google了一下，发现问题是如此的简单，在这里，分享给需要帮助的朋友。
   	系统：	Debian Wheezy Xfce
# 2.解决过程

{% highlight bash %}
	1.首先，保证安装了 synaptics驱动
	sudo apt-get install xserver-xorg-input-synaptics
	2.复制 /usr/share/X11/xorg.conf.d到 /etc/X11
	sudo cp -R /usr/share/X11/xorg.conf.d /etc/X11
	3.将原 /etc/X11/xorg.conf.d/10-evdev.conf配置文件中的 TouchPad相关的部分修改如下：
	Section "InputClass"
		Identifier "evdev touchpad catchall"
		MatchIsTouchpad "on"
		MatchDevicePatch "/dev/input/event*"
		Driver "synaptics"
		Option "TapButton1" "1"
		Option "TapButton2" "2"
		Option "TapButton2" "3"
	EndSection
	{% endhighlight %}

# 3.重启系统

>reboot

	这样就解决了困扰我很久的在 Debian Wheezy Xfce上触摸板无法使用的问题
    [参考原文](www.linuxdc.com/Linux/2013-07/87680.htm)
