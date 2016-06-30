---
title: "c下实现who和more命令"
layout: article
category: c 
---

# 代码不是重点，重点是陌生的东西

[who](!https://github.com/yuzibo/linux-programming/blob/master/unix_linux_programming/who1.c)

首先，推荐一本好书：<<understanding unix-linux programming>>,以下所有的灵感来自于这本书。

这里，重点记忆如下：

### 如何寻找有用的信息

充分利用man的联机文档，技巧有

> man -k key-word | grep "xx"

这样可以有效抓取你想要的联机帮助。运气好的话可能会有code,要多多阅读、仔细阅读。

例如在这段代码中，首先 man who,结果可以知道，这个命令读取的是/var/run/utmp文件，接下来，使用

```bash 
man -k utmp 
```

可以看到一大堆的东西，学会甄别。

### open和close read

其实光知道概念意义不大，必须还会使用，这些命令的实现的价值也在于此。

```c
int main(){
	struct utmp current_record;
	int	utmpfd;
	int	reclen = sizeof(current_record);
	if( ( utmpfd = open(UTMP_FILE,O_RDONLY)) == -1){
		perror(UTMP_FILE); /* UTMP_FILE is in utmp.h*/
		exit(1);
	}
	while(read(utmpfd, &current_record,reclen) == reclen)
		show_info(&current_record);
	close(utmpfd);
	return 0;
}
```
令人震撼的是read的实现，因为你不必实现知道要写入的结构、类型,只需要事先将结构定义好，然后按照read的使用要求就可以了。

### time_t 

这里是有很多的坑要填的。

```c

  struct {
                   int32_t tv_sec;           /* Seconds */
                   int32_t tv_usec;          /* Microseconds */
               } ut_tv;                      /* Time entry was made */
```

然后使用ctime函数:

```c
#define UT_TIME_MEMBER(UT_PTR) ((UT_PTR)->ut_tv.tv_sec)

void show_time(struct utmp *utmpfd)
{
	time_t tm = UT_TIME_MEMBER(utmpfd);
	char *ptr =  ctime(&tm) + 4;
	ptr[16] = '\0';
	printf("%s",ptr);

/*	int len = strlen(ptr);
 *	printf("The length of time is %D\n",len);
 */
}
```

如果这时对time_t类型的数据进行总结，还达不到那个程度，先简单的记录下来进行备案。

还有，一定要充分利用gdb的调试功能，就是在调这个程序的时候，一直在报段错误，其实是根本就没有编译过去，因为少了一个time.h文件，但是我的Makefile的gcc编译语句没有体现出来。
