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
解释一下这个用法。当你在等待公交车的时候，第一辆到站的时间是上午5点半(it_value)，以后每隔半小时(it_interval) 就会有一辆公交车准时到达车站。这就是上面的结构体的简单的一句话总结。
 
请看下面的例子：

```c
#include<stdio.h>
#include<sys/time.h>
#include<signal.h>

/* 信号处理函数 */
/*
 *  也就是收到SIGALRM信号后执行的操作
 *
 */
void countdown(int signum)
{
	static int num = 10;
	printf("%d.. ", num--);
	fflush(stdout);
	if(num < 0){
		printf("DONE!\n");
		exit(0);
	}

}
/**
 * 以 毫秒(milliseconds)为参数，转化为整秒和微妙(microseconds)
 *
 */
int set_ticker(int n_msecs)
{
	struct itimerval new_timeset;
	long n_sec, n_usecs;

	n_sec = n_msecs / 1000; /* 整数部分 */
	n_usecs = (n_msecs % 1000) * 1000L; /* 余数部分 */

	new_timeset.it_interval.tv_sec = n_sec; /* 设置间隔的整秒 */
	new_timeset.it_interval.tv_usec = n_usecs; /* 设置间隔的微妙 */

	new_timeset.it_value.tv_sec = n_sec; /* 第一次到达的时间 */
	new_timeset.it_value.tv_usec = n_usecs; /* 保存 计时值*/

	return setitimer(ITIMER_REAL, &new_timeset, NULL);

}



int main()
{

	signal(SIGALRM, countdown);
	if( set_ticker(500) == -1)
		perror("set_ticker");
	else while(1)
		pause();
	return 0;
}
```

这里的`set_ticker`函数的参数500是us(you 秒)， 注意是怎么转换的。

再看些其他的例子：

### 1. 设置一个定时器，每2.5秒产生一个SIGALRM信号。

```c
	struct itimeival value;
	
	value.it_value.tv_sec = 2;
	value.it_value.tv_usec = 500000; /* 注意单位的转化*/
	
	value.it_interval.tv_sec = 2;
	value.it_interval.tv_usec = 500000;

	setitimer(ITIMER_REAL, &value, NULL);

```

### 2.设置一个定时器，进程在用户状态下执行1秒钟发出首次信号， 以后进程每在用户态执行3秒，发送一个信号

将itimerval结构的it_value赋值为1秒，将it_interval赋值为3秒即可

```c
	struct itimerval timer;

	timer.it_value.tv_sec = 1;
	timer.it_value.tv_usec = 0;

	timer.it_interval.tv_sec = 3;
	timer.it_interval.tv_usec = 0;

	setitimer(ITIMER_VIRTUAL, &timer, NULL);
```

### 3. 取消一个ITIMER_PROF类的定时器

将itimerval结构的成员it_value均赋值为0即可。

```c
	struct itimerval timer;
	
	timer.it_value.tv_sec = 1;
	timer.it_value.tv_usec = 0;

	setitimer(ITIMER_PROF, &timer, NULL);
```
### 4. 设置一个定时1.5秒的真实时间定时器，它仅发送一次信号就自动取消。

将itimerval结构的成员it_value均赋值为1.5秒，成员it_interval赋值为0秒即可

```c
	struct itimerval timer;

	timer.it_value.tv_sec = 1;
	timer.it_value.tv_usec = 500000;

	timer.it_interval.tv_sec = 0;
	timer.it_interval.tv_usec = 0;

	setitimer(ITIMER_REAL, &timer, NULL);
```

####  注意结构体内的微秒，第一个程序处理的规范

# 总结

一个计时器是内核的机制，一个Unix程序用计时器来挂起和调度将要发生的动作。通过这种方式，内核在一定的时间之后向进程发送SIGALRM,alarm系统调用在特定的实际秒数之后发送SIGALRM给进程.





