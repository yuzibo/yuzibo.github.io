---
title:  "linuxnewbie 问答总结(一)"
layout: article
category: kernel 
---

# 内核空间和用户空间的数据类型

### 在内核中使用的话
很简单，只需使用

```c
u8
u16
u32
u64
```
类似的是(s8,s16...)

如果跨边界使用的话，必须向用户空间传递，只需在前面加上"__",使之成为"__u8",
"u16"即可。
LDD3全部描绘了这些，必须抓紧时间看看

# fork process
fork()->clone()->do_fork()->copy_process();请详细解释一下这个过程
代码实现是怎样的。

# logical address and vitual address
内核逻辑地址与内核代码相映射，可以通过标准的cpu内存访问函数来使用.可以使用
kmalloc函数分配，而且地址分为基地址和偏移地址，或者说是分段地址。(1:1)的映射
可以让内核访问大部分的RAM的空间。

内核虚拟地址与逻辑地址相似，但不必遵循1:1与物理地址的映射。使用vmalloc函数进
行物理内存分配(没有对应的逻辑地址)。也可以使用kmap去指定逻辑地址和虚拟地址的
对应。
System.Map is a symbol table, which contains a list of function names in the
Linux kernel, with for each function the virtual address at which its code
is loaded in memory.

# schedule()
关于这个函数是很意思的，目前讨论的不多。内核中调用schedule()的方式有两种，

	1. 直接呼叫schedule();
	
	2. 通过阻塞一个进程(blocking)

# preempt_count

preempt_count是每一个task的锁的数量。当锁的数量增加时，preempt_count的值就会
增加，锁的数量减少时，preempt_count的数量就会减少；当在内核中运行的task的
preempt_count>时，内核是不能被抢占的；如果preempt_count == 0的时候，这个时候
内核是可以被抢占的。

# write-reader和semaphore的区别
semaphore是控制一个进程在一个时间内访问一个数据；write-reader是可以有多个读
者的情况。

# spin locks
在多处理器系统上，linux使用spin locks去管理竞态。linux在获得spin locks时禁用了内核抢占；当释放了spin locks时，又开启了内核抢占；在单处理器上，使用
spin locks是不合适的
