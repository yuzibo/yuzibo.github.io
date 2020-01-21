---
title: c++中零碎知识点
category: c++
layout: post
---
* content
{:toc}

# explicit
`explicit`的作用是用来声明类构造函数是显示调用的，而非隐式调用，所以只用于修饰单参构造函数。因为无参构造函数和多参构造函数本身就是显示调用的。
以我目前的理解，显式构造就是使用`函数（）`，当然，这个函数是类的构造函数，而且还是单参的,
	```c
#include <iostream>
#include <string>
#include <iostream>

	class Explicit
{
	private:

	public:
		Explicit(int size){ // 可以使用explicit关键词进行修饰
			std::cout << "the size is " << size << std::endl;
		}
		Explicit(const char *str){ // 也可以使用explicit 关键字修饰
			std::string _str = str;
			std::cout << "the str is " << _str << std::endl;
		}
		Explicit(const Explicit& ins){
			std::cout <<"the Explicit is ins" << std::endl;
		}
		Explicit(int a, int b){
			std::cout << "the a,b is " <<  a << b << std::endl;
		}
};
int main()
{
	Explicit test0(15);
	Explicit test1 = 10;// hidden call or implicit conversions

	Explicit test2 = ("hello,yubo");
	Explicit test3 = "hello,yubo";// implicit conversions

	Explicit test4 = (1, 10);
	Explicit test5 = test1;

}
```
如果上面类中的两个构造函数使用`explicit`修饰，像主函数中用`=`赋值就不会被允许，报错如下:
```c
explicit.cpp: In function ‘int main()’:
explicit.cpp:33:19: error: conversion from ‘int’ to non-scalar type ‘Explicit’ requested
Explicit test1 = 10;// hidden call or implicit conversions
                     ^~
explicit.cpp:35:32: error: conversion from ‘const char [11]’ to non-scalar type ‘Explicit’ requested
Explicit test2 = ("hello,yubo");
                       ^
explicit.cpp:36:19: error: conversion from ‘const char [11]’ to non-scalar type ‘Explicit’ requested
Explicit test3 = "hello,yubo";// implicit conversions
                  ^~~~~~~~~~~~
explicit.cpp:38:21: error: conversion from ‘int’ to non-scalar type ‘Explicit’ requested
Explicit test4 = (1, 10);
               ~~^~~~~
```

