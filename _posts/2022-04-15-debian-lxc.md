---
title: debian lxc使用
category: debian
layout: post
---
* content
{:toc}

因为目前正在做autopkgtest的测试，所以这里得简短介绍下lxc的一些基本用法。

## 启动lxc
```bash
root@unmatched:~# lxc-start -n autopkgtest-unstable-riscv64
root@unmatched:~# lxc-ls -f
NAME                         STATE   AUTOSTART GROUPS IPV4      IPV6 UNPRIVILEGED
autopkgtest-unstable-riscv64 RUNNING 0         -      10.0.3.17 -    false
```
## 查看bridge
```bash
root@unmatched:~# grep net /var/lib/lxc/autopkgtest-unstable-riscv64/config
lxc.net.0.type = veth
lxc.net.0.link = lxcbr0 # 在host上的bridge is lxcbr0

root@unmatched:~# ifconfig lxcbr0
lxcbr0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.0.3.1  netmask 255.255.255.0  broadcast 10.0.3.255
        inet6 fe80::216:3eff:fe00:0  prefixlen 64  scopeid 0x20<link>
        ether 00:16:3e:00:00:00  txqueuelen 1000  (Ethernet)
        RX packets 454  bytes 46683 (45.5 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 354  bytes 156485 (152.8 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

## cd container
```bash
lxc-attach -n autopkgtest-unstable-riscv64
```

## 检查是否安装
```bash
root@autopkgtest-unstable-riscv64:~# dpkg --status ifupdown
Package: ifupdown
Status: install ok installed
```