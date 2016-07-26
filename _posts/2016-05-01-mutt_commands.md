---
title: "mutt使用技巧"
layout: article
category: tools
---


[github](https://github.com/yuzibo/configure_file/tree/master/mutt)

# 删除某个邮箱的全部信件

订阅了lkml,可是经常有很多的邮件看不了而删了。现在，强大的命令来了，请接招:

首先，使用命令

>mutt

进入，接着按__c__, 选择邮箱，这里我是自己用的是IMAP，这个协议把你的mutt当作
了终端。你在邮箱服务器上有几个文件夹或者标签，在mutt上就会有几个信箱。假如
你没有使用mutt，那么可以忽略这一步。

接着，在当前的邮箱下，键入：shift D

> shift d

它会提示

```c
Delete messages matching:
```
汉语就是

```c
删除符合此样式的信件：
```

接着使用:

> ~s .*

回车，所有的邮件被标记上了D，这就是你单封删除邮件的作用。或者，还可以使用

>~A

也可以达到以上相同的效果

## 打开邮件内的网页

这个功能更是geek,首先新建一个`.mailcap`的文件在主目录下：

```bash
text/html; lynx -dump -width=78 -nolist %s | sed 's/^  //';
sopiousoutput; needsterminal;nametemplate=%s.html

```

这样mutt就会将mail中html格式的信息转化为PLAIN/TEXT格式，方便阅读。

## 打开邮件内的url

在`.muttrc`内新建命令绑定

```bash
# 设置键绑定 ,为了使用urlview.
macro pager \cb <pipe-entry>'urlview'<enter> 'Follow links with urlview'
```

前提是你要安装`urlview`这个软件。

然后使用命令`ctrl-b`就可以打开链接了
