---
title: "linux中usb开发记录"
layout: article
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
