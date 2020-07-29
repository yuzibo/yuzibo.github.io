---
title: c++之thread基础介绍
category: c++
layout: post
---
* content
{:toc}

# 写在前言
thread应该是c++的高级特性了，初学者基本涉及不到对该特性的掌控。
但是目前在工作中已经涉及到了，早点记录下来有助于自己的进步。

提前说明一点，在linux下c++的多进程多依赖pthread库，所以如果以
命令行的形式编译thread相关的程序，需要手动指定pthread的库。例如

```
g++ -g bar.cpp -o bar -lpthread -std=c++11
```

# 概念入门
这里借花献佛[here](https://www.cnblogs.com/yssjun/p/11533346.html)
更强悍的[资料](https://computing.llnl.gov/tutorials/pthreads/)
从学习的路线图来说，使用多线程编程，需要对并行编程(parallel program)有
一个基本的[了解](https://computing.llnl.gov/tutorials/parallel_comp/)

# thread management
首先借助一个例子:
```c
#include <unistd.h>
#include <pthread.h>

void printids(const char *s){
	pid_t pid;
	pthread_t tid; // thread id
	pid = getpid();
	tid = pthread_self();
	printf("%s pid %u tid %u (0x%x)\n", s, (unsigned int)pid,
			(unsigned int)tid, (unsigned int)tid);
}
void *rhr_fn(void *arg){
	printids("new thread:");
	return NULL;
}

int main(){
	int err;
	pthread_t ntid;
	err = pthread_create(&ntid, NULL, rhr_fn, NULL);
	if (err != 0)
		printf("can not create new thread");
	printids("main thread:");
	pthread_join(ntid, NULL);
	return 0;
}
```

在涉及到thread相关的事务时，我们最好使用另一个计算机词汇去进行描述:`routines`.

## routines
```c
pthread_create();
pthread_exit(status);
pthread_cancel(thread);
pthread_attr_init(attr);
pthread_attr_destroy(attr);
```
### pthread_create
所有的routines(与thread相关)都是从`main()`函数开始的。`pthread_create`
就是用来创建新的thread并执行它。其中有四个参数：
1. thread : 子线程的标识符
2. attr： thread 的属性值，如果NULL的话则为默认值。
3. start_routine: 由刚才创建thread执行的c routine。
4. arg: 作为start_routine的参数，而且必须使用`void (*)`的形式传递，可以使用NULL
作为默认参数。

### limit
limit可以查看一个进程最多可以创建多少线程。 `ulimit -Hu`


### Thread Attributes
`pthread_attr_init`和`pthread_attr_destroy`分别作为与pthread_attr相关的生死函数。
大体上来说，thread相关的属性包括:
1. Detached or joinable state
2. Scheduling inheritance
3. Scheduling policy
4. Scheduling parameters
5. Scheduling contention scope
6. Stack size
7. Stack address
8. Stack guard (overflow) size

BTW, 这里与thread相关的调度算法包括:FIFO,RR(round-robin),OTHER(OS)

### Terminateing thread
`pthread_exit()`主要负责这件事。那么什么情况下可以终止thread呢？
1. 完成工作，thread正常从start routine返回
2. thread主动调用pthread_exit,不管工作完成的怎么样
3. 有其他子routine调用pthread_cancled routine
4. 入口进程(entire process)调用了 exec()或者 exit()
5. main()已经退出，但是没有清晰定义pthread_exit.

### 例子
```c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>

#define NUM_THREADS 5

void *print_hello(void *threadid){
	long tid;
	tid = (long) threadid;
	printf("hello, world, It is me, thread #%ld!\n", tid);
	pthread_exit(NULL);
}
int main(){
	pthread_t threads[NUM_THREADS];
	int rc;
	long t;
	for (t = 0; t < NUM_THREADS; t++){
		printf("In main, Createing the thread %ld\n", t);
		rc = pthread_create(&threads[t], NULL, print_hello, (void *)t);
		if (rc){
			printf("error: %d\n", rc);
			exit(-1);
		}
	}
}
```
我们来看一下结果：
```bash
vimer@host:~/src/test/c++/thread$ gcc -g thread_create.c -o test -pthread 
vimer@host:~/src/test/c++/thread$ ./test 
In main, Createing the thread 0
In main, Createing the thread 1
hello, world, It is me, thread #0!
In main, Createing the thread 2
hello, world, It is me, thread #1!
In main, Createing the thread 3
hello, world, It is me, thread #2!
In main, Createing the thread 4
hello, world, It is me, thread #3!
vimer@host:~/src/test/c++/thread$ ./test 
In main, Createing the thread 0
In main, Createing the thread 1
In main, Createing the thread 2
hello, world, It is me, thread #0!
hello, world, It is me, thread #1!
hello, world, It is me, thread #2!
In main, Createing the thread 3
In main, Createing the thread 4
hello, world, It is me, thread #3!
hello, world, It is me, thread #4!
```
看看，thread的id是不一样的。


