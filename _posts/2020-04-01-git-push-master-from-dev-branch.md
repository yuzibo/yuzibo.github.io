---
title: 从开发分支向远程主分支提交
category: git
layout: post
---
* content
{:toc}

[首先参见这个SO](https://stackoverflow.com/questions/5423517/how-do-i-push-a-local-git-branch-to-master-branch-in-the-remote)

首先提前反思下，这个操作很有必要吗？正常来说，我们都应该是在开发分支上开发，
然后验证 最后合入到 master，最后再git push.

我用到这个场景的原因是：我的博客在好几个平台上都有，自己的云主机、公司的工作站或者
还有自己的笔记本上偶尔也有git push。这东西一多的问题就是：master分支经常忘记git pull.
这样导致如果直接在master分支上开发，下载下来的代码经常冲突。

1. 新建开发分支

```bash
git checkout -b dev_br
```

2. git push

```bash
git push origin dev_br:master
```
