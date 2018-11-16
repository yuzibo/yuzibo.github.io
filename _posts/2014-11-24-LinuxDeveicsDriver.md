---
layout: post
title: "LDD读书笔记(1-4)"
category: book
---

* content
{:toc}

1.insmod 是系统调用 kernel/module.c，The function sys_init_module allocates kernel memory(how)=>（ The memory is allocated with vmalloc function）,系统调用函数把模块复制到内存区，通过内核符号表解决内核引用的问题，并且呼叫模块初始化函数使一切准备就绪。

2.在内核源代码中，使用前缀sys_ 就是系统调用。

3.modprobe 命令比insmod命令高级一点，它会自动解决模块引用不成功的问题。

4.如果模块正在被使用，清除模块的任务将会失败，或者这个模块已经被定义为不可清除

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

## 2014-11-23

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

###  模块装载竞争
1.你必须准备好只要你的代码完成它的第一步注册就有可能被调用，把你模块需要的设备准备好以后再去注册你的初始化函数。

2.避免把初始化函数失败。

###.模块参数
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

## 11-27
第一个字符设备驱动

在dev_t中，12位的主设备号，20位的次设备号，你的代码应该充分利用在 <linux/kdev_t>的宏，为了去获得主设备号和次设备号dev_t，使用如下命令：

<pre>
MAJOR(dev_t dev);
MINOR(dev_t dev);
</pre>

then,use __MKDEV(int major, int minor)__;

### 字符设备
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

## 非重点(disgression)
Major devices numbers 静态分配的多些，这些设备清单在内核的Documentayion/devices.txt,如果你的设备不工作，那么试试以下两种方法: 1.使用未使用的静态主设备号;2.使用动态分配的方法,in other word,我们应该更多的使用alloc_chrdev_region而不是register_chrdev_region.

### 主设备号
是关于驱动程序的，例如 /dev/null,/dev/zero 的主设备号是1,虚拟控制台和串口终端是4,VCSL和VCSL设备是7.

### 次设备号
由内核使用，用于正确确定设备文件所指的设备，可以通过设备号获得一个指向内核设备的直接指针。

### 三个重要的数据结构
file_operations structure :

{% highlight c %}
struct file_operations {
	struct module *owner;//<linux/module.h> => THIS_MODULE
	loff_t (*llseek) (struct file *, loff_t, int);
	//loff_t is long long							//via __kernel_loff_t;
//change current read/write						//position.
	ssize_t (*read) (struct file *, char __user *, size_t, loff_t *);
	/* ssize_t viaing  __kernel_ssize_t is defined long,
	   通常这个函数返回从设备读来的字节数，
	   如果是NULL,则会返回 -EINVAL("Invalid arguments")
	 */
	ssize_t (*aio_read)(struct kiocb *,char __user *, size_t, loff_t);
		//异步读
	ssize_t (*write) (struct file *, const char __user *, size_t, loff_t *);

	/*返回一个非负的整数(long long ),表示已经向设备发送了多少字节，if NULL, return -EINVAL;
	 */
	ssize_t (*aio_write) (struct kiocb *, const char __user *, size_t, loff_t *); //异步写方式
	int (*readdir) (struct file *, void *, filldir_t);
	/*它是被用来读管道，并且仅仅用于文件系统，对于设备文件，仅仅使用NULL*/
	unsigned int (*poll) (struct file *, struct poll_table_struct *);
	/*这个方法被用于三个系统调用，poll,epoll,select,询问一个读或写的文件描述符是否堵塞，if a driver
	  leaves its poll method NULL,这个设备被认为可读可写
	 */
	int (*ioctl) (struct inode *, struct file *, unsigned int, unsigned long);
	/*这ioctl系统调用提供了一种方式去实现设备的特殊命令，例如格式化软驱磁道，如果不存在
	  这样的ioctl方法，系统将会返回-ENOTTY("NO such ioctl for device")
	 */
	int (*mmap) (struct file *,struct vm_area_struct *);
	/*
	   mmap 被用来映射设备内存到进程地址空间，如果这里是NULL，那么返回 _ENODEV
	 */
	int (*open) (struct inode *, struct file *);//first operation,but...

	int (*flush) (struct *);
	/*目前，很少使用flush，如果它为NULL,kernel will ignore user application request.
	 */
	int (*release) (struct inode *, struct file *);
	/*激活file数据结构*/
	int (*fsync) (struct file *,struct dentry *, int);
	/*This method is the back end of the fsync system call,which a user calls to flush any
	  pending data,if this is NULL, return -EINVAL*/
	int (*aio_fsync)(struct kiocb *, int);//异步
	int (*fasync) (int, struct file *, int);
	/*这个方法被用来通知设备去改变它的FASYNC的标志，这是关于一个异步的问题*/
	int (*lock) (struct file *, int ,struct file_lock *);
	/*loch 方法被用来实现文件锁，locking对于日常文件很重要，但是对于设备驱动
	  却几乎没有用过*/
	ssize_t (*readv)(struct file *, const struct iovec *,unsigned long,loff_t *);
	ssize_t (*writev) (struct file *,const struct iovec *,unsigned long,loff_t *);
	/*实现扫描/采集 读或写 操作，if is NULL，被read和write代替*/
	ssize_t (*sendfile) (struct file *, loff_t *,size_t, read_actor_t, void *);
	//实现 sendfile系统调用，从一个文件描述符移动数据到另一个。=> NULL
	ssize_t (*sendpage) (struct file *, struct page *, int, size_t, loff_t *, int ;
	/*被内核用来发送数据一次一页同上面一样*/
	unsigned long (*get_unmapped_area)(struct file *,
		unsigned long, unsigned long, unsigned long, unsigned long);
	/*NULL？？*/
	int (*check_flags)(int);
	/*检查传递给fcntl的标志*/
	int (*dir_notify) (struct file *, unsigned long);
	/*当一个进程使用fcntl去要求目录改变，仅用来用于文件系统*/


};

{% endhighlight %}

这个scull设备驱动被初始化如下：

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

#### file struct

struct file 是第二重要的数据结构，与用户空间的FILE完全没有关系

{% highlight c %}
	mode_t f_mode;//mode_t is defined as __bitwise__
	/*The method 区分这个文件是可读的还是可写的*/
	loff_t f_ops;
	/*目前读和写的位置*/
	unsigned int f_flags;
	/*这是文件标志，such as O_RDONLY,O_NONBLACK,O_SYNC,当一个驱动询问是
	  否正在堵塞应该检查O_NONBLOCK标志位，所有的标志是被定义在<linux/fcntl.h>*/
	struct file_operations *f_op;
	/*这是关于文件的，这一块很重要，但是我没有读懂什么意思，open操作
	  对应主设备号1,filp->p对应次设备号*/
	void *private_data;
	/*这open系统呼叫在使用open方法之前设置了NULL？？，要记得释放*/
	struct dentry *f_dentry;
	/*the directory entry (dentry) 和文件有关系，BTW，设备从来不创建file结构*/
{% endhighlight %}

### inode structure
The inode 是被内核内部用来代表文件，单个文件可以有多个file结构，但是它们全都指向一个 inode,现在先有两个重要域关于驱动的

{% highlight c %}
	dev_t i_rdev;
	/*对于inode来说，它代表设备文件，包含实际的设备号*/
	struct cdev *i_dev;
	/*struct cdev 是代表字符设备的内部结构*/

{% endhighlight %}

最近，有开发者希望能从inode中直接获取主设备号和次设备，

	unsigned int iminor(struct inode *inode);
	unsigned int imajor(struct inode *inode);

### 字符设备注册
在linux中，内核使用 cdev 结构去表示字符设备，那么必须包含<linux/cdev.h>,可以使用以下方法在运行时获得 cdev 结构，

	struct cdev *my_cdev = cdev_alloc();
	my_dev->ops = &my_fops;

在初始化中,

	void cdev_init(struct cdev *cdev, struct file_operations *ops);

在kenel呼叫cdev是

	int cdev_add(struct cdev *dev, dev_t num, unsigned int count);

num是这个设备对应的第一设备号,count是设备号对应的设备的数量,多数情况下是1,也有例外的情况.这个函数失败的话会返回一个负数.

To remove a char device from the system ,call:

	void cdev_del(struct cdev, *dev);

## Device Registration in scull
scull 代表被一个scull_dev设备

	struct scull_dev {
		strcut scull_qset *data; /*first quantum*/
		int quantum; /* The current quantum size*/
		int qset; /*the current array size*/
		unsigned long size; /*amount of data stored here*/
		unsigned int access_key;
		struct semaphore sem; /* mutual exclusion semaphore*/
					/*互斥信号量*/
		struct cdev cdev;/* Char device structure*/
	}

struct cdev是设备加载到内核的接口,这个结构必须初始化和加进系统使用如下的方法,

	static void scull_setup_cdev(struct scull_cdev *dev, int index)
	{
		int err, devno = MKDEV(struct scull_major, scull_mirror +
					index);
		cdev->init(&dev->cdev, &scull_fops);
		dev->cdev.owner = THIS_MOUDLE;
		dev->cdev.ops = &scull_fops;
		err = cdev_add (&dev->cdev, devno,1);
		if(err);
		printk(KERN_NOTICE "error %d adding scull%d",err,index);
	}

## open()
__open__method is provided for a driver to do any initialization in preparation for later operations,must consider following tasks:检查设备特别的错误,如没有就绪 Initialize the device if it is being opened for the first time
Update f_op pointer,Allocate and in filp->private_data

第一件事是确定哪个设备正在被打开,open的函数原型为

	int (*open)(struct inode *inode, struct file *file)

我们希望scull_dev结构包含cdev结构,(它这是在说什么), container_of defined is in <linux/kernel.h>

	container_of(pointer, container_type, container_field);

这个宏把一个指针指向container_field的域,返回一个指针指向containing结构,在scull_open

	struct scull_dev *dev; /*device information*/

	dev = contain_of(inode->i_cdev,struct scull_dev, cdev);
	filp->private_data = dev;

只要一发现scull_dev结构,scull把一个指向前者的指针储存在private_data( in file structure)

另一种方法是储存在 inode 结构体中的次设备号,尤其你使用register_chrdev方法注册设备,scull_open的代码如下:

	int scull_open(struct inode *inode, struct file *file)
	{
		struct scull_dev *dev; /* device information*/
		dev = contain_of(inode->i_cdev, struct scull_dev, cdev);
		filp->private_data =dev;/*for other methods */
		/*now trim to 0 the length of the device if open was write
		 -only*/
		if ( (filp->f_flags & 0_ACCMODE) == 0_WRONLY) {
			scull_trim(dev);/*ignore errors*/
		}
		return 0; /* success*/


	}

scull is a global structure.

## release
这个函数的作用有两个:1.撤销任何已经分配给filp->private_data的数据,2. 最后一次关闭设备

	int scull_release(struct inode *inode, struct file *file)
	{
		return 0;
	}

因为没有硬件所以可以使用最简洁的方法去关闭scull.

如果一个设备文件关闭的次数比它打开的次数多会发生什么? (what happens when a device file is closed more times than it is opened),after all,dup和fork呼叫这open files不使用open,How to a driver know when an open device file has really been closed?

the answer is simple: not every close system call causes the release method to be invoked.the kernel keeps a counter of how many times a file structure is being used.Neither fork nor dup creates a new file structure (only open does that),They just increment the counter in the existing structure.The close system call executes the release method only when the file structure drops to 0,the guarantees that your driver sees only one release call for each open.

kernel automatically closes any file at process exit time by internally using the close system call.

##scull's Memory Usage

two core functions used to manage memory in the Linux kernel.defined in <linux/slab.h>

	void *kmalloc(size_t size, int flags);
	void kfree(void *ptr);

其中,size 是申请的字节大小,flags 在这里是GFP_KERNEL(又是一个多重的宏定义),稍后再详细解释这个东西.只要不使用kmalloc,就别使用kfree,当然,NULL可以传递给kfree.kmalloc 不是最有效的方法去申请内存,但这里只是为了简单展现是read和write的方法,申请整页的方法以后讲.

这里有好好几种方法改变quantum和quantum set的大小:1,改变宏SCULL_QUANTUM和SCULL_QSET.2.在加载模块的时候指定scull_quantum和scull_qset的大小.3.或者改变ioctl的大小.

	struct scull_qset {
		void **data;
		struct scull_qset *next;
	}

下面的代码段展示了struct scull_dev和struct scull_qset如何持有data,__scull_trim__被scull_open激活.它遍历list和free   quantum和quantum set.

	int scull_trim(struct scull_dev *dev)
	{
		struct scull_qset *next, *dptr;
		int qset = dev->qset;
		int i;
		for (dptr = dev->data;dptr; dptr = next){
			/*all the list items*/
			if(dptr->data){
				for(i=0; i<qset; i++)
					kfree(dptr->data[i]);
				kfree(dptr->data);
			}
			next = dptr->next;
			kfree(dptr);
		}
		dev->size = 0;
		dev->quantum = scull_quantum;
		dev->qset = scull_qset;
		dev->data = NULL;
		return 0;
	}

## read and write

	ssize_t read (struct file *flip, char __user *buff,
			size_t count, loff_t *offp);
	ssize_t write(struct file *filp, const char __user *buff,
			size_t count, loff_t *offp);

这里的buff是用户空间的数据,不能直接被kernel 的代码使用,为了能够在用户空间和内核空间传递buff,我们引入了特别的函数<asm/uaccess.h>,

	unsigned long copy_to_user(void __user *to,
				   const void *from,
				   unsigned long count);
	unsigned long copy_from_user(void *to,
					const void __user, *from,
					unsigned long count);

需要注意的是,用户空间的地址可能不存在,这时你必须把该进程睡眠.你必须保证传递给这些函数的用户空间指针是合法的.:

### the read method
A negative value is means an error,defined in <linux/errono.h>.typical values include -ETNTR(interrupted sytem call) -EFAULT(bad address).

## readv and writev
These sysyem calls are versions of read and write taking an array of structures.each of which contains a pointer and a length value.

	ssize_t (*read) (struct file *filp,const struct iovec *iov,
			unsigned long count, loff_t *ppos);
	ssize_t (*write) (struct file *filp, const struct iovec *iov,
			unsigned long count, loff_t *ppos);

Here,the filp and ppos arugments are the same as for read and write.The __iovec__structure,defined in <linux/uio.h>

	struct iovec
	{
		void __user *iov_base;
		__kernel_size_t iov_len;
	};

__kernel_size_t__是unsigned long ,Each iovec describes one chunk of data to be transferred; it starts at iov_base(in user space) and is iov_len bytes long.The count parameter tells the method how many iovec structure there are.

