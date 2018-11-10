---
title: "linux中usb开发记录"
layout: post
category: kernel
---

为了参加一个小比赛，目前需要了解一下linux usb的知识。

# 基础知识

### endpoint

A usb endpoint可以是下面四种类型的其中一个。

__CONTROL__

顾名思义，就是usb中控制设备行为的。通常当一个usb设备插入时有一个"endpoint 0"被用来使用。

__INTERRUPT__

这个端口每次以固定的大小有usb host向设备请求数据。USB 键盘和鼠标主要使用这个。

__BULK__

这个endpoint传输大的数据，如果想要数据没有丢失的话，就使用这个 endpoint.例如打印机、存储设备、网络设备。

__ISOCHRONOUS__

与上面的类似，区别在于不能保证数据会完全通过。


## 以上是高级的内容
现在的原理还没有彻底高明白， 但是，任何一个想被硬件捕捉的驱动必须有这个数据结构， 像侦测函数没有也是可以的。


```c
static struct usb_device_id hello_id_table[] = {

	{ USB_INTERFACE_INFO(USB_INTERFACE_CLASS_HID,
	  USB_INTERFACE_SUBCLASS_BOOT,
	  USB_INTERFACE_PROTOCOL_KEYBOARD) },
	{ }, /* Here are entry */
};

/* 向内核注册 */
MODULE_DEVICE_TABLE(usb, hello_id_table);
```

当你把这个数据结构和hello， world模块融合在一起，只要插入了模块，就可以使用udev规则插入模块。

暂时先记录在这里。
