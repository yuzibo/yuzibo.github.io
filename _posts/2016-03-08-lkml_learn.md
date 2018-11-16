---
layout: post
category: kernel
title: "在lkml上学到的"
---

* content
{:toc}

kernel的维护者，表面上很光鲜，其实他们的责任很大。

暂时先将lkml上看到的自己总结下来，每天看列表也是成为maintainer的基本功:)

# 使用calloc代替malloc() + memset()

在man calloc的手册中，我们可以看到是这么解释的.

>给数组中的每一个元素分配一个内存，然后内存空间被设置为0.

```c
 The  calloc()  function allocates memory for an array of nmemb elements
of size bytes each and returns a pointer to the allocated memory.   The
memory  is  set  to zero.  If nmemb or size is 0, then calloc() returns
either NULL, or a unique pointer value that can later  be  successfully
passed to free().
```
我们使用malloc和memset也是实现相同的东西

# linux kernel 开发周期
每一个新版本的发布需要两周的合并期，也就是linus从各个维护人那里得到新的特征
放进主线内核(mainline)，两周之后，合并期关闭，然后被标记为"rc1".在这期间，
不引入新的特征，只是对"rc1"的已有内容进行维护(修修补补)，一周以后，"rc2"发布

这个过程一直维持到"rc7",个别时期有可能是"rc6"或者"rc8"。当这一切到来时，
就会正式发布这个内核。比如，到了"4.5-rc7",接下来，linus会发布"4.5"的正式版本。而对于"4.6"版本的开发周期又开始了.

# 修订原先patch的格式

```c
> Fixes: d85b758f72b0 "virtio_net: fix support for small rings"

Fixes: d85b758f72b0 ("virtio_net: fix support for small rings")
```
后者才是正确的，被社区认可的。
