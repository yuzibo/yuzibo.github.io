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

## 如何把模式的数字转化为数字

st_mode是一个16位的二进制数，[图](http://pan.baidu.com/s/1pLD153P).

为了提取有效的数字，我们使用掩码技术。什么是掩码呢？就是好像带上面具将其他没
有的数据隐藏起来。

(1)掩码(masking) 会将不需要的字段置为0，需要的字段不发生变化。

(2)我们还知道整数在计算机中的表示也是二进制。这样一个普通的整数也就有了意义。

(3)与0做位与(&)操作可以将相应的bit为置为0， 

(4) 使用8进制

介绍完了掩码，还必须介绍子域编码。

在 <bits/stat.h>中，有以下定义：

```c
#define	__S_IFMT	0170000	/* These bits determine file type.  */

/* File types.  */
#define	__S_IFDIR	0040000	/* Directory.  */
#define	__S_IFCHR	0020000	/* Character device.  */
#define	__S_IFBLK	0060000	/* Block device.  */
#define	__S_IFREG	0100000	/* Regular file.  */
#define	__S_IFIFO	0010000	/* FIFO.  */

```

```c
if ((info.st_mode & 0170000) == 0040000)
	printf("This is a directory");
```

然而在<sys/stat.h>中，又定义了上面的宏，有__X_IFXXX前面的__去掉了。

```c
#include <bits/stat.h>

#if defined __USE_MISC || defined __USE_XOPEN
# define S_IFMT		__S_IFMT
# define S_IFDIR	__S_IFDIR
# define S_IFCHR	__S_IFCHR
# define S_IFBLK	__S_IFBLK
# define S_IFREG	__S_IFREG
# ifdef __S_IFIFO
#  define S_IFIFO	__S_IFIFO
# endif
# ifdef __S_IFLNK
#  define S_IFLNK	__S_IFLNK
# endif
# if (defined __USE_MISC || defined __USE_UNIX98) \
     && defined __S_IFSOCK
#  define S_IFSOCK	__S_IFSOCK
# endif
#endif

```

更简单的方法是使用<sys/stat.h>中的macro,注意，这里版本的不同文件所处的位置也
不同的.
下面,具体的宏实现如下：

```c

/* Test macros for file types.	*/

#define	__S_ISTYPE(mode, mask)	(((mode) & __S_IFMT) == (mask))

#define	S_ISDIR(mode)	 __S_ISTYPE((mode), __S_IFDIR)
#define	S_ISCHR(mode)	 __S_ISTYPE((mode), __S_IFCHR)
#define	S_ISBLK(mode)	 __S_ISTYPE((mode), __S_IFBLK)
#define	S_ISREG(mode)	 __S_ISTYPE((mode), __S_IFREG)
#ifdef __S_IFIFO
# define S_ISFIFO(mode)	 __S_ISTYPE((mode), __S_IFIFO)
#endif
#ifdef __S_IFLNK
# define S_ISLNK(mode)	 __S_ISTYPE((mode), __S_IFLNK)
#endif

#if defined __USE_MISC && !defined __S_IFLNK
# define S_ISLNK(mode)  0
#endif

```
这里，还可以定义如下宏：

```c
#define S_ISFIFO(m) (((m)&(0170000)) == 0010000)
```
 
### 解决用户/组问题

先提供struct passwd 的源码：

```c
/* defined in pwd/pwd.h */
/* The passwd structure.  */
struct passwd
{
  char *pw_name;		/* Username.  */
  char *pw_passwd;		/* Password.  */
  __uid_t pw_uid;		/* User ID.  */
  __gid_t pw_gid;		/* Group ID.  */
  char *pw_gecos;		/* Real name.  */
  char *pw_dir;			/* Home directory.  */
  char *pw_shell;		/* Shell program.  */
};

```


