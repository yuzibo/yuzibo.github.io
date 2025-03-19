---
layout: post
title: "Debian backports summary"
category: debian
---

* content
{:toc}

# wiki

官方[wiki](https://backports.debian.org/)

没想到 debian 的backports有这么多的内容, 暂时先记录在这里:

[https://backports.debian.org/changes/](https://wiki.debian.org/Backports)

具体的用法是:

```bash
https://wiki.debian.org/Backports
```

See [here](https://wiki.debian.org/Backports)

# case

[go-jose](https://tracker.debian.org/pkg/golang-github-go-jose-go-jose)
是我维护的一个简单的golang包，然后在2025 年初的时候， 上游被报一个
CVE issue, 按照正常流程， maintainer 需要先把新版本引入到
sid/unstable 然后进入到 testing. 等到 testing 更新后最后需要
backports.

```c
  ...
  Backporting a package is very similar to preparing a package for
upload to unstable. There are only a few differences:

  * You can only backport the version of a package that is in testing.
This ensures a clean upgrade path to the next version of Debian.

  * The distribution in the changelog should be "<release>-backports",
ie "bookworm-backports", instead of unstable.

  * Make only minimal changes to the package and don't worry too much
about lintian errors or warnings.

  * Be sure to build in a schroot/container/VM that matches the
backport distribution you are targeting. This is especially important
if the package compiles any code that might link to or depend on newer
versions of libraries that have been updated in testing.

  My general workflow for backporting a package consists of the
following steps:

  * Clone out the repo from salsa

  * Checkout out or create a "debian/bookworm-backports" branch from
the main development branch

  * Modify debian/gbp.conf to point to the new branch

  * Run `dch --bpo` which will automatically create the appropriate
changelog entry for you

  * Build and test the package to make sure everything works as
expected

  * Upload the package to the archive, create a tag for the release and
push changes up to salsa

  As a Debian Maintainer, you can be granted permissions to upload
backported versions of a package, but just like unstable a Debian
Developer must perform the first upload of the backported package.

  Also, if you haven't seen there's a nice page with further
information about performing backports at
https://backports.debian.org/Contribute/.

# thanks to: gibmat from Debian

```

基本上 gibmat 的流程就是一个标准的流程， 但是被卡在了 build 了。

## sbuild
在我的想法中， 依旧可以使用`sbuild-createchroot` [here](http://www.aftermath.cn/2022/02/17/sbuild-build-riscv-on-debian/) 创建 `stable-backports` 的 chroot.

```bash
sudo sbuild-createchroot --chroot-prefix=bookworm-backports
--extra-repository='deb http://deb.debian.org/debian
bookworm-backports main' --include=eatmydata,ccache bookworm
/srv/chroot/bookworm-backports-amd64-sbuild
http://ftp.fr.debian.org/debian
```

但是：

```bash
...
The following packages have unmet dependencies:
 sbuild-build-depends-main-dummy : Depends: golang-any (>= 2:1.21~)
but 2:1.19~1 is to be installed
E: Unable to correct problems, you have held broken packages.
apt-get failed.
E: Package installation failed
                                         Not removing build depends:
cloned chroot in use
...
```

From [introduction](https://backports.debian.org/Contribute/#index1h3), there is only pbuilder or cowbuilder support stable-backports.

```
gbp buildpackage  --git-upstream-tree=upstream --git-upstream-branch=upstream --git-sign-tags --git-builder=sbuild -d bookworm-backports -c bookworm-backports-amd64-sbuild  --no-clean-source --source  --git-debian-branch=debian/main --git-export-dir=../build-area/ --git-ignore-new  --verbose
```

注意： `-d bookworm-backports` 必须使用， 否则会报：

```bash
golang-github-go-jose-go-jose changes: lintian output: 'distribution-and-changes-mismatch unstable bookworm-backports', automatically rejected package.
```

然后使用 `pbuilder` 验证即可:

```bash
sudo DIST=bookworm gbp buildpackage  --git-upstream-tree=upstream --git-upstream-branch=upstream  --git-builder=pbuilder build  --git-pbuilder-options="--basetgz=/var/cache/pbuilder/base.tgz" ../build-area/golang-github-go-jose-go-jose_4.0.5-1~bpo12+1.dsc
```

然后产生附带 \*.changes文件的build后的文件。再正常上传即可。

备注： 必须确保 stable-backports  的依赖都满足。
