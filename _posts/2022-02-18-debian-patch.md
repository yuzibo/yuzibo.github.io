---
title: debian package 产生patch相关操作及dch
category: debian-riscv
layout: post
---
* content
{:toc}

# 如何产生patch
这篇[文章](https://raphaelhertzog.com/2011/07/04/how-to-prepare-patches-for-debian-packages/)非常有价值，解决了我真实想解决的问题。

## apt source

## dch --nmu

## dch -a
这条命令会在当前的版本下多次编辑changelog file。

## 产生patch

### create a new patch
#### quilt push -a
首先打上package自带的全部patch:
```bash
vimer@unmatched-local:~/04/0422/openvswitch-2.15.0+ds1$ quilt push -a
File series fully applied, ends at patch debian/patches/CVE-2021-36980_Fix_use-after-free_while_decoding_RAW_ENCAP.patch
```
#### quilt new xx.patch
```bash
vimer@unmatched-local:~/04/0422/openvswitch-2.15.0+ds1$ quilt new fix-ftbfs-riscv64.patch
Patch debian/patches/fix-ftbfs-riscv64.patch is now on top
```
上面这步是说，要产生一个xx的patch。下面有两步是可以使用的:

```bash
$ quilt add debian/rules
File debian/rules added to patch debian/patches/fix-ftbfs-riscv64.patch
```
这个动作的意思是说，我首先invoke Debian/rules这个文件，这时候你再对debian/rules进行编辑修改，也就是先加名单，然后修改。

还有一种就是:直接编辑模式，使用:

```bash
quilt edit debian/rules
```
这个时候进入的是一个编辑目录，然后可以直接修改，最后保存退出。

### 出patch

```bash
$ quilt refresh
Refreshed patch debian/patches/fix-ftbfs-riscv64.patch
```
此时默认在  debian/patch/下面产生了patch，并写入到debian/patch/series文件中。

### 测试

[参考这里](https://stackoverflow.com/questions/71331029/dpkg-buildpackage-reapplies-patches-to-debian-rules)
最简单的测试就是重新`apt sourc这个package的source code，然后直接打patch就行。
正常的patch(对除了debian/rules文件外的patch)都可以:

#### qulit import 
```bash
$ quilt import -P fix-foobar.patch /tmp/patch
Importing patch /tmp/patch (stored as fix-foobar.patch)
$ quilt push
Applying patch fix-foobar.patch
[...]
Now at patch fix-foobar.patch
```
The -P option allows to select the name of the patch file created in debian/patches/. As you see, the new patch file is recorded in debian/patches/series but not applied by default, we’re thus doing it with quilt push.

那么，如果针对的是 debian/rules的patch，应该使用下面的patch命令进行打patch。

# 打patch
## 准备工作
1. 根据[这篇文章](http://blog.mathieu-leplatre.info/apply-debian-patches-step-by-step.html#:~:text=Apply%20the%20patch%20file%20patch%20-p0%20%3C%20%24HOME%2FDesktop%2Fgui_track_filter.patch,Add%20your%20dpatch%20name%20in%20the%2000list%20file)

2. 首先安装：

```bash
 sudo apt install devscripts dpatch fakeroot dh-make
```

如果只是测试，没必要在debian目录下新建patches目录(假设没有这个目录的话)，但是正规的package，一般需要这个目录的。

```bash
sudo mkdir patches
[sudo] password for vimer:
vimer@debian:~/build_test/sip/sofia-sip-1.12.11+20110422.1/debian$ ls
changelog  copyright                 libsofia-sip-ua-dev.install    libsofia-sip-ua-glib-dev.install  sofia-sip-bin.install
compat     libsofia-sip-ua0.install  libsofia-sip-ua-glib3.install  patches                           sofia-sip-doc.docs
control    libsofia-sip-ua0.symbols  libsofia-sip-ua-glib3.symbols  rules
```

## 下载patch并apply
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
