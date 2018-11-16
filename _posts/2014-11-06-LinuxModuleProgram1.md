---
layout: post
title: "模块编程(1)Hello,World"
category: kernel
---

* content
{:toc}

# 前戏
看了这么多关于内核的东西，这两天终于上手实现了基于内核的编程——模块编程。
这里，简单的记录一下，因为还是有些东西需要牢记的。
先说点题外话，看到资料上说模块机制、设备机制、驱动机制是在linux上很重要的三种机制之一，所以，看起来，这真是万里长征的第一步。

## 先建立一个源文件，module.c

{% highlight c %}
#include<linux/init.h>
#include<linux/module.h>
#include<linux/kernel.h>
//上面的三个头文件必须有
MODULE_LICENSE("GPL");//模块许可声明
/*下面的__init 是一个宏，在include/linux/init.h里面*/
static int __init hello_init(void)
{
	printk("Hello,world\n");
	return 0;
}
static void __exit hello_exit(void)
{
	printk("GoodBye\n");
}
/*初始化*/
module_init(hello_init);
/*退出时使用*/
module_exit(hello_exit);
{% endhighlight %}

简单解释一下，一个模块源程序的

	1.头文件(必有)
	2.模块参数(可选)
	3.模块功能函数(optional)
	4.模块加载函数(必有)
	5.模块卸载函数(必有)
	6.模块许可声明(必有)。


## 在相同目录下创建一个 Makefile文件

{% highlight bash %}
ifeq ($(KERNELRELEASE),)
	VERSION_NUM :=$(shell uname -r)
    CURRENT_PATH :=$(shell pwd)
	KERNEL_DIR :=/usr/src/linux-headers-$(VERSION_NUM)

modules:
	$(MAKE) -C $(KERNEL_DIR) M=$(PWD) modules
modules_installs:
	$(MAKE) -C $(KERNEL_DIR) M=$(PWD) modules_installs
clean:
	rm -rf *.o *~ core .depend .*.cmd *.ko *.mod.c .tmp_versions *.order *.symvers
else
	obj-m := module.o
endif
{% endhighlight %}

关于Makefile文件的知识不是这篇文章的内容，但我们会努力讲解的简单明了一些。其中使用了shell中的选择判断语句，先取得当前系统的版本号，模块源文件所在的目录、内核文件的目录、然后就是目标依赖关系，当然这部分我自己也是不很明白，还需要彻底了解一下相关知识。看上去先产生模块，然后安装modules,这些都是make命令执行后运行的东西。如果我们执行 make clean 紧接着就是清除所在目录产生的中间文件文件，当然，你可以添加自己的规则。

### 2017-02-08 add

上面的 Makefile是针对于你的发行版的，找到你的镜像(kernel)头文件包，下面是 linux kernel tree编译内核模块的方法

```c
obj-m += module.o

all:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules

clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
```

使用这个  Makefile 就可以在自己编译的内核中编译自己的模块，记住一点，你正在运行的内核与 linux kernel tree必须一致，不然会有错误报出。


好，我们将所有的准备工作做好后，执行一下,(sudo 模式)

__make__

我们会看到如下信息：

![图片](http://yuzibo.qiniudn.com/2014-11-06-makeafter.png)

紧接着执行

__insmod module.ko__

,我们打开另一个终端，执行命令

__tail -f /var/log/message__

我们回到原来的窗口再执行

__rmmod module.ko__

这两条命令执行后在另一个窗口我们会看到如下信息：

![图片](http://yuzibo.qiniudn.com/2014-11-06-modulesofresult.png)

回到原来的窗口，我们执行 __make clean__,就只剩下了原来的文件。

# 模块的操作

Linux为用户提供了modutils工具，用来操作模块，包括以下命令

## insmod

这个命令是加载模块，使用 <strong>insmod module.ko</strong>可以加载module.ko模块，执行该命令后如果终端没有消息，则可以使用命令 demsg | tail 命令查看文件的最后几行.

## rmmod

rmmod module.ko就是将module.ko模块卸载。

## modprobe

比较高级的加载和卸载模块的命令，可以解决模块之间的依赖性。

## modinfo
用于查询模块的相关信息，如作者、版权等。

# 模块加载后文件系统的变化

## 在/proc/modules中会增加相关的模块信息,如下，

![图片](http://yuzibo.qiniudn.com/2014-11-06-proc-module.png)

## /proc/devices没有变化
## 在/sys/modules会增加一个module目录，我们用 __tree -a module__,会发现如下信息：

![图片](http://yuzibo.qiniudn.com/2014-11-06-treeforsysmodule.png)
