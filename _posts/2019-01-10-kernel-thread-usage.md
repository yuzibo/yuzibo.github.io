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

这篇文章也是很好的[here](https://sysplay.in/blog/linux-kernel-internals/2015/12/waiting-blocking-in-linux-driver-part-3/)

[kthread_run](https://blog.csdn.net/qb_2008/article/details/6835783)
这篇文章值得仔细阅读
kthread_run()负责内核线程的创建，参数包括入口函数threadfn，参数data，线程名称namefmt。可以看到线程的名字可以是类似sprintf方式组成的字符串。如果实际看到kthread.h文件，就会发现kthread_run实际是一个宏定义，它由kthread_create()和wake_up_process()两部分组成，这样的好处是用kthread_run()创建的线程可以直接运行，使用方便。

我的错误就是在使用`kthread_run`又运行了一个`wake_up_process`的语句。
```c
#define kthread_run(threadfn, data, namefmt, ...)			   \
({									   \
	struct task_struct *__k						   \
		= kthread_create(threadfn, data, namefmt, ## __VA_ARGS__); \
	if (!IS_ERR(__k))						   \
		wake_up_process(__k);					   \
	__k;								   \
})
```

## kthread_should_stop

kthread_should_stop()返回should_stop标志。它用于创建的线程检查结束标志，并决定是否退出。线程完全可以在完成自己的工作后主动结束，不需等待should_stop标志。
```c
/**
 * kthread_should_stop - should this kthread return now?
 *
 * When someone calls kthread_stop() on your kthread, it will be woken
 * and this will return true.  You should then return, and your return
 * value will be passed through to kthread_stop().
 ed_should_stop - should this kthread return now?
 *
 * When someone calls kthread_stop() on your kthread, it will be woken
 * and this will return true.  You should then return, and your return
 * value will be passed through to kthread_stop().
 */
bool kthread_should_stop(void)
{
	return test_bit(KTHREAD_SHOULD_STOP, &to_kthread(current)->flags);
}
EXPORT_SYMBOL(kthread_should_stop);
bool kthread_should_stop(void)
{
	return test_bit(KTHREAD_SHOULD_STOP, &to_kthread(current)->flags);
}
EXPORT_SYMBOL(kthread_should_stop);
```

## kthread_stop

```c
/**
 * kthread_stop - stop a thread created by kthread_create().
 * @k: thread created by kthread_create().
 *
 * Sets kthread_should_stop() for @k to return true, wakes it, and
 * waits for it to exit. This can also be called after kthread_create()
 * instead of calling wake_up_process(): the thread will exit without
 * calling threadfn().
 *
 * If threadfn() may call do_exit() itself, the caller must ensure
 * task_struct can't go away.
 *
 * Returns the result of threadfn(), or %-EINTR if wake_up_process()
 * was never called.
 */
int kthread_stop(struct task_struct *k)
{
	struct kthread *kthread;
	int ret;

	trace_sched_kthread_stop(k);

	get_task_struct(k);
	kthread = to_kthread(k);
	set_bit(KTHREAD_SHOULD_STOP, &kthread->flags);
	kthread_unpark(k);
	wake_up_process(k); // 首先唤醒这个进程
	wait_for_completion(&kthread->exited); //　等待完成
	ret = k->exit_code; //期待这个进程退出
	put_task_struct(k); // 更改状态

	trace_sched_kthread_stop_ret(ret);
	return ret;
}
```
由这个api　stop由**kthread_create()**产生的kthread,这个是可以直接调用的.线程一旦启动起来后，会一直运行，除非该线程主动调用do_exit函数，或者其他的进程调用kthread_stop函数，结束线程的运行。

##  wait_event_interruptible

```c

/**
 * wait_event_interruptible - sleep until a condition gets true
 * @wq_head: the waitqueue to wait on //首先把这个线程放入等待队列
 * @condition: a C expression for the event to wait for //激活的满足条件
 *
 * The process is put to sleep (TASK_INTERRUPTIBLE) until the
 * @condition evaluates to true or a signal is received.//这里这个信号是如何获取的呢?
 * The @condition is checked each time the waitqueue @wq_head is woken up.
 *
 * wake_up() has to be called after changing any variable that could
 * change the result of the wait condition.
 *
 * The function will return -ERESTARTSYS if it was interrupted by a
 * signal and 0 if @condition evaluated to true.
 */
#define wait_event_interruptible(wq_head, condition)				\
({										\
	int __ret = 0;								\
	might_sleep();								\
	if (!(condition))							\
		__ret = __wait_event_interruptible(wq_head, condition);		\
	__ret;									\
})
/*下面的宏在上面*/
#define __wait_event_interruptible(wq_head, condition)				\
	___wait_event(wq_head, condition, TASK_INTERRUPTIBLE, 0, 0,		\
		      schedule())
```
**wait_event_interruptible**函数最终将当前队列中的进程设置为**TASK_INTERRUPTIBLE**状态，然后调用**schedule()**函数
这个函数会将TASK_INTERRUPTIBLE状态的进程从**runqueue**队列中删除，结果就是不会再被调度了，那么，如何被重新调度呢？
当然使用**wait_up**.这里先猜测下，**wake_up**函数与上面的函数应该一致，只是应该换成**TASK_RUNNING**状态。

接下来就是揭晓答案的时刻。

```c
#define wake_up(x)			__wake_up(x, TASK_NORMAL, 1, NULL)
```
接着往下找:
　
```c
/**
 * __wake_up - wake up threads blocked on a waitqueue.
 * @wq_head: the waitqueue
 * @mode: which threads
 * @nr_exclusive: how many wake-one or wake-many threads to wake up
 * @key: is directly passed to the wakeup function
 *
 * If this function wakes up a task, it executes a full memory barrier before
 * accessing the task state.
 */
void __wake_up(struct wait_queue_head *wq_head, unsigned int mode,
			int nr_exclusive, void *key)
{
	__wake_up_common_lock(wq_head, mode, nr_exclusive, 0, key);
}
EXPORT_SYMBOL(__wake_up);

/*
 * Same as __wake_up but called with the spinlock in wait_queue_head_t held.
 */
void __wake_up_locked(struct wait_queue_head *wq_head, unsigned int mode, int nr)
{
	__wake_up_common(wq_head, mode, nr, 0, NULL, NULL);
}
EXPORT_SYMBOL_GPL(__wake_up_locked);

/*
 * The core wakeup function. Non-exclusive wakeups (nr_exclusive == 0) just
 * wake everything up. If it's an exclusive wakeup (nr_exclusive == small +ve
 * number) then we wake all the non-exclusive tasks and one exclusive task.
 *
 * There are circumstances in which we can try to wake a task which has already
 * started to run but is not in state TASK_RUNNING. try_to_wake_up() returns
 * zero in this (rare) case, and we handle it by continuing to scan the queue.
 */
static int __wake_up_common(struct wait_queue_head *wq_head, unsigned int mode,
			int nr_exclusive, int wake_flags, void *key,
			wait_queue_entry_t *bookmark)
{
	wait_queue_entry_t *curr, *next;
	int cnt = 0;

	lockdep_assert_held(&wq_head->lock);

	if (bookmark && (bookmark->flags & WQ_FLAG_BOOKMARK)) {
		curr = list_next_entry(bookmark, entry);

		list_del(&bookmark->entry);
		bookmark->flags = 0;
	} else
		curr = list_first_entry(&wq_head->head, wait_queue_entry_t, entry);

	if (&curr->entry == &wq_head->head)
		return nr_exclusive;

	list_for_each_entry_safe_from(curr, next, &wq_head->head, entry) {
		unsigned flags = curr->flags;
		int ret;

		if (flags & WQ_FLAG_BOOKMARK)
			continue;

		ret = curr->func(curr, mode, wake_flags, key);
		if (ret < 0)
			break;
		if (ret && (flags & WQ_FLAG_EXCLUSIVE) && !--nr_exclusive)
			break;

		if (bookmark && (++cnt > WAITQUEUE_WALK_BREAK_CNT) &&
				(&next->entry != &wq_head->head)) {
			bookmark->flags = WQ_FLAG_BOOKMARK;
			list_add_tail(&bookmark->entry, &next->entry);
			break;
		}
	}

	return nr_exclusive;
}
```
具体的封装链为:

	wake_up->__wake_up->__wake_up_locked -> __wake_up_common->

当然，最后一个函数有些复杂.

好一个*TASK_NORMAL*这究竟是个什么东西？
```c
/*
 * Task state bitmask. NOTE! These bits are also
 * encoded in fs/proc/array.c: get_task_state().
 *
 * We have two separate sets of flags: task->state
 * is about runnability, while task->exit_state are
 * about the task exiting. Confusing, but this way
 * modifying one set can't modify the other one by
 * mistake.
 */

/* Used in tsk->state: */
#define TASK_RUNNING			0x0000
#define TASK_INTERRUPTIBLE		0x0001
#define TASK_UNINTERRUPTIBLE		0x0002
#define __TASK_STOPPED			0x0004
#define __TASK_TRACED			0x0008
/* Used in tsk->exit_state: */
#define EXIT_DEAD			0x0010
#define EXIT_ZOMBIE			0x0020
#define EXIT_TRACE			(EXIT_ZOMBIE | EXIT_DEAD)
/* Used in tsk->state again: */
#define TASK_PARKED			0x0040
#define TASK_DEAD			0x0080
#define TASK_WAKEKILL			0x0100
#define TASK_WAKING			0x0200
#define TASK_NOLOAD			0x0400
#define TASK_NEW			0x0800
#define TASK_STATE_MAX			0x1000

/* Convenience macros for the sake of set_current_state: */
#define TASK_KILLABLE			(TASK_WAKEKILL | TASK_UNINTERRUPTIBLE)
#define TASK_STOPPED			(TASK_WAKEKILL | __TASK_STOPPED)
#define TASK_TRACED			(TASK_WAKEKILL | __TASK_TRACED)

#define TASK_IDLE			(TASK_UNINTERRUPTIBLE | TASK_NOLOAD)

/* Convenience macros for the sake of wake_up(): */
#define TASK_NORMAL			(TASK_INTERRUPTIBLE | TASK_UNINTERRUPTIBLE)

/* get_task_state(): */
#define TASK_REPORT			(TASK_RUNNING | TASK_INTERRUPTIBLE | \
					 TASK_UNINTERRUPTIBLE | __TASK_STOPPED | \
					 __TASK_TRACED | EXIT_DEAD | EXIT_ZOMBIE | \
					 TASK_PARKED)
```
重点是**TASK_NORMAL**这个宏可以唤醒可中断和不可中断的TASK
