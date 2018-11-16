---
title: "perl安装模块的方法"
layout: post
category: perl
---

* content
{:toc}

今天到了这一步
之前很多次想写一个网络爬虫，但是很多时候都无疾而终，这次，简单的记录一下。
perl模块的安装可以有很多的方法，现在我只熟悉两种方法。

# cpan
这一步是怎么安装的我忘了，下次可以再次补充上。

### install
？？

### 使用
>cpan module-name

最简单的杀器是 ：

>man cpan

但是这里有一点注意的是在vps上使用cpan会有限制的，特别是你的memory的值小于500
MB的时候，那么，此时应该怎么办？应该使用下面的方法:cpanm

# cpanm
从字面上理解，这个就是cpan module的简写,其实这里只是一个巧合。下面简单的记录
一下它的用法。

### install

```perl
curl -L -K http://cpanmin.us | perl - --self-upgrade
/usr/local/bin/cpanm local::lib
perl -I /usr/bin/perl -Mlocal::lib >> ~/.bashrc
```
解释几点：

1. curl -k选项，是忽略ssl认证失败的影响，否则无法访问网站。
2. 上面第一条语句是安装cpanm，下面是安装相关的库文件。你安装后的cpanm很可能
不是上面的目录，使用`which cpanm`即可找到cpanm的可执行路径，修改成对应的即可
3 最后一条语句的含义是将相关的库文件的可执行路径放到.bashrc中去。

### 使用
这两种方法安装模块的方法是大同小异，可以man一下，提醒一下，这里可以安装的文
件：

cpan上的模块；

网上的压缩文件；

本地文件；

URL；

