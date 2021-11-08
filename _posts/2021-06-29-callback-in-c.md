---
title: callback函数初体验
category: c
layout: post
---
* content
{:toc}


https://stackoverflow.com/questions/824234/what-is-a-callback-function

callback两个主要的作用：

1. 通过函数调用另一个函数 (函数指针)
2. 当第一个函数执行完毕后再执行另一个函数

# 初步看一下

callback最初听说，可以将socket的lib中的函数服复用，当时是处于懵懂的状态，现在重新整理一下。

```c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int a(int (*callback)(void)){
    printf("inside parent function\n");
    callback();
}

int test(){
    printf("inside the callback function\n");
}

int main(){
    a(&test);
    return 0;
}
```

打印下，这就是最基本的callback的使用。

再来举一个简单的例子:

```c
#include<stdio.h>
int func(int, int);
int main(void)
{
    int result1,result2;
    /* declaring a pointer to a function which takes
       two int arguments and returns an integer as result */
    int (*ptrFunc)(int,int);

    /* assigning ptrFunc to func's address */
    ptrFunc=func;

    /* calling func() through explicit dereference */
    result1 = (*ptrFunc)(10,20);

    /* calling func() through implicit dereference */
    result2 = ptrFunc(10,20);
    printf("result1 = %d result2 = %d\n",result1,result2);
    return 0;
}

int func(int x, int y)
{
    return x+y;
}

```

看到没有，如果我们仅仅知道了func的函数原型，就可以通过callback再次使用它了，而且参数必须指定，这样，容易理解callback的用法了吧。
其实如果我们再一次确认上面的代码，注意里面有一个  explicit 和 implicit dereference，这里确实有点有点意思。

其实，以上的代码就是通过函数指针 callback.

# register callback

The kernel's callback mechanism provides a general way for drivers to request and provide notification when certain conditions are satisfied.

所以驱动里使用的比较多呢。

https://docs.microsoft.com/en-us/windows-hardware/drivers/kernel/callback-objects

下面以几个更具体的例子进行说明:

```c
// cat callback.c

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "reg_callback.h"

void my_callback(void){
    printf("inside my_callback\n");
}

int main(){
    /* initilalize function pointer to my_callback */
    callback ptr_my_callback = my_callback;
    printf("This is a program demonstrating function callback\n");

    /* regitster our callback func */
    register_callback(ptr_my_callback);
    printf("back inside main program\n");
    return 0;
}

```

 cat reg_callback.h

```c
typedef void (*callback)(void);

void register_callback(callback ptr_reg_callback);

```

cat  reg_callback.c

```c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>


#include "reg_callback.h"

/* registration goes here */
void register_callback(callback ptr_reg_callback)
{
    printf("inside register_callback\n");
    /* calling  our callback function my_callback */
    (*ptr_reg_callback)();
}

```

 gcc -Wall -o callback callback.c reg_callback.c

```bash
vimer@user-system:~/test_yubo$ ./callback
This is a program demonstrating function callback
inside register_callback
inside my_callback
back inside main program
```
以上几个代码段是比较复杂的使用callback的方法，但是概括了一般的使用场景。


