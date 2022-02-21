---
title: debian官方patch相关操作
category: debian-riscv
layout: post
---
* content
{:toc}

1. 根据[这篇文章](http://blog.mathieu-leplatre.info/apply-debian-patches-step-by-step.html#:~:text=Apply%20the%20patch%20file%20patch%20-p0%20%3C%20%24HOME%2FDesktop%2Fgui_track_filter.patch,Add%20your%20dpatch%20name%20in%20the%2000list%20file)

2. 首先安装：

```bash
 sudo apt install devscripts dpatch fakeroot dh-make
```

如果只是测试，没必要在debian目录下新建patches目录(假设没有这个目录的话)

```bash
sudo mkdir patches
[sudo] password for vimer:
vimer@debian:~/build_test/sip/sofia-sip-1.12.11+20110422.1/debian$ ls
changelog  copyright                 libsofia-sip-ua-dev.install    libsofia-sip-ua-glib-dev.install  sofia-sip-bin.install
compat     libsofia-sip-ua0.install  libsofia-sip-ua-glib3.install  patches                           sofia-sip-doc.docs
control    libsofia-sip-ua0.symbols  libsofia-sip-ua-glib3.symbols  rules
```

# 下载patch并apply
以[这个patch https://bugs.debian.org/cgi-bin/bugreport.cgi?att=1;bug=978498](https://bugs.debian.org/cgi-bin/bugreport.cgi?att=1;bug=978498)为例，其实在这个debian bugs thread中我们是不容易找到patch的，我们需要find下`patch`字段。

找到以后，比如这个[sofia-sip-retooling.patch](https://bugs.debian.org/cgi-bin/bugreport.cgi?att=1;bug=978498;filename=sofia-sip-retooling.patch;msg=10)，然后可以直接click或者保存附件就行。

但是，最直接的方式却不支持了，比如`wget https://bugs.debian.org/cgi-bin/bugreport.cgi?att=1;bug=978498;filename=sofia-sip-retooling.patch;msg=10`或者"curl"命令。这个问题Debian社区的人居然不重视？？？能不能有点geek的乐趣，还得去浏览器下载，哈哈！

探究了一番后发现，是由于wget在接受这个参数时，默认把url中的特殊字符给截断了，其实主要是由于"?"引发的。前面这句话也许有纰漏，大佬说是由于shell引起的，确实是阶段的，但是为什么会截断，我觉得后面有必要研究一下。

后来试了一下，在脚本中把URL加上双引号就可以使用`curl`下载patch了，这样也好，后面写个脚本把url传进去，然后输出文件可以根据patch来输出。

这个事看看后面能不能给dget提交个patch。

拿到patch后，可以使用下面的命令进行apply patch to source code.

```bash
~$
vimer@debian:/tmp/sip/sofia-sip-1.12.11+20110422.1$ sudo < /tmp/sofia-sip-retooling.patch patch -p1
patching file debian/rules
```
