---
title: git bisect 使用 
category: git
layout: post
---
* content
{:toc}

# 背景

目前有一个bug，在5.15 kernel上没有问题，在6.1 上出现问题，正向排解不容易，
所以bisect试一试吧。

# 过程

首先通过git tag确定想要的version.

```bash
v5.16
v5.17
v5.18
v5.19
v6.0
v6.1
```


# 参考

https://www.ruanyifeng.com/blog/2018/12/git-bisect.html

