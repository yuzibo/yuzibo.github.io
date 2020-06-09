---
title: c++之static_cast的用法
category: c++
layout: post
---
* content
{:toc}

# 形式
```c
static_cast<type> 或者
static_cast <type-id> ( expression ) 
```

# 类型转换
截止到目前c++，一共有
```bash
1. static cast
2. Dynamic Cast
3. Const Cast
4. Reinterpret Cast
```
今天介绍的`Static Cast`是最简单的一种类型转换声明。其实，在c语言中大部分的类型转换（隐式或者显式）都是类似这样的：

```c
int main(){
	float f = 3.5;
	int a = f; // in c-sytle conversion
	int b = static_cast<int>(f);
	cout << "a is " << << " " << a << "b is " << b << endl;
}
```
那么，使用这个显式转换有什么好处吗？结合第二个例子看一下:
```c
int main(){
	int a = 10;
	char c = 'a';

	int* q = (int*)&c;
	int* p = static_cast<int*>(&c);
	return 0;
}
```
输出:
```c
vimer@host:~/src/test/c++$ g++ -g s_cast2.cpp -o s2
s_cast2.cpp: In function ‘int main()’:
s_cast2.cpp:15:31: error: invalid static_cast from type ‘char*’ to type ‘int*’
  int* p = static_cast<int*>(&c);
                               ^
```
上例中的`int \*q`，把字符变量的地址指向int型的指针(也许这种转换在程序中就是无意义的)，如果加上`static_cast<>`就可以让编译器之处这种错误了。

至于这种错误有什么影响，我自己还真菜，没有想清楚，看看这个[so](https://stackoverflow.com/questions/103512/why-use-static-castintx-instead-of-intx)

给出的解释是c是占据一个字节，但是指针是4个字节，这样在运行时就会出错。(至于为什么我还有点难以理解)

`static_cast`可以在编译阶段显式的阻止不正确的类型转换，这一特点很重要，试想在一个规模很
庞大的c++工程中，比如aosp这种，前后自定义的类型特别多，很容易在类型转换的时候导致一些
很微小的、不易察觉的错误。

第二个例子:
```c
class Int{
	int x;
	public:
	Int(int x_in = 0) : x {x_in} {
		cout << "Conversion Ctor called" << endl;
	}
	operator string(){
		cout << "Conversion Operator " << endl;
		return to_string(x);
	}
};

int main(){
	Int obj(3);
	string str = obj;
	obj = 20;
	string str2 = static_cast<string>(obj);
	obj = static_cast<Int>(30);
	return 0;
}
```
output:

```c
vimer@host:~/src/test/c++$ ./class 
Conversion Ctor called
Conversion Operator 
Conversion Ctor called
Conversion Operator 
Conversion Ctor called
```

# 与隐式转换相比
等我将这四种类型转换介绍完毕后我再统一介绍下这四种类型的适用场景，这里先说一下 static_cast与c-style的不同:
1. 便于搜索 grep xx  看起来整洁一点（这一点是相对的）；
2. 阻止类型不正确的转换；
