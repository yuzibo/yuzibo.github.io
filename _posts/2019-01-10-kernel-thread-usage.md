---
title: kernel thread使用简介
category: kernel
layout: post
---
* content
{:toc}

# 创建
创建的时候就很简单了，有

```c
kthread_run();
// 或者
kthread_create();
```

其实呢，这块就是自己知道的太少，来看看我的低级错误。
# 原始代码

```c
19.c
```

# 解释
```c
int wait_event_interruptible(wait_queue_head_t q, CONDITION);
void wake_up_all(wait_queue_head_t *q);
```
The whole point of a scheduler is to avoid polling in cases like this. What happens is precisely described in what you quoted : The condition is only rechecked on wake_up, ie for example if a given task is waiting for data to be produced :

consumer check if data is available
if not (ie condition false) it goes to sleep and is added to a wait queue
retry when waked up

While on the producer side
Once data is produced, set some flag, or add something to a list so that the condition evaluated by the consumer becomes true
call wake_up or wake_up all on a waitqueue

Now , I suggest you try to use them, and come back with another question AND code you tried if it does not work the way you want.

[wait_event_interruptula使用方法](https://blog.csdn.net/allen6268198/article/details/8112551)

这篇文章也是很好的{here](https://sysplay.in/blog/linux-kernel-internals/2015/12/waiting-blocking-in-linux-driver-part-3/)

[kthread_run](https://blog.csdn.net/qb_2008/article/details/6835783)
这篇文章值得仔细阅读
kthread_run()负责内核线程的创建，参数包括入口函数threadfn，参数data，线程名称namefmt。可以看到线程的名字可以是类似sprintf方式组成的字符串。如果实际看到kthread.h文件，就会发现kthread_run实际是一个宏定义，它由kthread_create()和wake_up_process()两部分组成，这样的好处是用kthread_run()创建的线程可以直接运行，使用方便。

我的错误就是在使用`kthread_run`又运行了一个`wake_up_process`的语句。

kthread_should_stop()返回should_stop标志。它用于创建的线程检查结束标志，并决定是否退出。线程完全可以在完成自己的工作后主动结束，不需等待should_stop标志。


