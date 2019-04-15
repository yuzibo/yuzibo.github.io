---
title: "c语言中INT_MAX与INT_MIN的使用方法"
category: c
layout: post
---
* content
{:toc}

# 7. Reverse Integer
Given a 32-bit signed integer, reverse digits of an integer.
```c
Example 1:

Input: 123
Output: 321
Example 2:

Input: -123
Output: -321
Example 3:

Input: 120
Output: 21
```
Note:
Assume we are dealing with an environment which could only store integers within the 32-bit signed integer range: [−2^31,  2^31 − 1]. For the purpose of this problem, assume that your function returns 0 when the reversed integer overflows.

其中的一个解决方案为:
```c
int reverse(int x) {

    long int ps = 0;
    while(x){
        if(ps > INT_MAX/10 || ps < INT_MIN/10)
            return 0;
        ps = x % 10 + ps * 10;
        x /= 10;
    }
    return ps;
}
```

## INT_MAX与INT_MIN
这里值得注意的就是，INT_MAX与INT_MIN是定义在**limits.h**头文件中
```c
#define INT_MAX 2147483647
#define INT_MIN (-INT_MAX - 1)
```
所以，如果输入**1534236469**,期待结果为0(有点看不懂),文章来自[here](https://blog.csdn.net/twt520ly/article/details/53038345)解释的非常清楚：

We want to repeatedly "pop" the last digit off of xx and "push" it to the back of the \text{rev}rev. In the end, \text{rev}rev will be the reverse of the xx.  To "pop" and "push" digits without the help of some auxiliary stack/array, we can use math.
```c
//pop operation:
pop = x % 10;
x /= 10;

//push operation:
temp = rev * 10 + pop;
rev = temp;
```
However, this approach is dangerous, because the statement \text{temp} = \text{rev} \cdot 10 + \text{pop}temp=rev⋅10+pop can cause overflow.
Luckily, it is easy to check beforehand whether or this statement would cause an overflow.
To explain, lets assume that \text{rev}rev is positive.

1. if temp == rev * 10 + pop　can cause overflow,then it must be that rev >= (INT_MAX/10).
2. if rev >= (INT_MAX/10), then temp　一定溢出
3. 如果rev 等于 (INT_MAX/10), 如果temp溢出的话，则pop一定大于7.

https://blog.csdn.net/twt520ly/article/details/53038345
