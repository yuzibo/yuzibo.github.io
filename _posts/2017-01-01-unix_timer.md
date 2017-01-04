---
title: "unix中计时器的应用"
layout: article
category: unix
---

# 简介
在<<Unix/Linux编程实践>>中第7章中，介绍了计时器的简单应用。简单的介绍下。

# 三种计时器

### ITIMER_REAL

这个计时器是真实计时器，也就是程序不管在用户态还是核心态用了多少处理器时间它都记录，
当这个计时器用尽，发送SIGALRM信号。

### ITIMER_VIRTUAL

这个计时器仅仅记录程序在用户态运行时的空间，类似于我们在篮球比赛中看到的，死球期间的
时间不记录在比赛时间内。这个计时器用完发送SIGVTALRM信号。

### ITIMER_PROF

这个计时器在这本书里被描绘成睡眠时态(用户+核心态),并不是核心态，（？）当这个计时器用尽，
会发送SIGPROF信号。

# 设置

函数alarm只能设置到以秒为单位的，想要使用更精确的时间，要精通以上时间计时器的精通

## 两种间隔

```c

struct itimeival{
	struct timeval it_interval; /* next value 重复间隔 */
	struct timeval it_value; /* current value 初始时间  */
}

struct timeval {
	long tv_sec; /* seconds */
	long tv_usec; /* 微妙 */

}
```
解释一下这个用法。当你在等待公交车的时候，第一辆到站的时间是上午5点半(it_value)，以后每隔半小时(it_interval)
就会有一辆公交车准时到达车站。这就是上面的结构体的简单的一句话总结。


