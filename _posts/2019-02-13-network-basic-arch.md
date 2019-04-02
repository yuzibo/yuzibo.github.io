---
title: 网络体系结构简介
category: network
layout: post
---
* content
{:toc}

# OSI模型
这里以教科书版的视角去解读。

## 七层模型

```c
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|      应用层(Application)      | http Telent Ftp SMTP SMTP NFS
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
		^
		|
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|     表示层(Presentation layer)| JPEG ASCII GIF DES MPEG
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
                ^
                |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|     会话层(session)           | SQL RPC NFS
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
                ^
                |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|     传输层(transport)         | TCP UDP SPX
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
                ^
                |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|     网络层(network)           | IP IPX
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
		^
		|
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|     数据链路层(link)          | MAC (媒介访问控制) LLC(逻辑链路控制)
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+ PPP ATM IEEE802.3/2
　　　　　　　　^
      		|
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|     物理层(physical)          | RS-232 RJ-45 FDDI
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```
## OSI各层功能特点即数据封装

**物理层:**提供物理通路，二进制数据传输、　定义机械　电气特性和接口 **比特流**

**链路层:** 数据链路的释放、流量控制、　构成链路数据单元、差错的检测与恢复、　帧界定与同步、传送以帧(frame)为单位的信息　**数据帧**

**网络层:**路由的选择与中继 网络链接的激活与终止　网络链接的多路复用、差错的检测与恢复
、排序与流量的控制、服务选择　**数据包**

**传输层:**映射传输地址到网络地址、传输链接的建立与释放、多路复用与分割、差错控制与恢复、分段与重组、组片与分片、序号及流量控制　**信息报文**

**会话层:**: 会话链接到传输链接、会话链接的恢复与释放、会话参数的协商、服务选择、活动管理与令牌管理、数据传输　　　　**同上**

**表示层:**数据语法的转换、数据加密与数据压缩、语法表示与链接管理  **同上**

**应用层：** 用户应用程序执行任务所需的协议与功能　**同上**
