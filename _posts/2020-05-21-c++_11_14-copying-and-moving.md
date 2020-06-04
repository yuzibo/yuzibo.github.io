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

# std::move
std::move是<utility>工具库的一个特色，很直观的一个命名，就是移动一个对象的内容，
```c
#include <iostream>
#include <utility>
#include <vector>
#include <string>
using namespace std;

int main(){
	std::string str = "hello";
	std::vector<std::string> v;

	v.push_back(str);
	std::cout << "After copy, str is \"" << str << "\"\n";

	v.push_back(std::move(str));
	/**
	 * std::move的使用是将原对象的内容移动至现在的对象，
	 * 这样的效率很高，代价就是原对象的内容被移动后有可能为空
	 */
	std::cout << "After move, str is \"" << str << "\"\n";
	std::cout << "The contents of the vector are " << v[0] << " the v[1]" << v[0] << std::endl;

}
```
Output:
```c
After copy, str is "hello"
After move, str is ""
The contents of the vector are hello the v[1]hello
```
std::move的[解释](https://wendeng.github.io/2019/05/14/c++%E5%9F%BA%E7%A1%80/c++11std-move%E4%BD%BF%E7%94%A8%E4%B8%8E%E5%8E%9F%E7%90%86/)
.下面需要补充几个概念。

## 右值(rvalue)和左值(lvalue)
一般来说，可以取地址的是左值，不能取地址的是右值。那么，什么对象可以取地址，又有哪些量是不可以取地址的呢？
左值的声明符号为`&`，右值的声明符号为`&&`。

为什么引入了std::move？不知道在哪里看到过这样的笑话，说是一个hello,world的程序c++的表达式可以复制出200份的内容，这显然夸张，但是稍微复杂的构造函数列表那是真的恐怖，所以，上面的测试你也已经看到了效果，那就是原对象不再保存这份内容了。
[主要参考这篇文章](https://wendeng.github.io/2019/05/14/c++%E5%9F%BA%E7%A1%80/c++11std-move%E4%BD%BF%E7%94%A8%E4%B8%8E%E5%8E%9F%E7%90%86/)


