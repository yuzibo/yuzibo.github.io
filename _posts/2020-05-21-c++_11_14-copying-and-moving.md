---
title: c11与c14之 copy-moving
category: c++
layout: post
---

# 0x0 前言
本系列是根据 SCott Meyers 的大作<<overview of the new c++(c++11/14)>>进行练习总结。
因为我本身对c++的使用还不是特别的熟悉，所以，在阅读本系列的过程中，在对一些新的特性进行
阐述的时候，可能会显得尤其啰嗦，这也符合我一贯的行文习惯，不好，这点得改。

BTW, 为什么这么着急的去看一些 c++的东西呢？ 因为aosp的大部分是C++写的啊，作为AOSP的使用者
，能不了解C++最新的技术吗？

# Copying vs Moving

## copy constructor

拷贝构造函数是一种将对象初始化的方式，除了那种带有参数的构造函数外，这也算一种很常见的赋值对象的方式。
```c
#include <iostream>
using namespace std;

class Point {
	private:
		int x, y;
	public:
		Point(int x1, int y1){x = x1, y = y1 ;} // Directly constructor
		// 另一种给构造函数赋初始值的方式是
		// 成员列表的形式: Point(int x1, int y1) : x(x1), y(y1){}
		// 这种方式只能类内使用
		Point(const Point &p2) { x = p2.x, y = p2.y ;} // copy constructor
		int getX() { return x ;}
		int getY() { return y ;}
};
int main()
{
	Point p1(10, 15);
	Point p2 = p1; // assign object
	cout << p1.getX() << endl;
	cout << p2.getY() << endl;
}

```

### 什么时候用copy constructor

[参考资料](https://www.geeksforgeeks.org/copy-constructor-in-cpp/)

1.
