---
layout: article
title: "kernel进程管理API"
category: kernel API
---
#函数
__task_pid_nr_ns(struct task_struct \*task,enum pid_type type,struct pid_namespace *ns)
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

{% highlight c %}
/*linux/pid.h*/
enum pid_type
{
	PIDTYPE_PID, //进程的进程号
	PIDTYPE_PGID, //process group' leader process ID
	PIDTYPE_SID,  //session' leader process ID
	PIDTYPE_MAX
};
/*
 *linux/pid_namespace.h
 */
struct pidmap {
	atomic_t nr_free;
	void *page;
}
struct pid_namespace {
	/*kerf is reference count,代表此命名空间在多少进程中被使用*/
	struct kref kref;
	/*current system PID */
	struct pidmap pidmap[PIDMAP_ENTRIES];
	/*上一次分配给进程的PID的值*/
	int last_pid;
	/*保存指向该进程的struct_task的指针*/
	struct task_struct *child_reaper;
	/*指向该进程在cache中的分配空间*/
	struct kmem_cache *pid_cachep;
	/*初始化为0,从level内核可知进程关联多少ID*/
	unsigned int level;
	struct pid_namespace *parent;
#ifdef CONFIG_PROC_FS
	struct vfsmount *proc_mnt;
#endif
#ifdef CONFIG_BSD_PROCESS_ACCT
	struct bsd_acct_struct *bacct;
#endif
};
extern struct pid_namespace init_pid_ns;

{% endhighlight %}
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
	 *显示函数find_get_pid()返回值的进程描述符
	 */
	printk("<0> the result of __task_pid_nr_ns is :%d\n",result1);
	/*
	*显示函数kernel_thread()的返回值
	*/
	printk("<0> the result of kernel_thread is :%d\n",result);
	/*显示当前进程号
	   */
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

然后，键入 

insmod __task_pid_nr_ns.ko
	   
这时一般终端就会有消息产出，如果没有可以接着使用 __dmesg -c__命令
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
#find_get_pid()
定义:struct pid *find_get_pid(int nr)
##功能
此函数根据提供的进程号获取对应的进程描述符，并使进程描述符的count的值加1即此进程的用户数加1

##参数说明
nr即为进程号
##返回参数
返回与参数提供的进程号对应的进程描述符，进程描述符定义如下：
{% highlight c %}
struct pid {
	/*此进程的任务数*/
	atomic_t count;
	/*level对应成员number[]的下标，一般取值为0*/
	unsigned int level;
	/*此进程的任务列表*/
	struct hlist_head tasks[PIDTYPE_MAX];
	struct rcu_head rcu;
	/*struct upid类型的数组*/
	struct upid numbers[1];
};
struct uoid {
	int nr;
	struct pid_namespace *ns;
	struct hlist_node pid_chain;
};
extern struct pid init_struct_pid;
{% endhighlight %}
##find_get_pid()应用举例
{% highlight c %}

#include <linux/module.h>
#include <linux/sched.h>
#include <linux/pid.h>
MODULE_LICENSE("GPL");

/*
 * define subprocess
 */
int my_function(void *argc)
{
	printk("<0> in the kerenl thread function!\n");
	return 0;
}
/*
 * load module function
 *
 */
static int __init find_get_pid_init(void)
{
	int result;
	printk("<0> into the find_get_pid_init.\n");
	/*
	 * create a new process, the value of return is a int num,also called 
	 * process id  
	 */
	result = kernel_thread(my_function,NULL,CLONE_KERNEL);
	/*
	 * According to process id,call zhe function,get the process descriptor
	 * information, wait ...atomc_t？
	 */
	struct pid *kpid = find_get_pid(result);
	/*
	 * how many time use the function
	 */
	printk("<0> the count of the pid is :%d\n",kpid->count);
	/*
	 * level
	 */
	printk("<0> the level of the pid is :%d\n",kpid->level);

	/*
	 * display PID
	 */
	printk("<0> the pid of the find_get_pid is :%d\n",kpid->numbers[kpid->level].nr);
	/*
	 * display kernel_thread's return value
	 */
	printk("<0> the result of the kernel_thread is :%d\n",result);
	printk("<0> out find_get_pid_init.\n");
	return 0;	
}
/*
 * quit module define
 */
static void __exit find_get_pid_exit(void)
{
	printk("<0> Goodbye find_get_pid");
}
module_init(find_get_pid_init);
module_exit(find_get_pid_exit);

{% endhighlight %}
##输出结果
<pre>
Message from syslogd@debian at Nov 23 05:42:16 ...
 kernel:[ 3162.689851]  into the find_get_pid_init.

Message from syslogd@debian at Nov 23 05:42:16 ...
 kernel:[ 3162.689863]  the count of the pid is :2

Message from syslogd@debian at Nov 23 05:42:16 ...
 kernel:[ 3162.689864]  the level of the pid is :0

Message from syslogd@debian at Nov 23 05:42:16 ...
 kernel:[ 3162.689866]  the pid of the find_get_pid is :3554

Message from syslogd@debian at Nov 23 05:42:16 ...
 kernel:[ 3162.689867]  the result of the kernel_thread is :3554

Message from syslogd@debian at Nov 23 05:42:16 ...
 kernel:[ 3162.689868]  out find_get_pid_init.

Message from syslogd@debian at Nov 23 05:42:16 ...
 kernel:[ 3162.690635]  in the kerenl thread function!
</pre>
