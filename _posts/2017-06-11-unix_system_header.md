---
title: "unix中系统头文件的位置(sys/socket.h)"
category: c/c++
layout: post
---

* content
{:toc}

#1 普通文件
在写c语言的程序中，我们随手丢上了一个<stdio.h>,但是这个文件在哪里？恐怕我们都没有认真考虑过。这篇文章就是简单介绍一下这方面的内容。

至少在我的系统上(debian - 9)，只要像上面没有前缀的c库头文件，默认位置存储在

>/usr/include/\*

上面\*是为了md文件的显示好看，自己输入的时候只需要一个\*.

```bash
 ls /usr/include/st
 stab.h         stdint.h       stdio.h        string.h       stropts.h
 stdc-predef.h  stdio_ext.h    stdlib.h       strings.h

```

看，有你熟悉的文件吗？

#2.有前缀的<sys/socket.h>

这个文件在编写unix网络程序的时候，是必须用到的文件之一，那么，这个文件位于哪里？记住，首先这种文件位于/usr/include/目录下。

使用命令查找一下就可以了。

```bash
find /usr/include/ -name socket.h
```
在我的系统上显示了如下的内容：

```bash
yubo@debian:~$ find /usr/include/ -name socket.h
/usr/include/linux/socket.h
/usr/include/asm-generic/socket.h
/usr/include/x86_64-linux-gnu/bits/socket.h
/usr/include/x86_64-linux-gnu/sys/socket.h
/usr/include/x86_64-linux-gnu/asm/socket.h

```

那么，从头文件上来看，上面第4个文件符合我的目的。

好了，有了以下内容，请看一下下面的头文件：

```c
#include <stdio.h>
#include <signal.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>
#include <netinet/in.h>
#include <netinet/ip.h>
#include <netinet/ip_icmp.h>
#include <stdlib.h>

#include <netdb.h>
#include <setjmp.h>
#include <errno.h>

```

其实这里面还涉及到一个glibc的问题，我们有时间再讲这方面的内容，
