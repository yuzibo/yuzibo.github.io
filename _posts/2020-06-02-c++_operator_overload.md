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
