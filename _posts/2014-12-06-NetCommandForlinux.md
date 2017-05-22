---
layout: article
title: "10个重要的linux网络命令"
category: shell
---
# 最基础的linux网络命令

### hostname

```bash
	hostname [none] display hostname
	hostname -d #display machine belongs to the domain
	hostname -f #display full name
	hostname -i #display ip
```

### ping

```bash
	ping [ip/address]
```

## ifconfig

```bash
	View network configure.
```

下面是我的ifconfig输出：

```bash
root@debian:/home/yubo/test/tmp/unix# ifconfig
eth0      Link encap:Ethernet  HWaddr 08:9e:01:6d:08:4e
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
          Interrupt:41 Base address:0x2000

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          RX packets:44786 errors:0 dropped:0 overruns:0 frame:0
          TX packets:44786 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:22286992 (21.2 MiB)  TX bytes:22286992 (21.2 MiB)

wlan0     Link encap:Ethernet  HWaddr 80:9b:20:5c:23:04
          inet addr:192.168.0.117  Bcast:192.168.0.255  Mask:255.255.255.0
          inet6 addr: fe80::829b:20ff:fe5c:2304/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:94748 errors:0 dropped:0 overruns:0 frame:0
          TX packets:208467 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:92813171 (88.5 MiB)  TX bytes:22941747 (21.8 MiB)

root@debian:/home/yubo/test/tmp/unix# route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         192.168.0.1     0.0.0.0         UG    0      0        0 wlan0
192.168.0.0     0.0.0.0         255.255.255.0   U     0      0        0 wlan0
root@debian:/home/yubo/test/tmp/unix#

```

注意，我这里配合着route命令。

从上面的输出，我们可以了解到root主机上被激活的ip地址是wlan0,因为这是我在WIFI
条件下连接上网的。lo可以暂时忽略。eth0是以太网的连接。

由此说明，任何由root主机创建的IP包的源地址(source address) 是192.168.0.117.
类似的，任何由root主机收到的IP包的目的地址是192.168.0.117

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
	  netstat -g 将会显示该主机订阅的所有多播网络。

### iptables

```bash
iptables -L ## 查看

iptables -F ## 清空规则

```

#### 链的类型

##### input

控制进来的链接

##### forward

转发。

##### Output

```bash
root@debian:/home/yubo/test/tmp/unix# sudo iptables -L -v
Chain INPUT (policy ACCEPT 572K packets, 504M bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination

Chain OUTPUT (policy ACCEPT 1003K packets, 129M bytes)
 pkts bytes target     prot opt in     out     source               destination

```

#### 链接一个特定的IP

阻塞所有来自10.10.10.10的链接。

```bash
iptables -A INPUT -s 10.10.10.10 -j DROP

```

阻塞一个范围的网址：

```bash
iptables -A INPUT -s 10.10.10.0/24 -j DROP
```

链接到一个特别的端口, 阻塞来自于10.10.10.10的ssh链接

```bash
iptables -A input -p tcp --dport ssh -s 10.10.10.10 -j DROP
```

你可以使用其他协议将“ssh”或者其他端口号。"-p"是协议，如果你想阻塞UDP，则使用
"-p udp".

如果你使用ssh链接主机，下面的命令慎用，危险！

```bash
iptables -A INPUT -p tcp --dport ssh -j DROP
```

##### 保存ipatbles

ubuntu

```bash
sudo /sbin/iptables-save
```

Red Hat

```bash
/sbin/service iptables save
```

或者

```bash
/etc/init.d/iptables save
```




向外转发链接

## 更新资源

https://www.quora.com/What-is-the-best-way-to-learn-Linux-networking-concepts-and-practices


