---
layout: post
title: "LDD读书笔记(2)"
category: book
---

* content
{:toc}

#Debugging Techniques
无论什么样的原因你都应该自己编译内核,在__kernel hacking__ menu 下,你最好开启以下选项.
###CONFIG_DEBUG_KERNEL
the option just makes other debugging options available.
###CONFIG_DEBUG_SLAB
这对于内核内存分配函数非常关键,	它可以推断溢出的内存的数量以及未初始化的错误,每一个被分配的内存的字节在处理之前是0xa5,当被释放后是0x6b...
###CONFIG_DEBUG_PAGEALLOC
Full pages are removed from the kernel address space,the option can slow it,also point out certain kinds of memory corruption errors
###CONFIG_DEBUG_SPINLOCK
It catches uninitialized spinlock and other errors(such as unlocking a lock twice)

###CONFIG_DEBUG_SPINLOCK_SLEEP
开启这个选项,如果你呼叫一个潜在(可能不是)的sleep函数,它就会发出警告.
###CONFIG_INIT_DEBUG
Items marked with __init(__initdata)在系统初始化完成后或模块加载完毕后被丢弃.
###CONFIG_DEBUG_INFO
The information debugging with __gdb__,You also want to enable CONFIG_FRAME_POINTER.
###CONFIG_MAGIC_SYSRQ

###CONFIG_DEBUG_STACKOVERFLOW AND CONFIG_DEBUG_STACK_USAGE
These options can help trace down kernel stack overflows.
###CONFIG_KALLSYMS
This option (under "General setup/Stardsrd features") causes kernel symbol information to be built into the kernel.
###CONFIG_IKCONFIG AND CONFIG_IKCONFIG_PROC
These options (under "General setup") cause the full kernel configuration state and to be made available via /proc.
###CONFIG_ACPI_DEBUG

###CONFIG_DEBUG_DRIVER
It is useful to trace down the low-level support code.
###CONFIG_SCSI_CONSTANTS
The item (under "Device drivers/SCSI device support")
###CONFIG_INPUT_EVBUG
The item ("Device drivers/Input device suuport") including security implications and however: it logs everything you type.
###CONFIG_PROFILING


#Debugging by Printing
The variable console_loglevel is initialized to DEFAULT_CONSOLE_LOGLEVEL AND can be modified through the sys_syslog system call,P95 这一段没看明白.
###Redirecting Console Messages
同样没有看懂
###How Messages Get Logged
The printk function writes messages into a circular buffer that is __LOG_BUF_LEN bytes long (from 4 KB to 1 MB) while configuring the kernel.

###系统日志那块很麻烦
###Rate Limit
如果你的设备有错误,但是你只是想打印一次的错误,那可以考虑

	int printk_ratelimit(void);

如果这个函数返回一个非0的数,那么继续打印消息,典型的应用是

	if (printk_ratelimit())
		printk(KERN_NOTICE "The printer is still on fire\n");

这个函数的行为可以通过 /proc/sys/kernel/printk_ratelimit改变.
###print device numbers
Defined in <linux/kdev_t.h>
	
	int print_dev_t(char *buffer, dev_t dev);
	char *format_dev_t(char *buffer, dev_t dev);

这一块学的真垃圾.

###Using the /proc/ Filesystem

这个目录下的文件是内核把硬件信息告诉外界./proc是很重要在linux system中,许多命令例如ps,top,uptime严重依赖这个目录.你的驱动也可以使用这个东西,并且是动态的.
我们最好使用 sysfs去调试信息.

<linux/proc_fs.h>是所有工作在/proc的模块的头文件,当有进程访问/proc下的文件,内核首先分配一页内存(4096 kb),此内存用来将数据发往用户空间,

	int (*read_proc)(char *page, char **start, off_t offset, int count,
			int *eof, void *data)

其中的offset和count同read方法的一致,其他的就可以按照字面上的理解.这个函数的参数需要注意.

下面是一个简单的例子:
{% highlight c %}
	int scull_read_procmen(char *buf, char **start, off_t offset,
			int count, int *eof, void *data)
	{
		int i, j, len = 0;
		int limit = count -80;

		for (i = 0; i < scull_nr_devs && len <= limit; i++) {
			struct scull_dev *d = &scull_devices[i];
			struct scull_qset *qs = d->data;
			if (down_interruptible(&d->sem))
				return -ERESTARTSYS;
			len += sprintf(buf + len,"\nDevice %i: qset %i, q %i, sz %li\n",
					i, d->qset, d->quantum, d->size);
			for (;qs && len <= limit; qs = qs->next) {
				len += sprintf(buf + len, " item at %p, qset at %p\n",
						qs, qs->data);
				if (qs->data && !qs->next)/*dump only last item*/
					for (qs->data[j])
						len += sprintf(buf + len,
								"	% 4i:%8p\n",
								j, qs->data[j]);
			}
		up(&scull_devices[i].sem);

		}
		*eof = 1;
		return len;
	
	}

{% endhighlight %}

##kdb内核调试器

1.在编译内核时，首先将支持kdb的选项打开，在 Linux hacking >> KGDB

2.在控制台下，按下 Pause Break 键启动调试，当内核发生oops，或者到达一个断点时也会开启调试。

3.具体用到的时候再说
##并发和竞争

1.当一个linux process reaches a point where it cannot make any further process it goes to sleep (or "block")

2.使用锁机制容易造成“sleep”，所以使用信号量来避免，在linux中，有一对函数叫做P，V。在进入临界区前，首先呼叫p，并且将value-1,V 释放这个信号量。当这两个函数出现意外时，需要等待...

3.实现

为了使用semaphore,需要包括<asm/semaphore>

	struct semaphore;

	void sem_init(struct semaphore *sem, int val); 
	// val is the inital value to assign to a semaphore.

还可以使用MACROS
	
	DECLARE_MUTEX(NAME); // ==>> 1

	DECLARE_MUTEX_LOCKED(NAME); // ==>> 0

如果在运行时进行初始化，可以使用以下两种方法

	void init_MUTEX(struct semaphore *sem);
	void init_MUTEX_LOCKED(struct semaphore *sem);

使用：
	
	void down (struct semaphore *sem);
	void down_interruptible(struct semaphore *sem); 
	//产生不可杀的进程(D state in PS command)
	int down_trylock(struct semaphore *sem);
	//立即返回nonzero
	
	void up(struct semaphore *sem);

使用信号量通过down获得，也就是说在你的目标代码中使用上述的的down xx（），可以获得这个信号量;当你离开这个临界区时，通过up()释放。

首先我们在设备文件中设置 

	struct semaphore sem;
	init_MUTEX(&scull_devices[i].sem);
	//一定要在设备分配之前使用

	up(&dev->sem);
	//must clean up

###Read/write semaphore
如果只是仅仅访问收保护的临界区，我们可以使用rwsem("reader/writer semaphore"), it comes from <linux/rwsem.h>.

	void down_read(struct rw_semaphore *sem);
	int down_read_trylock(struct rw_semaphore * sem);
	void up_read(struct rw_semaphore *sem);

down_read只是使用可读的权限使用被保护的数据，还可以是并发的。它可以把呼叫程序处于一种不可中断的睡眠。down_read_trylock如果成功的话返回非0,不成功返回0,这一点与其它的内核函数一样。一个 rwsem使用down_read到的，必须使用up_read释放。

for writer:

	void down_write(struct rw_semaphore *sem);
	int down_write_trylock(struct rw_semaphore *sem);
	void up_write(struct rw_semaphore *sem);
	void downgrade_write(struct rw_semaphore *sem);

综合rwsem的表现，我们拥有rwsem的时间不能过长，否则会出问题.
###completion
即便使用信号量我们也不能保障临界区的安全使用，in the 2.4.7 kernel,we can use completion that allow one thread to tell another that job is done. <linux/completion.h>

	DECLARE_COMPLETION(my_completion);

如果动态的使用，则

	struct completion my_completion;
	/*...*/
	init_completion(&my_completion);
wait.

	void wait_for_completion(strcut completion *c);

这个函数是不可中断的，如果使用后不及时释放，会产生不可杀的进程.


	
	

