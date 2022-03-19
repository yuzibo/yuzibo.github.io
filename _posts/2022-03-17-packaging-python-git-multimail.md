---
title: packaging python package - git-multimail 
category: debian-riscv
layout: post
---
* content
{:toc}

在邮箱里突然发现一个[RFP 1007025](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1007025):

发现这又是一个python包，果断直接找 Debian python packaging [wiki](https://wiki.debian.org/Python/LibraryStyleGuide)：

[python packaging git](https://wiki.debian.org/Python/GitPackaging)

[join debian python team](https://salsa.debian.org/python-team/tools/python-modules/blob/master/policy.rst#joining-the-team)

为了Debian中的python包容易维护(不只是python，还有其他)，Debian创建了多个语言或者框架相关的team，尽管每个包都是自己owner,但是统一都放到 https://salsa.debian.org/python-team/packages/ 下面，这样做的好处:

1.  假设后面maintainer缺席了，可以及时由team维护
2.  只要消除了1， 其他的事情都不叫事。

## 创建 repo 

Set up a new repository visit https://salsa.debian.org/python-team/packages/ and follow the 'new project' link (the link will not be accessible unless you have joined the team). Enter the source package name as the project name and leave the visibility set to public.

但是需要python team给你加权限才可以幺。



