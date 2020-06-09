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
来看最后一个例子.

```c
using namespace std;

struct B {
	int m = 0;
	void hello() const {
		std::cout << "hello world, this is B\n";
	}
};

struct D: B {
	void hello() const {
		std::cout << "hello world , this is D\n";
	}
};

enum class E { ONE = 1, TWO, THREE };
enum EU { ONE = 1, TWO, THREE };

int main(){
	// 1 initializing conversion
	int n = static_cast<int>(3.14);
	std::cout <<"n = " << n << endl;
	std::vector<int> v = static_cast<std::vector<int>>(10);
	std::cout << "v.size() = " << v.size() << endl;

	// 2 static downcast
	D d;
	B& br = d;
	br.hello();

	D& another_d = static_cast<D&>(br);
	another_d.hello();

	// 3 lvalue to xvalue
	std::vector<int> v2 = static_cast<std::vector<int>&&>(v);
	std::cout << "after move, v.size() is " << v.size() << endl;

	// 4 discard-value expression
	static_cast<void>(v2.size());

	// 5 inverse of implicit
	void* nv = &n;
	int* ni = static_cast<int*>(nv);
	std::cout << "*ni = " << *ni << endl;

	// 6 array-to-pointer followed by upcast
	D a[10];
	B* dp = static_cast<B*>(a);

	// 7 scoped enum to int or float
	E e = E::ONE;
	int one = static_cast<int>(e);
	std::cout << one << endl;

	// 8 int to enum, enum to another enum
	E e2 = static_cast<E>(one);
	EU eu = static_cast<EU>(e2);

	// 9. pointer to member upcast
	int D::*pm = &D::m;
	std::cout << br.*static_cast<int B::*>(pm) << endl;

	// 10. void* to any type
	void* voidp = &e;
	std::vector<int>* p = static_cast<std::vector<int>*>(voidp);

}
vimer@host:~/src/test/c++$ g++ -g cast.cpp -o cast 
vimer@host:~/src/test/c++$ ./cast 
n = 3
v.size() = 10
hello world, this is B
hello world , this is D
after move, v.size() is 0
*ni = 3
1
0
```

# 与隐式转换相比
等我将这四种类型转换介绍完毕后我再统一介绍下这四种类型的适用场景，这里先说一下 static_cast与c-style的不同:
1. 便于搜索 grep xx  看起来整洁一点（这一点是相对的）；
2. 阻止类型不正确的转换；

# 名词解释
### downcast
与下面的upcast类似，都是用于cast方面的内容。downcast就是由基类向派生类 cast.
```c
D& another_d = static_cast<D&>(br);
another_d.hello();
```
就是downcast转换。
### upcast
```c
D d;
B& br = d;
br.hello();
```
而这种就是upcast,有派生类向基类cast.
