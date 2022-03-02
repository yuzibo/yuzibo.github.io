---
title: Debian 打包教程
category: debian-riscv
layout: post
---
* content
{:toc}

[这里](https://wiki.debian.org/Packaging)有太多的资料可供参考。

由于历史的原因，Debian本身具有很多打包的命令与工具，各不相同。为了简化我们的操作或者顺应大势，我们首先考虑的是延续git的用法。

# git-buildpackage

主要是参考这篇[文章](https://wiki.debian.org/PackagingWithGit)

```bash
sudo apt install git-buildpackage
```

在我们使用`apt`命令进行相关操作时，首先应该也会想到，放在FTP上的是一个deb包。同理，我们打包deb包的根源，也就是upstream以什么样的形式存在呢？ 一种是tarball文件的方式，另一种自然就是git了(比如说在github上)。

我们今天先不实验tarball的形式，先探究git的方式(upstream)。

## import upstream branch


# debian make 

[资料](https://www.debian.org/doc/manuals/debmake-doc/ch04.en.html)
The debmake command is the helper script for the Debian packaging.

    *It always sets most of the obvious option states and values to reasonable defaults.
    *It generates the upstream tarball and its required symlink if they are missing.
    *It doesn’t overwrite the existing configuration files in the debian/ directory.
    *It supports the multiarch package.
    *It creates good template files such as the debian/copyright file compliant with DEP-5.

## 以tarball的方式构建

```bash
vimer@debian:~/maintain_packages/yubo_port/spa-1.0$ debmake -T
I: set parameters
I: sanity check of parameters
I: pkg="spa", ver="1.0", rev="1"
I: *** start packaging in "spa-1.0". ***
I: provide spa_1.0.orig.tar.gz for non-native Debian package
I: pwd = "/home/vimer/maintain_packages/yubo_port"
I: $ ln -sf spa-1.0.tar.gz spa_1.0.orig.tar.gz
I: pwd = "/home/vimer/maintain_packages/yubo_port/spa-1.0"
I: parse binary package settings:
I: binary package=spa Type=bin / Arch=any M-A=foreign
I: analyze the source tree
I: build_type = QMake
I: scan source for copyright+license text and file extensions
I:  44 %, ext = media
I:  11 %, ext = c
I:   7 %, ext = sh
I:   7 %, ext = text
I:   6 %, ext = md
I:   6 %, ext = ts
I:   4 %, ext = yml
I:   3 %, ext = qss
I:   2 %, ext = pro
I:   2 %, ext = qrc
I:   1 %, ext = gitignore
I:   1 %, ext = keystore
I:   1 %, ext = desktop
I:   1 %, ext = Debian
I:   1 %, ext = source
I:   1 %, ext = bak
I:   1 %, ext = ui
I:   1 %, ext = rc
I:   1 %, ext = nsi
I: make debian/* template files
I: found "debian/control"
I: debmake -x "0" ...
I: skipping :: debian/control (file exists)
I: skipping :: debian/copyright (file exists)
I: substituting => /usr/share/debmake/extra0/rules
I: skipping :: debian/rules (file exists)
I: substituting => /usr/share/debmake/extra0/changelog
I: creating => debian/changelog
I: run "debmake -x1" to get more template files
I: $ wrap-and-sort
```

正如前面所言，`debmake`是一个帮助命令，可以让你省去很多手写debian目录下文件的烦恼，上面log中显示的，skipping等字样，是因为我选择的这个github，之前已经有了相应的文件，这一点需要注意。

[具体的case](https://www.debian.org/doc/manuals/debmake-doc/ch04.en.html)。

# 其他资料
https://wiki.debian.org/BuildingTutorial


## 解决命名冲突

[Resolve conflicting values in Debian package](http://jonasbn.github.io/til/debian/resolve_conflicting_values_in_package.html)

## 解决changelog的版本

dpkg-source: error: can't build with source format '3.0 (native)': native package version may not have a revision
[dpkg-source: error: can't build with source format '3.0 (native)': native package version may not have a revision](https://github.com/jamesdbloom/grunt-debian-package/issues/23)
