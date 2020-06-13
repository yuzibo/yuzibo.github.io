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

# const在函数中的应用

## 修饰函数返回值
这里会涉及以下三种情况:
```c
const int fun1(); // 无意义，返回值要给其他使用
const int* func2(); // 指针指向的内容不变
int *const func3(); // 指针本身不可变
```
以上例子不够详细，来看一下[更复杂](http://duramecho.com/ComputerInformation/WhyHowCppConst.html)的。

```c
char *Function1()
{ return “Some text”;}
// 如果使用的下面的语句就会crash（我现在还不明白）
Function1()[1]=’a’;

// 如果使用const，编译器就会报错
const char *Function1()
{ return "Some text";}""}
```
## 修饰函数参数
函数参数使用const修饰，这里涉及到了两种情况:

1. 传值参数不可变，无意义
```c
void func(const int a); // a本身是形参，不会被改变
void func2(int *const var); // 指针本身不可变
```
这里涉及到一个基本的事实，就是函数被调用会开辟一个新栈，其形参会被复制给临时变量，而且
对临时变量所做的修改，都不会影响到形参的内容。
2. 参数所指内容为常量不可变
此类函数经常用在与字符串相关的操作中
```c
void string_copy(char *dst, const char *src);//
// 函数体内如果修改src 的内容将会编译出错
```
3. 修饰自定义的参数，比如：
```c
void func(A a)
```
其实这里应该同1是一样的。在c/c++中，函数的参数被copy，这样如果
不利用特殊手段，函数的参数本身不会被函数的行为所改变。
```c
void change_arg_value(int val){
	val = 56;// val will not changed into 56
}
```
在c++中，有一个很迷惑人的词语叫做"引用"，初学者，尤其从c语言转过来的
很难接受，至少对我而言是这样。
```c
void change_arg_value2(int &arg2){
	args2 = 56;//ok, agrs will be 56
}
```
那么，在c中相似的用法想必大家都知道了，就是传递地址的方式:
```c
void change_arg_value3(int *args3){
	*args3 = 78;
}
```
二者的对比程序如下:
```c
void change(int &args){
	args = 56;
}
void change2(int *args3){
	*args3  = 78;
}
int main()
{
	int a = 6;
	change(a);
	cout << "after reference a is " << a << endl;
	change2(&a);
	cout << "After passing of address of variable, a is " << a  << endl;
}
/* output:
 * vimer@host:~/src/test/c++$ ./ref
 * after reference a is 56
 * After passing of address of variable, a is 78
*/
```
那么，const又是如何与这块签上关系的呢？ 对于c++而言，我们知道了引用是一个高效的
“传递参数”的用法，至少不会产生大量的构造、copy相关的操作，这一点尤其对自定义的
class或者struct重要。
```c
void func4(big_struct_type &args4);
```
好，对于提高参数传递效率的目的我们已经达到了，那为什么还需要`const`呢？试想一下，
如果我们对于这个参数只是使用，对，使用，我们不希望在这个函数对这个数据进行修改，
或者不允许对此进行修改，怎么办？const的意义就在于此。
```c
void func5( big_strcut_type const &args5) // 或者
void func5(const big_struct_type &args5)
```

# const在类中的应用
这块的内容也很复杂，我这里先说明一种最重要的使用案例吧，至少很好理解的。
```c
class Test(){
	void method1();
	int member_var;
}
```
除去那些很复杂的方法，如果这里的method1()本意是不修改任何成员变量，那么，你能保证类似
下面的代码不发生吗?
```c
void Test::method1(){
	member_var += 1;
}
```
为了阻止像这样可能出现意外的情况，那么，最好使用
```c
class Test(){
	void method1() const;
	int member_var;
}
```
最好的解释还是在这个[SO](https://stackoverflow.com/questions/3141087/what-is-meant-with-const-at-end-of-function-declaration)

在一个方法后面加上关键词const，可以有效的防止该方法对类中的变量进行修改，如果这么做的话
编译器也会抛出一个编译错误的。

从另一个角度看，const加载函数结尾为什么会产生这个效果？这里就涉及到了this指针。
```c
int Foo::Bar(int random_arg); // 更详细的如下：
int Foo_Bar(Foo* this, int random_arg);
Foo f; 
f.Bar(4); //等同于
Foo f; 
Foo_Bar(&f, 4);
```
但是如果添加const进行修饰，则会有：
```c
int Foo::Bar(int random_arg) const;
int Foo_Bar(const Foo* this, int random_arg);
```
const影响成员变量的读写属性还是通过\*this指针确定的。

在c++11中，使用`mutable`关键词可以消除这种限制。

# 与define的区别
既然我们已经知道`const`的好处，尤其在使变量常量化这一点上，是不是与
关键词`define`很相似，那么，这二者还是有很大的不同的。













