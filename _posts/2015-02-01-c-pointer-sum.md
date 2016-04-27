---
layout: article
title: "c语言指针知识点总结"
category: c
---

# c函数指针总结

首先明白的是，函数在内存中有一个物理地址，这类似与数组。这个地址可以赋给一个
指针。函数的地址就是函数的入口，因此，函数指针可以用来调用一个函数

### 声明

	type (* pointer_var)();

返回值为type类型的函数指针，表示pointer_var是一个指向函数入口的指针变量。要
和以下的区别：

	type *pointer_var();

这是一个返回type *的函数，举两个例子:

{% highlight c %}
int max(int a, int b)
{
	if(a > b)
		return a;
	else
		return b;
}

int main()
{
	int max(int a,int b);
	int (*pmax)();
	int z,x,c;
	pmax = max;
	printf("Please input two numbers:\n");
	scanf("%d%d",&z,&x);
	/*
	 *这里，你可以sum(z,x);
	 * c=(*pmax)();
	 */
	c = (*pmax)(z,x);
	print("Max number is %d\n", c);
}
{% endhighlight %}

从上面我们可以看出来，先定义函数指针，<del>将函数指向函数指针后</del>，将函
数指针指向函数后，就可以像使用原函数那样进行调用。



那么，这两个函数返回值类型也必须一致

看下面的例子：

>void (*fptr) ();

把函数的地址赋值给函数指针，可以采用下面两种形式：

```c
fptr = &Function;
fptr = Function;
```
取地址运算符&不是必需的，因为单单一个函数标识符就表示了它的地址,上面的程序代码就是直接拿的函数名。

```c
x = (*fptr)();
x = fptr();
```
两种函数调用的方式。倾向使用第一种方式，前面接收的那个变量的类型要与调用的函数的类型一致。

# 指针函数
指针函数是带指针的函数，与上面的极易混淆，下面看一下具体形式

	类型标识符  *函数名(参数表)
	int *f(x,y)

<del>当然了，由于返回的是一个地址，所以类型说明符一般都是int。</del>void,float也都有返回的地址，什么都是可以的。

```c
#include<stdio.h>

int *GetDate(int wk,int ddy);

int main(){
	int wk,dy;
	do{
		printf("Enter week(1-5)day(1-7)\n");
		scanf("%d%d",&wk,&dy);
	}while(wk<1 || wk>5 || dy<1 || dy>7);
	printf("%d\n",*GetDate(wk,dy));
}
int *GetDate(int wk,int dy){
	static int calendar[5][7] =
	{
		{1,2,3,4,5,6,7,},
		{8,9,10,11,12,13,14},
		{15,16,17,18,19,20,21},
		{22,23,24,25,26,27,28},
		{29,30,31}
	};
	return &calendar[wk-1][dy-1];
}

```
首先这是一个函数，函数的返回值是地址。返回值必须用同类型的指针变量来接受，(当然了)，也就是说，指针函数一定有返回值，在
主调函数中，函数的返回值必须赋给同类型的指针变量。

在调用它的时候，由返回值类型确定相应的格式类型(对于printf函数而言)。

看下面的例子：

	A) char *(*fun1)(char * p1,char * p2);

	B) char **fun2(char * p1,char * p2);

	C) char *fun3(char * p1,char * p2);

C): fun3是函数名，p1,p2是参数，返回char *.

B): 同上，只不过返回值是 char **

A):  fun1不是函数，只是个指针变量，它指向一个函数，返回值是char *.

请看下面的例子：

	char *fun(char * p1, char *p2)
	{
		int i = 0;
		i = strcmp(p1, p2);
		if (0 == i)
			return p1;
		else
			return p2;
		/*Note:
		 Connect return value with char *
		 */
	}
	int main()
	{
		char *(*pf)(char *p1, char *p2);
		pf = &fun;
		(*pf) ("aa","bb");
		return 0;
	}

我们使用指针的时候，需要通过解引用符号取出指向其内存里的内容,上面我们是通过（*pf）取出存在这个地址上的函数,然后调用它。

### *(int *)&p是什么
{% highlight c %}
#include <stdio.h>
#include <string.h>

void Function ()
{
	printf(" Hello,world\n");
}
int main()
{
	void (*p)();
	/*define pointer of function,argument and return value are void*/
	*(int*)&p = (int)Function;
	/*&p, it's aim to address of p,then 把这个地址强制转换成指向
	  int类型的指针，(int)Function是把函数的入口地址强制转换
	 成int型*/
	(*p)();
	//call Function
	return 0;
}
{% endhighlight %}

### what is (*(void(*)())0)() ?
1.void(*)(),这是一个函数指针类型，没有参数，没有返回值

2.(void(*)())0 将0强制转换成函数指针类型，0是一个地址，也就是说一个函数存在首地址为0的一段区域内.

3.(*(void(*)())0) 去0地址开始开始的一段内存里面的内容，其内容就是保存在起始地址为0的函数

4.(*(void(*)())0)() 就是函数调用了

### 函数指针数组
现在我们清楚表达式“char * (*pf)(char * p)”定义的是一个函数指针pf。既然pf 是一个指针，那就可以储存在一个数组里。把上式修改一下：

char * (*pf[3])(char * p);

这是定义一个函数指针数组。它是一个数组，数组名为pf，数组内存储了3 个指向函数的指针。这些指针指向一些返回值类型为指向字符的指针、参数为一个指向字符的指针的函数。这念起来似乎有点拗口。不过不要紧，关键是你明白这是一个指针数组，是数组。

它有什么作用呢？
{% highlight c %}
#include <stdio.h>
#include <string.h>

char * fun1(char * p)
{
	printf("%s\n",p);
	return p;
}
char * fun2(char * p)
{
	printf("%s\n",p);
	return p;

}
char * fun3(char * p)
{
	printf("%s\n",p);
	return p;
}
int main()
{
	char * (*pf[3])(char * p);
	pf[0] = fun1;//首个可以直接使用函数名
	pf[1] = &fun2;
	pf[2] = &fun3;
	pf[0]("fun1");
	//感觉不对
	pf[0]("fun2");
	pf[0]("fun3");
	return 0;
}
{% endhighlight %}

### 函数指针数组指针
char * (*(*pf)[3])(char *p);

注意，这里的pf 和上一节的pf 就完全是两码事了。上一节的pf 并非指针，而是一个数组名；这里的pf 确实是实实在在的指针。这个指针指向一个包含了3 个元素的数组；这个数字里面存的是指向函数的指针；这些指针指向一些返回值类型为指向字符的指针、参数为一个指向字符的指针的函数。这比上一节的函数指针数组更拗口。其实你不用管这么多，明白这是一个指针就ok 了。其用法与前面讲的数组指针没有差别。下面列一个简单的例子：

{% highlight c %}
#include <stdio.h>
#include <string.h>

char * fun1(char *p)
{
	printf("%s\n");
	return p;
}
char * fun2(char * p)
{
	printf("%s\n");
	return p;
}
char * fun3(char * p)
{
	printf("%s\n");
	return p;
}
int main()
{
	char * (*a[3])(char * p);
	char * (*(*pf)[3])(char * p);
	pf = &a;
	a[0] = fun1;
	a[1] = &fun2;
	a[2] = &fun3;
	pf[0][0]("fun1");
	pf[0][1]("fun2");
	pf[0][2]("fun3");
	return 0;

}
{% endhighlight %}
