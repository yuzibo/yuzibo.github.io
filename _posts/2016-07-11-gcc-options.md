---
title: "gcc 编译过程解释"
layout: post
category: system
---

# 输入文件的后缀含义

输入文件的后缀解释如下：

		  .c                 C source file

          .i                 Preprocessed C or C++ source file

          .a                 Archive file

          .o                 Object file for ld command

          .s                 Assembler source file

          .S                 Assembler source file that
                             needs preprocessing

          .so                Shared object file


其他需要注意的选项：

-L dir   在库函数(lib)的搜索路径列表中添加dir目录

-l dir	在头文件(#include<>)的搜索路径列表中添加dir目录

-static  链接静态库

-llibrary  链接名为library的库文件



# 输出控制选项 [-options:]

### -c: 

指示编译器将源文件只是编译，编译后的源文件不会被送给链接器,生成一个目标文件
：file_name.o.

```bash
root@yubo-2:~/test/unix_linux/tmp# ls
hello.c
root@yubo-2:~/test/unix_linux/tmp# gcc -c hello.c 
root@yubo-2:~/test/unix_linux/tmp# ls
hello.c  hello.o
```

### -C|-C!: 

Preserves or removes comments in preprocessed output.  When -C is used with the -E option, comments are written to standard output; with the -P option, comments are written to an output file.  When -C! is in effect, comments are removed.

### -E:

Preprocess only; do not compile, assemble or link

```bash
root@yubo-2:~/test/unix_linux/tmp# ls
hello.c
root@yubo-2:~/test/unix_linux/tmp# gcc -E hello.c 
# 1 "hello.c"
# 1 "<command-line>"
# 1 "hello.c"
....
root@yubo-2:~/test/unix_linux/tmp# ls
hello.c

```

在屏幕上打印出非常多的预处理信息，就是简单一条printf函数，就接近900多行的预处理，使用这个选项，默认输出到标准输出。不会产生任何文件。

### -S:
           
Compile only; do not assemble or link

```bash 
root@yubo-2:~/test/unix_linux/tmp# ls
hello.c
root@yubo-2:~/test/unix_linux/tmp# gcc -S hello.c 
root@yubo-2:~/test/unix_linux/tmp# ls
hello.c  hello.s


```

只是产生了一个.s的汇编源文件

### -c:

Compile and assemble, but do not link

```bash
root@yubo-2:~/test/unix_linux/tmp# ls
hello.c
root@yubo-2:~/test/unix_linux/tmp# gcc -c hello.c 
root@yubo-2:~/test/unix_linux/tmp# ls
hello.c  hello.o
root@yubo-2:~/test/unix_linux/tmp# 

```

### -o:

>Place the output into <file>

```bash

root@yubo-2:~/test/unix_linux/tmp# ls
hello.c  hello.o
root@yubo-2:~/test/unix_linux/tmp# rm hello.o
root@yubo-2:~/test/unix_linux/tmp# 
root@yubo-2:~/test/unix_linux/tmp# gcc -S hello.c -o place_name
root@yubo-2:~/test/unix_linux/tmp# ls
hello.c  place_name
root@yubo-2:~/test/unix_linux/tmp# cat place_name 
	.file	"hello.c"
	.section	.rodata
...

```

这个选项尤其引起我的注意，这个意思是说任何选项后面加上这个选项，原来默认的输出的文件名会被设置为place_name,这是为了控制输出的文件名。

默认为 -o a.out 

### -pie:

Create a position independent executable

### -shared:

Create a shared library

# 编译过程

有了上面的知识储备，现在就能更好理解编译的过程了。

#### 预处理(pre-processing)

#### 编译(Compile)

#### 汇编(Assembling)

#### 链接(Linking)

### 预处理

接着上面的例子：

```bash

root@yubo-2:~/test/unix_linux/tmp# ls
hello.c
root@yubo-2:~/test/unix_linux/tmp# gcc -E hello.c -o hello.i
root@yubo-2:~/test/unix_linux/tmp# ls
hello.c  hello.i

root@yubo-2:~/test/unix_linux/tmp# cat hello.i | head -n 5
# 1 "hello.c"
# 1 "<command-line>"
# 1 "hello.c"


```

与上面的一样，只是多了一个目标文件hello.i,预处理就是把源程序用到的库函数、宏加载到hello.i中。

### 编译

这个阶段，编译器检查代码的规范性、是否有语法错误等，以确定代码的实际要做的工作，在检查无误后，gcc把代码翻译成汇编语言。使用”-S”选项来进行查看，该选项只进行编译而不进行汇编，生成汇编代码。

```bash


root@yubo-2:~/test/unix_linux/tmp# ls
hello.c  hello.i
root@yubo-2:~/test/unix_linux/tmp# gcc -S hello.i -o hello.s
root@yubo-2:~/test/unix_linux/tmp# cat hello.s | head -n 5
	.file	"hello.c"
	.section	.rodata
.LC0:
	.string	"hello, world"
	.text
root@yubo-2:~/test/unix_linux/tmp# 

```
### 汇编阶段

汇编阶段是把编译阶段生成的”.s”文件转成目标文件，在此可使用选项”-c”就可看到汇编代码已转化为”.o”的二进制目标代码了

```bash

root@yubo-2:~/test/unix_linux/tmp# ls
hello.c  hello.i  hello.s
root@yubo-2:~/test/unix_linux/tmp# gcc -c hello.s -o hello.o
root@yubo-2:~/test/unix_linux/tmp# ls
hello.c  hello.i  hello.o  hello.s
root@yubo-2:~/test/unix_linux/tmp# 

```

### 链接

将库函数的函数链接进来，库分为动态和静态两种，这里就涉及另外的知识了，先不讲

```bash

root@yubo-2:~/test/unix_linux/tmp# ls
hello.c  hello.i  hello.o  hello.s
root@yubo-2:~/test/unix_linux/tmp# gcc hello.o -o hello
root@yubo-2:~/test/unix_linux/tmp# ls
hello  hello.c	hello.i  hello.o  hello.s
root@yubo-2:~/test/unix_linux/tmp# ./hello
hello, world
root@yubo-2:~/test/unix_linux/tmp# 

```

gcc好像是一个工具包，其实各个阶段有不同的工具负责，这里应该分开讲清楚的。
