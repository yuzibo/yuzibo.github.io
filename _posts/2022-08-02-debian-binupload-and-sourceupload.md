---
title: debian bin upload vs source upload
category: debian-riscv
layout: post
---
* content
{:toc}

目前，众所周知的是，如果软件包是大版本升级，需要首先进入 NEW queue,目前这个机制在Debian内部也引起了巨大的反响，还正在讨论中。
当NEW queue没有问题后，向 release team发行 transition请求，即可再次向sid发送此版本的package更新。

在这里，简单记录下所有相关资料的链接。

# SourceOnlyUpload

[SourceOnlyUpload](https://wiki.debian.org/SourceOnlyUpload)

一个推荐的工作流程：

```bash
dch -i -m "Source only upload for testing migration."
dch -r
debuild -S
cd .. ; dput $changes_file
# git commit & git tag
```

Emaces team推荐的方式:

```bash

for foo in ...; do
    dgit clone foo
    dch "Rebuild for ..."
    dch -r
    git commit debian/changelog -m"..."
    dgit push-source
done
```

# binNMU
## 更详细的解释

> Not relevant with the issue. But could you tell me what meaning of
> binNMU here and how to generate it?

binNMUs (~= binary NMU) are rebuilds of a package without an upload.
They can be triggered by the release team and are part of transitions.
See also https://wiki.debian.org/Teams/ReleaseTeam/Transitions

> From my view I can understand, because we want to upgrade libzim(7->8), but
> its reverse dependencies has failed build on libzim8, so we have to upload
> binNMU for libzim8's reverse dependencies packages? Or binNMU is just for
> libzim8?

The binNMUs are for the reverse dependencies of libzim7 so that they
pick up a dependency on libzim8.


## 一个example

```bash

Package: release.debian.org
Severity: normal
User: release.debian.org@packages.debian.org
Usertags: binnmu

Hello,

I want to request binNMU to support python3.11.

  nmu spglib_2.0.2-1 . ANY . unstable . -m "Add python3.11"

```

[wiki](https://release.debian.org/wanna-build.html)
