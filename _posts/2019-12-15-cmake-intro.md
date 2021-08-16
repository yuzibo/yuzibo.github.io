---
title: Cmake简要总结
category: make
layout: post
---
* content
{:toc}

# 缘由
从接触linux至今，至少见到了Makefile编译系统，但是，在不同的平台上，这个Makefile
还需要进一步改写，这严重制约了项目的代码效率(特指维护方面)。CMake的提出就是解决这个问题的。

# 案例
首先编制一个简单的c程序,命名为add.cc.
```c
#include <stdio.h>
#include <stdlib.h>

int add_summary(int a,int b)
{
	return (a + b);
}

int main()
{
	int x,y;
	printf("Please input two numbers and be carefully overflow\n");
	scanf("%d %d", &x, &y);
	printf("The sum of two nums is %d\n", add_summary(x, y));
}
```
在相同目录下，然后编写一个CMakeLists文件。

```bash
swin:~/test/cmake$ cat CMakeLists.txt
# CMake不区分大小写
# CMake最低的版本号
cmake_minimum_required (VERSION 3.0)

# 项目信息,与包含工程的目录一直
project (cmake)

# 指定生成文件及源文件
add_executable (cmake add.cc)
```

```bash
$: ~/test/cmake$ ls
add.cc  CMakeLists.txt
```
然后在本地目录`cmake .`
```bash
cmake .
-- The C compiler identification is GNU 7.4.0
-- The CXX compiler identification is GNU 7.4.0
-- Check for working C compiler: /usr/bin/cc
-- Check for working C compiler: /usr/bin/cc -- works
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Detecting C compile features
-- Detecting C compile features - done
-- Check for working CXX compiler: /usr/bin/c++
-- Check for working CXX compiler: /usr/bin/c++ -- works
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Detecting CXX compile features
-- Detecting CXX compile features - done
-- Configuring done
-- Generating done
-- Build files have been written to: /home/yubo/test/cmake
```
会生成:

```c
yubo@win:~/test/cmake$ ls
add.cc  CMakeCache.txt  CMakeFiles  cmake_install.cmake  CMakeLists.txt  Makefile
```
借着Make:
```c
win:~/test/cmake$ make
Scanning dependencies of target cmake
[ 50%] Building CXX object CMakeFiles/cmake.dir/add.cc.o
[100%] Linking CXX executable cmake
[100%] Built target cmake
```
直接生成了可执行文件cmake:
```bash
swin:~/test/cmake$ ls
add.cc  CMakeCache.txt  cmake_install.cmake  Makefile
cmake   CMakeFiles      CMakeLists.txt
```
看到Makefile文件，你就可以接着使用make命令的其他选项了.

# 同一目录下，多个源文件

只需修改CMakeLists.txt即可。

```bash
# 第一个参数是可执行文件的名字，然后依次将工程所需的源文件添加
# 进去
add_executable(cmake, add.cc, sub.cc)
```
从工作量上来说，如果源文件很多的话，这个任务还是很艰巨的。更省事的方法是使用`aux_source_directory`命令，该命令会将指定目录下的所有源文件，以特定变量名保存结果。

```c
# 查找当前目录下的所有源文件
# 并将结果保存到 DIR_SRCS 变量
aux_source_directory(. DIR_SRCS)

# 然后指定生成目标
add_executable(cmake ${DIR_SRCS})
```

# 多个目录，多个文件
假设一个项目由多个目录构成，这也是在项目中非常常见的。上面我们将加法的
程序分离出去，编译成一个静态库。

# 只生成头文件

假设只需要某个库的头文件，也可以通过Cmake控制。

```bash
vimer@host:~/git/AviSynthPlus$ mkdir avisynth
vimer@host:~/git/AviSynthPlus$ cd avisynth/
vimer@host:~/git/AviSynthPlus/avisynth$ ls
vimer@host:~/git/AviSynthPlus/avisynth$ cmake ../ -DHEADERS_ONLY:bool=on
-- Install Only Headers: ON
-- Configuring done
-- Generating done
-- Build files have been written to: /home/vimer/git/AviSynthPlus/avisynth
vimer@host:~/git/AviSynthPlus/avisynth$ make install
```

通过`-DHEADERS_ONLY`可以控制这个行为。
