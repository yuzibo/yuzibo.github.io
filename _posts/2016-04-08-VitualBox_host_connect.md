---
title: "Vbox主机ssh访问虚拟机"
layout: post
category: tools 
---

* content
{:toc}

# 环境

### 宿主主机  win7
### 虚拟机系统 debian 8
### 网络连接方式 NAT

# 虚拟机与主机连接的几种方式的比较

TODO...

NAT就是虚拟机里的东西全部由主机来管理，你可以在虚拟机里访问主机，但是反过来
就不行。所以，你想在主机上访问虚拟机的ssh，需要特别的处理。

这时产生的虚拟机的ip一般为10.0.2.15

# 目标

其实，就是在主机上的nat的网络连接方式增加端口转发规则。

```c
Name: SSH (可以是任意唯一名)
Protocol: TCP
Host IP: 127.0.0.1
Host Port: 2222 (任何大于1024未使用的端口)
Guest IP: 虚拟机IP
Guest Port: 22 (SSH 端口)
```
这时你就可以使用127.0.0.1:2222的方式访问虚拟机里的ssh了。

这一种是比较落后的
