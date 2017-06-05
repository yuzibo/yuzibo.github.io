---
title: "linux/unix 安装软件过程"
category: unix
layout: article
---

做一次文章的搬运工吧！

[Here](https://stackoverflow.com/questions/3782994/any-difference-between-configure-ac-and-configure-in-and-makefile-am-and-makefi)

**configure.ac**和**configure.in**是Autoconf工具(由autoconf命令产生configure
脚本)的两个主要的源文件。区别在于configure.in是一个比较旧的文件名，目前仍可
以使用。configure.ac是适用于新的软件包。**.in**的后缀文件名现在被推荐仅仅用于运行**configure**脚本后产生config.status.

**Makefile.am**是Automake的源文件，Automake处理它产生**Makefile.in**,这个文件后来被**config.status**处理，这样才会产生最终的Makefile.

[划重点](https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/autoconf-2.69/html_node/Making-configure-Scripts.html)

# configure脚本文件

当运行完毕**./configure**命令后，会产生以下文件

