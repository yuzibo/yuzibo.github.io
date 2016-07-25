---
title: "AIX命令使用"
layout: article
category: shell
---

# 主要命令的补全

补全命令：

大多数unix默认的shell是 ksh， ksh要用连续两次 ESC 来补全命令，HPUX默认的Shell是Posix shell

上条命令、下条命令：
同   vi   操作一模一样，先按   ESC键   进入命令模式 

k     上一条 
j     下一条 
h     左移 
l     右移 
x     删除 

开启AIX KSH 自动补全功能
AIX系统下默认的Shell是ksh，不同于Linux下的bash，ksh不直接支持dos-key的便捷操作，如果没有找到途径，每条命令都要重新敲入，实在是很麻烦。Ksh还不支持文件名自动补全，这也是另外一个遗憾。
实现方法:
#set -o vi
上滚一条命令是ESC+k
下滚一条命令是ESC+j
ESC +    ESC -
 
自动补全是ESC+\
 
例如,想要自动补全,就先按ESC,再按\ 
[参考](http://ericbao.blog.sohu.com/198437033.html)
