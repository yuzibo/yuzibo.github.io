---
layout: article
title: "LKD读书笔记"
category: "book"
---
#Linux Kernel Development 读书笔记
(8/10/14)

==========================day01===================
1.Introduction to linux:
	1.kernel,device drivers,boot loader,command shell,filetype system utilities
	2.linux can dynammic loading of kernel modules or unloaded;symmetrical multiprocessor(SMP?);all process are the same
	3.Andrew Morton LKML
	4.practical
2.Getting started:
	1./usr/src/linux !!!不能动
	2.using patches
	3.Configuring the kernel
	4.GNU c:inlines;Assembly:empty if();No memory Protection==>oops;No Floating Point
3.Process Management
	1.The living result of running program code 
	2.Thread within the process,内核调度包括thread,not process.Modern operating systems provide two virtuazation:a virtualized processor and virtual memory
	3.fork() begins process's life,exit() end it's life,exec() begins a new address space and loads a new program into it
	4.task list  consist of circular doubly linked list,
Each element in the task list is a process descriptor of the type struct task_struct
	5.Allocating the Process Description:thread_info structure is defined on x86 in <asm/thread_info.h>,I want to know what he is taking about,
Process identification value or PID
	6. maximum value is recorded in /proc/sys/kernel/pid_max.via the "current" macro 
	7.Process State(5个)==>set_task_state(task,state)/*set task `task` to state `state`*/
	8.Process Context
	9.The Process Family tree,the big father is PID is one(init in last step of the boot process),总的来说，就是在引导boot程序的最后一步时由init呼叫其他系统程序，完成了启动后即开始转换为big father，“struct task_struct *my_parent = current->parent”
	10.Process Creation,fork()将父进程的所有资源复制给他的子进程，在这里，这两者之间用了一种锲约Copy-on-write(这是一种延迟（delay）),等时机差不多了再复制资源，所以，像连环套似的，下一个宝藏就是--copy-on-write,BTW,学习计算机，我自己最大的感受是当你看到一种新理论或者新名词时，最好不要去想这东东我能用着吗，我要掌握那得花多少时间啊，想都不要想，当然，如果你是按主题搜索资料时，还是要注意大方向的。
	11.Forking：The fork() via the clone() system call,do_fork()
	12.The Linux Implementation of Threads:They can also share open files and other resources,Thread enable concurrent programming and on the multiple processor systems ,true paralleism.But Linux kernel ,there is no concept of a thread,Linux implements all threads as standard processes.just happen to share resources ,such as an address space,with other process.linux没有线程的概念，这一点与windows与Solaris显然不同，也是存放在task_struct中在<linux/sched.h>有着clone flags的定义。
	13.Kernel threads-standard processes,do not have an address space (mm pointer ,which points at their address space ,is NULL) ,内核线程有很多，如 top,ps -ef啦，第一次读到源代码，宏的使用比较多，还有各种各样的强制转换
============================chapter04==========
Process Scheduling
	1. Multitasking,四个问题， suspending a running process is called preemption(?),timeslice ,yielding
	2.linux's Proces Scheduler is simple,But 2.5 kernel later call O(1) scheduler,get to constant-time,and 2.6.23,the completely fair scheduler or CFS.
	3.主要讲了两类Bound,I/O,process
	4.process priority,linux kernel have two separate priority ranges(-20 to +19 with a default of 0),shell ps -el
	5.Real-time
	6.关于linux的时间调度，有几个值得关注的地方：
		1. Time Accounting
		2. The scheduler entity struct,这个结构体定义在<linux/sched.h>中，并且这个结构实体嵌入在进程描述表中。 
		3.The virtual Runtime 记录了进程的实际运行时间，是上面结构体的一个成员。nanoseconds(十亿分之一，毫微秒)。
		4.进程选择(process selection),这里涉及红黑二叉树，自己还是一无所知,补上啊.红黑树的定义在/linux/sched.h中，这个数据结构在内核中异常重要，在不同场景中都有它的应用，请你自己一定要掌握下来。
		5.Picking the Next Task: 在红黑树的基础上，选择下一个任务就简单多了，选择rb_node的leftmost node就是了,而这个函数就是__pick_next_entity(),在 kernel/sched_fair.c中。
		6. Adding process to the Tree :  first created via fork(),then enqueue_entity(),将进程加入红黑树。
		7. Removing Process from tree
		8. The Scheduler Entry Point
		9. Sleeping and Walking Up
----------------------chapter 5 system call-----------
1. System Call Numbers
	在Linux中，每一次系统调用会指派一个系统调用序列(syscall numbers).	details for /arch/i386/kernel/syscall_64.c
	system_call() is important also.
		怎么也看不懂啊

----------------------chapter 7 interrupt ------------
1.	These interrupt values are often called interrupt request(IRQ),on the classic PC,IRQ zero is the timer and IRQ one is the keyboard interrupt.
2	The function the kernel runs in response to a specific is called an interrupt handler or interrupt service route(ISR),	
3.	In linux,interrupt handler are normal C functions.
	interrupt context;快速及时处理中断
	Device uses interrupts ,driver must register one interrupt handler.
with function request_irq(),which is declared in <linux/interrupt.h>
	On success,request_irq() return zero,A nonzero value indicates an error, a common error is -EBUSY.
4.	还要释放中断处理:request_irq()
	free_irq();
-------------------------9/4--------------------------------
1.	Linux把硬件中断的进程分成两部分。The top half is quick and simple and runs with some or all interrupts disabled.The bottom half runs later with all interrupts enabled.
2.	BH is called Bottom Half also.
3.	Task Queues : each queue contained a linked list of functions to call.
4.	Softirqs and Tasklets
	The softirq code lives in the kernel/softirq.c
	Softirqs are represented by the softirq_action structure,which is defined in <linux/interrupt.h>
5.	Networking and block devices --directly use softirqs.
	Softirq Types的图片放在了<picture/c>
6.	Registering your handler<net/core/dev.c>
	open_softirq(NET_TX_SOFTIRQ, net_tx_action);
	open_softirq(NET_RX_SOFTIRQ, net_rx_action);
7.	Tasklets are represented by two softirqs:HI_SOFTIRQ and TASKLET_SOFTIRQ.
8.	The tasklet structure
struct tasklet_struct
{
	struct tasklet_struct *next;
	unsigned long state;
	atomic_t count;
	void (*func)(unsigned long);
	unsigned long data;
};	
9.	Tasklet are scheduled via the tasklet_schedule() and tasklet_hi_scheduled() functions.
10.	old BH is no longer present in 2.6,the hostory is important.
	In 2.5,The kernel developers summarily removed the BH interface.Good riddance,BH!

--Work Queues--
1.	Work queues defer work into a kernel thread--this bottom half always runs in process context.
2.	struct workqueue_struct的数据结构定义在/kernel/workqueue.c中

struct workqueue_struct {
	struct list_head	pwqs;		/* WR: all pwqs of this wq */
	struct list_head	list;		/* PL: list of all workqueues */

	struct mutex		mutex;		/* protects this wq */
	int			work_color;	/* WQ: current work color */
	int			flush_color;	/* WQ: current flush color */
	atomic_t		nr_pwqs_to_flush; /* flush in progress */
	struct wq_flusher	*first_flusher;	/* WQ: first flusher */
	struct list_head	flusher_queue;	/* WQ: flush waiters */
	struct list_head	flusher_overflow; /* WQ: flush overflow list */

	struct list_head	maydays;	/* MD: pwqs requesting rescue */
	struct worker		*rescuer;	/* I: rescue worker */

	int			nr_drainers;	/* WQ: drain in progress */
	int			saved_max_active; /* WQ: saved pwq max_acti
     
						     }
	这是在高版本的内核中实现的，与LKD上的代码不是很一样
3.	The relationship between work,work queues,and the worker threads
4.	Here can you  use bottom half: softirqs,tasklets,work queues; 
这三方面当然有侧重点了，不同的应用对应不同的功能
5.	以上就是defer work(延迟工作);
-----------------------Kernel Synchronization---------
1.	Code paths that access and manipulate shared data are called critical regions.（在这里的临界区和操作系统的临界区不知道是不是一回事）	
2.	Race Conditions:	
	这里指的是两个线程共同分享一个临界区(Critial Region),为了预防这种情况的发生就叫做 Synchronization
3.	作者举的两个例子很熟悉，一个是ATM取款，另一个是数据库中的读脏数据的例子。原子操作是避免这类错误的根本。
4.	在Linux中，A value of zero means unlocked.On the popular x86 architecture,locks are implemented using such a similar instruction called compare and exchange.
5.	The kernel has similar causes of concurrency:
	1.Interrupts
	2.Softirqs and tasklets
	3.Kernel preemption
	4.Sleeping and synchronization with user-space
	5.Symmetrical multiprocessing
6.	Knowing What to protect
	It's to identify what data does not need protection and work from there.
7.	Most global kernel data structures need locking!
8.	deadlocking
	Whenever you write kernel code,whether it is a new system call or a rewritten driver,protecting data from concurrent access needs to be a primary concern.
----------------Kernel synchronization methods----------
1.	Atomic Interger Operations
	atomic_t type is define in <linux/types.h>,finally,use of it can hide any architecture-specific differences
	typedef struct {
		volatile int counter;

	
	} atomic_t;
	好几种关于atomic operations，书本现在读不进去，苦恼中
	<asm/atomic.h>
	Here, for example:
	static inline void atomic_add( int i,atomic_t *t)
	{
		asm volatile(LOCK_PREFIX "addl %1,%0"
				: "+m" (v->counter)
				: "ir" (i));
	}
	/*
	*解释这是GCC的扩展应用，具体用法是这样的
1.        asm [volatile] (AssemblyTemplate : [OutputOperands] [ :[ InputOperands][:[Clobbers] ] ] )
	在ISO C中可以使用 _asm_ 替代asm,_volatile_替代volatile.
	*
	*/
	----volatile意思是不要对其进行优化，这里不优化的话，就会被汇编成直接访问内存地址，而不是操作寄存器
	这里会被汇编成一条语句，%0 代表output,%1代表i，output和input的"m"和"ir" 是这种扩展嵌入汇编的constraint,m代表这需要访问内存地址来取出数值，i代表这个立即数，r代表可以放到任何的寄存器中
2.	64-bit Atomic Operations
	With the rising prevalence[普及] of 64-bit architecture ,32位机器的原子操作会逐渐移植到64位,但是自己在开发的时候一定注意机器的字长。
3.	Atomic Bitwise Operations
4.	Spin Locks
	spin locks can be used in interrupt handlers,be care when you attmpte to obtain spin locks you have alread hold,It's possible can't obtain spin lock never!
5.	spin_lock_irqsave() saves the current state of interrupts,disables them locally. There are a rule: Big Fat Rule.
6.	Semaphores in linux are sleeping locks.
7.	BKL: The Big Kernel Lock
8.	Sequential Locks.It works by maintaininng a sequence.

After i cast much time,i am on the way to the Linux Kernel.
But how i start to code?
	
P234
11-14
##two handware devices to help with time keeping
###the real-time clock
The real-time clock(RTC) continuous to keep track of time even the system is off,on PC architecture the RTC and CMOS are integrated.
	On boot,the Kernel reads the RTC and uses it to initialize the wall time,which is stored in the __xtime__variable.
###The timer interrupt is broken into two pieces,an architecture-dependent and architecture-independent,but both at least perform the following working.
	1.obtain the __xtime_lock__lock,which protects access to __jiffies_64__and wall time value--xtime.
	2.reset the system timers as required
	3.Periodically save the updated wall time to the RTC
	4.Call the architecture-independent the timer routin__tick_periodic()__,后面这个函数是个重点。

======================================================
overhaul:检修；改造:rectified:矫正 to a fault:fellowship(团契)::latency::at-odds::
http://v.163.com/movie/2014/9/5/8/MA44SCUPU_MA47GQ658.html
scenario::coexist::protocols::dabbled::coupons::bot::
============================================
debian 分区工具 apt-get install parted
