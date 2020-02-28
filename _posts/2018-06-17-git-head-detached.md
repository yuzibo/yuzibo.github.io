---
title: git HEAD detached from XXX 解决方法
category: git
layout: post
---
* content
{:toc}

# 中文
[csdn](https://blog.csdn.net/u011240877/article/details/76273335)
这篇博客还是非常牛b的，有时间把上述场景复现一遍，我说一下我的解决方案。

首先找到你要 checkout的那个分支，如果是远程的话，自己先新建一个分支:
```git
git checkout -b new_branch(or test, so this is the same name) <name of remote>/test
```

这个时候HEAD就在新的分支上去了。

## TODO
