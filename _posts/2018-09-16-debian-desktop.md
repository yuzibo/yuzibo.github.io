---
title: "debian桌面系统"
category: debian
layout: post
---

结合最近同学们对于Nvidia显卡的问题，我想有必要整理一下相关的概念。

这里只是简单的说说Debian系统。

对于桌面系统而言，你在不想使用桌面系统的时候，可以使用 `init 3`进入字符系统，使用`init 5`返回桌面系统。

After test can be deleted:

```bash
git remote add origin https://github.com/username-or-organization-name/your-remote-repository-name
```

# 如何直接开启debian的字符系统
像我而言，真的没有必要开启桌面系统，我只是简单的了解内核的使用，基本不使用桌面，浪费的内存还是相当的严重，那么，我就需要一种方案禁用桌面系统。最简单的就是：

### 修改 grub项

```bash
sudo vim /etc/default/grub
```
修改其中的几项
```bash
...
GRUB_CMDLINE_LINUX_DEFAULT="quiet"
GRUB_CMDLINE_LINUX=""
...
#GRUB_TERMINAL=console

```

为:

```bash
#GRUB_CMDLINE_LINUX_DEFAULT="quiet"
GRUB_CMDLINE_LINUX="text"
...
GRUB_TERMINAL=console

```

更新grub

```bash
sudo update-grub #or
sudo update-grub2
```

## 设置systemd

```bash
sudo systemctl set-default multi-user.target
```
 然后重启即可。

 诸位大哥请不要贸然使用`apt remove lightdm`，有些网络服务是用的这个,不然你的机器就死机了。

 说一下systemctl.

# systemd
这个命令就是原来service的前身，还记得我们以前经常使用的`sudo /init.d/xx restart|stop`的命令吗？systemd就是替换这个命令的。它的作用在以下几个方面.

## 启动级别配置
进入字符界面：`systemctl set-default multi-user.target`,相应地,进入桌面系统`systemctl set-default graphical.target`

## 开机启动服务

```bash
systemctl enable ***.service
```

## 禁止开机启动服务

```bash
systemctl disable ***.service
```

## start|stop|restart

```bash
systemctl start/stop/restart ***.service
```

## 查询服务状态

```bash
systemctl status ***.service
```

[reference](https://segmentfault.com/a/1190000002457000)。


