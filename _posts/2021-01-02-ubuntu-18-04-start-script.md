---
title: Ubuntu 18.04使用systemd设置开机自启动脚本
category: tools
layout: post
---
* content
{:toc}

总结来说，这篇文档放入tools吧。

# 原因

最近手上有一块nvidia  jetson的板子，在调程序时需要不断的开关机，但是呢总忘记风扇的开启，
对我来说，板子稍微发热我就难受，但是每次开机后手动enable风扇太low,总搜集整理这个文档。

# systemd
systemd也是大名鼎鼎，目前据说在最新的Ubuntu中已经使用它代替了initd. initd我之前用的比较多了，
但是具体原理没有太多的涉及，这篇文档也是这样的思路，在原理上、技术上不做太多的纠结，直接拿来使用。

## /etc/systemd/system/r-local.service
可以先看一下这个目录下有很多service后缀的文件，而且大部分是系统文件。例如`syslog.service`.
此时，我们可以在目录下新建一个文件:  rc-local.service,其实这里自定义的名字是无所谓的。其内容可以比着葫芦
画瓢:

```bash
[Unit]
Description=/etc/rc.local Compatibility
ConditionPathExists=/etc/rc.local
# Script was located in that

[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99

[Install]
WantedBy=multi-user.target
```

上面的字面意思也不用太多解释（之所以能够开机自启动在那个 forking）。当然，要记得修改文件权限:

```bash
sudo chmod 755 /etc/systemd/system/rc-local.service
```

## /etc/rc.local 

这个文件就是开机后具体执行的脚本，我的如下:

```bash
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.
echo "测试脚本执行成功"
echo 100 >> /sys/devices/pwm-fan/target_pwm

exit 0
```

当然， 需要同样赋予权限:`sudo chmod 755 /etc/rc.local`.

## 测试
下面的命令，就是基于rc-local.service文件。

```bash
dclab@dclab-desktop:~$ sudo systemctl enable rc-local
[sudo] password for dclab:
```

启动服务并检查状态

```bash
sudo systemctl start rc-local.service
dclab@dclab-desktop:~$ sudo systemctl status  rc-local.service
● rc-local.service - /etc/rc.local Compatibility
   Loaded: loaded (/etc/systemd/system/rc-local.service; enabled; vendor preset: e
  Drop-In: /lib/systemd/system/rc-local.service.d
           └─debian.conf
   Active: active (exited) since Tue 2021-01-19 19:59:36 CST; 57min ago
    Tasks: 0 (limit: 4915)
   CGroup: /system.slice/rc-local.service

Jan 19 19:59:36 dclab-desktop systemd[1]: Starting /etc/rc.local Compatibility...
Jan 19 19:59:36 dclab-desktop rc.local[6314]: 测试脚本执行成功
Jan 19 19:59:36 dclab-desktop systemd[1]: Started /etc/rc.local Compatibility.
Jan 19 20:55:18 dclab-desktop systemd[1]: /etc/systemd/system/rc-local.service:11:
```

