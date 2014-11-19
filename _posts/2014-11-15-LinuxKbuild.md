---
layout: article
title: "kbuild学习心得"
category: Linux
---
#起因
最近想写linux设备驱动，发现不同参考书上的Makefile文件风格不一致，不一致是小事，我自己对这方面知识的欠缺总感觉穿着很重的鞋子走路。当然，网上的资料也是良莠不齐，自己看内核代码Document/kbuild中的文件算是做一下读书笔记，有错误的话还请谅解。
##简介
“kbuild” is build system used by the linux kernel.Modules must use kbuild to stay compatible with GCC. Modules programming is consist of in-tree and out-of-tree
##系统命令
	$make -C <path_to_kerenl_src> M=$PWD
	$make -C /lib/modules/'uname -r'/build M=$PWD (__这里的‘uname -r’的单引号是shell中执行命令的‘’也就是左上角的__)

__target__:
__modules_install__
	$make -C /lib/modules/'uname -r'/build modules_install
##选项
	tips: $KDIR is short of path of the kernel source directory

__-C $KDIR__
	make命令会自动改变到这个特殊的kernel source目录

__M=$PWD__
	通知kbuild一个外部模块已经被建立,"M"是这个外部模块（kbuild file）所在的绝对路径
##target
	make -C $KDIR M=$PWD [target]
	
	模块默认在这个文件夹生成（哪个？），所有的文件都会在这个文件夹中
	
###modules: 
	同上
###modules_install:
	同上
###clean:
	仅仅删除在模块目录中生成的所有文件
###help:
	从来没用过
##建立分离文件
	最简单的例子：

__obj-m := <module_name>.o__

这kbuild系统将会根据<module_name>.c文件建立<module_name>.o，经过链接后，将后生成<module_name>.ko
	
如果模块是由多个文件构建而来，则是一下格式
	
__<module_name>-y := <src1>.o <src2>.o



##例子
{% highlight bash %}


	ifneq ($(KERNELRELEASE),)
	#kbuid part of Makefile
		obj-m := 8123.o
		8123-y := 8123_if.o 8123_pci.o 8123_bin.o
	else
	#normal makefile
		KDIR ?=/lib/modules/`uname -r`/build
	default:
		$(MAKE) -C $(KDIR) M=$$PWD
	genbin:
		echo "x" > 8123_bin.o_shipped
	endif


{% endhighlight	%}
##Makefile样本
经过本人亲自测试，下面的Makefile文件真实有效，其来源与LDD（Linux Decives Drives）
{% highlight bash %}
	ifneq ($(KERNELRELEASE),)
		obj-m := __task_pid_nr_ns.o
	else
		PWD := $(shell pwd)
		KVER := $(shell uname -r)
		KDIR := /lib/modules/$(KVER)/build 
	default:
		$(MAKE) -C $(KDIR) M=$(PWD)	modules
	endif
{% endhighlight %}

我们的源文件取名为__task_pid_nr_ns.c，一会我会把代码写上来，看来linux编程真的是博大精深啊。

