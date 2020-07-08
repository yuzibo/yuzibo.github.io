---
title: "c++之override和final"
category: c++
layout: post
---
* content
{:toc}

本篇文章参考以下资料：
[原文1](https://www.modernescpp.com/index.php/override-and-final)
[原文2](https://www.geeksforgeeks.org/override-keyword-c/)
# override
在方法中的修饰关键词*override*，表明该方法应该重写(override)基于该基类的虚方法。 什么？
虚函数不就是用来重写的吗？是的，但是重写的时候会出现很多非意料之中的疏忽，至少在
我目前看来就是这样的。我们先来看下简单的例子。
```c
#include <iostream>
using namespace std;

class Base {
	public:
		virtual void func() { // user want to override this in the derived class
			cout << "I am in base" << endl;
		}
};
class Derived : public Base {
	void  func(int a){ // By mistake to put int a int argument
		cout << "I am in derived class" << endl;
	}
};
int main(){
	Base b;
	Derived d;
	cout << "Compiled successfully" << endl;
	// cout << "Compiled successfully"
}
```
我们看到在Base类中，已经使用`virtual`进行声明了，那么在派生类中进行重写确实是理所当然的
但是，如果我们在派生类重新实现时改变了函数签名（所谓的函数签名就是指函数的名称 参数
返回值。。。）。此类错误我们应该极力避免，但是，很遗憾的是上面的程序是可以编译通过的。
不一而足，此类暗含的 编译器难以发现的错误严重影响我们的期望值，导致一些难以发觉的错误。

幸运的是，在c++11中，我们有一个关键词"override"可以阻止这种情况发生。
```c++
...
 void func(int a) override
    {
        cout << "I am in derived class" << endl;
    }
...
```

出错信息为:
```bash
g++ -g over2.cpp -o over2
over2.cpp:11:8: error: ‘void Derived::func(int)’ marked ‘override’, but does not override
  void  func(int a) override { // By mistake to put int a int argument
        ^~~~
```
`override`可以帮助检查以下几个方面的问题:
1. 在父类中同名的方法
2. 在父类中用`virtual`修饰的，这个本意就是让用户在后面重写
3. 父类中的方法与子类中的方法具有相同的签名（The method in the parent class has the same signature as the method in the subclass）

