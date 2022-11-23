---
title: debian python packaging notes
category: debian-riscv
layout: post
---
* content
{:toc}

# packaging
主要参考[这里](https://wiki.debian.org/Python/GitPackaging), 还有一个[policy](https://salsa.debian.org/python-team/tools/python-modules/-/blob/master/policy.rst)也非常重要的。

## introducing a new package
这里的引入新包，是指Debian中并没有，而是从头开始创建。

```bash
$ uscan   # Download your package's upstream original tarball
$ tar -xvf srcpkgname_1.0.orig.tar.gz
$ cd srcpkgname_1.0
$ git init
$ git checkout -b upstream
$ git add .
$ git commit -m "import srcpkgname_1.0.orig.tar.gz"
$ git tag -s upstream/1.0
$ pristine-tar commit ../srcpkgname_1.0.orig.tar.gz upstream
$ git checkout -b debian/main

```

##  introducing an existed package from debian

```bash
 gbp import-dscs --pristine-tar --debsnap python-ssdeep
gbp:info: Downloading snapshots of 'python-ssdeep' to '/tmp/tmp_0ren7kh'...
gbp:info: No git repository found, creating one.
gbp:info: Version '3.1+dfsg-1' imported under '/home/vimer/build/rfs/nmu/23_python-ssdeep/ssddep/python-ssdeep'
gbp:info: Version '3.1+dfsg-2' imported under '/home/vimer/build/rfs/nmu/23_python-ssdeep/ssddep/python-ssdeep'
gbp:info: Version '3.1+dfsg-2.1' imported under '/home/vimer/build/rfs/nmu/23_python-ssdeep/ssddep/python-ssdeep'
gbp:info: Version '3.1+dfsg-3' imported under '/home/vimer/build/rfs/nmu/23_python-ssdeep/ssddep/python-ssdeep'
gbp:info: Version '3.1+dfsg-4' imported under '/home/vimer/build/rfs/nmu/23_python-ssdeep/ssddep/python-ssdeep'
gbp:info: Everything imported under /home/vimer/build/rfs/nmu/23_python-ssdeep/ssddep/python-ssdeep

```

参考 [http://marquiz.github.io/git-buildpackage-rpm/gbp.import.html](http://marquiz.github.io/git-buildpackage-rpm/gbp.import.html)

## from upstream introduce a new release 
还要注意repacke的问题:

```python
$ gbp pq import
$ git checkout debian/master
$ gbp import-orig --pristine-tar --uscan
```
别忘记:

```bash
$ gbp pq rebase
$ gbp pq export
```

## tagging
Once you've built and uploaded your package, you should tag the release.

```bash
$ gbp buildpackage --git-tag-only
$ git push --tags
```

# debian/*

## 原则
 
1. arch  一般为 all(架构独立), 只有C扩展的才是any(架构非独立)

2. 测试一般使用pytest或者unittest(unitetest应该就是默认的)

3. 


## debian/rules
```bash
# 可以clear:
# package-installs-python-pycache-dir [usr/lib/python3.10/dist-packages/pygubu/__pyinstaller/__pycache__/]
override_dh_python3:
	dh_python3

```

# RFS
Debian python team的RFS有一些特殊的地方是，你除了发邮件外，还可以使用一些特殊手段在IRC发出请求提供帮助，那就是这样：

```bash
# on  #debian-python channel
!rfs ueberzug

# remove rfs
!rfs -git-multimail
```

这样就可以的了。

# packages
这里，主要记载一些我自己upload的python包或者看到的一些好的打包范例。

## lazy-loader

[lazy-loader](https://salsa.debian.org/python-team/packages/lazy-loader/-/tree/debian/main/debian)
是我第一个比较打包顺利的python包，其中确实学到了不少的知识。尤其关注 2022-10  的debian python mail
list对这个的初版审评意见。