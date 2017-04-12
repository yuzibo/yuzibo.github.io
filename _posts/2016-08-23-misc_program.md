---
title: "linux下的misc编程"
category: kernel
layout: article
---

# 补充材料

[here](http://stackoverflow.com/questions/18456155/what-is-the-difference-between-misc-drivers-and-char-drivers)

这篇文章解析了misc和[char](http://www.aftermath.cn/dev_char_kernel.html)的不同，但是思路都是一样的，主要可能是在归类的时候会有一些不同的。

先说一下，misc的主设备号已经被内核给固定死了，为10,只能修改次设备号(minor).

通常情况下，一个字符设备都不得不在初始化的过程中进行下面的步骤：

通过alloc_chrdev_region()分配主次设备号。

使用cdev_init()和cdev_add()来以一个字符设备注册自己。



而一个misc驱动，则可以只用一个调用misc_register()

来完成这所有的步骤。(所以miscdevice是一种特殊的chrdev字符设备驱动)

所有的miscdevice设备形成一个链表，对设备访问时，内核根据次设备号查找

对应的miscdevice设备，然后调用其file_operations中注册的文件操作方法进行操作。


