---
title: port nodejs to debian riscv64
category: debian-riscv
layout: post
---
* content
{:toc}

# 资料
以下是nodejs 支持 riscv64的例证.
[github](https://github.com/luyahan/nodejs-riscv64) [nodejs1](https://github.com/nodejs/node/issues/42005) [nodejs2](https://github.com/nodejs/build/issues/2876) [riscv.org](https://lists.riscv.org/g/tech-toolchain-runtime/message/217) [riscv](https://riscv.org/blog/2020/08/unlocking-javascript-v8-riscv-open-sourced/)

# 试验
建议1
在社区大佬的帮助下，目前有很多试验是需要记录下来的。后面复盘总结一下。

    You will probably need to use the "build profiles" documented in debian/README.source.

这个文件是可以解决依赖关系的。当时我使用`sbuild`build时，有一个依赖，  就是我想build `A`, 但是依赖`B`,而build `B`时也需要`A`的支持。这个就需要某些特殊的配置的。

建议2
```bash
node 16.14.0 is available on master-16.x branch.
Doing a local build right now.
The documentation generator prints some errors, nothing to be alarmed of.
This is the command i'm using for the build:
sbuild -d experimental '--extra-repository=deb http://deb.debian.org/debian experimental main' --build-dep-resolver=aspcud
```

然后我的步骤:
```bash
sudo sbuild --arch=riscv64 -d sid-riscv64-sbuild
```The following information may help to resolve the situation:

The following packages have unmet dependencies:
 sbuild-build-depends-main-dummy : Depends: libicu-dev (>= 70.1~) but 67.1-7 is to be installed
                                   Depends: node-acorn (>= 6.2.1~) but it is not going to be installed
                                   Depends: pkg-js-tools (>= 0.8.2~) but it is not going to be installed
                                   Depends: node-js-yaml (>= 4.1.0+dfsg+~4.0.5-6) but it is not going to be installed
                                   Depends: node-marked (>= 4~) but it is not going to be installed
                                   Depends: node-highlight.js but it is not going to be installed
E: Unable to correct problems, you have held broken packages.
apt-get failed.
E: Package installation failed
``` 
This may be a common error on Debian riscv arch. I am thinking that I have to build from a package without node-*dependencies？
Below is my operations step how to build(please point to me wrong as I am newbie to gbp also):
1. git clone
     git clone git@salsa.debian.org:js-team/nodejs.git
2. checkout 16.14
     git checkout -b main origin/master-16.x
      git checkout -b upstream origin/upstream-16.x // not need -b
     git checkout -b pristine-tar origin/pristine-tar // not need -b also
      git checkout main
3. gbp buildpackage --git-pbuilder --git-submodules --git-upstream-branch='upstream/16.14' --git-debian-branch=main --git-no-pristine-tar --git-upstream-tree=tag --git-ignore-new -sa // the step to generate *.orig.tar.gz file. But I do not have the base directory /var/cache/pbuilder/base.cow and it fail at last(*.orig.tzr.gz has been generated)
4. execute ` sudo sbuild --arch=riscv64 -d sid-riscv64-sbuild ` and got above errors.
```

然后大佬给的建议:

```bash
You can do it a bit simpler because of the debian/gbp.conf file, so no need to rename any branch at all.
git checkout master-16.x
gbp buildpackage --git-pbuilder --git-ignore-new -sa
...
Also you really will want to use the DEB_BUILD_PROFILES="nodoc nocheck nobuiltin"
```

最后build成功:

```bash
sudo sbuild --arch=riscv64 -d sid-riscv64-sbuild --build-dep-resolver=aspcud
```

这只是工作的第一步，下面需要分解任务。

```bash
That failure is not fatal and happens on some other archs too, you don't really need to fix it.

Anyway once you built nodejs on riscv64 with DEB_BUILD_PROFILES as above,
you should now try to build all the build-dependencies of nodejs that themselves depend on nodejs
(they have the <!nocheck> or <!nodoc> flag in debian/control).
Once that is done, you can rebuild nodejs without DEB_BUILD_PROFILES at all, and upload it to experimental.
```


# issue


## node_acorn
node_acorn 需要 nodejs, 标志禁不掉 -- todo

```bash
 sudo sbuild --arch=riscv64 -d sid-riscv64-sbuild --build-dep-resolver=aspcud
dh clean --with nodejs
dh: error: unable to load addon nodejs: Can't locate Debian/Debhelper/Sequence/nodejs.pm in @INC (you may need to install the Debian::Debhelper::Sequence::nodejs module) (@INC contains: /etc/perl /usr/local/lib/x86_64-linux-gnu/perl/5.34.0 /usr/local/share/perl/5.34.0 /usr/lib/x86_64-linux-gnu/perl5/5.34 /usr/share/perl5 /usr/lib/x86_64-linux-gnu/perl-base /usr/lib/x86_64-linux-gnu/perl/5.34 /usr/share/perl/5.34 /usr/local/lib/site_perl) at (eval 13) line 1.
BEGIN failed--compilation aborted at (eval 13) line 1.
```

## 无法执行

```bash
sudo sbuild --arch=riscv64 -d sid-riscv64-sbuild --extra-repository='deb http://deb.debian.org/debian experimental main' --build-dep-resolver=aspcud --extra-package=/home/vimer/no_del_debs/nodejs_16.14.0~dfsg-1_riscv64.deb
```

# 进一步改进



```bash
DEB_BUILD_PROFILES="nodoc nocheck nobuiltin"  dpkg-buildpackage --build=any
```

# 依赖package
http://ftp.kr.debian.org/debian-ports//pool-riscv64/main/i/icu/libicu-dev_70.1-2_riscv64.deb

http://ftp.kr.debian.org/debian-ports//pool-riscv64/main/i/icu/libicu70_70.1-2_riscv64.deb

http://ftp.kr.debian.org/debian-ports//pool-riscv64/main/i/icu/icu-devtools_70.1-2_riscv64.deb
