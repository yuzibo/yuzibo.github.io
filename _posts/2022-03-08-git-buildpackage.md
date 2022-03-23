---
title: debian git-buildpackage用法(jimtcl)
category: debian-riscv
layout: post
---
* content
{:toc}


根据Debian社区大佬的要求，如果想成为一个package maintainer的话，仅仅修改这个field是不够的，还必须有其他的改动。
一开始还确实不太理解，觉得对方是在双标，然而等自己真正实践起来才发现，大佬的想法没错。如果连最基本的都操作不了，如果出了问题怎么解决？

丢人也好，受气也罢，最关键的一点是，是自己太菜。目前的工作完全支持我在这一块全身心的投入，还有什么理由做不好呢？

为什么说Debian社区比较geek呢(其他发行版我用的也不多)，就是debian自己的工具，什么都能给你造一个出来，这不，社区给你打早了一个封装git的命令 `gbp`,对，应该就是 `git-buildpackage`的缩写。

最权威的参考手册莫过于[这里](https://honk.sigxcpu.org/projects/git-buildpackage/manual-html/).
这里有个中文的[文章](https://hosiet.me/blog/2016/09/15/make-debian-package-with-git-the-canonical-way/)也是非常的精彩。

首先介绍下目前git-buildpackage的一些workflow。

1. debian-branch : 也就是自己维护工作的分支,针对于debian而言（目前默认是debian/main）；
2. upstream-branch ： 这个是用来保持upstream的记录的，默认是 upstream/latest
3. pristine-tar branch: 初始化时， gbp会默认创建这个分支。

# git fork

Debian开发人员为了自己管理代码与upstream方便的进行交互，一般来说会在 [salsa.debian.org](https://salsa.debian.org/)创建一个repo。这个repo与upstream的区别就是，摒除git的概念，只从代码的角度来看，就是在salsa repo中添加了一个 `debian`的名录。看到这里，你应该就明白这是怎么一回事了吧。

我首先 forked [https://salsa.debian.org/debian/jimtcl](https://salsa.debian.org/debian/jimtcl)到自己名下[https://salsa.debian.org/vimerbf-guest/jimtcl](https://salsa.debian.org/vimerbf-guest/jimtcl).其实，这里也就是说明了一件事，如果salsa上面已经存在一个你想维护的包，可以直接fork下来使用。

下面的操作[参考这里](http://www.debian.org.tw/topics/how-to-start-your-first-Debian-package.html)

我们看一下fork出来的branch情况:

```bash
vimer@debian-local:~/git/jimtcl/jimtcl$ git branch -a
* debian/main
  remotes/origin/HEAD -> origin/debian/main
  remotes/origin/debian/experimental
  remotes/origin/debian/main
  remotes/origin/pristine-tar
  remotes/origin/upstream/latest
  remotes/origin/upstream/latest-repack
```
我们看到，除了本地有一个debian/main, upstream/latest分支没有本地分支，pristine-tar我们暂时不用管，gbp会自己创建。
那么，我们得首先创建 upstream/latest 分支(这一块我也不是特别明白，如果有误解，请指正)。
```bash
vimer@debian-local:~/git/jimtcl/jimtcl$ git branch upstream origin/upstream/latest
分支 'upstream' 设置为跟踪来自 'origin' 的远程分支 'upstream/latest'。
vimer@debian-local:~/git/jimtcl/jimtcl$ git branch  pristine-tar origin/pristine-tar
分支 'pristine-tar' 设置为跟踪来自 'origin' 的远程分支 'pristine-tar'。
```

然后upstream，可以使用指定。
```bash
 gbp import-orig https://github.com/msteveb/jimtcl/archive/refs/tags/0.81.tar.gz
```
如果这个时候报这个错误，可以使用下面的方式:

```bash
vimer@debian-local:~/git/jimtcl/jimtcl$ gbp import-orig https://github.com/msteveb/jimtcl/archive/refs/tags/0.81.tar.gz
gbp:error:
Repository does not have branch 'upstream/latest' for upstream sources. If there is none see
file:///usr/share/doc/git-buildpackage/manual-html/gbp.import.html#GBP.IMPORT.CONVERT
on howto create it otherwise use --upstream-branch to specify it.
```

如果github抽风，还可以使用`--pristine-tar`指定tar文件:

```bash
$ gbp import-orig --pristine-tar ../0.81.tar.gz --debian-branch=debian/main -u 0.81                gbp:info: Importing '../0.81.tar.gz' to branch 'upstream/latest'...
gbp:info: Source package is jimtcl
gbp:info: Upstream version is 0.81
Branch 'pristine-tar' set up to track remote branch 'pristine-tar' from 'origin'.
gbp:info: Replacing upstream source on 'debian/main'
gbp:info: Successfully imported version 0.81 of ../jimtcl_0.81.orig.tar.gz
```
其中， `--debian-branch`就是我们的本地分支， `-u`指定版本。
或者：
```bash
gbp import-orig https://github.com/msteveb/jimtcl/archive/refs/tags/0.81.tar.gz --debian-branch=debian/main --upstream-branch=upstream  -u 0.81
```

现在我们可以看下branch的情况:

```bash
vimer@debian-local:~/git/jimtcl/jimtcl$ git branch -a
* debian/main
  pristine-tar
  upstream/latest
  remotes/origin/HEAD -> origin/debian/main
  remotes/origin/debian/experimental
  remotes/origin/debian/main
  remotes/origin/pristine-tar
  remotes/origin/upstream/latest
  remotes/origin/upstream/latest-repack
```
接着看一下 `git log`:
```bash
commit 0d9289c68cca547ee4815b0d9ea2e0aaab57a7e0 (HEAD -> debian/main)
Merge: b8edd3d 8e5bb80
Author: vimer <tsu.yubo@gmail.com>
Date:   Wed Mar 9 11:29:43 2022 +0800

    Update upstream source from tag 'upstream/0.81'

    Update to upstream version '0.81'
    with Debian dir 49f71ac6d713ed89146f5f7525bad4ba5855b69f

commit 8e5bb802b183ce511f70dc9978d4a1bb797b4cf7 (tag: upstream/0.81, upstream/latest)
Author: vimer <tsu.yubo@gmail.com>
Date:   Wed Mar 9 11:29:30 2022 +0800

    New upstream version 0.81

commit b8edd3d0e96e36089dcf78be01702692c0f92f43 (tag: debian/0.79+dfsg0-3, origin/debian/main, origin/HEAD)
Author: Didier Raboud <odyx@debian.org>
Date:   Fri Sep 3 16:22:09 2021 +0200

    jimtcl 0.79+dfsg0-3 Debian release

```

# 修改patch（可选）

假设有的话。
```bash
# 1. 先处理debian/patches/下的文件 
gbp pq import 
# 2. 
gbp pq export

# 3. commit 
git  add xx && git commit --amend 

```

# build dsc file

```bash
 gbp buildpackage --git-debian-branch=debian/main --git-export-dir=/tmp/build-area/jimtcl -S
```
因为有很多用法没有搞明白，导致出现了很多的error。下面这个是我试验OK的。

```bash
 gbp buildpackage --git-debian-branch=debian/main  --git-upstream-tree=upstream --git-pristine-tar-commit  --git-export-dir=/tmp/build-area/jimtcl -S  --git-verbose
```
`--git-debian-branch=debian/main` 指明debian branch。

`--git-upstream-tree=upstream`也很关键： How to find the upstream sources used to generate the tarball，因为我是使用的`pristine`来引入upstream的源码，如果是其他的，估计不会使用这个选项了。请[参考这里](https://unix.stackexchange.com/questions/504746/how-to-build-postfix-from-debian-salsa-git-gbperror-upstream-3-3-2-is-not-a)，主要是，我这里没有把标签打上去。

`--git-pristine-tar-commit`: Commit the pristine-tar delta to the pristine-tar branch if a new tarball was generated and the pristine-tar data isn't already there. 这段话的意思其实我是拿捏不准的。

`--git-export-dir=/tmp/build-area/jimtcl -S`是把该tarball的dsc文件放在这个位置，方便后面的build。

`--git-verbose`是可以详细的把执行过程打印出来，方便debug使用。

# dch -i

如果已经有了 debian目录，我们可以暂时不必使用(`debmake`)命令去自动生成debian目录下的东西；如果没有的话，需要执行。

如果已经有了debian目录，我们的工作就是查漏补缺。第一步就是更新版本号，这里注意一下:

```bash
vimer@debian-local:~/git/jimtcl/jimtcl-0.81$ dch -i
dch warning: neither DEBEMAIL nor EMAIL environment variable is set
dch warning: building email address from username and mailname
dch: Did you see those 2 warnings?  Press RETURN to continue...
```

然后使用`dch -i`去更改changelog文件。有几个地方需要改一下：

unknown 要改成 unstable(或者experimential),bug number 要改為自己的 ITP number,修改自己的名字與 email.

`debmake只会生成模板，实质性的内容并不会起作用。

# Build a source package .dsc
这里的dsc就是debian source control文件，可以参考[这里](https://wikitech.wikimedia.org/wiki/Git-buildpackage)
```bash
gbp buildpackage --git-export-dir=/var/tmp/build-area/packagename -S
```

# Build the binary packages with Pbuilder

```bash
pbuilder build --basetgz /var/cache/pbuilder/lucid.tgz /var/tmp/build-area/packagename/packagename_version.dsc
```

# error 及应对
```bash
gbp import-orig https://github.com/msteveb/jimtcl/archive/refs/tags/0.81.tar.gz
gbp:error:
Repository does not have branch 'upstream/latest' for upstream sources. If there is none see
file:///usr/share/doc/git-buildpackage/manual-html/gbp.import.html#GBP.IMPORT.CONVERT
on howto create it otherwise use --upstream-branch to specify it.
# 需要 checkout -b 一个
vimer@debian-local:~/git/jimtcl/jimtcl$ git checkout -b upstream/latest
切换到一个新分支 'upstream/latest'
vimer@debian-local:~/git/jimtcl/jimtcl$ gbp import-orig https://github.com/msteveb/jimtcl/archive/refs/tags/0.81.tar.gz
What is the upstream version? [] 0.81
gbp:info: Importing '../0.81.tar.gz' to branch 'upstream/latest'...
gbp:info: Source package is jimtcl
gbp:info: Upstream version is 0.81
Branch 'pristine-tar' set up to track remote branch 'pristine-tar' from 'origin'.
gbp:info: Merging to 'debian/master'
gbp:error: Import of ../jimtcl_0.81.orig.tar.gz failed: Error running git checkout: error: 路径规格 'debian/master' 未匹配任何 git 已知文件
gbp:error: Error detected, Will roll back changes.
gbp:info: Rolling back branch upstream/latest by resetting it to a86b79ef1858b0ab651302dd1f4bcf9190bfdf73
gbp:info: Rolling back branch 'pristine-tar' by deleting it
gbp:info: Rolling back tag 'upstream/0.81' by deleting it
gbp:info: Rolling back branch 'debian/master' by deleting it
gbp:error: Rolled back changes after import error.
```

你看，上面又报了这个错，我们接着拆招吧~

```bash
vimer@debian-local:~/git/jimtcl/jimtcl$ git checkout -b debian/master
切换到一个新分支 'debian/master'
vimer@debian-local:~/git/jimtcl/jimtcl$ gbp import-orig https://github.com/msteveb/jimtcl/archive/refs/tags/0.81.tar.gz --debian-branch=debian/master -u 0.81
gbp:error: Failed to download https://github.com/msteveb/jimtcl/archive/refs/tags/0.81.tar.gz: ../0.81.tar.gz already exists
vimer@debian-local:~/git/jimtcl/jimtcl$ gbp import-orig --pristine-tar ../0.81.tar.gz --debian-branch=debian/master -u 0.81              gbp:info: Importing '../0.81.tar.gz' to branch 'upstream/latest'...
gbp:info: Source package is jimtcl
gbp:info: Upstream version is 0.81
Branch 'pristine-tar' set up to track remote branch 'pristine-tar' from 'origin'.
gbp:info: Replacing upstream source on 'debian/master'
gbp:info: Successfully imported version 0.81 of ../jimtcl_0.81.orig.tar.gz
```

# 参考命令
这些参考命令放在这里，逐渐加深印象。

```bash
# 1 
gbp buildpackage --git-ignore-new  --git-no-pristine-tar --verbose 

#2 
 gbp config buildpackage
```

## 简单的命令
假设co-team上传了一个远程分支，你可以更简单的使用:

```bash
git checkout master-16.x
gbp buildpackage --git-pbuilder --git-ignore-new -sa # 补充完全
```

## 直接使用git

也就是没有tarball的情况下怎么办?

```bash
sudo gbp buildpackage  --git-submodules  --git-no-pristine-tar --git-upstream-tree=tag --git-ignore-new -sa --git-export-dir=../
```
但是这个也会有问题，需要第一次把 `-u`说明正确。


# symbols file

原来是旧的 0.79.symbols,  现在是新的0.81.symbols

```bash
sudo dpkg-deb -x libjim0.81_0.81+dfsg0-1_amd64.deb /tmp/jimctl  # 解包
sudo dpkg-gensymbols -v0.81 -plibjim -P/tmp/jimctl/ -Olibjim.symbols  # 得到符号表

```

https://wiki.debian.org/UsingSymbolsFiles