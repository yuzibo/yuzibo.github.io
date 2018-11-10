---
title: "unix中关于进程之wait的认识"
layout: post
category: unix
---

这篇文章介绍wait和exit的知识。

*[1.wait](#1)

*[1.1实例](#1.1)

*[1.2通信](#1.2)

*[2.exit](#2)

*[2.1实例](#2.1)

<h2 id="1">1.wait</h2>

系统调用wait做两件事，首先，wait暂停调用它的进程，直到子进程结束，然后，wait取得子进程结束时传递给exit的值。

```c
#include <stdio.h>
#include <stdlib.h>


#define DELAY 2

void child_code(int), parent_code(int);
int main()
{
	int newpid;

	printf("Before: mypid is %d\n", getpid());

	if ((newpid = fork()) == -1)
		perror("fork");
	else if (newpid == 0)
		child_code(DELAY);
	else
		parent_code(newpid);

}
void child_code(int delay)
{
	printf("child %d here, will sleep for %d seconds\n", getpid(), delay);
	sleep(delay);
	printf("child done ,about to exit\n");
	exit(17);
}
void parent_code(int childpid)
{
	int wait_rec; /* return value from wait() */
	wait_rec = wait(NULL);
	printf("done waiting for %d. Wait returned: %d\n", childpid, wait_rec);

}

```

注意这个wait，返回了子进程的某个值。

```bash
yubo@debian:~/test/tmp/unix$ ./test
Before: mypid is 21708
child 21709 here, will sleep for 2 seconds
child done ,about to exit
done waiting for 21709. Wait returned: 21709
yubo@debian:~/test/tmp/unix$
```


<h2 id="1.2">通信</h2>

wait的目的之一就是通知父进程子进程结束运行了，第二个目的是告诉父进程子进程是如何结束的。

一个进程以（成功、失败或死亡）之一来结束运行了。通常情况下，成功的程序调用exit（0）退出或者从main函数中return 0。

一个进程有可能内存不足导致执行失败，这个时候，unix的编程标准是给exit一个非0
的值，这样你就告诉程序员这个程序是由于何种的原因导致失败的。

最后一种就是进程有可能被被别的信号杀死。

wait返回结束的子进程的pid给父进程，父进程是如何知道子进程是以何种的方式退出的呢？

答案是传递给wait的参数之中。这个整型变量的地址传递给函数，由3部分构成--8位记录退出值，7位记录信号序号，还有一位是标识位：产生了内核镜像(code dump).

```c
#include <stdio.h>
#include <stdlib.h>

#define DELAY 5


void child_code(int );

void parent_code(int);

int main()
{
	int newpid;
	printf("Before, mypid is %d\n", getpid());

	if ((newpid = fork()) == -1)
		perror("fork");
	else if (newpid == 0)
		child_code(DELAY);
	else
		parent_code(newpid);

}

void child_code(int delay)
{
	printf("child %d here,will sleep for %d seconds\n",getpid(), delay);

	sleep(delay);

	printf("child done, about to exit\n");

	exit(17);
}

void parent_code(int childpid)
{
	int wait_rv;
	int child_status;
	int high_8, low_7, bit_7;

	wait_rv = wait(&child_status);

	printf("done waiting for %d,Wait returned: %d\n", childpid, wait_rv);
	high_8 = child_status >> 8; /** 1111 1111 0000 0000 */
	low_7 = child_status & 0x7f; /* 0000 0000 0111 1111 */
	bit_7 = child_status & 0x80; /* 0000 0000 1000 0000 */

	printf("status: exit  = %d, sig = %d, core = %d\n",high_8, low_7, bit_7);
}
```

第一次运行可以有以下结果：

```bash
yubo@debian:~/test/tmp/unix$ ./test
Before, mypid is 7711
child 7712 here,will sleep for 5 seconds
child done, about to exit
done waiting for 7712,Wait returned: 7712
status: exit  = 17, sig = 0, core = 0
```

这里大约会停顿5秒中的时间用来等待子进程。

第二次运行时要注意，另开一个后台，当运行这个程序时，看到子进程的pid时，立即回到另一个终端，kill child-pid，这时候你再看看返回的结果。

```bash
yubo@debian:~/test/tmp/unix$ ./test
Before, mypid is 7768
child 7769 here,will sleep for 5 seconds
done waiting for 7769,Wait returned: 7769
status: exit  = 0, sig = 15, core = 0

```

你可以将程序中的DELAY的值设置的大一些。


