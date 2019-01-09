---
title: kernel自带库文件的使用
category: kernel
layout: post
---

* content
{:toc}

# libbpf

这样写就是太乱了，但是为了安排到kernel目录下，暂时也就这样吧。
文章的题目什么意思呢？ 在kernel的主目录下，我们会看到一个tools/include/目录，这个目录是做什么的呢？他就是给内核某个特性的提供一个库，这个库你可以编译成动态库也可以编译成静态库，这取决于你的选择，通过这个库，你就可以像其他库文件一样使用了。

[例子](https://suricata.readthedocs.io/en/latest/capture-hardware/ebpf-xdp.html)

```c
cd linux/tools/lib/bpf/
make && sudo make install

sudo make install_headers
sudo ldconfig
```
