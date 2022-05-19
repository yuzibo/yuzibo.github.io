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