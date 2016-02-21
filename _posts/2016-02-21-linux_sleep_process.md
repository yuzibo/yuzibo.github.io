---
layout: article
title: "linux 进程休眠"
category: linux
---

# 休眠规则
1. 不要在原子上下文中休眠

2. 禁止中断时,也不能休眠

3. 要确保有进程能唤醒自己

4.休眠被唤醒之后仍要检查等待的条件是否为真,否则重新继续休眠.

# 简单休眠
我们休眠的代码必须能够唤醒(wake_up),我们需要维护一个称为等待队列的数据结构.
等待队列就是一个进程链表,其中包含了等待了某个特定事件的所有进程.
linux维护一个"等待队列头"来管理,wait_queue_head_t,定义在<linux/wait.h>
{% highlight c %}
struct __wait_queue_head {
	spinlock_t		lock;
	struct list_head	task_list;
};
typedef struct __wait_queue_head wait_queue_head_t;

{% endhighlight %}
这里结构体前面的"__"是系统调用的函数.

# 初始化方法

## 静态方法

`DECLARE_WAIT_QUEUE_HEAD(name)`


{% highlight c %}
/* This is the method to initializer */
#define DECLARE_WAIT_QUEUE_HEAD(name) {
	wait_queue_head_t name = __WAIT_QUEUE_HEAD_INITIALIZER(name)
}
#define __WAIT_QUEUE_HEAD_INITIALIZER(name) {				\
	.lock		= __SPIN_LOCK_UNLOCKED(name.lock)		\
	.task_list	= { &(name).task_list, &(name).tsak_list}
}
DECLARE_WAIT_QUEUE_HEAD(name);
{% endhighlight %}
色块内的是方法,这里,我把相关的代码放在了一起,以便于理解.

## 动态方法
{% highlight c %}

 wait_queue_head_t my_queue;
 init_waitqueue_head(&my_queue);

 /* from here */

 struct __wit_queue_head {
	spinlock_t		lock;
	struct list_head	task_list;
 };
typedef struct __wait_queue_head wait_queue_head_t;
{% endhighlight %}

linux 中最简单的休眠方式是下面的宏:

wait_event(queue, condition);	//uninterruptible sleep

wait_event_interruptible(queue, condition); //返回非0值表示
休眠被信号中断

在这两个Macro实现中,分别有一个`might_sleep()`的使用.而且后者
在实现上比前者多了个`int __ret = 0`;

wait_event_timeout(queue, condition, timeout);

wait_event_interruptible_timeout(queue, condition, timeout);

### might_sleep()
不得不说一下这个宏,上面这四个宏中都牵扯上它了.代码注释是这么说的:

	might_sleep - annotation for function that can sleep

queue 是等待队列头,传值方式,condition是任意一个布尔表达式,在休眠前后多次
对condition求值,为真则唤醒.

### 唤醒进程 wake_up

```c
void wake_up(wait_queue_head_t *queue);
void wake_up_interruptible(wait_queue_head_t *queue);
```








