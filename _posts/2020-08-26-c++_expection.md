---
title: c++之expection
category: c++
layout: post
---
* content
{:toc}

# 历史渊源
expection在众多的编程语言中占据着重要的地位， 大名鼎鼎的java python都有这个关键词。
expection是一个基类，一般可以通过 #include<expection> 引入。

# 形式
一般来说，形式如这个代码块:

```c++
try {
			bool isValid = checkUsername(username);
			if(isValid) {
				cout << "Valid" << '\n';
			} else {
				cout << "Invalid" << '\n';
			}
		} catch (BadLengthException e) {
			cout << "Too short: " << e.what() << '\n';
	}
```
这个catch就是需要自定义的.

```c++
#include <exception>
using namespace std;

/* Define the exception here */
class BadLengthException : public exception {
    public:
        int N;
        BadLengthException(int n) {
            this->N = n;
        };
        int what() {
            return this->N;
        }
};
```

# Why use exception?
[stackoverflow](https://stackoverflow.com/questions/4506369/when-and-how-should-i-use-exception-handling)

[c++ FAQ](https://isocpp.org/wiki/faq/exceptions)
