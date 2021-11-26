---
layout: post
title: "c语言中的bits操作"
category: c/c++
---

* content
{:toc}

# 首先解释下关于位操作的概念
0s表示一串0, 1s表示一串1.
```c
x ^ 0s = x      x & 0s = 0      x | 0s = x
x ^ 1s = ~x     x & 1s = x      x | 1s = 1s
x ^ x = 0       x & x = x       x | x = x

```

位屏蔽(bitmask): 所谓位屏蔽(bitmask)就是利用一个二进制字串与已有的二进制字串
进行(AND)运算,通过结果知道原二进制字串中的特定位上有没有1.例如,二进制10011有
五个位,屏蔽码是10,则
```c
	10011
AND     00010
---------------
	00010 > 0(不等于0),
```
说明在原始数据倒数第二位有数据1,而屏蔽码1000的运算结果 10011 AND 01000 = 00000,说明倒数第四位是数据0,没有该选项.

# 位运算技巧
**n&(n-1)** 去除 n 的位级表示中最低的那一位。例如对于二进制表示 10110100，减去 1 得到 10110011，这两个数相与得到 10110000。
**n&(-n)** 得到 n 的位级表示中最低的那一位。-n 得到 n 的反码加 1，对于二进制表示 10110100，-n 得到 01001100，相与得到 00000100。
**n-n&(~n+1)** 去除 n 的位级表示中最高的那一位。

# '&'的操作
这个操作符是进行**与**操作的，常规来说，很简单就是与**0**相与得0,其余都得１．

作用集中在三个方面：
1. set 0
2. 取一个数的指定位
3. 保留指定位

## 461 Hamming Distance
The Hamming distance between two integers is the number of positions at which the corresponding bits are different.

Given two integers x and y, calculate the Hamming distance.

Note:
0 ≤ x, y < 2^31.

Example:

Input: x = 1, y = 4

Output: 2
```c
Explanation:
1   (0 0 0 1)
4   (0 1 0 0)
       ↑   ↑
```

The above arrows point to positions where the corresponding bits are different.
```c
int count_bit_1(int n){
	unsigned int count = 0;
	while(n){
		count += n & 1;
		n >>= 1;
	}
	return count;
}

int count_bit_0(int n)
{
	unsigned int rc = 0;
	while(n){
		rc += !(n & 1);
		n >>= 1;
		printf("the n is %d\t", rc);
	}
	return rc;
}

```
上面就是统计一个整型数字中的０和１的个数。

４６１最终结果：

```c
int hammingDistance(int x, int y) {
    int c = x ^ y;
    unsigned int count = 0;
    while(c){
        count += c & 1;
        c >>= 1;
    }
    return count;
}
```
# "^"操作的特点
这个亦或操作在CSAPP经典著作中也有详解，这里简单记录一下。直观上说，就是如果两个数字(0或者1)相同得1,不相同为0,为什么这样呢?[这篇文章](https://blog.csdn.net/dengheCSDN/article/details/78223629)可以看一下，就是说，在计算机的器件中，期初没有负责进位标志的东西，那么，这个加法操作可以借助"^"来实现。
```c
int add(int a, int b)
{
    if (a == 0)
        return b;
    if (b == 0)
        return a;
    int p1 = a&b;//位与。
    p1 = p1 << 1;//这两句只考虑进位
    int p2 = a^b;//位异或。不考虑进位
    return add(p2, p1);    //结束的标志是a为0了，或者b为0了
}
int main()
{
    int x = 3, y = 2;
    int sum = 0;
    sum = add(x,y);
    cout << sum << endl;
}
```
看到没，这就是基本逻辑，在add()函数中，p2 = a^b，如果有进位，就不用管它。比如 0+0=0, 0+1 = 1, 1+0  = 1, 1 +1 = 0。看到没，1+1 是等于0 的，那么进位呢？进位靠 ＆ 运算来实现，p1 只考虑进位，也就是说，如果 1 + 1 结果是 1, 但是此时的这个1应该往前面进一位，变成 10, 所以，有了p1 = p1 << 1。那么，到什么时候结束呢？只有一种可能，没有进位了，也就是说 p1 为0 了，那么此时的加法结果就是不考虑进位的p2 了。
    最后，解释一下为什么要递归 add()函数。实际上， 函数只需要执行两次就够了，执行到第二次的时候，我们就能保证P1 移位以后，为0. 此时，返回 p2 即可。所以，代码还可以这样优化：

性质：
1. a xor b xor a = b;这个性质可以扩充好几个元素(a,b)
2. 使特定位翻转找一个数，对应X要翻转的各位，该数的对应位为1，其余位为零，此数与X对应位异或即可。 例：X=10101110，使X低4位翻转，用X ^0000 1111 = 1010 0001即可得到。
3. 与0相异或，保留原值 ，X ^ 00000000 = 1010 1110。 从上面的例题可以清楚的看到这一点。

## 136. Single Number
Given a non-empty array of integers, every element appears twice except for one. Find that single one.

Note:

Your algorithm should have a linear runtime complexity. Could you implement it without using extra memory?

Example 1:

Input: [2,2,1]
Output: 1
Example 2:

Input: [4,1,2,1,2]
Output: 4

这个题目就是利用了异或的操作。

```c
int singleNumber(int* nums, int numsSize) {
    int i, ret = 0;
    for(i = 0; i < numsSize; i++){
            ret ^= nums[i];
        }
    return ret;
}
```

[资料](https://cyc2018.github.io/CS-Notes/#/notes/Leetcode%20%E9%A2%98%E8%A7%A3%20-%20%E4%BD%8D%E8%BF%90%E7%AE%97)
