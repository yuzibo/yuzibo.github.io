---
title: Port riscv64 to Debian task list --2022/02/21
category: debian-riscv
layout: post
---
* content
{:toc}

以下是我push的一些port riscv的情况，方便自己查看。

| 软件名称 | bug url   | 是否有patch | 最新状态 |   说明 |
| -------- | --------- | ----------- | -------- |
| sofia-sip  | [link](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=978498) |  yes           |  apply patch 后可以编译riscv64 deb |需要推动patch merge into ports's repo      |
| [yubiserver](https://udd.debian.org/cgi-bin/ftbfs.cgi?arch=riscv64)     | [link](https://buildd.debian.org/status/package.php?p=yubiserver&suite=sid)     | 无 | 自己可以fix  | |
