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

# symbols 文件的具体作用

It means that packages depending on a library can relax their version
dependencies on that library to the oldest version that supports all
the symbols they use. Until the symbols mechanism was invented,
whenever a library added a symbol, it bumped its shlibs and after that
packages built against the library would require the new version.
That made it harder to do (partial) upgrades, testing migration etc.

https://wiki.debian.org/Projects/ImprovedDpkgShlibdeps