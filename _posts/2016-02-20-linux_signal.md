---
layout: article
title: "linux信号浅析"
category: unix
---
!(linux 中关于信号的资源)[http://www.thegeekstuff.com/2012/03/linux-signals-fundamentals/] 

# 信号是什么

信号就是一个软中断(software interrupts)。 一个健壮的程序必须需要处理信号，信号是向应用程序传递异步事件的方式。

一个用户按下ctrl+c 就是向另一个程序发送信号

# 信号从哪里来

### 用户

用户通过Crtl-C、Crtl-\等键或者通过驱动终端程序来请求内核产生信号。

### 内核

当进程执行出错时，内核给进程发送一个信号，比如，非法存取段、浮点数溢出、
或者一个非法的机器指令。内核也利用信号通知进程特事件的发生。

### 进程
一个进程可以通过系统调用kill给另一个进程发送信号。一个进程可以可以和另一个
进程通过信号通信。

由进程的某个操作产生的信号被称为同步信号，例如，被零除；像用户击键这样的进程外
的事件引起的信号称之为异步信号。

# 进程处理

### 接受默认处理(通常是消亡)

使用以下调用来恢复默认处理


```c
	signal(SIGINT, SIG_DFL);

```

### 忽略信号
程序可以通过以下调用来告诉内核，它需要忽略SIGINT的信号

```c
signal(SIGINT, SIG_IGN);
```

如果产生像除以0的致命错误、SIGKILL和SIGSTOP不能被忽略。

后两个信号供root用户拥有杀死任何进程的权利。

### 调用另一个程序(捕捉)
程序在接收到SIGINT后，调用一个恢复设置的函数

```c
	signal(SIGALRM, handler);
```

补充一下最后一点,捕捉信号的函数应该是可重入的。在解释这个原因前，让我们首先了解下什么是可重入。一个可重入的函数是一个函数在执行的过程的可以因为某些原因被停止下来(比如中断或者信号)，在完成了某项任务后可以返回继续执行原来的程序。原因很简单，当一个程序正在执行的时候，信号发生(捕捉另一个信号)，进程转而执行其他的程序，如果这个时候正好宿主程序的全局变量和被呼叫的程序的变量同名的话，那么，当子进程执行完毕后返回宿主进程中，会产生意想不到的结果

# 信号的种类

### 可靠信号
可靠信号就是实时信号

### 非可靠信号
非可靠信号就是非实时信号,凡位于[SIGRTMIN, SIGRTMAX]区间的都是可靠信号.

非可靠信号一般都有明确的用途和含义,可靠信号则可以让用户自己定义使用.

# 信号的安装

### 系统调用 signal

```c
#include<signal.h>

void (*signal(int signum, void (*handler))(int))(int); 

```



`signum` 指定要安装的信号,handler指定信号处理的函数.

该函数的和返回值是一个函数指针,指向上次安装的handler.

## 经典安装方式
<pre>
if(signal(SIGINT,SIG_IGN) != SIG_IGN){
	signal(SIGINT, sig_handler);
}
</pre>

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

# 库函数sigaction
使用sigaction安装信号的动作后,该动作一直保持,直到另一次调用sigaction建立另一个动作为止.这就克服了古老的signal调用存在的问题.

```
#include <signal.h>
int sigaction(int signum, const struct sigaction *act,
		struct sigaction *oldact);
```

`signum`  除了SIGKILL和SIGSTOP以外的参数都正确

`act` 如果act非空,那么来自act的信号就是传提给signum的.

`oldact` 如果oldact非空,那么oldact就保存前一个信号(?)

The sigaction structure is defined as something like:

{% highlight c %}
struct sigaction {
	                  void     (*sa_handler)(int);
	                  void     (*sa_sigaction)(int, siginfo_t *, void *);
	                  sigset_t   sa_mask;
	                  int        sa_flags;
	                  void     (*sa_restorer)(void);
	              };

{% endhighlight %}
/* 设置SIGINT */
{% highlight c %}
action.sa_handler = sig_handler;
sigemptyset(&action.sa_mask);
sigaddset(&action.sa_mask, SIGTERM);
action.sa_flags = 0;
/* 获取上次的handler,如果不是忽略动作,则安装信号 */
sigaction(SIGINT, NULL,&old_action);
if (old_action.sa_handler != SIG_IGN){
	sigaction(SIGINT, &action, NULL);
}
{% endhighlight %}

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



# singal.h

我们先看singal函数的声明：

```c
void (*signal(int sig_num,void(*handler)(int))) (int)
```
你必须弄明白声明才可以运用自如。

这是一个函数指针(void (\*fun)(int)),这样就好看多了吧，它与指针函数(int \*fun())极易混淆。你可以这样记忆，
()的优先级比\*要高，(\*fun())是函数在先，所以整体加上 * 就是指针函数了;(void (\*fun)(int)),由于两个括号是相同等级的，
那么先出现的就是指针了((\*fun)),再加上后面的就是指针函数了。^_^

言归正传，一般的函数指针的声明为:

```c
void (*fp)(int)
```
这里的参数类型可以去掉的。那么，这里的fp相当于singal函数声明中的

```c
signal(int sig_num, void(*handler)(int))
```

函数名signal，参数列表包括一个整型值和一个函数指针，这个函数指针是

```c
void(*handler)(int)
```
我们来对照一个代码段的例子来说明这个比较有意思的话题。

```c
#include <signal.h>
#include <stdio.h>
void handler(int s)
{
	if (SIGBUS == s) printf("now got a bus error signal\n");
	if (SIGSEGV == s) printf("now got a segmentation violation signal\n");
	if (SIGILL == s) printf("Now got an illegal instruction siganl\n");
	exit(1);
}
int main(){
	int *p = NULL;
	signal(SIGBUS,handler);
	signal(SIGSEGV,handler);
	signal(SIGILL,handler);
}
```
说明一下，最好使用信号名称去捕捉信号，因为在不同的系统上信号值是不一样的。关键看看后面的handler的实现。

# 信号的基本概念
