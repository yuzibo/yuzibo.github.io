---
layout: article
title: "LDD读书笔记"
category: book
---

1.insmod 是系统调用 kernel/module.c，The function sys_init_module allocates kernel memory(how)=>（ The memory is allocated with vmalloc function）,系统调用函数把模块复制到内存区，通过内核符号表解决内核引用的问题，并且呼叫模块初始化函数使一切准备就绪。

2.在内核源代码中，使用前缀sys_ 就是系统调用。

3.modprobe 命令比insmod命令高级一点，它会自动解决模块引用不成功的问题。

4.如果模块正在被使用，清楚模块的任务将会失败，或者这个模块已经被定义为不可清除

5.lsmod 将会列出目前正在内核被加载的模块还有例如其他模块正在使用一个特殊的模块，他是通过读 /proc/modules虚拟文件实现的。当前加载的模块也可以在虚拟系统文件 /sys/module读取。

6.在装载模块时，在链接的过程中会寻找一个目标文件 vermagic.o（不过，在debian中我没有找到这个文件）和当前的系统配置相对照，还有 vmlinux是做什么用的？

7. 系统文件日志
/var/log/messages,
终于印证了我的设想，如果我想编译一个模块但不是现在源码树的内核，应该重新指定KERNELDIR，测试一下。

8.当你写的驱动需要在不同版本的linux上运行时，你这时就需要充分利用macros和#ifdef结构体了，类似大量的定义在这个文件linux/veersion.h中，这个头文件自动包括linux/module.h

UTS_RELEASE
这个宏定义了一个描述这个代码树的版本的字符串，例如"2.6.10"

LINUX_VERSION_CODE
定义了一个代表内核版本的二进制文件，一个字节代表版本的一部分，如，2.6.10是132618(0x020610)

KERNEL_VERSION(major,minor,release)
KERNEL_VERSION(2.6.10)==>132618,
	
not clutter driver (填充)
9.解决 platform dependency
The best way is to release your driver under a GPL-compatible license and contribute it to the mainline kernel,distributing your driver in source form and a set of scripts to compile it on the user's platform
##2014-11-23
msdos relies on symbols exported by the fat module, and each input USB device stacks on the usbcore and input modules.
有意识的去使用modprobe，这一句命令就可以代替很多insmod命令，
如果你写的模块希望被其他模块所使用，最好加入以下两句话
EXPORT_SYMBOL(name);
EXPORT_SYMBOL_GPL(name);
具体的请参看<linux/module.h>吧，在模块中有一个“ELF”部分，在那里导入了有关符号表的东西。
MODULE_AUTHOR();
MODULE_VERSION();
MODULE_ALIAS();
MODULE_DEVICE_TABLE();
10. 初始化
static int __int initialization_function(void)
{
	/*code*/
}
module_init(initialization_function);
这初始化函数应该被定义为static,__init提示内核当模块被加载后可以释放掉空间...这还有相似的标签(__initdata) for data used only during initialization,只是必须牢记，这些函数只是能在初始化的时候使用，其他时候不再使用，我们在没有配置热插拔选项的内核中可能会遇到与上面类似的tags：devinit and devinitdata

module__init 是强制性， 这个宏增加了一个的段对于模块的目标代码在初始化函数，没有这个定义，初始化函数是从来不会调用的。

模块可以注册不同的设备，对于不同的设备，这有一个特别的函数完成注册，传递给内核注册函数的参数一般是指向新设备的数据结构和这个注册设备的名字，这个数据结构经常包含指向模块函数的指针，这也是在模块体内部的函数得到调用的方法。

以下这些东西：串口，miscellaneous(杂项)设备，系统文件，/proc 文件，可执行的域名，line discipline（线性规划），这些文件不是直接与硬件打交道，但保持这软件抽象域，这些东西是可以被注册的。

这还有其他设备的插件也可以被注册，绝大多数用register_前缀。

11.清除函数
a function marked __exit can be called only at module unload ro system shutdown time.any other use is an error.
and it (__exit)is vital for cleanup function.

In the linux kernel, err codes are negative numbers defined in the <linux/errno.h>
p52--p53的代码没有看明白。

###12. 模块装载竞争
1.你必须准备好只要你的代码完成它的第一步注册就有可能被调用，把你模块需要的设备准备好以后再去注册你的初始化函数。

2.避免把初始化函数失败。

###13.模块参数
IDE can allow user control of DMA operations.
hardware need to know I/O ports and I/O memory address.
参数值可以被赋值在使用命令 insmod 或者 modprobe的时候，使用module_param macro,which is defined in <moduleparam.h>中
它带来三个参数：变量，类型，特权，例如下面的
<pre>
static char *whom = "world";
static int howmany = 1;
module_param(howmany, int, S_IRUGO);
module_param(whom, charp, S_IRUGO);
</pre>
使用命令
insmod hellop howmany=10 who="Mom";(有问题)

数组参数使用module_param_array(name,type,num,perm);
the perm was defined in <linux/stat.h>,
##11-27
第一个字符设备驱动

在dev_t中，12位的主设备号，20位的次设备号，你的代码应该充分利用在 <linux/kdev_t>的宏，为了去获得主设备号和次设备号dev_t，使用如下命令：
<pre>
MAJOR(dev_t dev);
MINOR(dev_t dev);
</pre>
then,use __MKDEV(int major, int minor)__;
##字符设备
为一个字符串设备获得设备号的函数是
<pre>
register_chrdev_region(dev_t first,unsigned int count,
			char *name)
</pre>
first 是你申请的开始设备号的范围，这经常从0开始，count是你申请的设备的总数
name必须和你的number相对应，而且这个名字就在/proc/devices中显示，另外，这个/proc/目录是个虚拟目录，它时刻在读取计算机的各个硬件cpu、io、模块等信息，要注意利用啊。
这个函数如果正确执行，会返回一个0,否则就返回一个负数,现在很多人努力使用这个函数，
<pre>
int alloc_chrdev_region(dev_t *dev, unsigned int firstminor,
			unsigned int count, char *name)
</pre>
记住，申请完设备后一定要记得释放，驱动程序应该始终使用alloc_chrdev_region.
<pre>
void unsigned_chrdev_region(dev_t first,unsigned int count)
</pre>
##非重点(disgression)
Major devices numbers 静态分配的多些，这些设备清单在内核的Documentayion/devices.txt,如果你的设备不工作，那么试试以下两种方法: 1.使用未使用的静态主设备号;2.使用动态分配的方法,in other word,我们应该更多的使用alloc_chrdev_region而不是register_chrdev_region.

###主设备号
是关于驱动程序的，例如 /dev/null,/dev/zero 的主设备号是1,虚拟控制台和串口终端是4,VCSL和VCSL设备是7.
###次设备号
由内核使用，用于正确确定设备文件所指的设备，可以通过设备号获得一个指向内核设备的直接指针。
file_operations structure :
	struct file_operations scull_fops = {
		.owner = THIS_MODULE,
		.llseek = scull_llseek,
		.read = scull_read,
		.write = scull_write,
		.ioctl = scull_ioptl,
		.open = scull_open,
		.release = scull_release,


	};
hints:

对于结构体
	struct a {
		int a;
		int b;
	}
有以下几种初始化方式：
	struct a a1 = {
		.a = 1,
		.b = 2,
	};
或者
	struct a a2 = {
		a:1,
		b:2,
	};
or
	struct a a3 = {
		1,2
	};

内核喜欢用第一种方式，使用第一种和第二种方式，成员初始化的顺序可以改变。使代码更具有可移植性。
