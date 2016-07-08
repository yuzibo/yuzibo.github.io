---
title: "ls命令的实现"
layout: article
category: unix
---

关于对单个文件的操作，应该关注这篇[文章](http://yuzibo.github.io/apue_ch4.html)

# 如何读取目录的内容

首先在联机帮助中寻找关键字direct来查找。

> man -k direct | grep read

这样就被指引到了readdir这个函数中，在这里面的说明文档，有以下内容

```c
   #include <dirent.h>

       struct dirent *readdir(DIR *dirp);

       int readdir_r(DIR *dirp, struct dirent *entry, struct dirent **result);

```

这个函数返回DIR *dir记录中的下一条目录项。

在linux上，dirent结构体的内容如下:

```c
struct dirent {
               ino_t          d_ino;       /* inode number */
               off_t          d_off;       /* offset to the next dirent */
               unsigned short d_reclen;    /* length of this record */
               unsigned char  d_type;      /* type of file; not supported
                                              by all file system types */
               char           d_name[256]; /* filename */
           };


```

其中的d_type的选项为:

```c
       DT_BLK      This is a block device.

       DT_CHR      This is a character device.

       DT_DIR      This is a directory.

       DT_FIFO     This is a named pipe (FIFO).

       DT_LNK      This is a symbolic link.

       DT_REG      This is a regular file.

       DT_SOCK     This is a Unix domain socket.
		 
	   DT_UNKNOWN  The file type is unknown.
```

那么，与文件的操作相比较，还得有opendir，closedir等操作。

# ls 的实现

那么，ls的算法如下：

```c
main()
	opendir
	while(readdir)
		print d_name
	closedir
```

那么，先看看v1.0是怎么实现的。

```c
/*
 * ls.c: implement of ls command
 */

#include<stdio.h>
#include<sys/types.h>
#include<dirent.h>

void do_ls(char *);
int main(int argc, char *argv[])
{
	if( argc == 1)
		do_ls(".");
	else
		while(--argc){
			printf("%s:\n",*++argv);
			do_ls(*argv);

		}

}
void do_ls(char *dirname )
{
	/*
	 * list files in directory called dirname
	 */
	DIR *dir_ptr; /* the directory */
	struct dirent *direntp; /* each entry */

	if ((dir_ptr = opendir(dirname)) == NULL)
		fprintf(stderr, "ls1;cannot open %s\n",dirname);
	else
	{
		while((direntp = readdir(dir_ptr)) != NULL)
			printf("%s\n",direntp->d_name);
		closedir(dir_ptr);
	}

}

```

结果只是把所有的文件展示出来，但是还有很多的信息没有展示，比如：ls -l命令，
输出结果的排序等等。

想实现`ls -l` 的效果， 需要读取文件的信息状态，那么，这个信息由stst结构体提
供，相关的代码还是得看上面连接的部分


![图片](http://ww3.sinaimg.cn/thumb300/a865ffcbgw1f5mhduocozj20m603it8z.jpg)
