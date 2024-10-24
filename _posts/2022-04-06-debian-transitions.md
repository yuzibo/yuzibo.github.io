---
title: debian transition一般解释
category: debian-riscv
layout: post
---
* content
{:toc}

好多东西都放在了#debian-riscv下面，为了自己查找方便，暂且这样吧。

[transitions](https://wiki.debian.org/Teams/ReleaseTeam/Transitions)是debian为了减少或者为了阻止因为library 版本变化而引起依赖这个lib其他debian 包构建失败的情况，故有这么个transitions的机制。

# 应用
1. Change of ABI (SONAME bump) without change in API
2. Change of ABI and API, when the -dev package does not change name.

第一点就是一个巨大的难点对于新手来说，这个后面还需要更进一步总结。

[the message](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=956183#46)是一个很好的学习case：

The old libwmf0.2-7 package contains the same SONAMEs as the combination of the new libwmf-0.2-7 and   libwmflite-0.2-7 packages.If the new library is genuinely
compatible with the old library, then I think a better way to do this
would be to introduce an empty, transitional package with the old name
libwmf0.2-7. This shouldn't require going through the NEW queue again,
because libwmf0.2-7 still exists in unstable.

# transition slot request

```bash

Package: release.debian.org
Severity: normal
User: release.debian.org@packages.debian.org
Usertags: transition

Hello,

I would like to request a transition slot for openmm
(experimental -> unstable) due to soname bump. Current ben tracker [1]
is OK, all reverse dependencies build fine.

Thanks,
Andrius

[1] https://release.debian.org/transitions/html/auto-openmm.html

```
具体讲一下我自己的事例就行： 我在Debian中首先维护的一个package就做 [jimtcl](https://tracker.debian.org/pkg/jimtcl)
看到没， 他还有一个`-dev`的package。 dev就是我们所谓的开发SDk，这种情况一般都是让外部package使用的。

所以，如果我由0.79直接升级到0.81是不行的，因为这里面可能会涉及到api的改变，那么，所有依赖`jimtcl`的package能不能编译成功还真不一定保证。而包的维护者一定要注意这个情况可能发生的情况，要坚决避免或者把所有的问题close掉才可以。

1. 升级SONAME，然后把包上传到 `exp`;
2. 等到在[ben](https://release.debian.org/transitions/) 页面上看到 `auto-yourpackage`  时，你最好使用`ratt`这个package把所有依赖你的包的包都使用你上传到`exp`的package进行构建，如果没有问题，则可以向release team发送请求了:

补充说明: 1 步应该是可以这样的， 如果依赖你这个包比较少的情况下， 甚至可以提前自己在本地local build， 然后分别性的针对每一个反向依赖进行rebuild， 有问题的话发 issue 通知 maintainer; 没有问题的话最好。  

直接上传到 exp也好， 有问题的话可以让对应的 maintainer 随时查看.
 
```bash
如上文所示即可
```

3. 这时候等待release team给你通知，说你可以upload新的unstable上面去了。
等你上传完毕，你会收到一封通知:

```bash
From: Debian testing watch <noreply@release.debian.org>
To: jimtcl@packages.debian.org
Subject: jimtcl 0.81+dfsg0-2 MIGRATED to testing

FYI: The status of the jimtcl source package
in Debian's testing distribution has changed.

  Previous version: 0.79+dfsg0-3
  Current version:  0.81+dfsg0-2
```
这就可以了。

当然，我维护这个jimtcl还是有一定曲折的。

# update

我们根据这个 [1011630](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1011630)来复盘一下这个已经完成的 transiton.

1. 确保你的 新版本在 exp build ok
2. reverse deps build ok
3. 发送一个类似 1011630 的bug，或者 像 [#1050987](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1050987)也可以； 在得到 ack 后，再将新版本的 package upload to sid

接下来不用管， 等一两天的话， 他的反向依赖会自动 rebuild, 等一切ok， 要注意跟踪构建结果。
4. 完成之后，可以给 release team 反应?  什么时间给他 ack  呢？

我觉得是得你的包 transate into  testing后， 就可以告诉 release team

