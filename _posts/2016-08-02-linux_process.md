---
title: "linux中关于进程之fork()的认识"
layout: post
category: unix
---

好吧，开一系列介绍linux进程的文章，先从fork说起。

# fork()入门

fork()函数就是复制当前的进程创造一个新的进程，当前的进程叫做叫做父进程，复制产生的进程叫做子进程。

子进程复制父进程的一切资源，除了：

1 子进程具有独一无二的进程 pid,

2 子进程有一个父进程，其ID和创造这个进程(子进程)的id相同

进程调用fork后，内核将控制权交给两个进程。

先看代码，这里有点意思，程序的输出结果如果你不仔细分辨的，真的会让你想不到。

```c
#include<stdio.h>
#include<unistd.h>

int main()
{
	pid_t fpid; //表示fork()返回的值
	int count = 0;
	fpid = fork();

	if(fpid < 0)
		printf("error in fork!");
	else  if (fpid == 0){
		printf("I am the child process, my process id is %d\n", getpid());
		printf("I am son of my father\n");
		count ++;
	}
	else {
		printf("I am the parent process, my process id is %d \n", getpid());
		printf("I am father of my son\n");
		count++;
	}
	printf(" as a result: %d\n", count);
	return 0;
}
```

结果在我的机子上显示为;

```bash
I am the parent process, my process id is 10369
I am father of my son
 as a result: 1
root@yubo-2:~/test/unix_linux# I am the child process, my process id is 10370
I am son of my father
 as a result: 1
```

也就是说一个主程序在没有循环的情况下，居然有两个返回值，它是怎么做到的后来剖析，现在简单地分析下导致这种现象的原因.

#### fork的一个神奇之处就在于它仅仅调用一次，但是能够返回两次，而且可能有有三种不同的返回值

1 在父进程中，fork返回新创建子进程的进程id

2 在子进程中，fork返回0

3 fork返回一个负值，意味着fork创建失败。

看到网上说，进程经过fork()后形成了进程链，父进程的fpid指向子进程的进程id,因为子进程没有子进程(至少在这个程序中),所以其fpid为0.

fork()出错的原因可能有几下几种：

1 当前的进程数已经达到了系统规定的上限，这是errno的值为EAGAIN.

2 系统内存不足，这时errno的值为ENOMEM

两个进程的执行没有先后顺序，根据调度算法而已.

### 建立一个新的进程

```c
#include<stdio.h>
int main()
{
	int ret_from_fork, mypid;

	mypid = getpid();
	printf("Before: my pid is %d\n", mypid);

	ret_from_fork = fork();

	sleep(1);

	printf("After, my pid is %d, fork() said %d\n", getpid(), ret_from_fork);

}

```

结果如下所示：

![fork-1.png](http://yuzibo.qiniudn.com/fork-1.png)

注意第一段所说，fork调用是将原来的进程复制到新的进程，包括数据和程序，但是，新的程序是运行到当前程序行，并不会从整个程序的开头从头运行。这个图片中，原进程21635运行Before：后运行fork，启动了一个子进程，随后，进程21635接着进行，打印了After：，当进程21635消亡后，才转移到子进程，注意，子进程并不是从头开始的，而是从fork开始，也就是说，fork的Before不会打印，只执行After的语句。

		   p21636
		 |------->
	Before   |  After
	=========|=======> p21635
		fork


一个fork会产生2个进程，两个fork会产生4个进程，依次类推....

### 子进程创建进程

```c
#include<stdio.h>
int main()
{
	fork();
	fork();
	fork();
	printf("my pid is %d \n", getpid());
}
yubo@debian:~/test/tmp/unix$

```
结果如下所示：

![fork3.png](http://yuzibo.qiniudn.com/fork3.png)

### 分辨子进程和父进程

```c
#include<stdio.h>
int main()
{
	int fork_rv;

	printf("Before: my pid is %d \n", getpid());

	fork_rv = fork();

	if (fork_rv == -1)
		perror("Fork  failed\n");
	else if (fork_rv == 0)
		printf("I am the child, my pid is %d\n", getpid());
	else
		printf("I am the parent, my pid is %d\n", getpid());
}

```

![fork4.png](http://yuzibo.qiniudn.com/fork4.png)


# fork进阶

先上代码；

```c
#include<stdio.h>
#include<unistd.h>

int main()
{
	int i = 0;
	printf("i son/pa  ppid	pid  fpid\n");
	/* ppid 是当前进程的父进程pid,
	 * pid 是当前进程的pid
	 * fpid 是fork返回给当前进程的值
	 */
	for(i = 0; i < 2; i++){
		pid_t fpid = fork();
		if(fpid == 0)
			printf(" %d child %4d %4d %4d\n", i, getppid(), getpid(), fpid);
		else
			printf("%d parent %4d %4d %4d\n", i, getppid(), getpid(), fpid);
	}
	 return 0;
}
```

这是在我的机子上的结果：

```bash
root@yubo-2:~/test/unix_linux# ./test
i son/pa  ppid	pid  fpid
0 parent 11040 11508 11509
1 parent 11040 11508 11510
root@yubo-2:~/test/unix_linux#  1 child    1 11510    0
 0 child    1 11509    0
1 parent    1 11509 11511
 1 child    1 11511    0
```

仔细分析这个输入法，在 i = 0时，上面这个程序调用fork函数，系统中出现两个进程
p11508和p11509(p是进程的意思)，且p11508是p11509的父进程，p11040是p11508的父进程。因为对应的函数为： getpid(), fpid = fork(), getppod().即进程链p11040->p11508->p11509.


