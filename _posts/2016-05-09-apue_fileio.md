---
title: "unix文件 io"
layout: post
category: unix 
---

* content
{:toc}

# update 

随着时间的发展，看的书越来越多，需要进行重新归类了

2016-07-15 将apue的标题改为unix 文件 io，新增文件属性的内容。

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
这儿有一篇厉害的c的程序，不知道在讲些什么，但是还使用了od命令：
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

在函数create中，如果标志O_CREAT 和 O_EXCL也是表达的同样的意思。这里不是这个意思，好好理解去；

### dup 和dup2

```c
int dup(int fd);
int dup2(int fd, int fd2);
```
成功返回新的fd，失败-1.前者会分配最小的可利用的fd，后者将fd2的值作为返回的fd，如果fd2已经打开了，则先关闭它；如果参数1的fd与fd2相同，则返回fd2并保持打开状态。
如果熟悉fcntl函数的话，上面的函数分别等于以下代码段:

```c
fcntl(fd, F_DUPFD,0);和
close(fd);
fcntl(fd, F_DUPFD,fd2);
```
但是需要注意的是，dup2是原子操作，而close()和fcntl函数之间可能存在异步的风险。还有就是errno有可能不同的。

### sync,fsync, fdatasync

这几个函数是为了控制延时写，将缓存的数据放回磁盘中。

```c
#include<unistd.h>
int fsync(int fd);
int fdatasync(int fd);

void sync(void);

```
sync函数 以每隔30秒的周期从系统中调动，命令sync就是调用的这个函数。

fsync对于单个文件有效，且必须等待磁盘回写结束后才能返回。比如在数据库操作中
需要确认已修改的块已经被写回磁盘。

fdatasync仅对于文件中的数据部分，其他的没有影响。fsync对于文件属性也回写。

### fcntl

```c
#include<fcntl.h>
int fcntl(int fd, int cmd, .../* int arg */);
```
这个函数主要有5个方面的作用：

1. 复制一个存在的描述符（cmd = F_DUPFD 或者F_DUPFD_CLOEXEC）

2. 得到/设置文件描述符标志(cmd = F_GETFD 或者F_SETFD)

3. 得到/设置文件状态标志(cmd = F_GETFL或者F_SETFL)

4. 得到/设置异步io属性(cmd = F_GETOWN或者F_SETOWN)

5. 得到/设置记录锁(cmd = F_GETLK,F_SETLK或者F_SETLKW);


# 文件属性

## 磁盘文件的属性

### 缓冲

可以通过修改控制改变文件描述符的动作。通过3步来关闭磁盘缓冲。

1. 获取位置

2. 修改设置

3. 存储设置

代码如下：

```c
#include<fcntl.h>
int s;					// settings
s = fcntl(fd, F_GETFL)  //get flags 
s |= O_SYNC;			// set SYNC bit
result = fcntl(fd, F_SETFL, s); // set flags
if (result == -1)		// if error 
	perror("setting SYNC"); // report
```

文件描述的属性被编码在一个整数的位中。

上面的代码含义就是fd所指定的文件上，参数F_GETFL得到当前的位集，变量s存放这个
flag集， 位逻辑或操作打开位O_SYNC.该位告诉内核，对write的调用仅能在数据写入实际的硬件时才能返回，而不是在数据复制到内核缓冲时就执行默认的返回操作。

设置O_SYNC会关闭内核的缓冲机制。

### 自动添加模式

文件描述符的另一个属性是自动添加(auto-append mode)， 自动添加模式对于若干进
程在同一时间写入文件是很有用的,这里，使用的效果就是避免竞态。

说的简单一点就是，auto-append mode 就是当文件描述符属性O_APPEND打开后，每个
对write的调用自动调用lseek函数将内容添加到文件的末尾。

```c
#include <fcntl.h>
int s;					// settings
s = fcntl(fd, F_GETFL); // get flags 
s |= O_APPEND;			// set APPEND bit
result = fcntl(fd, F_SETFL, s); //set flags
if  (result == -1)			//IF ERROR
	perror("setting APPEND"); //report
else
	write(fd, &rec, 1); // write
```
也就是说当O_APPEND被设置的时候，lseek和write被打包成一个原子操作

open和write在执行一个文件描述符时有很多的选项。详细的请看联机手册。

## 终端连接的属性

### 读取tty驱动程序的属性

```c
#include <termios.h>
#include <unistd.h>
int result = tcgetattr(int fd, struct termios *info);
```

### 操作属性

```c
测试位			if(flagset & MASK)
置位			flagset |= MASK
清除位			flagset &= ~MASK
```

