---
layout: article
title: "模块编程(1)Hello,World"
category: Programming
---
#前戏
看了这么多关于内核的东西，这两天终于上手实现了基于内核的编程——模块编程。
这里，简单的记录一下，因为还是有些东西需要牢记的。
先说点题外话，看到资料上说模块机制、设备机制、驱动机制是在linux上很重要的三种机制，所以，看起来，这真是万里长征的第一步。

##先建立一个源文件，module.c

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

##在相同目录下创建一个 Makefile文件

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

关于Makefile文件的内容不是这篇文章的内容，但我们会努力讲解的简单明了一些。其中使用了shell中的选择判断语句，先取的当前系统的版本号，模块源文件所在的目录，内核文件的目录，然后就是目标依赖关系，当然这部分我自己也是不很明白，还需要彻底了解一下相关知识。看上去先产生模块，然后安装modules,这些都是make命令执行后运行的东西。如果我们执行 make clean 紧接着就是清除所在目录产生的中间文件文件，当然，你可以添加自己的规则。

好，我们将所有的准备工作做好后，执行一下,(sudo 模式)

__make__
我们会看到如下信息：
[!图片](http://yuzibo.qiniudn.com/2014-11-06-makeafter.png)
紧接着执行 __insmod module.ko__,我们打开另一个终端，执行命令__tail -f /var/log/message__,我们回到原来的窗口再执行__rmmod module.ko__,这两条命令执行后在另一个窗口我们会看到如下信息：
[!图片](http://yuzibo.qiniudn.com/2014-11-06-modulesofresult.png)
回到原来的窗口，我们执行 __make clean__,就只剩下了原来的文件。



