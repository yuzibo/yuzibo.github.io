---
title: Update debian symbols files
category: debian-riscv
layout: post
---
* content
{:toc}

如果因为有symbols file的影响导致ftbfs，可以尝试着更新xx.symbols文件，具体的方法如下：

[fix bug](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1012565#10)

最根本的教程是[here](https://www.eyrie.org/~eagle/journal/2012-01/008.html)。

首先安装 `pkg-kde-tools `依赖包。

然后要把源码下载下来，可以使用 `apt source xx`的方法。
```bash
pkgkde-getbuildlogs
pkgkde-symbolshelper batchpatch -v 1.6.1 *_unstable_logs/*.build
```
有可能需要多次的更新symbols文件。