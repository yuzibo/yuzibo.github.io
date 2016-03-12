---
layout: article
title: "10个重要的linux网络命令"
category: shell
---
# 最基础的linux网络命令

### hostname
	hostname [none] display hostname
	hostname -d #display machine belongs to the domain
	hostname -f #display full name
	hostname -i #display ip
### ping
	ping [ip/address]
## ifconfig
	View network configure.
### iwconfig
	用于无线网卡
### nsloopup
	从ip获得主机名或者从ip获得主机名
	nsloopup google.com
### traceroute
	查看数据包在提交到远程系统或者网站的时候所经过的ip,hoop,time
### finger
	查看用户信息。
### telent
	 通过telnet协议连接目标主机，如果telnet连接可以在任一端口上完成即代表着两台主机间的连接良好。

	 telnet hostname port - 使用指定的端口telnet主机名。这通常用来测试主机是否在线或者网络是否正常。
### ethtool
	 有的发行版不带这些工具，需要我们自己去下载。
### netstat

	  发现主机连接最有用最通用的Linux命令。你可以使用"netstat -g"查询该主机订阅的所有多播组（网络）

	  netstat -nap | grep port 将会显示使用该端口的应用程序的进程id
	  netstat -a  or netstat –all 将会显示包括TCP和UDP的所有连接
	  netstat --tcp  or netstat –t 将会显示TCP连接
	  netstat --udp or netstat –u 将会显示UDP连接
	  netstat -g 将会显示该主机订阅的所有多播网络。 ""
