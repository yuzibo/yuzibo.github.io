---
title: c++的输入输出小结
category: c++
layout: post
---
* content
{:toc}

任何一门编程语言的输入输出都应该彻底的掌握，c++更应该是这样的。

# 小数点精度
这个直接使用<iomanip>文件下的内容即可。
```c
int main() {
    int a; long b; char c; float d; double e;
    cin >> a >> b >> c >> d >>e;
    cout <<  a << endl << b << endl << c << endl;
    cout << setiosflags(ios::fixed) << setprecision(3);
    cout << d << endl;
    cout << setiosflags(ios::fixed) << setprecision(9);
    cout << e << endl;
    return 0;
}
```
方法`setiosflags`具有后效性，一旦你设置了，一直到程序结束，精确度会一直保持下去的.

# 完整读取一行字符串

有两种方式: getline()和cin.getline().

## getline()

该函数可以直接读取c++的string。

```c++
    string str;
    getline(cin, str);
    cout << str << endl;
```
结果:
```bash
vimer@host:~/test$ g++ -g getline.cpp -o getline
vimer@host:~/test$ ./getline
[null,2,3,null,] # input
[null,2,3,null,] # output
```
## cin.getline()
这是一种类似c的方式使用数组。
```c
    char str2[1024];
    cin.getline(str2, 1024);
    cout << str2 << endl;
```
结果:
```bash
vimer@host:~/test$ g++ -g getline.cpp -o getline
vimer@host:~/test$ ./getline
[2,3,,null] # input
[2,3,,null] # output
```
leetcode的c++代码，尤其是二叉树的那部分，其测试用例都是使用,例如:

> [1, null,3,4,5]

这类的数组形式的输入，那如果自己写测试用例怎么办？我的思路是，首先按照上面的方式整行读取文本内容，然后再借助c++的
strtok函数分别提取出来或者存储在另外一个数组。
