---
title: "linux中关于进程之wait的认识"
layout: article
category: unix
---

这篇文章介绍wait和exit的知识。

*[1.wait](#1)

*[1.1实例](#1.1)

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



