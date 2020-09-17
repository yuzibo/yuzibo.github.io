---
title: 特殊格式输出 in c
category: c
layout: post
---
* content
{:toc}

# 缘由
因为在目前的项目中，涉及到了很多了int与hex或者bin之间转换，之前还是傻乎乎的打算计算器去手工运算，忽然
之间大佬给了一个c语言的程序，看了以后恍然大悟，原来这个是最简单的方式，

# int to hex

```c
    int d = 123;
    printf("%d == 0x%x\n", d, d);
    // output： 123 == 0x7b
    int d = 123;
    printf("%d == %x\n", d, d);
    // 123 == 7b
```
可以发现，hex的格式输出符为`%x`,  那么如果想打印出前缀`0x`,则需要在格式符`%x`添加`0x`,如果是大写的0X, 需要
大写的`0X`.

# 链接
[SO1](https://stackoverflow.com/questions/3464194/how-can-i-convert-an-integer-to-a-hexadecimal-string-in-c/3464376)

