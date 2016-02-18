---
layout: article
title: "struct成员偏移量"
category: C
---
# 起因
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

# 利用宏来求结构体成员的偏移量
这才是今天的重点，发现自己很容易跑偏，抓紧时间啊;
先看看[!StackOverFlow](http://stackoverflow.com/questions/18554721/how-to-understand-size-t-type-0-member)的这个问题吧，我知道了，之前说过现在读linux kernel代码毫无感觉，无从下手的主要原因是自己知道的太少了，其实自己现在的c语言水平，根本连linux kernel的门都找不到。废话少讲，每天必须有五个新增知识点进账。


