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
