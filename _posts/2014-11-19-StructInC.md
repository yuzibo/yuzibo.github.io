---
layout: post
title: "struct和字节对齐的一些东西"
category: c
---
# 一 起因
* content
{:toc}

原本是想看Linux Kernel内核的，结果...
这篇文章纯属自己回忆瞎写，请不要当真。
## 结构声明
struct __tag {
	member-list
} variable-list__;

上面的粗体至少有部分;不知道c语言的发明者为什么会添了个标签，按照书上的解释，标签(tag)可以为成员列表提供一个名字，这样它就可以在后续的声明中使用，而且多个声明共同使用一个成员列表，并且创建同一种类型的数据结构。

{% highlight c %}
struct {
	int a;
	char b;
	float c;
} x;
{% endhighlight %}
这个声明创建了一个名叫x的变量，它包含三个成员：一个整数、一个字符和一个浮点。
{% highlight c %}
struct {
	int a;
	char b;
	float c;
} y[20],*z;

{% endhighlight %}
这个声明创建了y和z，y是一个数组，它包含了20个结构，z是一个指针，它指向这个类型的结构。上面两个声明会被当作两种截然不同的类型。
##标签的使用
{% highlight c %}
struct SIMPLE {
	int a;
	char b;
	float c;

};
{% endhighlight %}
我们以后想快速创建含有类似结构的结构体变量时，可以这样使用：
struct SIMPLE x;

struct SIMPLE y[20],*z;

并且它们具有相同的类型。

## typedef
使用结构体时，我们有一个东西不得不说：typedef;请看下例：
{% highlight c %}
typedef struct{
	int a;
	char b;
	float c;
} Simple;

{% endhighlight %}
区别在于现在的Simple是一个类型名而不是标签了，我们可以这样使用：

Simple x;

Simple y[20],*z;

同上面使用标签是一样的。

# 二 字节对齐

关于字节对齐，根据机器类型来讲，有两类：一是内存上的，二是栈上的。为什么使用
对齐，主要从存取效率上考虑的，以某个整数的倍数为起点(也就是边界对齐)取一次数
据用一个？周期，但是如果不对齐的话则需要两次。continue....

