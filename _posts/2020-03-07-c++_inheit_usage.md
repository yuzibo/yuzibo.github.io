---
title:  c++的继承使用方法
category: c++
layout: post
---
* content
{:toc}

继承的特性丰富了c++的使用，当然也有一定的使用门槛，现在简单介绍一点
这方面的知识，以备将来使用。

# 最简单的例子
下面的程序代码是一个最简单的使用继承的案例，我们来看一下:
```c
class Triangle{
    public:
    	void triangle(){
	     		cout<<"I am a triangle\n";
			    	}
};

class Isosceles : public Triangle{
    public:
    	void isosceles(){ // 等腰 三角形
	    		cout<<"I am an isosceles triangle\n";
			    	}
	  		//Write your code here.
};

int main(){
    Isosceles isc;
    isc.isosceles();
    isc.description();
    isc.triangle();
    return 0;
```
这一个是使用子类的实例化对象，继承了父类的方法。注意，这里没有解释一
些细节的问题，比如说`public`的属性什么的，只是在感官层面上进行一个概
括。

当然，还可以继续继承下去.

```c
class Equilateral : public Isosceles{
    public:
        void equilateral(){
            cout << "I am an equilateral triangle\n";
        }
};//Write your code here.
// 使用的话  ，可以直接实例化 Equilateral
int main(){
    Equilateral eqr;
    eqr.equilateral();
    eqr.isosceles();
    eqr.triangle();
    return 0;
}
```

# 子类的调用父类的成员
其实这里面对有关权限的制约还是非常复杂的，我这里暂时不打算讲述这些，毕竟我自己没有
尝试这些东西，那就先整下自己已经涉及到的内容。

## 子类调用父类的成员变量
这是什么意思？比如说，我的父类中有一个方法`display ()`,这个方法就是用来展示父类内部
的成员变量，但是呢，父类不提供构造方法，而是通过子类去给父类的成员变量赋值，这听起
来很变态，但是，这是[hackeranker的一道题目](https://www.hackerrank.com/challenges/rectangle-area/problem)

技巧在于在子类中使用keyword `using`,这个时候，你在子类中父类的变量(这个变量必须设置
为` public`)在子类中就可以自由的使用了.
```c
#include <iostream>
using namespace std;
/*
    * Create classes Rectangle and RectangleArea
     */
class Rectangle{
    public:
        int width;
        int height;
    public:
        void display(){
	            cout << width << " " << height << endl;
		            }
};
class RectangleArea : public Rectangle {
    public:
        using Rectangle::width; // 直接调用父类的成员
        using Rectangle::height;
    public:
        void read_input(){
	            cin >> width >> height;
	        }
        void display(){
	            cout << width * height << endl;
	    }
};
int main()
{
      RectangleArea r_area;
      r_area.read_input();
    /*
     * Print the width and height
     */
    r_area.Rectangle::display();
    /*
     * Print the area
     */
    r_area.display();
    return 0;
}
```

对于这个方案的处理，我不知道还有没有更好的处理呢？
