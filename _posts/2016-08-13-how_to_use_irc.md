---
title: "IRC工具使用总结"
layout: post
category: tools
---

* content
{:toc}

update: 2022/02/20 添加windos clients

# windows
最近由于项目需要需要在IRC上及时沟通，但是目前的办公环境是在windows上，所以，需要在window上找一款IRC tool。
我一开始使用的是xchat-2，很小灵巧，非常喜欢，但是不知道因为什么原因，导致闪退。实在不行，自己只能在vscode上找了。

```bash
Visual Studio Code IRC: VSIRC

Run the "VSIRC: Open" command to open a new irc client
The /connect command can be used to join a server.
The /disconnect command can be used to leave a server.
"/join #channel" allows you to join a channel
"/list" lists all channels
"/last" to connect to last server
```
当然，一开始我还真不知道如何开启这个服务呢，怎么也找不到在哪里运行这个`VSIRC: Open`,最后搞了半天，
才发现是在 `shift + ctrl +p` 调出命令窗口才是可以的。剩下的就是具体的命令了。

# 第一步

```bash
/NETWORK LIST

选择一个并且加入进去

/CONNECT Freenode
 /JOIN #irssi


 需要帮助

 /HELP NETWORK
 /HELP SERVER
 /HELP CHANNEL
 /HELP
```


# 加入服务器
一般的开源组织使用的oftc比较多一些， 尤其是debian一类的比较多。
比如，加入linux kernelnewbies channel

/server irc.oftc.net


# 加入一个频道

/JOIN #debian


/join #kernelnewbies





