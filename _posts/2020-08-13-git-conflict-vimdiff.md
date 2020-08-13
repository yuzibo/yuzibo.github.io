---
title: git 使用 vimdiff解决冲突
category: tools
layout: post
---
* content
{:toc}

# 冲突的基本概念
随着对git的使用逐渐加重，我发现了一些更有意思的问题，冲突变得更加频繁了，嗯，可以
很好的解决这个问题。

无论什么样的冲突，请记住一个模型，LOACL BASE REMOTE这三个分支，冲突基本就是围绕这三
个分支进行。

# vimdiff使用
可以看这个[教程](https://www.rosipov.com/blog/use-vimdiff-as-git-mergetool/)

# 手工解决
上面的操作是在 MERGED 文件中使用命令全部保留:

```c
:diffget RE // 或者
:diffg RE  " get from REMOTE
:diffg BA  " get from BASE
:diffg LO  " get from LOCAL
```

关闭所有vim窗口使用`:wqa`.




