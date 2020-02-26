---
title: "c++中string的用法"
category: c++
layout: post
---

[参考这篇](https://blog.csdn.net/tengfei461807914/article/details/52203202)

# string
string作为c++的一个标准stl,仅凭这一点就应该比c方便很多了（c大神勿喷）。

## 声明和初始化
使用等好的叫做拷贝初始化，不适用等号的初始化叫做直接初始化。
```c
 string s;//默认初始化
    string s1("ssss");
    cout << s1<<endl;
    string s2(s1);
    string s3 = s2;
    cout<<s3<<endl;
    string s4(10, 'c'); // 生成一个10个‘c’的s4
    cout<<s4<<endl;

     char cs[] = "hello,world";
    string s7(cs, 4); // 复制cs的前4个字符给s7
    string s1= "hello,world";
    string s8(s1,4); // 从s1的pos4开始赋值给s8,其大小不超过s1的size

    string s9(s1, 4,3);
    string s9(s1, 4,3); //从s1的第四位开始，符给3个字符给s9,超出的未定义
    string s = "helloyubo";
     string s2 = s.substr(1,5); //数字分别表明起点和终点位置
     cout << s2<<endl;
     string s3 = s.substr(1);// 从1一直到最后
     cout << s3<<endl;
    cout << s9<<endl;

```
如果输入的位置超出了字符的长度，则会抛出一个out_of_range的异常。
## insert
先看代码。

```c
 string str = "to be question";
    string str2 = "the ";
    string str3 = "or not to be";
    string::iterator it;
    str.insert(6, str2);i // c++的string从1开始计数
    str.insert(6, str3, 3, 4); // 在pos 6的位置上，插入str3从pos 3 开始，往后截取4个字符
     str.insert(14, " that is cool", 8); //在14的 pos上插入8个字符
     str.insert(6, " or not to be "); // 在pos 6上面，插入后面的字符串
     str.insert(6, 3,':'); // 在pos 6的位置上插入3个':'
      it = str.insert(str.begin()+5, ',');// 注意上面的str都保持了初始声明的样子
      //这里的begin+5，是从0数到4的，返回的*it是当前位置的内容
    cout << str << endl; // to be, question
    str.insert(str.end(), 3,':');// 在str的末尾处插入3个':'
    //to be, question:::
```

## erase操作
string设计区间操作的一般为左开右闭。下面的代码具有连续性，也就是说，经过一条语句后对另一条语句是有影响的。

```c
std::string str("This is c++");
   std::cout << str << '\n';// This is c++
   str.erase(5,2);
   std::cout << str <<'\n'; //This  c++ 擦除在pos 5后面的2位
   str.erase(str.begin()+5);
   std::cout << str<<'\n';//This c++ 擦除迭代器所处的位置上的内容
   str.erase(str.begin()+6, str.end());
   std::cout << str << '\n';//This c  擦除迭代器之间的内容
```

## append() 和replace()

append()的用法

```c
  std::string str;
   std::string str2 = "hello";
   std::string str3 = " world,yubo";

   str.append(str2);
   std::cout << str << '\n'; //hello
   str.append(str3, 7, 4);
   std::cout << str << '\n'; //helloyubo
   str.append("haha", 4);
   std::cout << str << '\n'; //helloyubohaha
   str.append("hechun");
   std::cout << str << '\n'; //helloyubohahahechun
   str.append(10u, '*');
   std::cout << str << '\n'; //helloyubohahahechun**********
   str.append<int>(5,65); //helloyubohahahechun**********AAAAA
   std::cout<< str <<'\n'; ```
直接粘replace()用法的代码
```c
std::string base="this is a test string.";
    std::string str2="n example";
    std::string str3="sample phrase";
    std::string str4="useful.";

    // replace signatures used in the same order as described above:

    // Using positions:                 0123456789*123456789*12345
    std::string str=base;           // "this is a test string."
    //第9个字符以及后面的4个字符被str2代替
    str.replace(9,5,str2);          // "this is an example string." (1)
    //第19个字符串以及后面的5个字符用str的第7个字符以及后面的5个字符代替
    str.replace(19,6,str3,7,6);     // "this is an example phrase." (2)
    //第8个字符以及后面的9个字符用字符串参数代替
    str.replace(8,10,"just a");     // "this is just a phrase."     (3)
    //第8个字符以及后面的5个字符用字符串参数的前7个字符替换
    str.replace(8,6,"a shorty",7);  // "this is a short phrase."    (4)
    //第22以及后面的0个字符用3个叹号替换
    str.replace(22,1,3,'!');        // "this is a short phrase!!!"  (5)
    //迭代器的原理同上
    // Using iterators:                                               0123456789*123456789*
    str.replace(str.begin(),str.end()-3,str3);                    // "sample phrase!!!"      (1)
    str.replace(str.begin(),str.begin()+6,"replace");             // "replace phrase!!!"     (3)
    str.replace(str.begin()+8,str.begin()+14,"is coolness",7);    // "replace is cool!!!"    (4)
    str.replace(str.begin()+12,str.end()-4,4,'o');                // "replace is cooool!!!"  (5)
    str.replace(str.begin()+11,str.end(),str4.begin(),str4.end());// "replace is useful."    (6)
    std::cout << str << '\n';
    return 0;
}
```

## assign()操作

代码如下：

```c
#include <iostream>
#include <string>

int main ()
{
    std::string str;
    std::string base="The quick brown fox jumps over a lazy dog.";

    // used in the same order as described above:
    //直接把base赋值给str
    str.assign(base);
    std::cout << str << '\n';
    //把base第10个字符以及后面的8个字符赋给str
    str.assign(base,10,9);
    std::cout << str << '\n';         // "brown fox"
    //把参数中的0到6个字符串赋给str
    str.assign("pangrams are cool",7);
    std::cout << str << '\n';         // "pangram"
    //直接使用参数赋值
    str.assign("c-string");
    std::cout << str << '\n';         // "c-string"
    //给str赋值10个'*'字符
    str.assign(10,'*');
    std::cout << str << '\n';         // "**********"
    //赋值是10个'-'
    str.assign<int>(10,0x2D);
    std::cout << str << '\n';         // "----------"
    //指定base迭代器范围的字符串
    str.assign(base.begin()+16,base.end()-12);
    std::cout << str << '\n';         // "fox jumps over"

    return 0;
}

```

## find()函数
代码：

```c
ios::sync_with_stdio(false);
  std::string str("There are two needles in this haystack with needles.");
  std::string str2("needle");
  //寻找第一次出现的needle,找到返回出现的位置，否则返回结尾
  std::size_t found = str.find(str2);
  if(found != std::string::npos)
    std::cout << "first 'needle' found at " << found << '\n'; // first 'needle' found at 14
     // 如果是str2 是neede，则结果为 NULL
   found = str.find("needles are small",found + 1, 6);
   if(found != std::string::npos)
    std::cout << "second 'needle' found at" << found << '\n'; //first 'needle' found at 14
//second 'needle' found at44
// 需要注释掉上面的语句
//还可以查找一个字符
```

### rfind()
函数查找最后一个出现的的字符串

## compare()
这里偷懒下，直接使用csdn的代码
```c
#include <bits/stdc++.h>
using namespace std;

int main()
{
    ios::sync_with_stdio(false);
    string s1="123",s2="123";
    cout<<s1.compare(s2)<<endl;//0

    s1="123",s2="1234";
    cout<<s1.compare(s2)<<endl;//-1

    s1="1234",s2="123";
    cout<<s1.compare(s2)<<endl;//1

    std::string str1 ("green apple");
    std::string str2 ("red apple");

    if (str1.compare(str2) != 0)
    std::cout << str1 << " is not " << str2 << '\n';
    //str1的第6个字符以及后面的4个字符和参数比较
    if (str1.compare(6,5,"apple") == 0)
    std::cout << "still, " << str1 << " is an apple\n";

    if (str2.compare(str2.size()-5,5,"apple") == 0)
    std::cout << "and " << str2 << " is also an apple\n";
    //str1的第6个字符以及后面的4个字符和str2的第4个字符以及后面的4个字符比较
    if (str1.compare(6,5,str2,4,5) == 0)
    std::cout << "therefore, both are apples\n";
    return 0;
}
```

# osstringstream
这是一个处理I/O输入输出流的大招，在头文件<sstream>文件下使用。这里，先简单介绍一个很特殊的用法
比如，如果在程序中需要将数字(int)和string组合在一块，现在可以有以下几个方法：

1. 纯c
```c
char *str = (char *)malloc(sizeof (x));
sprinf(str, "%s %d", int-x);
str[last] = '\0';
```

2. c/c++
首先将int转化为char\*
```c
string s = "Hello";
int a = 520;
char* buf = new char[10]; // 2147483647  int的最大值
_itoa(a, buf ,10); // 注意，这里float或者double转化有一些问题
		//重点是第三个参数，决定了进制
cout << s + buf << endl;
```

3. 纯c++的风格
主要使用osstringstream这个方法，其还是继承于string class，还包括istringstream(输
入操作)、 ostringstream(输出操作)，这些方法是可以处理类似c的字符串格式。

```c
osstringstream oss;
int a = 4520;
string str = " hello";
oss << str << a; // 现在，str和a的内容已经进入oss对象中
cout << oss.str() << endl; // 可以正常输出了
```

4. c++11的特性
哈哈， C++的复杂之处就在这里体现出来了，版本更新太快了，据说20即将面试了。
```c
int a = 520;
float b = 5.20;
string str = "Hello";
string res = str + to_string(a);
res.resize(4); // here， we need to be noticed
cout << res << endl;
```
[参考](https://blog.csdn.net/PROGRAM_anywhere/article/details/63720261)

# StringStream
这个方法也很特殊，他可以自己在一串混合字符串中自动摘取整型或者其他你指定的东西。
比如:

```c
stringstream ss("23,4,56");
char ch;
int a, b, c;
ss >> a >> ch >> b >> ch >> c;  // a = 23, b = 4, c = 56
```
下面的题目要求是在一串"24,5,26"的字符串中，将数字提取出来并存放到vector中。

1. way one
```c
vector<int> parseInts(string str)
{
	vector<int> vec;
	stringstream ss(str); // Declares a stringstream object to deal
	char ch; // -> ','
	int temp;
	while(ss){ // ss will be terminated by NULL byte
		ss >> temp >> ch; // Extract the comma with >> operators
		vec.push_back(temp);
	}
	return vec;
}
```
上面一定注意`stringstream()`实例化的参数就是你要处理的`string`

2. way two
还可以使用`strtok`这个函数，当然，在c++中，如果要直接使用`string`类型的东西交给
`strtok`处理，需要首先转化为`char* `。

```c
vector<int> parseInts(string str) {
    vector<int> nums;
    char* s_char = (char *)str.c_str(); // 这个转换将string -> char *
    const char* spilt = ","; // const 好习惯
    char* p = strtok(s_char, spilt);  // 需要知道这个函数的实现
    int a;                          // "24,25,26"
    while(p != NULL){
        // char* -> int
	sscanf(p, "%d", &a);
        nums.push_back(a);
        p = strtok(NULL, spilt);
    }
    s_char = NULL;
    return nums;
}
```
