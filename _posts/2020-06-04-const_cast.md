---
title: c++之const_cast的用法
category: c++
layout: post
---
* content
{:toc}

const_cast这个强制转换的作用需要你对关键词`const`的威力有一个清晰的认识才可以。简而言之
const_cast可以转变由const修饰的某些东西。

# const用法总结
## const修饰的常量
必须在定义的时候进行初始化。 
```c
const int b = 10;
	b = 0; // errors: b can not be changed
	const string s = "vimer";
	const int i, j = 0; // uninitialized const i
```
显示的错误为:
```c
vimer@host:~/src/test/c++$ g++ -g const2.cpp -o s2
const2.cpp: In function ‘int main()’:
const2.cpp:18:6: error: assignment of read-only variable ‘b’
  b = 0; // errors: b can not be changed
      ^
const2.cpp:20:12: error: uninitialized const ‘i’ [-fpermissive]
  const int i, j = 0; // uninitialized const i
            ^
```

## const与指针
这一块在当时看c++的教科书时就很迷惑，现在终于有机会整理了，总结下。
```c
const  char *a;
char const *b;
char * const c;
const char* const a;
```
现在就根据[这篇文章](https://stackoverflow.com/questions/890535/what-is-the-difference-between-char-const-and-const-char)

处理此类的困惑，要结合从右到左的(from-right-to-left) 原则。

1. 默念
```c
int 		*		mutable_pointer_to_mutable_int;
int const	* 		mutable_pointer_to_const_int;
int			* const const_pointer_to_mutable_int;
int const   * const const_pointer_to_const_int;
```
2. 读出来- from right to left
```c
const int *foo; // equilant to int const *foo
```
`foo` points `(\*)` to an `int` that cannot change `const`.
```c
*foo = 123 or foo[0] = 123; // invalid
foo = &bar; // ok
```
第二：
```c
int *const foo; // 
```
Means "foo cannot change (const) and points (\*) to an int"
```c
*foo = 123 or foo[0] = 123 // ok == 
foo = &bar; // not right
```
第三:

```c
const int *const foo; //
*foo = 123 or foo[0] = 123; // not right
foo = &bar; // not right 
```
 












