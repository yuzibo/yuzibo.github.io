---
title: leetcode math easy 小计
category: leetcode
layout: post
---
* content
{:toc}

这边文章简单记录leetcode的简单数学题目。

# 202 Happy Number
Write an algorithm to determine if a number is "happy".

A happy number is a number defined by the following process: Starting with any positive integer, replace the number by the sum of the squares of its digits, and repeat the process until the number equals 1 (where it will stay), or it loops endlessly in a cycle which does not include 1. Those numbers for which this process ends in 1 are happy numbers.

```c
Example:

Input: 19
Output: true
Explanation:
1^2 + 9^2 = 82
8^2 + 2^2 = 68
6^2 + 8^2 = 100
1^2 + 0^2 + 0^2 = 1
```

这道题目其实很简单，原先没有想到开始的逻辑，后来看到网上的介绍是说可以利用
HashmapSet数据结构来结束无限循环。好是好，但是我利用c语言目前还没有具体实现，所以，先偷个懒，利用一点数学的技巧。

数学上，非快乐数一定会出现4，至于为什么，我也没有搞明白。那么，以后遇到这样的问题怎么办？我觉得最好尝试着写出几个数字，来看看其中有没有相同点。
下面是第一版的解决方法。
```c
bool isHappy(int n){
    int sum;
    while ( n != 1 && n != 4){
        sum = 0;
        while(n){
            sum += (n % 10) * (n % 10);
            n /= 10;
        }
        n = sum;
    }
    return n == 1;
}
```
上面的代码段中有一点是如何统计一个整数的各位数字，这个思想值利用，还有一个就是先除再乘。

# 204 count Primes(计算质数)
计算一个整数范围内质数的个数.
版本1:
```c
bool is_prime(int n){
    int i;
    int flag = 1;
    if (n <= 1)
        return false;
    for(i = 2; i * i <= n; i++){
        if(n % i == 0){
            flag = 0;
            break;
        }
    }
    return flag;
}
int countPrimes(int n){
   int res = 0;
    int i;
    for(i = 1; i < n;i++){
        if(is_prime(i))
            res++;
    }
    return res;
}
```
# sqrt
# sqrt
求一个int的sqrt，我首先使用的暴力求解, 简直惨不忍睹，

```c
class Solution {
public:
    int mySqrt(int x) {
        if (x == 0) {
            return 0;
        }
        int i = 0, ret = 0;
        while(i * i < x){
            i++; 
            if (i == 46340)
                break;
        }
        if (i * i > x)
            return i - 1;
        else
            return i;  
    } 
};
```