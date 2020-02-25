---
title: c++的类模板
category: c++
layout: post
---
* content
{:toc}

还记得在初次接触c++的时候，根本看不见去有关模板的任何东西。现在看上去还好一些，现在就将一些基本的总结下来。

# class template
其实，按照c++的学习规律看，应该先介绍函数模板后再介绍class模板，可是因为做题需要，就先介绍这个东西。
函数模板中定义的类型参数可以用在函数声明和函数定义中，类模板中定义的类型参数可以用在类声明和类实现中。类模板的目的同样是将数据的类型参数化。

```c
template<typename 类型参数1 , typename 类型参数2 , …> class 类名{
    //TODO:
};
```
一旦定义好了类模板，就可以将类型参数用于类的成员函数了，也就是原来使用<font color= "red"> int float char</font>等关键词的地方都可以用类型参数来代替。下面是一个
网站的学习例子 ，假设设计一个类模板，首先先使用一个参数初始化容器，后面使用`add(x)`
方法将初始化 的参数和`add`里面的参数求和后再输出，要求这个类可以处理<font color = "red"> int long string</font>等.

### 一个参数
输入的格式为：
```c
3
string John Doe
int 1 2
float 4.0 1.5
```
则输出为:

```c
JohnDoe
3
5.5
```
先看一下主函数是怎么处理的 ：
```c
int main () {
  int n,i;
  cin >> n;
  for(i=0;i<n;i++) {
      string type;
      cin >> type;
      if(type=="float") {
              double element1,element2;
              cin >> element1 >> element2;
              AddElements<double> myfloat (element1);
              cout << myfloat.add(element2) << endl;
          }
          else if(type == "int") {
	          int element1, element2;
	          cin >> element1 >> element2;
	          AddElements<int> myint (element1);
	          cout << myint.add(element2) << endl;
	      }
	      else if(type == "string") {
	              string element1, element2;
	              cin >> element1 >> element2;
	              AddElements<string> mystring (element1);
	              cout << mystring.concatenate(element2) << endl;
	          }
	        }
    return 0;
}
```
那么，这个模板应该如何定义？
```c
template <class T>
class AddElements {
private:
    T m_x; // 这是成员变量，其类型一定是泛型的
public:
    AddElements(T x): m_x(x) {} // 这是构造函数初始化参数的一个方法
			// 如果两个参数 Point(T1 x, T2 y): m_x(x), m_y(y){ }
    T add(T x) const; // 成员函数的返回值类型 返回和
    T concatenate(T x) const;
};
// class的成员函数需要在类外定义，仍需带上模板头
template <class T>
T AddElements<T>::add(T sec) const {
    return sec + this->m_x;
}
template <class T>
T AddElements<T>::concatenate(T str) const {
    return  this->m_x + str;
}
```
这个问题的难点在于如何找到第一次定义时的参数？幸好我会前理解了下`this`指针，
而且一下子就命中。这里作为新手有几个部分需要注意一下：
`定义成员函数的形式，别忘了<T>`
与函数模板不同的是，类模板在实例化时必须显式地指明数据类型，编译器不能根据给定的数据推演出数据类型。 <font color = "red">这也是一个参数的</font>。

### 无参数
这里需要再澄清一次，你的参数一定是传递给class的成员变量处理，这也就是为什么必须
模板参数。下面的例子就是打印一个数组：很简单，但是很直接。<font color = "red">这是无参数的</font>

```c
template <class T>
class Array{
private:
	T *ptr;
	int size;
public:
	Array(T arr[], int s);
	void print();
};
template <class T>
Array<T>::Array(T arr[], int s){
	ptr = new T[s]; // ptr 是class的私有变量，这里可以直接使用
	size = s;
	for(int i = 0; i < size; i++){
			ptr[i] = arr[i];
		}
}
template <class T>
void Array<T>::print(){
	for (int i = 0; i < size; i++){
			cout << " " << *(ptr + i);
				}
		cout << endl;
}
int main()
{
	int arr[6] = {1,2,4,6,7,4};
	Array<int> a(arr, 6);
	a.print();
	return 0;
}
```

### 多参数
```c
template <class T, class U>
class testClass {
private:
	T x;
	U y;
public:
	testClass(){
			cout << "Constructor called" << endl;
				}
};
int main()
{
	testClass<char, char> a;
	testClass<int , char> b;
}
```

如果想使用默认参数，也是在声明对象时，能不能设置一个默认的参数？
可以的，只需在声明模板的时候指定就可以了。比如，<font color = "red"> template<class T, Class U = char></font>,
在使用的时候可以`testClass<char, > a`就可以的。
# Function template
其实与class 模板是一致的，只不过这里处理的是函数，class 在处理上稍微更复杂一些。
还是上代码：
```c
template <typename T>
T myMax(T x, T y){
	return x > y ? x : y;
}
int main()
{
	cout << myMax<int>(3, 7) << endl;
	cout << myMax<char>('a', 'b') << endl;
}
```
这句是对函数进行模板化的。

# FAQ
1. 函数重载于函数模板这二者有什么不同？
先说明下，这二者都是来自于面向对象的多态特征。[这篇文章](http://www.aftermath.cn/2020/01/17/c++-small-summary/)记录了一点函数重载。简单一句话，
函数重载是多个函数做`相似`的事情，函数模板是多个函数做`相同`的操作。
