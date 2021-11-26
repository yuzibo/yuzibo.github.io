---
title: C++中NULL元素的特殊点
category: c/c++
layout: post
---
* content
{:toc}

# 缘由

我们都对c++的NULL不陌生，但是今天在看一个代码的时候突然愣住了，就是简单的如下面这样:

```c
 if(start > end) {
    res.push_back(NULL);
    return res;
}
```

你说这个条件成立的话，另一个意思就是res添加了一个NULL元素,那么，该res.size()的值会不会加1呢，答案是肯定的，只不过我之前没有遇到此类的问题，导致自己没想过来，下面使用具体的代码进行验证:

```c
int main() {
        vector<char*> s;
        s.push_back("hello");
        cout << s.size() << endl;
        s.push_back(NULL);
        cout << s.size() << endl;
}
// output
// 1
// 2
```

一看上述代码就是新手写的，为啥呢？会报警告的，c++编译器，详情可以参考这篇[文章](https://developer.aliyun.com/article/277202)

```c
  s.push_back(const_cast<char*>("hello"));
```
这样的代码才算ok， 或者直接声明为`vector<string> s`, 但是更需要特许处理一下。






