---
title: debian rush maintain with gbp
category: debian-riscv
layout: post
---
* content
{:toc}

记录下维护rush的操作，在后面进行更广泛的总结。

#  gbp buildpackage

## clone
```bash
vimer@debian-local:~/build_test/rfs/debian-rush$ gbp clone git@salsa.debian.org:vimerbf-guest/rush.git
gbp:info: Cloning from 'git@salsa.debian.org:vimerbf-guest/rush.git'
```

其实，如果有新的upstream更新，应该是先`gbp pq import`,其次才是import upstream release.

https://www.eyrie.org/~eagle/notes/debian/git.html#workflow:

```bash
When there's a new upstream release, run:

    git fetch upstream
    gbp pq import  # only if you have patches against upstream
    git checkout debian/master
    gbp import-orig --uscan --upstream-vcs-tag=<upstream-tag>
    # The rest are only if you have patches against upstream
    gbp pq rebase
    gbp pq export
    gbp pq drop
    git add debian/patches
    git commit
```

## import
import新的版本：

```bash
vimer@debian-local:~/build_test/rfs/debian-rush/rush$ gbp import-orig --uscan --debian-branch=debian/main --upstream-branch=upstream/latest --verbose   
gbp:debug: ['git', 'rev-parse', '--show-cdup']
gbp:debug: ['git', 'rev-parse', '--is-bare-repository']
gbp:debug: ['git', 'rev-parse', '--git-dir']
gbp:debug: ['git', 'for-each-ref', '--format=%(refname:short)', 'refs/heads/']
gbp:debug: ['git', 'show-ref', '--verify', 'refs/heads/upstream/latest']
gbp:error:
Repository does not have branch 'upstream/latest' for upstream sources. If there is none see
file:///usr/share/doc/git-buildpackage/manual-html/gbp.import.html#GBP.IMPORT.CONVERT
on howto create it otherwise use --upstream-branch to specify it.
```
这里失败了，因为没有`upstream/latest` branch. 对策是新建一个`upstream/latest` branch即可。

```bash
vimer@debian-local:~/build_test/rfs/debian-rush/rush$ git checkout -b upstream/latest
切换到一个新分支 'upstream/latest'
vimer@debian-local:~/build_test/rfs/debian-rush/rush$ git checkout debian/main
切换到分支 'debian/main'
您的分支与上游分支 'origin/debian/main' 一致。
...
vimer@debian-local:~/build_test/rfs/debian-rush/rush$ gbp import-orig --uscan --debian-branch=debian/main --upstream-branch=upstream/latest --verbose
...
gbp:debug: rm ['-rf', '../tmpdk5cwagw'] []
gbp:info: Successfully imported version 2.2 of ../rush_2.2.orig.tar.gz
```

## build 

假设我们有一个新的 upstream release，使用 `gbp buildpackage`时，如果没有orig的tarball，则不会build的，
build的version是根据top of changelog来确定版本及对应的tarball。

```bash
gbp buildpackage --git-upstream-tree=upstream/2.2 --git-upstream-branch=upstream/2.2  --git-builder=sbuild -d unstable  --git-debian-branch=debian/main --git-export-dir=../build-area/ --git-ignore-new  --verbose
```

这个只有在我们没有新的orig tarball时确认使用。

还可以使用这个命令编译:

```bash
gbp buildpackage  --git-builder=sbuild -d unstable  --source --git-debian-branch=debian/main --git-export-dir=../rush-build-area/  --git-ignore-new --verbose
```

# lintian

## W: rush source: orig-tarball-missing-upstream-signature rush_2.2.orig.tar.gz
```bash
 gpg --armor --detach-sign myprogram-0.1.orig.tar.gz
```

# 目前 rush 2.2 已经进入debian

[salsa](git@salsa.debian.org:debian/rush.git) 后面所有的改动转移到这里来。