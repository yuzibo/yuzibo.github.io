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
