---
title: "VitualBox共享文件夹"
layout: article
category: tools 
---

# 首先安装增强型文件包


### 安装前的准备

>apt-get  install bzip2   

>apt-get  install  linux-headers-`uname -r`  build-essential

必须有这两个，否则很容易不成功。

在VitualBox自带的安装包内这个iso文件一直存在着。我们只需将它安装上即可。
在虚拟机里，这里有两种安装方式命令行和图形界面。

命令行的请参考这篇文章[here](http://home.51.com/ipitx/diary/item/10052415.html)
唯一的坏处就是无法自动挂载。

```bash
mount  /dev/cdrom  /media/cdrom       
cd  /media/cdrom0
```
或者到/media/cdrom中去查看

### 图形方法：

首先在VitualBox的"设备"里的"安装增强型"，然后"xx.iso"文件就加在了桌面上。然
后命令行进入

>/media/cdrom0

使用脚本

>sh xxx.sh

就安装上了。<del>最后重启。</del>

# 设置共享文件夹

在虚拟机的设置里有个共享文件夹的设置，选择你想要共享的文件夹，然后选择下面的
两个选项："自动挂载"和"临时分配"。

# 挂载共享文件夹

```bash
sudo  mkdir /mnt/shared 
sudo mount -t vboxsf share /mnt/shared

```
这里的"share"就是共享文件夹的名字。

# 自动加载
为了不能每次手动加载，可以使用脚本/etc/fstab

> share	/mnt/shared	vboxsf rw, gid=username,uid=username,auto 0 0

还可以在 /etc/rc.local加入

> mount -t vboxsf share /mnt/shared

# 卸载挂载点

>umount -f /mnt/shared


