---
title: "linux下源码安装软件"
category: tools
layout: post
---

* content
{:toc}

其实这就涉及到了unix下从configure、make、make install一系列的步骤。

一般来说，拿到source packet后，我们首先运行./configure命令

```bash
./configure --prefix=/usr/local --enable-xx --with=yy
```

自己安装的软件，最后安装在/usr/local目录下，这样能够减少很多麻烦。好像，其他的软件如果需要其他的共享库，默认去/usr/local中查找，如果找不到，就会报链接错误。
