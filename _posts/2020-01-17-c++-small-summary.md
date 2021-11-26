---
title: c++中零碎知识点
category: c/c++
layout: post
---
* content
{:toc}

c++ 的特点：
抽象、封装、继承、多态。针对这四个特性，C++引入一系列的特征。

初学者一般说成员函数，后面熟悉了要纠正为方法(method)

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
			// 格式： 如 explicit Explicit(int size)
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

# 函数重载 override
这是c++的一个class特性，来看一个基本的代码:

```c
class BaseClass{
	public:
	void disp(){
			cout << "Function of Parent Class\n";
				}
};
class DerivedClass: public BaseClass {
	public:
	void disp(){
			cout << "Function of Child class\n";
				}
};
int main(){
	DerivedClass obj = DerivedClass();
	obj.disp();
	return 0;
}
```
请注意在实例化时，我们使用的那个类就是调用哪个类，在这个例子中，打印的是，```Function of child```.如果
，使用<font color="red">BaseClass obj</font>则会打印父类的成员函数。

这里既然提到函数重载(Function overriding)，就多说一下吧。函数重载说简单些基本就是让类中的方法在不同的
情况下可以自己去处理一些问题。比如，如果我们的方法所处理的事务处理的参数可能不一致怎么办？这个时候我们
就函数重载了。以下面为例：

```c
class Sum{
public:
	int add(int a, int b){
		return a + b;
	}
	int add(int a, int b, int c){
		return a + b + c;
	}
};
```
我们可以使用下面的语句进行调用：
```c
	cout << obj.add(1,2) << obj.add(1,2,3) << endl;
```
对`操作符`进行操作也是类似的。

# this pointer
按照书上的理解，`this`指针保存了目前 object 的地址，通过这个地址，你可以访问很多普通手段无法访问的数据。

### this access number variable
```c
class Demo {
private:
	int num;
	char ch;
public:
	void setMyValue(int num, char ch){
		this->num = num;// this is number variable
		this->ch = ch; //so, we have to use this
	}
void displayMyValues(){
	cout << num << endl;
	cout << ch << endl;
	}
};
int main(){
	Demo obj;
	obj.setMyValue(100, 'A');
	obj.displayMyValues();
	return 0;
}
```
这个例子就很好的解释了this指针在访问成员变量的方法。

### function call chains
这是我第一次看到类似的说法，而且还是很有意思的。这个方法也就是在创建实例之后，我们可以
连续调用其中的成员函数.那么，为什么会使用这个方案，现在还不得而知。
```c
class Demo {
private:
	int num;
	char ch;
public:
	Demo &setNum(int num){ // Here, function prototype
		this->num = num; // class name and "&"
		return *this;
	}
	Demo &setCh(char ch){
		this->num++;
		this->ch = ch;
		return *this;
	}
	void disPlay(){
		cout << num << endl;
		cout << ch << endl;
	}
};
int main()
{
	Demo obj;
	//obj.setNum(100).setCh('A');
	obj.setCh('B').setNum(99);
	obj.disPlay();
	return 0;
}
```
在时候这个方案的时候，我们可以清晰的看到，在class中是如何声明的，尤其注意的是，`Demo &f()`.还有一点就是调用函数的顺序没有特别的要求，谁也可以在前面，谁也可以在后面。
