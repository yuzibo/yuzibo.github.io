---
title: Autotools使用
category: build
layout: post
---
* content
{:toc}

Autotools是一个linux下使用广泛的build系统，尤其是在debian的packaging过程中需要大量遇到。所以，这篇文章根据[https://earthly.dev/blog/autoconf/](https://earthly.dev/blog/autoconf/)进行整理翻译，进行一些自己的积累。

Autotools主要由以下三大组件构成： `autoconf`, `automake`,`aclocal`. 

## Autoconf
Autoconf是`m4sh`写的，后者使用`m4`宏。`m4sh`提供了一些宏可以用来生成`configure.ac`文件，然后接着可以自动产生`configure`文件。

