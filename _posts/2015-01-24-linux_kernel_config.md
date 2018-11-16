---
layout: post
title: "linux kernel 配置"
category: kernel
---

* content
{:toc}

# 好工具
之前一直为笔记本的驱动找不到合适的驱动，现在，有这么一个网站：

https://cateee.net/lkddb/

据官网介绍可以解决这个问题，不知道是真的还是假的

# 前言
在真的机子上debian的内核一次没有配置成功，我要用两天的时间把配置的内容探个究竟。

## 工具
在编译内核之前最好使用

	make mrproper

清扫一下。

我使用的是git，clone的linus的版本，一切准备妥当后，我们要选择合适的配置工具。
我选的是 make menuconfig,注意无论哪一种都需要相应的软件包。

# 配置
在配置前的方括号中按下“y”，就是built-in,这是将相关代码编译进内核，默认与目标机相关的硬件的代码必须内建进内核，这些东西就如同人的基本器官，不可无;另一种就是M，这是将相关的选项编译成模块，这样就可以是编译的内核的体积不过于太大，精简内核是我们必须掌握的知识点;最后一种就是按下"space",什么也不做，就是回答“no”。

## 补充
内核的发展太快了，当我写这篇文章的时候，代码还可以是最新的(git pull),但是很快就update的，不过，有些东西是不会变动太大。

### 说明：下面的项目就是我自己的内核的配置，后边的字母代表我的选项。


# 特殊的配置

# Namespace support

注意这篇文章：

http://lwn.net/Articles/531114/

http://unix.stackexchange.com/questions/92177/kernel-namespaces-support

# networking

### CAN BUS

CAN总线 编辑
同义词 CAN-BUS一般指CAN总线
CAN是控制器局域网络(Controller Area Network, CAN)的简称，是由以研发和生产汽车电子产品著称的德国BOSCH公司开发的，并最终成为国际标准（ISO 11898），是国际上应用最广泛的现场总线之一。 在北美和西欧，CAN总线协议已经成为汽车计算机控制系统和嵌入式工业控制局域网的标准总线，并且拥有以CAN为底层协议专为大型货车和重工机械车辆设计的J1939协议。[1]

### IrDA

红外线协议

### RF switch

射频那块的东西

# Device drives

### misc devices

杂项设备 杂项设备（misc device）
杂项设备也是在嵌入式系统中用得比较多的一种设备驱动。在 Linux 内核的include\linux目录下有Miscdevice.h文件，要把自己定义的misc device从设备定义在这里。其实是因为这些字符设备不符合预先确定的字符设备范畴，所有这些设备采用主编号10，一起归于misc device，其实misc_register就是用主标号10调用register_chrdev()的。
也就是说，misc设备其实也就是特殊的字符设备。

来自百度知道：

https://zhidao.baidu.com/question/354123482.html

### mpt
Media Transfer Protocol

### FDI

光纤式分布


