---
title: "linux下的misc编程"
category: kernel
layout: post
---

# 补充材料

[here](http://stackoverflow.com/questions/18456155/what-is-the-difference-between-misc-drivers-and-char-drivers)

这篇文章解析了misc和[char](http://www.aftermath.cn/dev_char_kernel.html)的不同，但是思路都是一样的，主要可能是在归类的时候会有一些不同的。

先说一下，misc的主设备号已经被内核给固定死了，为10,只能修改次设备号(minor).

通常情况下，一个字符设备都不得不在初始化的过程中进行下面的步骤：

通过alloc_chrdev_region()分配主次设备号。

使用cdev_init()和cdev_add()来以一个字符设备注册自己。



而一个misc驱动，则可以只用一个调用misc_register()

来完成这所有的步骤。(所以miscdevice是一种特殊的chrdev字符设备驱动)

所有的miscdevice设备形成一个链表，对设备访问时，内核根据次设备号查找

对应的miscdevice设备，然后调用其file_operations中注册的文件操作方法进行操作。

下面将结合具体的代码进行分析。

```c
#include <linux/module.h>
#include <linux/slab.h>
#include <linux/types.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/miscdevice.h>
#include <linux/major.h>
#include <linux/fs.h>
#include <linux/device.h>
#include <linux/cdev.h>
#include <linux/uaccess.h>



MODULE_AUTHOR("Bo YU<tsu.yubo@gmail.com>");

MODULE_DESCRIPTION("task 06\n");

MODULE_LICENSE("GPL");

#define BUF_LEN 60
#define MY_ID_LEN 12 /* include final NULL, so it is 13 */

static char *my_id = "yubo";
static char read_id[BUF_LEN] = {0};


static ssize_t dev_read(struct file *file, char __user *userbuf,
			size_t len, loff_t *f_pos)
{

	return simple_read_from_buffer(userbuf, len,
				f_pos, my_id, strlen(my_id));
}


static ssize_t dev_write(struct file *file, const char __user *userbuf,
			size_t len, loff_t *pos)
{
	ssize_t ret;

	ret = simple_write_to_buffer(read_id, BUF_LEN, pos, userbuf, len);

	if (ret < 0)
		return ret;

	else if ((ret != MY_ID_LEN) || strncmp(my_id, read_id, len - 1))
		return -EINVAL;

	else
		return len;
}


static const struct file_operations dev_fops = {
	.write = dev_write,
	.read = dev_read,
};



struct miscdevice misc_device = {
	.minor = MISC_DYNAMIC_MINOR,
	.name = "eudyptula",
	.fops = &dev_fops,
};


static int __init hello_init(void)
{
	int ret;

	ret = misc_register(&misc_device);

	if (ret) {
		pr_err("can't register misc device\n'");
		return ret;
	}

	return 0;
}
static void __exit hello_exit(void)
{
	misc_deregister(&misc_device);
}

module_init(hello_init);

module_exit(hello_exit);
```

上面的代码中最麻烦的部分不过是simple_write_to_buffer,这个函数将copy_from_usr函数进行了安全封装，其实一开始很简单的，我的问题在于用户空间的程序write和read在一个程序里进行，这样可能会导致一些问题，我将这两个操作分开以后问题就好多了。

注意是如何检查错误的。

下面是用户空间的程序：

> read

```c
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <fcntl.h>
#include <string.h>

#define BUF_LEN 256

static char re_string[256];
static char string_to_send[256];

int main()
{
	int ret, fd;

	printf("starting test task 06...\n");
	fd = open("/dev/eudyptula", O_RDWR);
	if (fd < 0) {
		perror("Failed to open the device\n");
		return errno;
	}

	printf("Reading from the device...\n");
	ret = read(fd, re_string, BUF_LEN);
	if (ret < 0) {
		perror("Failed to read the device... \n");
		return errno;
	}
	printf("The received message is: [%s]\n", re_string);

	close(fd);


}
```

> write

```c
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <fcntl.h>
#include <string.h>

#define BUF_LEN 256

static char string_to_send[256] = {0};

int main()
{
	int ret, fd;

	printf("starting test task 06...\n");
	fd = open("/dev/eudyptula", O_RDWR);
	if (fd < 0) {
		perror("Failed to open the device\n");
		return errno;
	}


	printf("Type in your id into kernel\n");

	scanf("%[^\n]%*c", string_to_send);
	/*	^表示”非”，即读入其后面的字符就结束读入。
	 *	这样想读入一行字符串带空格的字符直接用:
	 *	scanf("%[^\n]%*c",str);
         */

	printf("Writing the message to the device is [%s], the len of write is %d\n",string_to_send, strlen(string_to_send));

	ret = write(fd, string_to_send, strlen(string_to_send));

	if(ret != strlen(string_to_send)){

		printf("write into kernel %d bytes \n", ret);
		return errno;
	}

	else
		printf("success for matching of write! the ret is %d\n", ret);
	close(fd);


}

```

为了保密需要，我将自己的id进行了替换。
