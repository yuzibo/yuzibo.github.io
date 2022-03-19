---
title: linux 增加 swap 空间
category: tools
layout: post
---
* content
{:toc}
[根据这篇文章进行摘录](https://blog.csdn.net/mimi_csdn/article/details/102542855)

# 查看swap空间
```bash
rvboards@d1-1:~$ free -m
               total        used        free      shared  buff/cache   available
Mem:             996         253         612           0         129         726
Swap:           3023         219        2803
```
查看swap信息，包括文件和分区的详细信息
swapon -s或者cat /proc/swaps
如果都没有，我们就需要手动添加交换分区。注意，OPENVZ架构的VPS是不支持手动添加交换分区的。
添加交换空间有两种选择：添加一个交换分区或添加一个交换文件。推荐你添加一个交换分区；不过，若你没有多少空闲空间可用， 则添加交换文件。

增加swap交换文件
1.使用dd命令创建一个swap交换文件
dd if=/dev/zero of=/home/swap bs=1024 count=1024000
这样就建立一个/home/swap的分区文件，大小为1G。

2.制作为swap格式文件：
mkswap /home/swap

3.再用swapon命令把这个文件分区挂载swap分区
swapon /home/swap
我们用free -m命令看一下，发现已经有交换分区了。
但是重启系统后，swap分区又变成0了。

4.为防止重启后swap分区变成0，要修改/etc/fstab文件
vi /etc/fstab
在文件末尾（最后一行）加上
/home/swap swap swap default 0 0
这样就算重启系统，swap分区还是有值。

5.删除swap交换文件
1、先停止swap分区
/sbin/swapoff /home/swap

2、删除swap分区文件
rm -rf /home/swap

3、删除自动挂载配置命令
vi /etc/fstab
这行删除