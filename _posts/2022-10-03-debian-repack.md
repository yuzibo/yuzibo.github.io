---
title: debian repack 汇总
category: debian-riscv
layout: post
---
* content
{:toc}

目前在修包过程中，经常会遇到需要升级的情况。目前来说，升级不是特别大的问题，反而在repack遇到了不小的阻扰，下面是一些总结。

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



