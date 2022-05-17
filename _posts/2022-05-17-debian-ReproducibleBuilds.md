---
title: Debian reproducible-build简介
category: debian-riscv
layout: post
---
* content
{:toc}

目前，debian有这么几个和build系统相关的东西：

* Debian-buildd 必须是DD才可以，目前riscv已经有了，但是需要资源。这个是Debian官方承认的，覆盖面最全的；
* Debian reproducible 也是这篇文章的主角，重点介绍的的；
* Debian jenkins 这个暂时没有详细了解，但是应该去看看；
* Debian-ci 这个是跑ci的，重点检测的是包的质量。

# Debian reproducible
总部[wiki](https://wiki.debian.org/ReproducibleBuilds).

[about](https://wiki.debian.org/ReproducibleBuilds/About)这里云云了一大堆，看官可以自己去瞧一瞧，在此不必赘述（但是从项目背景的角度看，这个页面真的应该好好读一读，这样的话，你会更加明白rb的意义）。其实，这个项目的本身感觉是从安全的角度出发的。



## debian reproducible-builds
如果需要关注Debian的话，需要对这个页面进行特别的关注:
[https://reproducible-builds.org/contribute/debian/](https://reproducible-builds.org/contribute/debian/)

