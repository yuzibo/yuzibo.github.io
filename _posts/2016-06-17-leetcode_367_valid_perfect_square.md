---
title: "leetcode 367 valid perfect square"
layout: article
category: leetcode
---

/**
 *	思路： 一开始我使用的枚举，结果说我运行超时，肯定是
 *	效率不高
 *	@1: 牛顿迭代法目前还没有掌握，那个求一个的平方根比较简单
 *	但是如何呢；
 *	@2： 使用二分法 L = 1. R = num/2 + 1;
 */

```c
bool isPerfectSquare(int num){
	long long  L = 1, R = (num >> 1) + 1;
	while(L <= R){
		long long middle = L + ((R - L)>>1);
		long long value = middle * middle;
		if(value == num)
			return true;
		else if(value > num)
			R = middle - 1;
		else
			L = middle + 1;

	}
	return false;
}
```

各方面来说，目前的编程状态属于一种特别混乱。不过，自己还好涉猎面比较广泛，
竞赛算法类的编程，还可以拿的起来；linux系统级别的，需要自己钻时间挖掘知识点

这个系列肯定不完整，以后再加上其他语言版本的。
