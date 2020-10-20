---
title: c++运算符重载
category: c++
layout: post
---
* content
{:toc}

估计我们在学习c++基础教程的时候，都会遇到在操作符重载这节中使用的实数和虚数的概念，
今天，我也在这里稍微简单地记录下这个问题。也算弥补自己在这方面没有记录的一个遗憾吧。

# 复数的使用
当然是使用这个大名鼎鼎的用例了。

```c
#include <iostream>
using namespace std;

class Complex {
	private:
		int real, imag;
	public:
		Complex(int r = 0, int i = 0) {
			real = r;
			imag = i;
		}
		Complex operator + (Complex const &obj){
			Complex res;
			res.real = real + obj.real;
			res.imag = imag + obj.imag;
			return res;
		}
		void print() { cout << real << "+i " << imag << endl ;}
};
int main()
{
	Complex c1(10, 5), c2(2, 4);
	Complex c3 = c1 + c2;
	c3.print();
}
```
从上面的例子中，自己在c++目前存在的缺陷，还是集中在参数的引用等方面。

# 重载()
其实，这是我在网上看到这个标题后感觉还是挺有意思的，后面一看，才知道是
构造函数呀！

```c
#include <iostream>
using namespace std;
class dis_time{
	public:
		dis_time(int h, int m, int s){
			hour = h;
			minute = m;
			second = s;
		}
		void print(){
			cout << hour <<":" << minute <<":" << second << endl;
		}

	private:
		int hour;
		int minute;
		int second;
};

int main()
{
	dis_time t1(1,1,1);
	t1.print();
}
```
这是我的第一版实现（不考虑全面）。后面，如果我打算使用
```c
dis_time t2;
t2();
```
则会报下面的错误:
```c
oper2.cpp: In function ‘int main()’:
oper2.cpp:28:11: error: no matching function for call to ‘dis_time::dis_time()’
  dis_time t1;
           ^~
oper2.cpp:11:3: note: candidate: dis_time::dis_time(int, int, int)
   dis_time(int h, int m, int s){
   ^~~~~~~~
oper2.cpp:11:3: note:   candidate expects 3 arguments, 0 provided
oper2.cpp:9:7: note: candidate: constexpr dis_time::dis_time(const dis_time&)
 class dis_time{
       ^~~~~~~~
oper2.cpp:9:7: note:   candidate expects 1 argument, 0 provided
oper2.cpp:9:7: note: candidate: constexpr dis_time::dis_time(dis_time&&)
oper2.cpp:9:7: note:   candidate expects 1 argument, 0 provided
oper2.cpp:29:10: error: no match for call to ‘(dis_time) (int, int, int)’
  t1(2,4,5);
```

# ostream overload

这里主要要介绍的是"<<"输出运算符的重载，其实，是很简单的一个实例，但是具体来讲还是有一个地方需要重点补充下。

```c
class Complex
{
    double real,imag;   
public:
    Complex( double r=0, double i=0):real(r),imag(i){ };
    friend ostream & operator<<( ostream & os,const Complex & c);
    friend istream & operator>>( istream & is,Complex & c);
};
ostream & operator<<( ostream & os,const Complex & c)
{
    os << c.real << "+" << c.imag << "i"; //以"a+bi"的形式输出
    return os;
}
```

C++中输入运算符的重载，第一个参数需要是ostream的引用，第二个参数就是需要运用
重载符的对象，最好也是引用形式，而且，在输出时不能改变原有的对象，所以我们可以
添加const关键词进行修饰。

这段代码摘自[here](http://c.biancheng.net/view/242.html),我们可以很容易的
看出，这里的操作符是在类外面进行重载的。这样的情况下，需要在类内的成员中添加
友元函数声明，不然编译器会报错的。

## 友元函数

根据[这篇文章](https://blog.csdn.net/zwe7616175/article/details/81216118), 友元函数的特性是可以把一个类的成员分享给其他类， 实现类共享，此类代码在
aosp中也不少的， 主要是为了减少不必要的开销， 提高效率。但是缺点就是破坏了类的
封装性，这一点还没有深刻的体会。

[this, friend function](https://blog.csdn.net/weixin_42547950/article/details/104338918?utm_medium=distribute.pc_relevant_t0.none-task-blog-BlogCommendFromMachineLearnPai2-1.channel_param&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-BlogCommendFromMachineLearnPai2-1.channel_param)


 那么， 既然已经很明确建议不适用友元函数，在重载输出运算符时有没有好的办法呢？有的：

 ```c
#include <iostream>

using namespace std;

class Person {
public:
    Person(const string& first_name, const string& last_name) : first_name_(first_name), last_name_(last_name) {}
    const string& get_first_name() const {
      return first_name_;
    }
    const string& get_last_name() const {
      return last_name_;
    }
private:
    string first_name_;
    string last_name_;
};
// Call Person's some method to avoid friend.
ostream& operator<<(ostream& os, const Person& p){
    os <<"first_name=" << p.get_first_name() <<"," <<"last_name=" << p.get_last_name();
    return os;
}


int main() {
    string first_name, last_name, event;
    cin >> first_name >> last_name >> event;
    auto p = Person(first_name, last_name);
    cout << p << " " << event << endl;
    return 0;
}

 ```









