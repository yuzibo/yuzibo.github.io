---
title: "libvirt问题汇总"
category: tools
layout: post
---

* content
{:toc}

# 源码安装
首先声明一下，我的libvirt是通过源码安装的，如果你在安装的时候没有通过一些正确的设定，
很有可能会导致启动困难。

## 将插槽连接到 '/var/run/libvirt/virtlogd-sock' 失败: 没有那个文件或目录
意思很明确，就是virtlogd-sock文件没有开启，这种情况典型的就是你在源码安装时没有使用daemon进行，每一次机器开关机时都无法自动启动该进程。

这里，应该使用systemctl命令，

```bash
sudo systemctl start virtlockd[tab补全]
virtlockd-admin.socket  virtlockd.service       virtlockd.socket
```
启动这个socket服务就行了。

针对上面的这个问题，libvirt的维护人说：

	we have a systemd unit so you can enable that


Update: 目前不知道为什么我没有开启这个systemd unit，暂时还是使用`service`命令。

```bash
service libvirtd restart
```
也可以解决上面的问题


