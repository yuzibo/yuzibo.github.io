---
title: c/c++之thread简介
category: c/c++
layout: post
---
* content
{:toc}

# pthread简介
现在开始介入thread的初步知识。

## 创建pthread

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


## 向线程传递参数

```c
#include <iostream>
#include <pthread.h>
using namespace std;


#define NUM_THREADS     5

void *PrintHello(void *threadid){
    // 对传入的参数进行强制类型转换，由无类型指针转化为整型指针
    int tid = *((int*)threadid);
    cout << "Hello vimer! thread id" << tid << endl;
    pthread_exit(NULL);
}

int main()
{
    pthread_t threads[NUM_THREADS];
    int indexes[NUM_THREADS];
    int rc;
    int i;

    for(i = 0; i < NUM_THREADS; i++){
        cout << "main(): create thread," << i << endl;
        indexes[i] = i; // 保存i的值
        // 传入的时候必须强制转换为void *类型，即无类型指针
        rc = pthread_create(&threads[i], NULL, PrintHello,
                            (void*)&(indexes[i]));
        if (rc){
            cout << "fail to create thread" << rc << endl;
            exit(-1);
        }
    }
    pthread_exit(NULL);
}
```

输出的结果如下:

```bash
vimer@user-HP:~/test$ ./test
main(): create thread,0
main(): create thread,1
Hello vimer! thread id0
main(): create thread,2
Hello vimer! thread id1
main(): create thread,3
Hello vimer! thread id2
Hello vimer! thread id3
main(): create thread,4
Hello vimer! thread id4
```

下面这个例子是传递结构体参数:

```bash
#include <iostream>
#include <pthread.h>
using namespace std;

#define NUM_THREADS 5

struct thread_data{
    int thread_id;
    char *message;
};

void *PrintHello(void *threadargs){
    struct thread_data *my_data;

    my_data = (struct thread_data *)threadargs;

    cout << "Thread ID: " << my_data->thread_id;
    cout << " Message:" << my_data->message << endl;

    pthread_exit(NULL);

}

int main()
{
    pthread_t threads[NUM_THREADS];
    struct thread_data td[NUM_THREADS];
    int rc, i;

    for ( i = 0; i < NUM_THREADS; i++){
        cout << "main(): create thread" << i << endl;
        td[i].thread_id = i;
        td[i].message = (char *)"this is message";
        rc = pthread_create(&threads[i], NULL,
                        PrintHello, (void *)&td[i]);
        if (rc) {
            cout << "fail to create thread" << rc << endl;
            exit(-1);
        }
    }
    pthread_exit(NULL);
}

```

输出log :

```bash
vimer@user-HP:~/test$ ./test
main(): create thread0
main(): create thread1
Thread ID: 0 Message:this is message
main(): create thread2
Thread ID: 1 Message:this is message
main(): create thread3
Thread ID: 2 Message:this is message
Thread ID: 3 Message:this is message
main(): create thread4
Thread ID: 4 Message:this is message
```