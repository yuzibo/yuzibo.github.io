---
title: "linux中错误提示"
layout: article
category: unix
---

# EAGAIN

这个错误经常出现在当应用程序进行一些非阻塞(non-blocking)操作(对文件或socket)的时候。例如，以 O_NONBLOCK的标志打开文件/socket/FIFO，如果你连续做read操作而没有数据可读。此时程序不会阻塞起来等待数据准备就绪返回，read函数会返回一个错误EAGAIN，提示你的应用程序现在没有数据可读请稍后再试。

# EINTR

出现这个错误是因为函数没有任何数据被传送此时发生了中断，
