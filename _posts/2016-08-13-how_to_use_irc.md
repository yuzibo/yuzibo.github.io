---
title: "IRC工具使用总结"
layout: post
category: tools
---

* content
{:toc}

update: 2022/02/20 添加windos clients
update: 2022/06/18 添加更多说明

# server相关的用法
## 注册

我是在oftc的server里注册的，具体指令如下 ：
```bash
/NickServ REGISTER passwd your-email
```
然后你会收到:
```bash
 Nickname vimer has been registered successfully and is now yours to use.
-NickServ- See HELP SET for information on settings that you can set on your new
-NickServ- nickname.  If you change nickname or reconnect to the IRC network you will be
-NickServ- required to identify using the password you chose when you registered.  See
-NickServ- HELP IDENTIFY for more information on identifying your nickname.
-NickServ-  
-NickServ- To complete the registration, the nickname must be VERIFIED.  Note that we
-NickServ- do not validate the e-mail address.
-NickServ- To verify your nick, please visit the following link in your browser:
-NickServ-  
-NickServ- url
-NickServ-  
-NickServ- This link expires in 1 hour.  If the link expires, see REVERIFY.
```
然后根据url去验证即可。

## 签别自己
```bash
/msg NickServ identify curpasswd
```

## 查询某人的信息
```bash
/msg NickServ INFO vimer
```

## 隐藏ip
前提是先注册
```bash
/msg NickServ SET CLOAK ON
```
# windows
最近由于项目需要需要在IRC上及时沟通，但是目前的办公环境是在windows上，所以，需要在window上找一款IRC tool。
我一开始使用的是xchat-2，很小灵巧，非常喜欢，但是不知道因为什么原因，导致闪退。
花了点钱，买了人生中第一份license。继续使用 xchat。

# linux平台下
linux推荐使用 `irssi`.

```bash
/NETWORK LIST
 /HELP NETWORK
 /HELP SERVER
 /HELP CHANNEL
 /HELP
```

选择一个并且加入进去. 更多的用法需要[参考](https://irssi.org/documentation/startup/)

## 加入服务器:

/CONNECT Freenode or oftc

## 加入频道

/JOIN #irssi

## debian一些常用的频道
[The hostname irc.debian.org is an alias for irc.oftc.net. Most Debian IRC channels are on the OFTC IRC network](https://wiki.debian.org/IRC)

```bash
#debian-bugs
#debian-buildd: Teams/DebianBuildd
#debian-mentors: Support for new contributors with questions on packaging and Debian infrastructure projects/services. See also the debian-mentors mailing list.
#debian-ports: https://www.ports.debian.org/
#debian-riscv: Debian RISC-V port
#devscripts: devscripts
```
# 加入服务器
一般的开源组织使用的oftc比较多一些， 尤其是debian一类的比较多。
比如，加入linux kernelnewbies channel

/server irc.oftc.net


# 加入一个频道

/JOIN #debian


/join #kernelnewbies





