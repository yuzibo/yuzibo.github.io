---
title: packaging python package - git-multimail 
category: debian-riscv
layout: post
---
* content
{:toc}

在邮箱里突然发现一个[RFP 1007025](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1007025):

发现这又是一个python包，果断直接找 Debian python packaging [wiki](https://wiki.debian.org/Python/LibraryStyleGuide)：

[python packaging git](https://wiki.debian.org/Python/GitPackaging)

[join debian python team](https://salsa.debian.org/python-team/tools/python-modules/blob/master/policy.rst#joining-the-team)

为了Debian中的python包容易维护(不只是python，还有其他)，Debian创建了多个语言或者框架相关的team，尽管每个包都是自己owner,但是统一都放到 https://salsa.debian.org/python-team/packages/ 下面，这样做的好处:

1.  假设后面maintainer缺席了，可以及时由team维护
2.  只要消除了1， 其他的事情都不叫事。

注意一点:  debian python team不使用 `git-gdm`,这一点尤其注意。
## 创建 repo 

Set up a new repository visit https://salsa.debian.org/python-team/packages/ and follow the 'new project' link (the link will not be accessible unless you have joined the team). Enter the source package name as the project name and leave the visibility set to public.

但是需要python team给你加权限才可以幺。

## 初始化分支
### git基本操作

```bash
$ uscan   # Download your package's upstream original tarball
$ tar -xvf srcpkgname_1.0.orig.tar.gz
$ cd srcpkgname_1.0
$ git init
$ git checkout -b upstream
$ git add .
$ git commit -m "import srcpkgname_1.0.orig.tar.gz"
$ git tag -s upstream/1.0
$ pristine-tar commit ../srcpkgname_1.0.orig.tar.gz upstream ##
$ git checkout -b debian/master
```
这里重点介绍下 `pristine-tar`命令： pristine-tar commit tarball [upstream] pristine-tar commit generates a pristine-tar delta file for the specified tarball, and commits it to version control.

The upstream parameter specifies the tag or branch that contains the same content that is present in the tarball。

<del>
### 不要使用 git-dpm in Debian python team
<del>python team自己维护了一套tool，叫做  git-dpm,需要安装一下。</del>
```bash
git branch -D foo  # make sure there is no branch foo
git-dpm import-tar ../foo_0.0.0.orig.tar.gz 
git checkout -b upstream-foo # 会创建一个upstream的分支
git-dpm init ../foo_0.0.0.orig.tar.gz  # 创建一个master 分支，有debian目录，然而upstream是没有的。
```
</del>
## 添加内容

### d/changelog
首先使用  `dch --create`去创建一个changelog文件，然后再通过`dch -i`或者`dch -e`去编辑相关的信息，可以去看看别的package怎么写的。

这儿我的例子如下：

```bash
git-multimail (0.15-1) unstable; urgency=medium

  * Initial release of git-multimail to Debian. (Closes: #1007025)

  * Start from upstream's packaging. With some refreshing:

    -- Add myself as Maintainer.

 -- Bo YU <tsu.yubo@gmail.com>  Thu, 31 Mar 2022 10:58:24 +0800
```

## debmake
这个命令可以让你从头开始创建打包所需的原料脚本。[refer to](https://www.debian.org/doc/manuals/debmake-doc/ch04.en.html)

The `debmake` command is the helper script for the Debian packaging.

* It always sets most of the obvious option states and values to reasonable defaults.
* It generates the upstream tarball and its required symlink if they are missing.
* It doesn’t overwrite the existing configuration files in the debian/ directory.
* It supports the multiarch package.
* It creates good template files such as the debian/copyright file compliant with DEP-5.
* These features make Debian packaging with debmake simple and modern.

 我们使用`debmake`命令看一下：

 ```bash
(sid-amd64-sbuild)root@debian-local:/home/vimer/git/git-multimail/git-multimail# debmake
I: set parameters
I: sanity check of parameters
I: pkg="git-multimail", ver="1.5.0", rev="1"
I: *** start packaging in "git-multimail". ***
W: parent directory should be "git-multimail-1.5.0".  (If you use pbuilder, this may be OK.)
I: provide git-multimail_1.5.0.orig.tar.gz for non-native Debian package
I: pwd = "/home/vimer/git/git-multimail"
I: Use existing "git-multimail_1.5.0.orig.tar.gz" as upstream tarball
I: pwd = "/home/vimer/git/git-multimail/git-multimail"
I: parse binary package settings:
I: binary package=git-multimail Type=bin / Arch=any M-A=foreign
I: analyze the source tree
I: build_type = Python distutils
I: scan source for copyright+license text and file extensions
...

I: check_all_licenses
I: ........................................................................W: Non-UTF-8 char found, using latin-1: t/email-content.d/accent-python2
...........
I: check_all_licenses completed for 83 files.
I: bunch_all_licenses
I: format_all_licenses
I: make debian/* template files
I: found "debian/changelog"
I: debmake -x "0" ...
I: creating => debian/control
I: creating => debian/copyright
I: substituting => /usr/share/debmake/extra0/rules
I: creating => debian/rules
I: substituting => /usr/share/debmake/extra0/changelog
I: skipping :: debian/changelog (file exists)
I: run "debmake -x1" to get more template files
I: $ wrap-and-sort
```

这个时候，已经自动为你创建了一些debian/目录下的文件(之前已有的文件不会覆盖)。

主要是看一下d/rules文件:

```bash
#!/usr/bin/make -f
# You must remove unused comment lines for the released package.
#export DH_VERBOSE = 1
#export DEB_BUILD_MAINT_OPTIONS = hardening=+all
#export DEB_CFLAGS_MAINT_APPEND  = -Wall -pedantic
#export DEB_LDFLAGS_MAINT_APPEND = -Wl,--as-needed

%:
        dh $@ --with python2
```
### d/rules
下面是 d/rules 文件：

```bash
(sid-amd64-sbuild)root@debian-local:/home/vimer/git/git-multimail/git-multimail/debian# cat control
Source: git-multimail
Section: unknown
Priority: optional
Maintainer: root <>
Build-Depends: debhelper-compat (= 12),
               dh-python,
               python-all,
               python-setuptools,
               python3-all
Standards-Version: 4.5.0
Homepage: <insert the upstream URL, if relevant>
X-Python-Version: >= 2.6

Package: git-multimail
Architecture: any
Multi-Arch: foreign
Depends: ${misc:Depends}, ${shlibs:Depends}
Description: auto-generated package by debmake
 This Debian binary package was auto-generated by the
 debmake(1) command provided by the debmake package.
```
这里有几项是最关键的，比如，section   maintainer什么的，这块需要根据自己的实际情况来，当然，我这里是python package，那就先抄一个 [control](https://salsa.debian.org/python-team/packages/aiodogstatsd/-/blob/master/debian/control)
.

### d/copyright
这里有一个比较棘手的文件是 d/copyright文件，不太清楚如何去修改它。可以[参考这里copyright-format](https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/)

这里应该对每一个文件的copyright进行检查并说明，Files, Copyright, License为一组，最后是lisence的解释说明。

## 具体填充文件

[参考这篇文章](https://wiki.debian.org/Python/LibraryStyleGuide?action=show&redirect=Python%2FPackaging)

### d/control

如果使用deb_make命令的话。可以直接使用那个模板不是问题的。对于python的包来说，这应该是是注意python2和3版本的区别。
还有就是支持rst格式的doc支持。这个上面的链接都有提及。

### d/rules

```bash
#!/usr/bin/make -f

export DH_VERBOSE = 1
export PYBUILD_NAME=git-multimail


%:
        dh $@ --with python2,python3 --buildsystem=pybuild

```

### d/watch
使用 d/watch文件可以用来监控upstream有无更新的release,使用下面的命令可以解决大部分github的监控。

```bash
version=4
opts=\
repacksuffix=+ds,\
repack,compression=xz,\
dversionmangle=s/\+(debian|dfsg|ds|deb)(\.?\d+)?$//,\
filenamemangle=s%(?:.*?)?v?(\d[\d.]*)\.tar\.gz%<project>-$1.tar.gz% \
https://github.com/git-multimail/git-multimail/tags \
(?:.*?/)?v?(\d[\d.]*)\.tar\.gz debian uupdate
```
在主目录中可以使用`uscan`命令进行测试。

```bash
uscan --no-download --verbose
```

# fix
这里有一些需要fix的问题对于新的itp包：

## 没包含source code

Dsc failed to parse

dsc is missing from changes
Make sure you include the full source (if you are using sbuild make sure to use the --source option or the equivalent configuration item; if you are using dpkg-buildpackage directly use the default flags or -S for a source only upload)

方案说的也很清楚哈。

# 经过

##  gbp 临时命令:
```bash
gbp buildpackage --git-upstream-tree=upstream/1.5.0 --git-upstream-branch=upstream/1.5.0  --git-builder=sbuild -d unstable  --git-debian-branch=debian/main --git-export-dir=../build-area/ --git-ignore-new  --verbose
```

## 多次修改
```bash
#!/usr/bin/make -f

export DH_VERBOSE = 1

export PYBUILD_NAME=git-multimail

%:
        dh $@ --with python3 --buildsystem=pybuild

override_dh_auto_clean:
        rm -rf .pytest_cache
        dh_auto_clean

override_dh_auto_build:
        PYTHONPATH=. http_proxy='127.0.0.1:9' python3 -m sphinx -N -bhtml doc/ build/html

override_dh_auto_test:
ifeq ($(filter nocheck,$(DEB_BUILD_PROFILES)),)
        dh_auto_test
endif

```

## 删除不想要的文件
```bash
https://sources.debian.org/src/util-linux/2.38-4/debian/rules/?hl=77#L77
```