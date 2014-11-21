---
layout: article
title: "kernel进程管理API-__task_pid_nr_ns()"
category: kernel API
---
#文件包含
\#include<linux/sched.h>
#函数定义
##在内核源代码的位置 linux-3.2.64/kernel/pid.c
##函数定义格式:
{% highlight c %}
pid_t __task_pid_nr_ns(struct task_struct *task, enum pid_type type,
		struct pid_namespace *ns)
{
	pid_t nr =0;
	rcu_read_lock();
	if (!ns)
		ns = current->nsproxy->pid_ns;
	if (likely(pid_alive(task))) {
		if (type != PIDTYPE_PID)
			task = task->group_leader;
		nr = pid_nr_ns(task->pid[type].pid,ns);
	}
	rcu_read_unlock();
	return nr;
}
EXPORT_SYSBOL(__task_pid_nr_ns);
{% endhighlight %}
#函数功能描述
此函数用于获取进程的进程号，但应该满足以下几个条件。
1.参数type如果不等于PIDTYPE_PID，则参数task用其所属任务组的第一个任务赋值，否则保持task不变。

2.此进程是参数task任务描述符的进程。

3.保证进程描述符和pid_namespaces和参数ns相同。

#参数补充(未写)

#举例


{% highlight c %}
/*
 *include head file
 */
#include <linux/module.h>
#include <linux/sched.h>
#include <linux/pid.h>
/*
 *per 
 */
MODULE_LICENSE("GPL");
/*
 *define subprocess function  
 */
int my_function(void *argc)
{
	printk("<0>in the kernel thread function\n");
	return 0;
}
static int __init __task_pid_nr_ns_init(void)
{
	int result;
	printk("<0> into __task_pid_nr_ns_init.\n");
	/*
	 *Create a new process
	 */
	result = kernel_thread(my_function,NULL,CLONE_KERNEL);
	/*
	 *get subprocess pid
	 */
	struct pid *kpid = find_get_pid(result);
	/*
	 *get 进程所属的任务描述符
	 */
	struct task_struct *task = pid_task(kpid, PIDTYPE_PID);
	/*
	 *获取任务对应进程的进程描述符
	 */
	pid_t result1 = __task_pid_nr_ns(task, PIDTYPE_PID, kpid->numbers[kpid->level].ns);
	/*
	 *显示返回值的进程号
	 *
	 */
	printk("<0> the pid of the find_get_pid is :%d\n",kpid->numbers[kpid -> level].nr);
	/*
	 *显示函数的返回值
	 */
	printk("<0> the result of __task_pid_nr_ns is :%d\n",result1);
	printk("<0> the result of kernel_thread is :%d\n",result);
	printk("<0> the pid of current thread is :%d\n",current->pid);
	printk("<0> out __task_pid_nr_ns_init.\n");
	return 0;
}
static void __exit __task_pid_nr_ns_exit(void)
{
	printk("<0> Goobye __task_pid_nr_ns\n");
}
/*
 *load and exit
 */
module_init(__task_pid_nr_ns_init);
module_exit(__task_pid_nr_ns_exit);
{% endhighlight %}
结合以前的知识，写出Makefile，执行

__make__

然后，键入 __insmod\ __task_pid_nr_ns.ko__,这时一般终端就会有消息产出，如果没有可以接着使用 __dmesg -c__命令
##终端信息
<pre>
Message from syslogd@debian at Nov 21 15:28:12 ...
 kernel:[  458.244921]  into __task_pid_nr_ns_init.

Message from syslogd@debian at Nov 21 15:28:12 ...
 kernel:[  458.244971]  the pid of the find_get_pid is :2915

Message from syslogd@debian at Nov 21 15:28:12 ...
 kernel:[  458.244980]  the result of __task_pid_nr_ns is :2915

Message from syslogd@debian at Nov 21 15:28:12 ...
 kernel:[  458.244988]  the result of kernel_thread is :2915

Message from syslogd@debian at Nov 21 15:28:12 ...
 kernel:[  458.244995]  the pid of current thread is :2914

Message from syslogd@debian at Nov 21 15:28:12 ...
 kernel:[  458.245002]  out __task_pid_nr_ns_init.

Message from syslogd@debian at Nov 21 15:28:12 ...
 kernel:[  458.245964] in the kernel thread function
dmesg -c
dmesg: klogctl failed: 不允许的操作
yubo@debian:~/linux/process$ 
</pre>

