---
title: "apue之文件io"
layout: article
category: apue
---

# 点滴记录apue的学习
这一章简单记录有关文件io的操作，大概提一点，这块的函数返回值不成功的话返回值
为-1。

相关的练习题放在[github](https://github.com/yuzibo/Apue/tree/master/cha3-fileIO)

### open

```c
#include <fcntl.h>
int open(const char *path,int oflag,...);
int openat(int fd,const char *path,int oflag...);
```
错误的话就会返回"-1"
尤其注意几个标志，它控制了你要打开的文件的方式。举几个例子，

```c
O_RDONLY : open for reading only;
O_WRONLY : open for writing only;
O_RDWR	 : OPEN FOR READING AND writing
O_EXEC	 : 
O_SEARCH :
```
这些标志放在了<fcntl.h>中，还有其他的，等到有新的认识，再补充上。这几个标志
位还可以使用"|"的形式一起使用。

### create

```c
#nclude <fcntl.h>
int create(const char *path, mode_t mode);

```
这儿有一篇有厉害的c的程序，不知道在讲些什么，但是还使用了od命令：
上面代码库中的creat.c,真的不知道在讲些什么！！

### close

```c
#include <unistd.h>
int close(int fd);
/*
 * error return -1
 */

```

这个函数的作用是关闭已打开文件描述符。当关闭一个文件时，这个文件会自动释放在
它身上的锁；当一个进程终止时，内核会自动释放相关的文件。

## 注意，两个函数的头文件不一样

### lseek

```c
#include <sys/types.h>
#include <unistd.h>
off_t lseek(int fd,off_t offset,int whence);
/*   error on -1 */
```
其中参数列表中offset与第三个参数有关,若第三个参数为下列值：

>SEEK_SET: 则文件的偏移量设置为从文件开始处offset的地方；

>SEEK_CUR: 偏移量为现在的值加上offset，可正可负；

>SEEK_END: 偏移量为整个文件的大小记上offset，可正可负；

函数的返回值为文件重新标定后的偏移量。所以，在有些机器上，返回值可能是负的
所以即使读取成功了有可能是-1，特别重要这一点·``

### read

```c
#include <unistd.h>
ssize_t read(int fd, void *buf,size_t bbytes);
```
返回值是读取的字节数，0读到文件尾，-1读出错了。

### write 

```c
#include <unistd.h>
ssize_t write(int fd, const void *buf,size_t nbytes);

```
返回的是写入文件的字数，如果错误返回-1.

标准输入输出STDIN_FILEIN,有这个标志，就可以使用标准输入了。

### 文件分享
简单地说，这类文件有三类：

1. process table entry 在进程表中有一个表项，里面有文件描述符（包括fd的标志和一个指向文件的指针）。这里的fd flag没有搞明白具体是啥含义。

2. file table entry: 这个表里的项是来自于上面的一个指向，在这个表中，
有三个域a.这个文件的状态：读、写、追加、同步...b.文件的偏移位置。c.一个指向
v-node的指针；

3.这v-node 是一个链表，里面有文件的类型、在这个文件上的函数指针，在linux上这
里是有i-node结构，里面包括文件的作者、文件的大小、文件指向实际块的指针；

#### 重点，如果两个进程共享一个文件，那么，是如何指向的呢？这里的共享，是针
对v(i)-node 的共享，不是对前1、2两种情况的分享；主要原因是每个进程要控制自己
在文件中的偏移量。

在这种情况下，有三种类型的操作需要我们分别：

>write.

每次执行完成后，在file table entry中偏移量需要增加写入的个数；如果大于文件的大小，那么在i-node中设置现在文件的偏移量？

> O_APPEND 

如果打开的文件设置为O_APPEND,那么file table entry的偏移量会从 i-node的偏移量中选取后设置；

> lseek

与O_APPEND原理相似，但不一样！！！

这个标志，仅仅修改文件指针的偏移位置，没有任何I/O操作。

有可能在file table entry中被不止一个文件描述符所指向，尤其是在执行完fork命令后，父进程和子进程就会共享一个file table entry。

1的flag为与2的status的区别在于前者仅仅局限于单一进程中，后者对所有的进程的开放。

### 原子操作

```c
#include <unistd.h>
ssize_t pread(int fd, void *buf, size_t nbytes, off_t offset);

ssize_t pwrite(ing fd, const void *buf, size_t nbytes, off_t offset);

```
两个函数成功后都会返回相应的字节数，0文件结尾， -1错误。

pread 是在lseek后立即执行read操作；pwrite是相同的结果。

在以下两种情况下，最好使用这个方法：

1. 两个操作之间没有中断

2. 目前的偏移没有更新

在函数creat中，如果标志O_CREAT 和 O_EXCL也是表达的同样的意思。这里不是这个意思，好好理解去；

### dup 和dup2

```c
int dup(int fd);
int dup2(int fd, int fd2);
```
成功返回新的fd，失败-1.前者会分配最小的可利用的fd，后者将fd2的值作为返回的fd，如果fd2已经打开了，则先关闭它；如果参数1的fd与fd2相同，则返回fd2并保持打开状态。
