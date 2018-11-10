---
title: "c下实现who和more命令-time"
layout: post
category: unix 
---

# 代码不是重点，重点是陌生的东西

[who](https://github.com/yuzibo/linux-programming/blob/master/unix_linux_programming/who1.c)

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


# time 相关

### time

```c
#include <time.h>

time_t time(time_t *t);


```

功能： 以秒(seconds)为单位得到自从the Epoch的时间。

If t  is non-null, the return value is also stored in the memory pointed to by t.

### time_t 

这里是有很多的坑要填的。相关的代码[在](https://github.com/yuzibo/linux-programming/tree/master/unix_linux_programming/time)

```c

  struct {
                   int32_t tv_sec;           /* Seconds */
                   int32_t tv_usec;          /* Microseconds */
               } ut_tv;                      /* Time entry was made */
```

### timeval

```c
 struct timeval {
               time_t      tv_sec;     /* seconds */
               suseconds_t tv_usec;    /* microseconds */
           };
```
### tm

```c
struct tm {
               int tm_sec;        /* seconds */
               int tm_min;        /* minutes */
               int tm_hour;       /* hours */
               int tm_mday;       /* day of the month */
               int tm_mon;        /* month */
               int tm_year;       /* year */
               int tm_wday;       /* day of the week */
               int tm_yday;       /* day in the year */
               int tm_isdst;      /* daylight saving time */
           };

```
需要特别注意的是，年份是从1970年01月01日0:00:00开始计算的。

这就是在处理有关时间的问题时，经常打交道的三个结构体。

# 相关的时间函数

接下来是几个比较容易常用的有关时间的函数：

### char *strptime()

```c
#include <time.h>
char *strptime(const char *s, const char *format,struct	tm *tm);

```
功能： 将一个字符串的时间表达式转化进tm结构体。

这里要注意一下第二个参数，因为有些麻烦，所以最好是需要用的时候man一下。
这个函数在使用的时候，必须首先初始化一下tm。


### size_t strftime()

```c
size_t strftime(char *s, size_t max, const char *format,
		        const struct tm *tm);
```

功能： 格式化日期和时间(format data and time),其相关的信息来自于tm，第三个参
数和strptime函数类似，用的时候联机man 一下。

举个例子测试下：

```c
/*
 *          $ ./a.out '%m'
 *          Result string is "11"
 *          $ ./a.out '%5m'
 *          Result string is "00011"
 *          $ ./a.out '%_5m'
 *          Result string is "   11"
 */
       Here is  the program source:

       #include <time.h>
       #include <stdio.h>
       #include <stdlib.h>

       int
       main(int argc, char *argv[])
       {
           char outstr[200];
           time_t t;
           struct tm *tmp;

           t = time(NULL);
           tmp = localtime(&t);
           if (tmp == NULL) {
               perror("localtime");
               exit(EXIT_FAILURE);
           }

           if (strftime(outstr, sizeof(outstr), argv[1], tmp) == 0) {
               fprintf(stderr, "strftime returned 0");
               exit(EXIT_FAILURE);
           }

           printf("Result string is \"%s\"\n", outstr);
           exit(EXIT_SUCCESS);
       }
```
 上面的注释将这段代码的功能描述的很清楚，也就是用'%Y'等格式化来当前时间关键
 字段的输出。

将这两段程序综合起来看，就明白了

```c
 #define _XOPEN_SOURCE
       #include <stdio.h>
       #include <stdlib.h>
       #include <string.h>
       #include <time.h>

       int
       main(void)
       {
           struct tm tm;
           char buf[255];

           memset(&tm, 0, sizeof(struct tm));
           strptime("2016-07-06 18:31:01", "%Y-%m-%d %H:%M:%S", &tm);
           strftime(buf, sizeof(buf), "%d %b %Y %H:%M", &tm);
           puts(buf);
           exit(EXIT_SUCCESS);
       }



```
其结果是：

>06 Jul 2016 09:53

### char *asctim3(),char *ctime(),struct tm *gmtime(),struct tm *localtime(), struct mktime()

```c
#include <time.h>
char *asctime(const struct tm *tm);
char *asctime_r(const struct tm *tm, char *buf);

char *ctime(const time_t *timep);
char *ctime_r(const time_t *timep, char	*buf);

struct tm *gmtime(const time_t *timep);
struct tm *gmtime_r(const time_t *timep, struct tm *result);

struct tm *localtime(const time_t *timep);
struct tm *localtime_r(const time_t *timep, struct tm *result);

time_t mktime(struct tm *tm);

```

功能：

The  ctime(), gmtime() and localtime() functions all take an argument of 
data type time_t which represents calendar time.  When interpreted
as an absolute time value, it represents the number of seconds elapsed 
since the Epoch, 1970-01-01 00:00:00 +0000 (UTC).

The asctime() and mktime() functions both take an argument representing broken-down time which is a  representation  separated  into  year,month, day, etc.

### ctime()

The call ctime(t) is equivalent to asctime(localtime(t)).  It converts the calendar time t into a null-terminated string of the form

>              "Wed Jun 30 21:49:08 1993\n"

简单说一下就是将日历时间(calendar time t)转化为如上的字符串格式，这个
calendar time t,应该就是time_t 类型，其中记录了从 1970年01月01日0:00:00开始的时间。

#### 注意，这几个后缀为_r的是可以返回到用户自定义的字符串中。

### gmtime()

转为为UTC(Coordinated Universal Time)

### localtime()

转为为用户所在的时区的时间表达形式.

### asctime()

将形式为tm成员的时间表达式转化成类似于ctime 的形式。

### mktime()

将零碎的tm成员的时间表达式转化为local time，也是以calendar的形式。



# 简单的使用

### 版本1
```c
#include<stdio.h>
#include<time.h>
int main(){
	time_t timep;
	time(&timep); /* 获取time_t 类型的当前时间  */
	printf("%s\n",asctime(gmtime(&timep)));
	/* 使用gtime将time_t类型的时间转换为
	 * struct tm类型的时间，然后再用asctime转换为
	 * 我们常见的格式: Fri Wed Jul  6 05:40:11 2016
	 *
	 */
	return 0;

}


```
输出结果为：

>Wed Jul  6 05:45:15 2016
 
### 版本2

```c
#include<stdio.h>
#include<time.h>
int main(){
	time_t timep;
	time(&timep); /* 获取time_t类型的当前时间*/
	printf("%s\n",ctime(&timep));
	/*转换为常见的字符串 Wed Jul  6 01:49:11 2016 */
	return 0;

}


```

输出结果：

>Wed Jul  6 01:51:54 2016

我在验证这两个程序的时候，时间间隔不会超过20分钟，所以，我们看到后者与我现在
的时间时区是一样的。因为我是在vps验证的，经过date命令的输出，我发现ctime函数
与date的输出是一致的。那么，我是否可以认为ctime函数经过了时区处理?

```bash
root@hehe:~/test/unix_linux# date
2016年 07月 06日 星期三 01:54:28 EDT
```

### 版本3

```c
#include<stdio.h>
#include<time.h>
int main(){
	char *wday[] = {"Sun", "Mon","Tue","Wed","Thu","Fri","Sat"};
	time_t timep;
	struct tm *p;

	time(&timep); /*获得time_t结构的时间， UTC时间*/
	p = gmtime(&timep); /*转化为 struct* tm 结构的时间 */
	printf("%d/%d/%d\n",1900 + p->tm_year, 1 + p->tm_mon, p->tm_mday);

	printf("%s %d:%d:%d\n",wday[p->tm_wday], p->tm_hour, p->tm_min,p->tm_sec);
	return 0;
}

```

输出的结果为:

```c
2016/7/6
Wed 6:16:20
```
这个结果与版本1相类似

### 版本4

```c
#include<time.h>
int main()
{
	char *wday[] = {"Sun", "Mon", "Tue", "Wed","Thu", "Fri", "Sat"};
	time_t timep;
	struct tm *p;

	time(&timep);/*获得time_t结构的时间，UTC时间 */
	p = localtime(&timep);
	printf("%d/%d/%d\n", 1900 + p->tm_year, 1 + p->tm_mon, p->tm_mday);
	printf("%s %d:%d:%d\n",wday[p->tm_wday], p->tm_hour, p->tm_min, p->tm_sec);
	return 0;

}


```

输出结果为:

```c
2016/7/6
Wed 2:57:55

```

与版本2的结果类似。

# 这个程序中使用到函数

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
