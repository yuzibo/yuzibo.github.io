---
layout: article
title: "LDD读书笔记(2)"
category: book
---

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



