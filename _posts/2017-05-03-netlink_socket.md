---
title: "netlink嵌套字"
category: network
layout: article
---

如果你有用户空间的程序去测试，请参考这篇文章[1](https://home.regit.org/netfilter-en/nftables-quick-howto/)

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

# 使用netlink sockets 库

libnl是与内核空间交流的用户空间程序的API，iproute2就是使用的libnl库，一般在这个源代码包的下面，有基本核心库(libnl),它支持一般netlink家族(libnl-genl),路由家族(libnl-route)和netfilter家族(libnl-nf).还有一个最小化的用户空间的库函数叫libmnl.

先来一段用户空间的程序，看看大体概貌

```c
#include <netlink/netlink.h>
#include <errno.h>

int main(int argc, char *argv[])
{
	struct nl_sock *h[1025];
	int i;

	h[0] = nl_socket_alloc();
	printf("Created handle with port 0x%x\n",
			nl_socket_get_local_port(h[0]));
	nl_socket_free(h[0]);
	h[0] = nl_socket_alloc();
	printf("Created handle with port 0x%x\n",
			nl_socket_get_local_port(h[0]));
	nl_socket_free(h[0]);

	for (i = 0; i < 1025; i++) {
		h[i] = nl_socket_alloc();
		if (h[i] == NULL)
			nl_perror(ENOMEM, "Unable to allocate socket");
		else
			printf("Created handle with port 0x%x\n",
				nl_socket_get_local_port(h[i]));
	}

	return 0;
}
```

这是在编译的时候，有些麻烦，

```c
gcc program.c $(pkg-config --cflags --libs libnl-3.0)
```

这里涉及了**pkg-config**的用法。这个工具还是非常有用的，他解决了有关已安装的库函数中的种种使用的问题。比如，库函数的版本、链接位置...pkg-config的具体以后补充。

看一下**sockaddr_nl**的结构体

```c

struct sockaddr_nl {
	__kernel_sa_family_t	nl_family;	/* AF_NETLINK	*/
	unsigned short	nl_pad;		/* zero		*/
	__u32		nl_pid;		/* port ID	*/
       	__u32		nl_groups;	/* multicast groups mask */
};
```

上面的成员参数可以看注释，这里说一下nl_pid,它是netlink socket的单播地址，对于内核来说，它应该是0;对于用户空间来说，应该是运行它的的pid(使用getpid()).


## socket monitoring interface

**sock_diag**就是提供了基于netlink子系统、可以得到有关socket的信息。有关网络的工具**ss**就是大量使用了sock_diag.

#### NETLINK_SOCK_DIAG

