---
title: gcc diagnostic用法
category: c/c++
layout: post
---
* content
{:toc}

目前中文的资料介绍diagnostic的介绍资料较少一些，故积累本文以作总结。

# 源码

Makefile 如下
```c
CPPFLAGS:=-std=c11 -W -Wall -pedantic -Werror

.PHONY: all
all: puts
```

puts.c如下:

```c
#include <stdio.h>

int main(int argc, const char *argv[])
{
    while(*++argv)
        puts(*argv);
    return 0;
}
```

编译的时候，error显示如下:

```bash
vimer@user-HP:~/test/gcc$ make
cc  -std=c11 -W -Wall -pedantic -Werror   puts.c   -o puts
puts.c: In function ‘main’:
puts.c:12:14: error: unused parameter ‘argc’ [-Werror=unused-parameter]
 int main(int argc, const char *argv[])
              ^~~~
cc1: all warnings being treated as errors
<builtin>: recipe for target 'puts' failed
make: *** [puts] Error 1
```
之所以有这些error，需要注意到`cppflags`的那几个字段，是这几个决定了编译的具体行为。
当然，gcc编译的常用选项也需要进行一番总结。

# 改进

## __arrtibute__
1. __attribute__
可以使用这个关键字进行某些warning的消除。
```c
int main(__attribute__((unused)) int argc, const char *argv[])
{
    while(*++argv)
        puts(*argv);
    return 0;
}
```
编译结果:
```bash
vimer@user-HP:~/test/gcc$ make
cc  -std=c11 -W -Wall -pedantic -Werror   puts.c   -o puts
```

`__attribute__`是GCC的扩展，当然也是来自LLVM的支持。如果想写出可移植的代码，需要将该字段放到宏中去编写。
这个后面我们再总结一下。

## _Pragma
这个代码没有编译成功:

```c
#include <unistd.h>

_Pragam("GCC diagnostic push")
_Pragam("GCC diagnostic ignore \"-Wunused-parameter\"")


int main(__attribute__((unused)) int argc, const char *argv[])
{
    while(*++argv)
        puts(*argv);
    return 0;
}
_Pragam("GCC diagnostic pop")

```
编译的log如下，但是这篇文章的主旨不是这里，所以暂且不表。
```bash
vimer@user-HP:~/test/gcc$ make
cc  -std=c11 -W -Wall -pedantic -Werror   puts.c   -o puts
puts.c:11:9: error: expected declaration specifiers or ‘...’ before string constant
 _Pragam("GCC diagnostic push")
         ^~~~~~~~~~~~~~~~~~~~~
puts.c:21:9: error: expected declaration specifiers or ‘...’ before string constant
 _Pragam("GCC diagnostic pop")
         ^~~~~~~~~~~~~~~~~~~~
<builtin>: recipe for target 'puts' failed
make: *** [puts] Error 1
```

## #pragma
先看代码

```c
#include <stdio.h>

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-parameter"


int main(__attribute__((unused)) int argc, const char *argv[])
{
    while(*++argv)
        puts(*argv);
    return 0;
}
#pragma GCC diagnostic pop
```
编译的log如下:

```bash
vimer@user-HP:~/test/gcc$ make
cc  -std=c11 -W -Wall -pedantic -Werror   puts.c   -o puts
```

怎么样，出乎意料吧，其实这里才是这篇文章的主题：  c源码程序中借助这样的技巧，把一些不可避免的
warning给屏蔽掉。看一下我们的工程代码：

```c
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wconversion"
#include <gst/video/videooverlay.h>
#pragma GCC diagnostic pop
```
这里难道是 include 的文件有问题？ `-Wconversion`大概率设涉及到类型的转换之类的。而且，这个声明必须放到
`.c`文件中去做。

## Makefile

最后是修改Makefile,实际效果我没有进行试验，但是我估计应该是可以的。

```c
CPPFLAGS:=-std=c11 -W -Wall -pedantic -Werror

.PHONY: all
all: puts

puts.o: CPPFLAGS+=-Wno-unused-parameter
```

具体的[code 参考](https://stackoverflow.com/questions/3378560/how-to-disable-gcc-warnings-for-a-few-lines-of-code)

# pragma

这个用法是有具体语法的，比如

```c
#pragma GCC diagnostic kind option
```

以下摘自官方：

    Modifies the disposition of a diagnostic. Note that not all diagnostics are modifiable; at the moment only warnings (normally controlled by ‘-W…’) can be controlled, and not all of them. Use -fdiagnostics-show-option to determine which diagnostics are controllable and which option controls them.

    kind is ‘error’ to treat this diagnostic as an error, ‘warning’ to treat it like a warning (even if -Werror is in effect), or ‘ignored’ if the diagnostic is to be ignored. option is a double quoted string that matches the command-line option.

```c
#pragma GCC diagnostic warning "-Wformat"
#pragma GCC diagnostic error "-Wformat"
#pragma GCC diagnostic ignored "-Wformat"
```
    Note that these pragmas override any command-line options. GCC keeps track of the location of each pragma, and issues diagnostics according to the state as of that point in the source file. Thus, pragmas occurring after a line do not affect diagnostics caused by that line.

说的很明白，就是 `#pragma`会覆盖编译选项的(比如来自makefile什么的)，所以引入了下面的技巧:

    #pragma GCC diagnostic push
    #pragma GCC diagnostic pop