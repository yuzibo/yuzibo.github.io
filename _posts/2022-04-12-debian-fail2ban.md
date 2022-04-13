---
title: 云主机防范暴力攻击--策略 fail2ban
category: tools
layout: post
---
* content
{:toc}

# 策略
策略有几个：
## 修改22端口
是的，可以直接修改 `/etc/ssh/sshd_config`然后把22端口换成其他的端口。

## 禁止密码登录
禁止密码登录是最好的选择，然后使用秘钥登录。

## 使用fail2ban
下面就使用这个program试试。

## 密码复杂
必须使用八位 包含特殊字符的密码

## 查看日志
是不是查看 `/var/log/auth.log`及`lastlog`去看一下有没有异常情况。

# fail2ban

```bash
 sudo apt install fail2ban
```