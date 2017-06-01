---
title: "netlink嵌套字"
category: network
layout: article
---

在net/下，有af_netlink.c af_netlink.h genetlink.c和diag.c

af_netlink 文件中提供了绝大多数的API，genetlink提供了新的API，这使得更容易创建netlink消息。diag.c是为了dump netlink消息，里面是相关的API。

netlink较其他内核与用户空间的交流方式具有以下优势：

不需要poll模式，[前文](http://www.aftermath.cn/liinux_network_flow.html)我们说了。一个用户空间的程序打开一个socket，然后直接recvmsg(),如果没有从内核发送过来信息，就进入一个阻塞状态。例如，iproute2包中/lib/libnetlink.c中的 rtnl_listen()方法。还有一个优势是可以允许内核发送异步消息到用户空间，这不需要用户空间的程序去特定的抓取。最后一个优势就是netlink支持多播传输机制。


同样，创建netlink嵌套字使用socket()方法，类型可以是SOCK_RAW或者SOCK_DGRAM.

netlink嵌套字既可以在用户空间创建，也可以在内核空间创建。内核里使用方法**netlink_kernel_create()**去创建，这两者都会产生一个netlink_sock对象。用户空间的会被**netlink_create()**方法处理。内核里是**__netlink_kernel_create()**,这个方法设置了**NETLINK_KERNEL_SOCKET_**标志。最终所有的方法会调用**__netlink_create()**(源头其实是sk_alloc()),

用户空间的程序：

```c
socket(AF_NETLINK, SOCK_RAW, NETLINK_ROUTE);
```

然后创造一个**sockaddr_nl**的对象实例
