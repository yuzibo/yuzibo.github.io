---
title: "SDN之OVS学习"
category: sdn
layout: post
---

* content
{:toc}

# OVS架构
用户空间程序有数据库服务ovsdb-server和守护进程ovs-vswitchd.kernel中是
datapath的内核模块，最上面的Contronller表示OpenFlow控制器，控制器与OVS进行通信是经由openflow协议。

https://blog.csdn.net/maijian/post/details/74332260


## 各个组件
### Bridge
顾名思义，Bridge代表一个以太网交换机(switch),一个主机可以创建一个或者多个的
Bridge,它的功能就是根据一定规则，把从某一个端口收到的数据发送到一个或者多个端口中。

添加一个网桥br0

```c
ovs-vsctl add-br br0
```
端口(port): 这个概念与物理交换机的端口相似，是在OVS Bridge上创建的一个虚拟端口，每个port都有自己的Bridge.值得注意的是，Port有下面几种类型：

>1	Normal

可以把宿主OS上的网卡挂载到OVS上，此时OVS会生成同名的Port处理这块网卡发出的数据包。这种类型的port成为Normal.且不分配Ip地址,也就是说之前分配的地址无法访问。（虚拟机网卡tap***）

```c
ovs-vsctl add-port br-ext eth1
#Bridge br-ext中出现Port "eth1"
```

>2	internal

这个端口的作用就是自动创建一个同名接口(interface) 挂载到新建立的Port上。

```c
ovs-vsctl add-br br0
ovs-vsctl add-port br0 p0 -- set Interface p0 type=internal

#查看网桥br0
ovs-vsctl show br0
    Bridge "br0"
        fail_mode: secure
        Port "p0"
            Interface "p0"
                type: internal
        Port "br0"
            Interface "br0"
                type: internal
```
可以看到有两个Port。当ovs创建一个新网桥时，默认会创建一个与网桥同名的Internal Port。在OVS中，只有”internal”类型的设备才支持配置IP地址信息，因此我们可以为br0接口配置一个IP地址，当然p0也可以配置IP地址

```bash
ip addr add 192.168.10.11/24 dev br0
ip link set br0 up
#添加默认路由
ip route add default via 192.168.10.1 dev br0
```
>3	patch

当主机中有多个ovs网桥时，可以使用Patch Port把两个网桥连起来。Patch Port总是成对出现，分别连接在两个网桥上，从一个Patch Port收到的数据包会被转发到另一个Patch Port，类似于Linux系统中的veth。使用Patch连接的两个网桥跟一个网桥没什么区别，OpenStack Neutron中使用到了Patch Port。上面网桥br-ext中的Port phy-br-ext与br-int中的Port int-br-ext是一对Patch Port

演示：

```bash
ovs-vsctl add-br br0
ovs-vsctl add-br br1
ovs-vsctl \
-- add-port br0 patch0 -- set interface patch0 type=patch options:peer=patch1 \
-- add-port br1 patch1 -- set interface patch1 type=patch options:peer=patch0

#结果如下
#ovs-vsctl show
    Bridge "br0"
        Port "br0"
            Interface "br0"
                type: internal
        Port "patch0"
            Interface "patch0"
                type: patch
                options: {peer="patch1"}
    Bridge "br1"
        Port "br1"
            Interface "br1"
                type: internal
        Port "patch1"
            Interface "patch1"
                type: patch
                options: {peer="patch0"}
```
还有一个Tunnel，以后再说了。
# pager
https://www.usenix.org/system/files/conference/nsdi15/nsdi15-paper-pfaff.pdf


[how to do reasch at under?]http://www.ece.rutgers.edu/~pompili/index_file/extra/HowToDoResearch_ANRG_WP02001.pdf

有关在ovs下的Qos命令
http://www.programmersought.com/article/294415472/

