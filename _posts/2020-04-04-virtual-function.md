---
title: "c++ 多态的概念和虚函数的用法"
category: c/c++
layout: post
---
* content
{:toc}

c++的虚函数与面向对象的`多态`的思想紧密结合，[这篇文章](https://www.geeksforgeeks.org/polymorphism-in-c/)
简单介绍了多态的一些概念，这个值得下面进行总结。

# 多态 polymorphism
多态主要有两种:

1. 编译时多态
	1. 方法重载
	2. 符号重载

2. 运行时多态
	1. 虚函数

目前，本博客已经就编译时多态进行了一些总结，这篇文
章主要总结运行时多态的用法，也就是虚函数的用法。

举个简单的例子热身.

```c
using namespace std;


class B {
        public:
                virtual void s() = 0; //  pure Virtual Function
};

class D:public B{
        public:
                void s(){
                        cout <<"Virtual function in Derived class";
                }
};
int main(){
        B *a;
        D obj;
        a = &obj;
        a->s();
}

```

[参考这篇文章](https://www.geeksforgeeks.org/virtual-function-cpp/)

# 实例1
为了更好的说明虚函数的用法，先看一个最基本的例子：
```c
#include <iostream>
using namespace std;

class base {
	public:
		virtual void print() // keyword virtual
		{
			cout << "print the base class" << endl;
		}
		void show(){
			cout << "show the base class" << endl;
		}
};
class derived : public base {
	public:
		void print()
		{
			cout << "print derived class " << endl;
		}
		void show()
		{
			cout << "show derived class" << endl;
		}

};

int main()
{
	base* bptr;
	derived d;
	bptr = &d;

	// vitual function, binded at runtime
	bptr->print();

	// Non-virtual function, binded at compile time
	bptr->show();
}
```
输出结果为:
```bash
print derived class
show the base class
```
这里最显著的一个地方在于，在同一个派生类（有地址引用）调用`有无`virtual修饰的方法是不一样的。
如果用我自己的话说就是，虚函数改变了基类的成员函数，这还是在不修改
基类代码的情况下。那么，在已有继承的方法前提下，这个特点还有意义吗？
或者说，虚函数到底是做什么的？这不仅仅对我这样的初学者是一种疑惑，
同样的，[stackoverflow](https://stackoverflow.com/questions/2391679/why-do-we-need-virtual-functions-in-c)
也有类似的疑惑。Task is cheap,show me the code.

`example 1`:
```c
#include <iostream>
using namespace std;

class Animal {
	public:
		void eat() {
			cout << "I' m eating generic food" << endl;
		}
};
class Cat : public Animal{
	public:
		void eat() { cout << "I am eating a rat " << endl; }
};
int main()
{
	Animal *animal = new Animal;
	Cat *cat = new Cat;

	animal->eat(); // I am eating generic food
	cat->eat(); // I am eating a rat
}
```
都没问题吧，但是，如果利用一个中间函数去调用情况又不一样了，比如：

```c
void func(Animal *xyz) {
	xyz->eat();
}
int main()
{
	Animal *animal = new Animal;
	Cat *cat = new Cat;

	func(animal);
	//I' m eating generic food
	func(cat);
	//I' m eating generic food		''
}
```

这个时候就出现问题了,全部输出了基类的方法。如果还有dog pig monkey
啥的都能乱死了，那怎么办？
关键就是在基类的方法加上`virtual`就可以了。

其实，在我看来，加上这个关键词并不能有助于真正理解这个问题：问题的
关键在于怎么使用基类和派生类才会导致这个问题的产生。

如果在`func(Animal *xyz)`使用 cat 去定义函数参数类型则是失败的。

# 实例2
这是一个[编程题目](https://www.hackerrank.com/challenges/virtual-functions/problem)大体的意思是:

一个基类： Person, 内含 name age两个成员变量，getdata()和putdata()两个方法，负责分别得到和输出两个成员变量。

派生类Professor多加一个publications的变量，两个成员方法不变，只不过在putdata方法中
还需要自动展示一个id号。

派生类Student需要一个marks[6]去存储6门课程成绩，最后输出。

代码如下：
```c

/*
 *     File Name: print_test.cpp
 *     Author: Bo Yu
 *     Mail: tsu.yubo@gmail.com
 *     Created Time: 2020年04月26日 星期日 09时00分43秒
 */
#include <iostream>
#include <cstring>

using namespace std;

class Person {
public:
    string name;
    int age;
    virtual void getdata() {
        cin >> this->name >> this->age;
    }
    virtual void putdata() {
        cout << this->name << " " << this->age << endl;
    }
};

class Professor : public Person {
public:
    Professor() {
        this->cur_id = ++id;
    }
    int publications;
    static int id;
    int cur_id;
    void getdata() {
        cin >> this->name >> this->age >> this->publications;
    }
    void putdata() {
        cout << this->name << " "
            << this->age << " "
            << this->publications << " "
            << this->cur_id << endl;
    }
};
int Professor::id = 0;

class Student : public Person {
#define NUM_OF_MARKS 6
public:
    Student() {
        this->cur_id = ++id;
    }
    int marks[NUM_OF_MARKS];
    static int id;
    int cur_id;
    void getdata() {
        cin >> this->name >> this->age;
        for (int i=0; i<NUM_OF_MARKS; i++) {
            cin >> marks[i];
        }
    }
    void putdata() {
        int marksSum = 0;
        for (int i=0; i<NUM_OF_MARKS; i++) {
            marksSum += marks[i];
        }
        cout << this->name << " "
            << this->age << " "
            << marksSum << " "
            << this->cur_id << endl;
    }
};
int Student::id = 0;

int main(){

    int n, val;
    cin>>n; //The number of objects that is going to be created.
    Person *per[n];

    for(int i = 0;i < n;i++){

        cin>>val;
        if(val == 1){
            // If val is 1 current object is of type Professor
            per[i] = new Professor;

        }
        else per[i] = new Student; // Else the current object is of type Student

        per[i]->getdata(); // Get the data from the user.

    }

    for(int i=0;i<n;i++)
        per[i]->putdata(); // Print the required output for each object.

    return 0;

}
```

需要说明的一点是:

`类中的静态成员变量必须在类外定义`，这一点是由于static变量的生存周期决定的。
我自己的代码与这份代码已经具有85%的相似性了，但是就是输出不对。
