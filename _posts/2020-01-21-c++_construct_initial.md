---
title: "c++"的初始化
category: c++
layout: post
---
* content
{:toc}

# 构造函数的初始化
这个问题也需要总结一下，因为最明显的方案有两种。孰好孰坏，还得看情况。
题目来自于[hackerrank](https://www.hackerrank.com/challenges/box-it/problem?h_r=next-challenge&h_v=zen&isFullScreen=false)

## 初始化列表
这个在开源代码里比较常见，据说效率上比较快的。因为是构造函数吗，这里就涉及到
多参函数和无参函数。请看以下代码，是初始化一个`Box()`中的长宽高(l,b,h).

```c
class Box{
private:
    int l, b, h;
public:
    Box() : l(0), b(0), h(0){}
    Box(int length, int breath, int height) :
    l(length),b(breath),h(height)  //  be carefully ","
    {
    }  // this is initialzer list method
    Box (const Box& obj) :
    l(obj.l), b(obj.b),h(obj.h)
    {}   // copy constructor
    int getLength() {
	   return this->l;
    }
    int getBreadth() {
           return this->b;
    }
    int getHeight() {
	   return this->h;
    }
    long long int CalculateVolume()  // 必须大数梳理
    {
            long long int result =  1LL * this->l * this->b * this->h;
            return result;
     }
};
```
Please note the initialized list model is :
```c
    Box(int length, int breath, int height) :
    l(length),b(breath),h(height)  //  be carefully ","
    {
    }  // this is initialzer list method
```
There is `copy constructor function ` <font color = "red">Box(const Box& obj)</font>
The fundamental principle of copy constructor i dont understand.But we first
have a glance at :
```c
Box(int length, int breath, int height):l(length),b(breathr, h(height) {}
```
and `l`,`b`,`h` is private variables that we want to pass constructor
function's arguments.

Notes: There  will be must use `initialized list` as below:

1. No default arguments in inherit relationship,more understand:
```c
class Box() {
private:
	int m_length;
	int m_height;
public:
	Box(int length, int height) : m_length(length),m_height(height){}
} // below must use it ^_^
class red_Box: public Box{
public:
	red_Box(int length, int height, int type) :
	Box(length, height){
		;
	} // must use initialized list
private:
	int type;
}
```

2. Const constant in class must use it
```c
class Box() {
private:
	int m_length;
	int m_height;
public:
	Box(int length, int height) : m_length(length),m_height(height){}
} // below must use it ^_^
class red_Box: public Box{
public:
	red_Box(int length, int height, int type) :
	Box(length, height),
	TYPE(2)
	{
		// if TYPE = 4 is error
	} // must use initialized list
private:
	int type;
	const int TYPE;
```
3. containing custom data type of members
## Constructor body assignment
```c
    Box(){
             l = 0, b = 0, h = 0;
    } // default value is 0, maybe use below method


```

# 拷贝构造函数
```c
    Box (const Box& obj) :
    l(obj.l), b(obj.b),h(obj.h)
    {}   // copy constructor
```



[the chanlleg](https://www.hackerrank.com/challenges/box-it/problem?h_r=next-challenge&h_v=zen)

[类内定义的问题](https://stackoverflow.com/questions/10744787/operator-must-take-exactly-one-argument)
