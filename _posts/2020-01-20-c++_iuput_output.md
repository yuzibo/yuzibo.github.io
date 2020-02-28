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
