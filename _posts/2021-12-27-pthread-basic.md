---
title: c/c++之thread简介
category: c/c++
layout: post
---
* content
{:toc}

# pthread简介
现在开始介入thread的初步知识。

直接上一个demo code:

```c
#include <iostream>

#include <pthread.h>
using namespace std;

#define NUM_THREADS 5

// 綫程運行的函數
void* say_hello(void* args){
    cout << "Hello, vimer" << endl;
    return 0;
}
int main(){
    // 定义线程的ID变量，多个变量使用数组
    pthread_t   tids[NUM_THREADS];
    for (int i = 0; i < NUM_THREADS; i++){
        // 参数依次是： 创建线程的id, 线程参数， 调用的函数，传入的函数args
        int ret = pthread_create(&tids[i], NULL, say_hello, NULL);
        if(ret != 0)
            cout << "pthread_create error: error_code=" << ret << endl;
    }
    // 等各个线程退出后，进程才结束，否则进程强制结束了，线程可能还没有反应过来
    pthread_exit(NULL);
}
```

编译命令:

```bash
g++ thread.cpp -lpthread -o test
```
其实，这里有意思的是，不同时间执行的输出是不一样的:

```bash
vimer@user-HP:~/test/thread$ ./test
Hello, vimer
Hello, vimerHello, vimer

Hello, vimer
Hello, vimer
vimer@user-HP:~/test/thread$ ./test
Hello, vimer
Hello, vimer
Hello, vimer
Hello, vimer
Hello, vimer
```
是这样的，目前还是有点难以理解。
看一下具体的api吧：

```c
/* Create a new thread, starting with execution of START-ROUTINE
   getting passed ARG.  Creation attributed come from ATTR.  The new
   handle is stored in *NEWTHREAD.  */
extern int pthread_create (pthread_t *__restrict __newthread,
			   const pthread_attr_t *__restrict __attr,
			   void *(*__start_routine) (void *),
			   void *__restrict __arg) __THROWNL __nonnull ((1, 3));

/* Terminate calling thread.

   The registered cleanup handlers are called via exception handling
   so we cannot mark this function with __THROW.*/
extern void pthread_exit (void *__retval) __attribute__ ((__noreturn__));
```