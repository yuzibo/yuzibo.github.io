---
title: fail2ban的使用
category: tools
layout: post
---
* content
{:toc}

【转载来自文末】

sudo systemctl status fail2ban

创建两个默认的配置文件/etc/fail2ban/jail.d/defaults-debian.conf和/etc/fail2ban/jail.conf

我们不建议直接修改这些文件，因为更新Fail2ban时它们可能会被覆盖。

Fail2ban将按以下顺序读取配置文件。每个.local文件都会覆盖.conf文件中的设置。
/etc/fail2ban/jail.conf，/etc/fail2ban/jail.d/*.conf 。/etc/fail2ban/jail.local，/etc/fail2ban/jail.d/*.local

配置Fail2ban的最简单方法是将复制jail.conf为jail.local，然后修改.local文件。你也可以从头开始构建.local配置文件。

bantime，findtime和maxretry选项的值定义了禁止时间和禁止条件。bantime是禁止持续的时间。findtime是设置失败次数之间的持续时间。

https://www.myfreax.com/install-configure-fail2ban-on-debian-10/

一个有用的用法是:
```bash
sudo fail2ban-client status sshd
```
有一个文件是专门控制 `sshd`的，忘了找到出处了。