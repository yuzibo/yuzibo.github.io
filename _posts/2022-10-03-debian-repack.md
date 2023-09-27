---
title: debian repack 汇总
category: debian-riscv
layout: post
---
* content
{:toc}

目前在修包过程中，经常会遇到需要升级的情况。目前来说，升级不是特别大的问题，反而在repack遇到了不小的阻扰，下面是一些总结。

# 一个新包 加dfsg后缀

过程：  
1. 首先还是正常的流程，打一个 python 包：

等到有一个基本的雏形后，

``` python
filecheck (0.0.22-1) UNRELEASED; urgency=low

  * Initial release. Closes: #nnnn

 -- Bo YU <tsu.yubo@gmail.com>  Fri, 22 Sep 2023 22:12:19 +0800

```

然后一直build，然后 lintian 可以报错：

```
filecheck source: source-is-missing [tests/integration/tools/FileCheck/FileCheck-8.0.1-Linux]
```

这个时候想办法排除:

```python
 1.   d/watch
    
    version=4
opts=\
repack,repacksuffix=+dfsg,\
compression=xz,\
filenamemangle=s/.*?(\d[\d\.-]*@ARCHIVE_EXT@)/FileCheck\.py-$1/ \
 https://github.com/mull-project/FileCheck.py/tags .*/archive/.*/v?([\d\.]+).tar.gz

2. uscan --force-download --verbose

3. gbp import-orig --pristine-tar ../filecheck_0.0.23+dfsg.orig.tar.xz
What is the upstream version? [0.0.23+dfsg]
gbp:info: Importing '../filecheck_0.0.23+dfsg.orig.tar.xz' to branch 'upstream'...
gbp:info: Source package is filecheck
gbp:info: Upstream version is 0.0.23+dfsg
gbp:info: Replacing upstream source on 'debian/main'
gbp:info: Successfully imported version 0.0.23+dfsg of ../filecheck_0.0.23+dfsg.orig.tar.xz
(需要 gbp.conf 最好)

4. 这时候可以丢弃了upstream/xx 的tag，而直接使用 +dfsg 的upstream 分支

【解答问题】
W: filecheck source: debian-watch-not-mangling-version opts=repack,repacksuffix=+dfsg,compression=xz,filenamemangle=s/.*?(\d[\d\.-]*@ARCHIVE_EXT@)/FileCheck\.py-$1/ https://github.com/mull-project/FileCheck.py/tags .*/archive/.*/v?([\d\.]+).tar.gz [debian/watch:6]

```

可以参考：
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=913761

# DFSG
这个主题需要后面具体补充。 TBD

# workflow
首先建立git repo:

## 1. import 
```bash
gbp import-dsc https://deb.debian.org/debian/pool/main/j/jamulus/jamulus_3.8.2+dfsg-1.dsc
```
接下来就需要看一下d/copyright的`excluded-files`域，在新版本的upstream中，这里很有可能会有些变化。比如，
前期的exclde文件可能在新版本中已经不存在了，或者有新的文件不满足Debian policy，需要重新repack。我个人的做法是首先编辑d/copyright文件，利用`uscan`的魔法去repack.

整理完d/copyright后，就可以使用：

```bash
$ gbp import-orig --pristine-tar --uscan

vimer@debian:~/build/gitlab/jamulus$ gbp import-orig --pristine-tar --uscan
gbp:info: Launching uscan...
uscan warn: The directory name distributions doesn't match the requirement of
   --check-dirname-level=1 --check-dirname-regex=jamulus(-.+)? .
   Set --check-dirname-level=0 to disable this sanity check feature., skipping
Can't exec "debian/repack": No such file or directory at /usr/share/perl5/Dpkg/IPC.pm line 311.
uscan: error: unable to execute debian/repack --upstream-version 3.9.1+dfsg: No such file or directory
uscan: error: debian/repack --upstream-version 3.9.1+dfsg subprocess returned exit status 255
gbp:error: Uscan failed - debug by running 'uscan --verbose'
```
如果repack失败了，则需要再次import tarball.

```bash
gbp import-orig --pristine-tar ../dfsg-*.tar.gz
```

注意，最好手动检查../dfsg-*tar.gz文件符不符合d/copyright 文件描述的。

#  资料

https://wiki.debian.org/BenFinney/software/repack
https://wiki.debian.org/Javascript/Repacking



