---
title: debian watch 备忘录
category: debian
layout: post
---
* content
{:toc}

debian/watch 对于新手打包者来说，是一个非常难啃的骨头，所以，这里简单的记录下。

# strace

```bash
version=4
opts=dversionmangle=s/\+ds(\.\d+)?$//,repacksuffix=+ds,repack,compression=xz,pgpsigurlmangle=s/$/.asc/, \
 https://strace.io/files/@ANY_VERSION@/@PACKAGE@-@ANY_VERSION@@ARCHIVE_EXT@
```

# dfsg + removing string

```bash

debian/watch:
version=4
opts=dversionmangle=s/\+dfsg.*$//,repacksuffix=+dfsg,compression=xz \
https://github.com/rems-project/sail/tags .*/archive/.*/(\d\S+)\.tar\.gz
```

现在能匹配到  0.18-linux-binary， 如何只匹配到 0.18

如下:
```bash
version=4
opts=dversionmangle=s/\+dfsg.*$//,repacksuffix=+dfsg,compression=xz \
https://github.com/rems-project/sail/tags .*/archive/.*/(\d+\.\d+)\.tar\.gz
```
`(\d+\.\d+)`：这部分正则表达式只匹配由数字和一个点组成的版本号，如 0.18，它确保只会匹配类似 0.18 的格式，而不会匹配后面带有其他字符的版本号，如 0.18-linux-binary。
