---
title: "mutt&&lynx使用技巧"
layout: post
category: tools
---

* content
{:toc}


[配置文件](https://github.com/yuzibo/configure_file/tree/master/mutt)

# 如何打开已发送邮箱
除了可以在配置文件外指定已发送邮箱存储的文件，如果不这样，你第一次使用mutt 的时候，会提示你自动创建sent邮箱。
当你再次键入`neomutt`命令时，进入的是收件箱的UI.怎么才能找到发件箱呢？

方法；type `c` then display `Open mailbox('?' for list mailbox)`.So you can type `sent`.If you want to return
to mailbox(received mail box),you can type the mailbox of dir,in my example it is `/var/mail/me`
# Delete duplicate mails
[the article](http://promberger.info/linux/2008/03/31/mutt-delete-duplicate-e-mail-messages/).
The method: first you must be enable configure option `duplicate_threads = yes`.you can type `:set ?duplicate_threads` to ensure the results.

Then you can type <font color='red'>o</font> to resort all mails in certainly pattern.For example`d`,which will be sort mail as `date` model.

As last you say <font color='red'>T</font> tag pattern,put in `~=` as the pattern.Duplicate mail are now tagged.The mail tagged will show start with a `*`.To delete them,either type just `d`or type `;` then hit `d`.

You can add configure option in `.muttrc` to delete duplicate mail automatically.
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

更新： mutt只是一个管理邮箱的软件，并不会显示很复杂的邮件内容，
比如，网页类型的及非ascii编码类型的。如果想使用以上效果，那么就需要
其他软件配合了。

我首先使用的lynx文本网页浏览器，有一点我是开始没有理会
的，无法显示中文的邮件内容，lynx的配置在.mailcap的配置如下：

```bash
text/html; lynx -dump -width=78 -nolist %s | sed 's/^  //';
sopiousoutput; needsterminal;nametemplate=%s.html

```

这样mutt就会将mail中html格式的信息转化为PLAIN/TEXT格式，方便阅读。

## 查看中文编码问题

mutt对于英语的支持那是相当不错，可是在浏览由中文邮箱发过来的邮件
时便会遇到可恶的乱码问题，如今，你可以使用w3m这个对中文支持好的。

将上面.mailcap文件的注释掉，使用下面的语句：

```bash
text/html; w3m -dump -ppc 9 -I %{charset} -T text/html %s|uniq; copiousoutput
```

这样子你就可以看见你亲切的汉字邮件了。

## 打开邮件内的url

<del>
在`.muttrc`内新建命令绑定

```bash
# 设置键绑定 ,为了使用urlview.
macro pager \cb <pipe-entry>'urlview'<enter> 'Follow links with urlview'
```

前提是你要安装`urlview`这个软件。

然后使用命令`ctrl-b`就可以打开链接了
</del>

现在使用`urlscan`命令，同样，在`.muttrc`配置文件中写入man手册的语句。

# neomutt
现在，这几大发行版本已经把NeoMutt作为默认的版本了，但是使用源码安装的时候会遇上各种各样的包依赖，这时候，你要熟悉你的发行版的搜索软件的命令，以debian为例，那就是这样：

```bash
sudo apt-cache search xx
```

将源代码包下载下来后，使用如下的编译选项：

这个软件首先安装字符库或者图形界面的需要，推荐使用slang。当完成以后，使用*./configure.autosetup   --help*,因为下面的命令已经不适用了。
```bash
./configure --with-slang=/usr/local/src/slang-2.2.4
--ssl --disable-doc --debug
```

接着使用

> make

> make install



# lynx使用记录

这也是一个unix的神器，学会使用的话，收益匪浅。

###  *?* 帮助

### 使用空格键进行翻页
不要使用箭头，慢的要死

### 标签
按下*a*键，接着按*d*,就添加了一个书签.查看书签需要`v`

### 输入rul
按下_g_即可输入url。

### 中断没有回应的
_Ctrl-g_即可。

### 查看源代码
使用_\_即可查看源代码，还可以再次使用返回页面

