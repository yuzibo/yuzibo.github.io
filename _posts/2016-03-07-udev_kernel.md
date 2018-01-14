---
layout: article
title: "udev用户空间设备管理"
category: kernel
---
内核提供机制，但不能在内核中提供策略。
比如所谈恋爱，内核不但可以允许我们谈恋爱，而且也不能限制我们和谁谈。
以前利用devfs实现的时候，第一个相亲的女孩为/dev/girl01,第二个相亲的女孩为
/dev/girl02,在udev的实现下，不管第几个女孩，统一称为/dev/mygirl.

```c
/*
 * netlink的使用规范，使用的udev
 * 策略和机制的区别
 *
 * */
#include<stdio.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<string.h>
#include<stdlib.h>
#include<linux/netlink.h>
#include<poll.h>
static void die(char *s)
{
	write(2, s, strlen(s));
	exit(1);
}
int main(){
	struct sockaddr_nl nls;
	struct pollfd pfd;
	char  buf[512];

	/*
	 * open hotplug event netlink socket
	 * */
	memset(&nls, 0, sizeof(struct sockaddr_nl));
	nls.nl_family = AF_NETLINK;
	nls.nl_pid = getpid();
	nls.nl_groups = -1;
	pfd.events = POLLIN;
	pfd.fd = socket(PF_NETLINK,SOCK_DGRAM,NETLINK_KOBJECT_UEVENT);
	if(pfd.fd == -1){
		die("not root\n");

	}
	//listen to the netlink socket
	if (bind(pfd.fd,(void *)&nls, sizeof(struct sockaddr_nl))){

		die("Bind failure.\n");
	}
	while(poll(&pfd, 1, -1)){
		/*
		 * wait something to happen
		 * */
		int i, len = recv(pfd.fd, buf, sizeof(buf),MSG_DONTWAIT);
		if(len == -1)
			die("recv failed\n");
		//print data to the stdout
		i = 0;
		while(i < len){
			printf("%s\n",buf + i);/* char pointer */
			i += strlen(buf + i) + 1; /* ?? */
		}

	}
	die("poll\n");
	return 0;

}
```
udev完全在用户态工作，利用设备加入或者移除时内核所发送的热插拔(hotplug)事件
来工作。在热插拔时，设备的详细信息通过netlink套接字发送出来，发出的事情叫做
uevent。
这段代码的实现了内核通过netlink接受热插拔事件并冲刷掉的范例.编译并运行这段
代码，然后插入usb或者其他热插拔事件，会在终端收到相关的信息.
