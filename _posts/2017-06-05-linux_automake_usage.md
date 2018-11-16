---
title: "linux的automake使用方法-未完"
category: make
layout: post
---

* content
{:toc}

[这篇](http://www.aftermath.cn/Makefile.html)简单的介绍下了Makefile文件，但是如果你自己独自写一个完整的Makefile，这多少有些不现实。在类unix下，有个automake的工具，这个就可以好好利用.

# 环境要求

### autoconf
在我的linux上，使用*autoconf  --version*就可以知道有没有安装这个软件了。

### automake
利用同样的测试方法。


# 大体思路

先后建立三个文件：hello.c -> configure.in -> Makefile.am 然后依次执行

```bash
aclocal && autoconf && automake --add-missing  \
&& ./configure && make && ./hello

```

如果是安装软件的话，在上面的make后面添加 *make imstall *即可。

# 详细步骤


1. 新建立一个hello.c的文就:


```c
#include <stdio.h>
int main(int argc, char *argv[])
{
	printf("hello,world\n");
	return 0;

}


```

2. 生成configure
使用autoscan生成configure.in的模板文件configure.scan

```bash
root@yubo-2:/home/yubo/test/makefile# autoscan
root@yubo-2:/home/yubo/test/makefile# ls
autoscan.log  configure.scan  hello.c

```
看到上面的命令中生成了一个configure.scan文件，这个就是configure.in的模板(但是，我怎么记得现在推荐为configure.ac)


首先将configure.scan文件命名为configure.in(现在好像推荐使用configure.ac)

然后修改几个内容：

```bash
mv configure.scan configure.in
root@yubo-2:/home/yubo/test/makefile# cat configure.in
#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.69])
AC_INIT(hello.c) # 修改
#AC_CONFIG_SRCDIR([hello.c]) #修改
AC_CONFIG_HEADERS([config.h])
AM_INIT_AUTOMAKE(hello.c, 1.0) # 修改

# Checks for programs.
AC_PROG_CC

# Checks for libraries.

# Checks for header files.

# Checks for typedefs, structures, and compiler characteristics.

# Checks for library functions.

AC_OUTPUT(Makefile) #修改
```

上面的文件中，以AC开头的宏来自autoconf, 以AM开头的automake,这些宏都是用M4语言写成的。

autoconf是用来生成自动配置软件源代码脚本(configure)的工具，它是非常独立地，不需要用户的干预。

autoconf命令来处理configure.ac/configure.in文件，生成一个configure文件，生成的configure文件是一个可以移植的shell脚本，来决定哪些库是可以用的、所用的平台有哪些特征、哪些头文件和库已经找到等等，然后将收集到的这些信息，编译成标记，生成一个Makefile,同时生成一个包含已定义的预处理符号的config.h。

要生成*configure*文件， 你必须告诉autoconf如何找到你所用的宏，方式是使用aclocal程序来生成你的aclocal.m4

aclocal文件根据configure.in文件的内容，自动生成aclocal.m4文件，　aclocal根据configure.in文件的内容，自动生成aclocal.m4文件。aclocal是一个perl 脚本程序，它的定义是：“aclocal - create aclocal.m4 by scanning configure.ac”。

```bash
root@yubo-2:/home/yubo/test/makefile# aclocal
aclocal: warning: autoconf input should be named 'configure.ac', not 'configure.in'
root@yubo-2:/home/yubo/test/makefile# ls
aclocal.m4  autom4te.cache  autoscan.log  configure.in	hello.c
root@yubo-2:/home/yubo/test/makefile# autoconf
root@yubo-2:/home/yubo/test/makefile# ls
aclocal.m4  autom4te.cache  autoscan.log  configure  configure.in  hello.c
```

m4是一个宏处理器。将输入拷贝到输出，同时将宏展开。宏可以是内嵌的，也可以是用户定义的。除了可以展开宏，m4还有一些内建的函数，用来引用文件，执行命令，整数运算，文本操作，循环等。m4既可以作为编译器的前端，也可以单独作为一个宏处理器。

接下来就是新建Makefile.am文件了。automake会根据你写的Makefile.am自动生成Makefile.in文件的。

```bash
root@yubo-2:/home/yubo/test/makefile# cat Makefile.am
AUTOMAKE_OPTIONS=foreign
bin_PROGRAMS=hello
hello_SOURCES=hello.c

```

### automake

这个命令的主要功能就是从Makefile.am文件产生Makefile.in文件，

一个典型的automake输入文件只是一系列变量的定义，从而产生Makefile.in文件。

接下来运行命令：

```bash
automake --add-missing
```

下面是我的显示台上的输出：

```bash
root@yubo-2:/home/yubo/test/makefile# automake -add-missing
automake: error: unrecognized option '-dd-missing'.
automake: Try '/usr/bin/automake --help' for more information.
root@yubo-2:/home/yubo/test/makefile# automake --add-missing
automake: warning: autoconf input should be named 'configure.ac', not 'configure.in'
configure.in:7: warning: AM_INIT_AUTOMAKE: two- and three-arguments forms are deprecated.  For more info, see:
configure.in:7:
http://www.gnu.org/software/automake/manual/automake.html#Modernize-AM_005fINIT_005fAUTOMAKE-invocation
configure.in:10: installing './compile'
configure.in:7: installing './install-sh'
configure.in:7: installing './missing'
configure.in:6: error: required file 'config.h.in' not found
Makefile.am: installing './depcomp'
automake: warning: autoconf input should be named 'configure.ac', not 'configure.in'
```


再次声明，我在这篇教程里，不止一次提醒我有警告产生，而且意思非常明确，你可以试一试。我这里为了结果一致，暂时没有改正过来，需要大家的注意。







[M4](https://www.gnu.org/software/m4/m4.html)



