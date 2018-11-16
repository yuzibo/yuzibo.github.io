---
title: "利用udev安装内核modules"
layout: post
category: kernel
---

* content
{:toc}

[上文](http://www.aftermath.cn/udev_rules.html)介绍了udev的编写，这篇文章就结合一个usb键盘，亲自测试udev的应用。

# 实验

编写一个内核模块，当任何一个usb键盘插入时自动加载相应的模块并打印出相关的日志。

这个实验的目的，就是让你熟悉udev对硬件的控制，我们知道，安装内核的模块后，才能利用硬件。传统的insmod module-name已经熟悉，现在就是udev的表现时刻了（用户空间工具，取决于你的发行版）

### 准备模块
先写一个模块，关于usb键盘的。

```c
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/usb.h>
#include <linux/usb/input.h>
#include <linux/hid.h>

MODULE_AUTHOR("Bo YU<tsu.yubo@gmail.com>");

MODULE_DESCRIPTION("probe usb keyboard\n");

MODULE_LICENSE("GPL");

static struct usb_device_id hello_id_table [] = {
	{
		USB_INTERFACE_INFO(USB_INTERFACE_CLASS_HID,
		USB_INTERFACE_SUBCLASS_BOOT,
		USB_INTERFACE_PROTOCOL_KEYBOARD)
	},
		{ }, /* Here are entry */
};

/* 向内核注册 */
MODULE_DEVICE_TABLE(usb, hello_id_table);

static int hello_probe(struct usb_interface *interface,
		const struct usb_device_id *id)
{
	pr_info("Hello, Module, Task 05: USB keyboard function called\n");
	return 0;
}

static void hello_disconnect(struct usb_interface *interface)
{
	pr_info("Hello, Module, Task 05: USB keyboard disconnect function is called\n");

}

static struct usb_driver hello_driver = {
	.name  = "hello_driver",
	.probe = hello_probe,
	.disconnect = hello_disconnect,
	.id_table  = hello_id_table,
};

static int __init hello_init(void)
{
	int retval = 0;
	pr_info("Hello, module Task 05, hello, world!\n");
	retval = usb_register(&hello_driver);

	if (retval)
		pr_info("Hello, module task 05 .Register failed, Error number %d", retval);

	return 0;

}
static void __exit hello_exit(void)
{
	usb_deregister(&hello_driver);
	pr_info("Hello, Module task 05: Exit\n");
}

module_init(hello_init);

module_exit(hello_exit);

```

相应的[Makefile](http://www.aftermath.cn/LinuxModuleProgram1.html)，在链接的这篇文章，用Ctrl+f搜寻一下201702即可。

为了使用udev，前提你的模块写的得正确，可以make && insmod x.ko我这里是没有问题的。

接下来，就是编写udev了。

### 编写udev

首先使用命令：

	sudo udevadm info --name=/dev/input/by-id/usb-Chicony_HP_Elite_USB_Keyboard-event-kbd --attribute-walk

这是我的usb键盘的名字，费了很大的劲才找到，by-id目录后才是键盘名字，--attribute--walk是参数。如果你也找不到你要插入的设备，就先dmesg一下，然后插入你的硬件，再dmesg一下，你就会发现你的硬件信息。

这是我的信息：

![udev-3.png](http://yuzibo.qiniudn.com/udev-3.png)

这个系统信息很全，将这个设备的所有相关的硬件表示出来了。KERNEL、SUBSYSTEM等需要的字眼已经全出来了。接下来就是编写udev的规则了。

你可以将规则文件放在/lib/udev/rules.d/目录下也可以放在/etc/udev/rules.d/目录下，为了方便自己的管理，放在/etc目录下比较方便。

怎么写呢，这样的：

```bash
SUBSYSTEM=="input", SYMLINK+="task05", RUN+="/usr/bin/install.sh"
```

规则文件的命名也是有规律的：[摘自](http://hackaday.com/2009/09/18/how-to-write-udev-rules/)

	iles should be named xx-descriptive-name.rules, the xx should be
chosen first according to the following sequence points:

	< 60  most user rules; if you want to prevent an assignment being
overriden by default rules, use the := operator.

	these cannot access persistent information such as that from
vol_id

	< 70  rules that run helpers such as vol_id to populate the udev db

	< 90  rules that run other programs (often using information in the
udev db)

	>=90  rules that should run last

现在的问题就是我的脚本运行问题，我测试了好几次，好像udev的执行脚本必须放在/bin的目录下，其他的则不行。

/usr/bin/install.sh 的文件内容如下：

```bash
#!/usr/bin/sh

insmod /home/yubo/little/test/task05.ko
```

那么，在确认没有安装这个模块的前提下，依次这么做：

插入键盘，dmesg如下：

![udev-4.png](http://yuzibo.qiniudn.com/udev-4.png)

然后，拔掉键盘，

![udev-5.png](http://yuzibo.qiniudn.com/udev-5.png)

然后确保/test下的目录已经make生成可task05.ko这个文件，接着执行

	sudo /etc/init.d/udev restart

那么，插入文件后，dmesg后显示：

![udev-6.png](http://yuzibo.qiniudn.com/udev-6.png)

也就是说，将task05这个模块插入了内核，但是，有不完善的地方，如果重复安装，则不行的。

