---
title: debian watch 备忘录
category: debian
layout: post
---
* content
{:toc}

debian/watch 对于新手打包者来说，是一个非常难啃的骨头，所以，这里简单的记录下。

strace

```bash
version=4
opts=dversionmangle=s/\+ds(\.\d+)?$//,repacksuffix=+ds,repack,compression=xz,pgpsigurlmangle=s/$/.asc/, \
 https://strace.io/files/@ANY_VERSION@/@PACKAGE@-@ANY_VERSION@@ARCHIVE_EXT@
```
