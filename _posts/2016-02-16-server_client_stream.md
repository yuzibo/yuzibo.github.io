---
layout: article
title: "流式套接字客户端服务端编程详解"
category: network
---

# 套接字概念
套接字(socket)是一种为计算机网络通信编程的接口,首次出现在美国加州Berkeley大学开发的BSD版本的系统中.有了套接字(应用层),从而允许我们进行服务器/客户端的开发,不必关心底层的细节.详细的关于内核网络协议的实现,我会在以后详细阐述,[现在,这篇文章](https://www.ibm.com/developerworks/cn/linux/l-linux-networking-stack/)

## 创建套接字
{% highlight c %}
#include<sys/types.h>
#include<sys/socket.h>
int socket(int domain,int type, int protocol)
{% endhighlight %}
### 说明
` domain`: 代表套接字地址族,常用的有AF_INET,PF_INET(IPv4),AF_INET6(IPv6),
AF_IPX(Novell 网络协议)...

`type`: 最常用的是SOCK_STREAM和SOCK_DGRAM,分别表示流式套接字和数据包套接字.

`protocol`: 一般情况下会设置为0,表示由系统在当前的domain下选择合适的协议.

##套接字地址


TODO
