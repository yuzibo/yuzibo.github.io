---
title: "查找系统的硬件信息"
layout: post
category: system
---

* content
{:toc}

# uname

```bash
uanme -a
```

简单粗暴明了

# 其它

下面这些命令，没有的话，需要自己重新安装，不大，占不了多少内存。

```bash
lspci
lsusb
lshw
lscpu
lshw
/proc
```

简单介绍工具lshw：

```bash
sudo lshw -html > lshw.html
```

这样就生成了.html，用浏览器打开就行了。

