---
layout: post
category: kernel
title: "在lkml上学到的"
---

* content
{:toc}

# merge window
## 2020-01-19 (v5.5-rc7)
## 2020-01-12  (v5.5-rc6)
这一周期在内核中至关重要，refer to [the article](https://www.kernel.org/doc/html/latest/process/2.Process.html?highlight=merge%20window)
`merge window`大约维持两周的时间，其实，如果我没记错的话，也就是最后一个<font color = "red">rc</font>释放出来
就是`merge window`的开始时间。原话是这样说的:

```c
The merge window lasts for approximately two weeks. At the end of this time, Linus Torvalds will declare that the window is closed and release the first of the “rc” kernels.
```
这里有一个与中文思维差异很大的命名方式，下面的原文:

```c
or the kernel which is destined to be 2.6.40, for example, the release which happens at the end of the merge window will be called 2.6.40-rc1. The -rc1 release is the signal that the time to merge new features has passed, and that the time to stabilize the next kernel has begun.
```
`2.6.40-rc1`一直到`2.6.40-rc7`（反正最后一个rc）是为了`2.6.41`准备的。那么，具体到什么版本的rcx作为`stable`版本，
这里也没有一个确切的规定，一般是人为的认为bug最少(regression)。等到stable版本出来之后，就会选择其中的一个交给Greg HK维护。
`stable`版本也会接受patch,但是必须接受以下两点:

	1. 一个有效的bug fix;
	2. patch已经合并到主线内核中

```c
The selection of a kernel for long-term support is purely a matter of a maintainer
having the need and the time to maintain that release. There are no known plans for
long-term support for any specific upcoming release.
```
这句话的意思：长期版本的支持(long term)内核的选择，这对于维护人来说是需要花费时间去维护的。
对于任何即将发布的特定版本，没有已知的长期支持计划。

也就是说，你的patch是你需要的，但是stable没有支持，这就需要你ccing stable团队，将patch吸收进去，
而且，能不能成功，这也是一个未知数。

## 有关merge window的疑问
The merge window lasts for approximately two weeks. At the end of this time, Linus Torvalds will declare that the window is closed and release the first of the “rc” kernels. 这句话的意思是说，rc1的发布就意味着merge window的结束吧
但是，When the merge window opens, top-level maintainers will ask Linus to “pull” the patches they have selected for merging from their repositories. 这里，就感觉相互矛盾了呢。在git log中，随处可见子系统维护人tag 为rc3,rc4的pull请求，难道，merge window的开始时间不是最后一版的rc吗 ？

[根据Greg HK](https://www.mail-archive.com/kernelnewbies@kernelnewbies.org/msg10206.html)

THe merge window is for kernel subsystem maintainers, as a "normal"
developer, you usually don't have to worry about that at all.

一个"rc"的持续时间大约一周，所以，一个次版本(minor version)的开发时间大约6~8周.

“rc1”的发布很关键。

[这篇文章](https://www.mail-archive.com/kernelnewbies@kernelnewbies.org/msg19018.html)说的很清楚了。

---->>>

> My question is about what to do during the closed window? I don't think I
> should submit patches as I assume I'll create a backlog for the maintainer
> who'll possibly be flooded when the window re-opens. Similarly I could create
> patches but not send them until the window re-opens, but again I'll just be
> creating a backlog.

Just keep going. The maintainers will keep a queue of patches and then try to
apply them in order when the merge window -rc1 is released for the next one.

Worse cases would be that the patches will no longer apply (in which case, a V2
will be needed) or, if you haven't heard anything for a while after the -rc1,
then a patch RESEND should do the trick.
----<<<

## next tree

Hi Lucas,

To follow changes to the linux-tree tree you need to first do a remote
update (this will get all the changes from the remote linux-next branch
to the local origin/master tracking branch) and then reset the HEAD
pointer of current checked out branch to the HEAD of linux-next remote
tracking branch (i.e origin/master).
```bash
$ git remote update
$ git reset --hard origin/master
```
This will make your current branch (master) *exactly* like the remote
linux-next tree. You cannot do pull or merge from the remote tracking
branch.

[SO](https://stackoverflow.com/questions/19327523/explain-linux-kernel-state-terminology-e-g-net-next-linux-next-net-git)
有关net net-next  next-的解释。

next树包含的所有next树的信息在[here](https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/Next/Trees?id=HEAD)


## How to get patches from e-mail client?
[the link](https://www.mail-archive.com/kernelnewbies@kernelnewbies.org/msg17376.html)

## git tree?
有许多向linus发送pull请求的git仓库并不一定在git.kernel.org网站，比如：

Merge tag 'drm-fixes-2020-01-10' of git://anongit.freedesktop.org/drm/drm

drm的tree就在freedesktop.org网站上。

# 内核中如何处理Reviewed-by tags

I have given you an R-by for this one already, so why haven't you added it here?

Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

什么意思呢？就是如果你在V2,V3,,,版本中一定加上此前别的hacker给你添加的R-by tags， 记住它

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


## 内存分配标志
```c
When allocating memory, the GFP_KERNEL cannot be used during the
spin_lock period. It may cause scheduling when holding spin_lock
```
未证实这个论断的正确性，这里需要知道的知识点包括 内存分配的 标志 和 锁相关的原理和机制
