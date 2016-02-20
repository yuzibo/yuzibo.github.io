---
layout: article
title: "linux信号浅析"
category: linux
---

# 信号的种类

### 可靠信号
可靠信号就是实时信号

### 非可靠信号
非可靠信号就是非实时信号,凡位于[SIGRTMIN, SIGRTMAX]区间的都是可靠信号.

非可靠信号一般都有明确的用途和含义,可靠信号则可以让用户自己定义使用.

# 信号的安装

### 系统调用 signal

#include<signal.h>
void (*signal(int signum, void (*handler))(int))(int);

`signum` 指定要安装的信号,handler指定信号处理的函数.

该函数的和返回值是一个函数指针,指向上次安装的handler.

## 经典安装方式
```
if(signal(SIGINT,SIG_IGN) != SIG_IGN){
	signal(SIGINT, sig_handler);
}
```

先获得上次的handler,如果不是忽略信号,就安装此信号的hndler.
由于信号被交付后,系统自动的重置handler为默认动作,为了使信号在handler处理期间,仍能对后继信号作出反应,往往在handler的第一条语句再次调用 signal
<pre>
sig_handler(int signum){
	/*  reinstall signal */
	signal(signum, sig_handler);
	...
}
</pre>
我们知道在程序的任意执行点上, 信号随时可能发生, 如果信号在sig_handler重新安装
信号之前产生, 这次信号就会执行默认动作, 而不是sig_handler. 这种问题是不可预料的.

## 库函数sigaction
使用sigaction安装信号的动作后,该动作一直保持,直到另一次调用sigaction建立另一个动作为止.这就克服了古老的signal调用存在的问题.

<pre>
#include <signal.h>

       int sigaction(int signum, const struct sigaction *act,
		                            struct sigaction *oldact);
</pre>

`signum`  除了SIGKILL和SIGSTOP以外的参数都正确

`act` 如果act非空,那么来自act的信号就是传提给signum的.

`oldact` 如果oldact非空,那么oldact就保存前一个信号(?)

The sigaction structure is defined as something like:
<pre>
           struct sigaction {
	                  void     (*sa_handler)(int);
	                  void     (*sa_sigaction)(int, siginfo_t *, void *);
	                  sigset_t   sa_mask;
	                  int        sa_flags;
	                  void     (*sa_restorer)(void);
	              };
</pre>
/* 设置SIGINT */
<pre>
action.sa_handler = sig_handler;
sigemptyset(&action.sa_mask);
sigaddset(&action.sa_mask, SIGTERM);
action.sa_flags = 0;
/* 获取上次的handler,如果不是忽略动作,则安装信号 */
sigaction(SIGINT, NULL,&old_action);
if (old_action.sa_handler != SIG_IGN){
	sigaction(SIGINT, &action, NULL);
}
</pre>
基于 sigaction 实现的库函数: signal
sigaction 自然强大, 但安装信号很繁琐, 目前linux中的signal()是通过sigation()函数
实现的，因此，即使通过signal（）安装的信号，在信号处理函数的结尾也不必
再调用一次信号安装函数。

# 如何屏蔽信号
首先是信号集的API
<pre>
int sigemptyset(sigset_t *set);
int sigfillset(sigset_t *set);
int sigaddset(sigset_t *set,int signum);
int sigdelset(sigset_t *set,int signum);
int sigismember(const sigset_t *set, int signum);
int sigsuspend(const sigset_t *mask);
int sigpending(sigset_t *set);
</pre>
`int sigprocmask(int how, const sigset_t *set, sigset_t *oldset);`

这个函数检查和改变被阻塞的函数,操作主要有三种:

`SIG_BLOCK` 在进程当前阻塞信号集中添加set指向信号集中的信号;

`SIG_UNBLOCK` 如果进程阻塞信号集中包含set指向信号集中的信号,则解除对该信号的阻塞.

`SET_SETMASK` 更新进程阻塞信号集为set指向的信号集



[reference](http://kenby.iteye.com/blog/1173862)
