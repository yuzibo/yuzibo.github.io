---
title: rvalue reference in c++
category: c++
layout: post
---
* content
{:toc}

# rvalue references
首先，我们考虑下之前的有关这类的定义。有一个"左值"(lvalue)是一个指针能够指向的内存位置，那么，"
右值"(rvalue)是不需要指针指向的一类东西。从生命周期的角度考虑，一个rvalue的使用范围很短，
且一个rvalue不指向任何地方；而lvalue自变量进行声明后一直到消亡。

```c
int x = 666;
```
以这个赋值为例，我们的"666"可以看成一个字符常量，这个字符没有指向任何的地址，所以我们可以
把“666”看成rvalue.而这个数据赋值给了变量x，这个变量x就是一个内存地址的别名，我们可以通过指针
去访问这个x（地址）的内容，所以它是一个lvalue。

```c
int *y = &x; //
```
我们利用取址符"&"，将变量x的地址取出来，然后赋值给int \*的变量y，这里也许有人会问，既然是存储
变量的地址，那么我们使用int y不行吗？至少在我看来，最明显的问题就是类型不一致，因为我们得保障
地址类型(\*)的接受变量是一致的。结合我们今天要介绍的知识就是，&的操作数是lvalue,但是产生的
结果是rvalue.

其实，这里就总结出来了左值和右值的一般定义就是: 在"="赋值符左边的变量就是左值，相反在右边的就是
右值。

```c
int y;
666 = y;
```
这个程序就算新手也不会这么写，那错在哪里呢？是把y保存到地址666位置上引起系统奔溃吗？从技术角度看
就是，"666"就是一个文字表达式常量(literal constant)，实际就是，y没有保存到任何地方（因为编译器
根本识别不了）。

# 函数返回值
先看一个例子:
```c
int setValue(){
	return 6;
}
//...
setValue() = 3;
```
很明显，这是error,使用上面的例子我们知道了setValue函数的返回值就是一个右值。但是：

```c
int global = 100;
int& setGlobal(){
	return global;
}
// ...
setGlobal() = 400;
```
这个代码是ok的，注意，如果我不指明的话，上面的代码是不是看不出来是c++？
那么，假设这是c的话一点不突兀吧，再想一想自己过去在c++中参数的引用，不就是
这个样子呢？

这个代码返回了一个引用。*引用*就是一个指向已经存在的变量地址，上述代码就是(global)，
因此这也是一个lvalue。注意这里的"&" 不是取地址符而是引用符号。

当然这个用法还是很少用的。

# 左值引用
接着看一个例子。
```c
int y = 10;
int& yref = y;
yref++; // Now y is 11
```
这里，*yref*的类型是*int&*，而且是变量y的引用，这个时候就可以正常的改变y的值
通过改变yref.现在可以明确一点的就是，引用必须指向一个具有明确位置的对象，y在这里是满足的，ok。

```c
void func(int& x){

}
int main(){
	func(10);// error!
	// x = 10;
	// func(x);
	// is ok
}
```
output:
```bash
rvalue.cpp:14:9: error: cannot bind non-const lvalue reference of type ‘int&’ to an rvalue of type int’
  func(10);
           ^
```
其实这里涉及到了一个rvalue to lvalue conversion.而这种转化是错误的。但是，哈哈，又有意外：
```c
const int& ref = 10; // It is ok
```
下面的代码也是ok的:
```c
void func(const int& x){

}
int main(){
	func(10);
}
```
 为什么这样一改就可以呢？从来没有技术方面的考虑，就是从一个常理考虑的:
使用const修饰表明你不想修改这个参数，对不对。那么，你传递过去一个字符常量是没问题的。

# int&&
在英文中，"&&"是 Double address operator或者
double ampersand, 假设:
```c
int&& a; // "a" 是一个 r-value reference
```
而且在常规的用法中，"&&"是经常在函数中被声明一个参数，
再次澄清一遍，右值就是没有内存地址的一个符号。上面已
经说过，右值引用的不能够指向左值。[1]

# 右值引用的作用

# 参考
[1](https://stackoverflow.com/questions/5481539/what-does-t-double-ampersand-mean-in-c11)

