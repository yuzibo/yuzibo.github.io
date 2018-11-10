---
title: "git产生patch并使用git send-email发送"
category: git
layout: post
---

# 1
# 产生patch
git 产生patch还是非常简单的，我们使用最多的就是`git format-patch`命令了。
产生单个patch

```bash
git format-patch -o ~/patch/ HEAD^
```
注意这里的HEAD^(HEAD~也可以),如果只有HEAD是不可以的,当然，如果你查看log的话，使用下面的命令：

```bash
git log --pretty=oneline --abbrev-commit
git show HEAD  # 展示的第一个commit日志
```
## 发送单个patch
### mutt方法
很简单的一点就是 mutt -H your-pacth,then send it,oh, sure, don not forget maintainer of address and who is them.
如何得到维护人的地址或者相关列表呢？使用下面的命令：

```bash
git show HEAD | perl scripts/get_maintainer.pl --separator , --nokeywords --nogit --nogit-fallback --norolestats --nol
perl scripts/get_maintainer.pl --separator , --nokeywords --nogit --nogit-fallback --norolestats --nol -f source-files
```

### git send-email
way 1: git send-email --annotate HEAD^,这一个方式不可控。
way 2: git send-email your-patch.使用这个方法，你上面产生patch的格式稍微复杂些：使用下面的命令：

```bash
git format-patch -o ~/patch/ --cc=mail-list1  --to=maintainer@xx.com HEAD^
```
上面的地址在上面的命令中挑出即可。为什么我们在这里这么费劲地产生一个patch,这种方式貌似有些复杂，其实用起来就很简单的。
# 2
git send-email是为了提交patch而产生的，所以，你使用它提交patch会非常容易，那么，如果你想提交普通文件的话，需要使用下面的命令：
## 单个文件
对，接着使用你上面产生的patch，因为它已经包含相应的信息了，所以仅仅使用：

```bash
git send-email   --to=tsu.yubo@gmail.com your-patch
```
一直按"y"即可，这样单个patch就发出去了。(上面的--to你可以用，也可以不用)

# 3.产生多个文件
[here](https://burzalodowa.wordpress.com/2013/10/05/how-to-send-patches-with-git-send-email/)我是参考的这篇文章。
例如，你要产生patch的commit如下：
```bash
db868ad xhci: remove conversion from generic to pci device in xhci_mem.c
c010f0c xhci: remove unnecessary check in xhci_free_stream_info()
a166493 xhci: fix SCT_FOR_CTX(p) macro
56e4cd3 xhci: replace USB_MAXINTERFACES with config->desc.bNumInterface
```
接下来就是两种方法：
way 1: git format-patch -o ~/patches/ -3 HEAD
这样你就会得到从`c010f0c`,`a166493`,`56e4cd3`的patch.
还有一种方式就是 在commit-id 处使用 `56e4cd3^..c010f0c`,这样也能满足上面的方案。
way 2: git format-patch -o ~/patches/ -3 c010f0c(这一个是重点，我觉得可以用+号往上产生，比如，产生头两个)
这里很有意思的一件事就是：
```bash
git format-patch -o ~/patch/  -3
```
就会产生前三个commit的patch.同时，如果你查看0001-xx.patch，你就会看到[PATCH 1/n],这个n就是你上面的"-n".
你以为这样就结束了，"--to"什么的忘了吗？
## 带封皮的cover-letter的patchset
使用下面的命令：

```bash
git format-patch -o /tmp/ --cover-letter -n --thread=shallow --cc="linux-usb@vger.kernel.org" -3
```

