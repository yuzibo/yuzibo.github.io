---
title: c++之lambda表达式
category: c++
layout: post
---
* content
{:toc}

本篇是第一篇接触如此高级议题的c++的文章，让我们来看一下c++的lambda的表达式。

lambda是一个新鲜事物(相比c98),其实到c++ 14这个东西也在不停的发展，还是有一些意思的，至于为什么引入lambda表达式，我目前也没有搞明白，如果后面有一个深入的理解，我再回来补充完善。

(浅显的理解就是，lambda用作为捕捉，就是以一种全新的方式用作简化表达的方式，新的语法。但是优势在哪里，目前不知道)
c++给人的感觉就是不停的自我革命，前一版的限制，下一版出来一个特性突破上次的限制。

根据[官方文档](https://en.cppreference.com/w/cpp/language/lambda), 记录点自己的心得，简单的[概念理解](https://www.jianshu.com/p/923d11151027)，可以看这篇文章。

一般的函数定义为:
```c
ret_value function_name(parameter) option { function_body; }
```

而lambda表达式的形式为:
```c
[ capture ] ( parameter ) option -> return_type { body; };
```
看到这个箭头，我就突然想起了Rust中，也有类似的用法。

# capture list

捕捉在形式上利用","分割，当然也有一些默认的捕捉符。

1. `[]`不捕获任何变量
2. `[&]`以引用的方式捕获外部作用域的所有变量
3. `[=]`以赋值方式捕获外部作用域的所有变量
4. `[=, &foo]`以赋值的方式捕获外部作用域所有变量，以引用方式捕获foo变量
5. `[bar]`以赋值方式捕捉bar变量，不捕获其他变量
6. `[this]`捕获当前类的this指针，让lambda表达式拥有和当前类成员同样的访问权限，可以修改类的成员变量，使用类的成员函数。如果已经使用了&或者=，就默认添加此选项。


以下几点为特殊说明:

A lambda expression can use a variable without capturing it if the variable

    1. is a non-local variable or has static or thread local storage duration (in which case the variable cannot be captured), or
    2. is a reference that has been initialized with a constant expression.

A lambda expression can read the value of a variable without capturing it if the variable

    1. has const non-volatile integral or enumeration type and has been initialized with a constant expression, or
    2. is constexpr and has no mutable members.

符号“（）”可以作为他的默认构造函数,看下面的例子:

```c
// generic lambda, operator() is a template with two parameters
auto glambda = [](auto a, auto&& b) { return a < b; };
bool b = glambda(3, 3.14); // ok
```

返回值为`auto`类型的lambda值，可以被称为`generic lambda`,从这个简单的例子看的出来，这和模板(template)没有太多的区别。

一个综合的例子:

```c
#include <iostream>
#include <vector>
#include <algorithm>
#include <functional>

using namespace std;

int main(){
        std::vector<int> c = {1, 2, 3, 4, 5, 6, 7,8};
        int x = 5;
        c.erase(std::remove_if(c.begin(), c.end(), [x](int n) { return n < x;}), c.end());
        std::cout << "c" << endl;
        std::for_each(c.begin(), c.end(), [](int i){ std::cout << i << " "; });
}

```