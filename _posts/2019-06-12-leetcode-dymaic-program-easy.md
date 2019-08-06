---
title: "leetcode 动态规划-easy"
category: leetcode
layout: post
---
* content
{:toc}

# 参考资料
这里说的还是比较全面的，尤其九章[here](https://www.zhihu.com/question/39948290)

# 70. Climbing Stairs
You are climbing a stair case. It takes n steps to reach to the top.

Each time you can either climb 1 or 2 steps. In how many distinct ways can you climb to the top?


###  Solution
Other than f(n) = f(n-1) + f(n-2);
there are another solution:

```c
nt climbStairs(int n){
    int a = 1, b = 1;
    while(n--){
            a = (b += a) - a;
            printf("the n is %d\t, a is %d and b is %d\n", n+1, a, b);
    }
    return a;
}
```
If n == 5, Paste my output code above:

```bash
the n is 5	, a is 1 and b is 2
the n is 4	, a is 2 and b is 3
the n is 3	, a is 3 and b is 5
the n is 2	, a is 5 and b is 8
the n is 1	, a is 8 and b is 13
```

There is solution that i dont understand about "w[idx^1]"
这里解释一点就是，根据上面资料的介绍，这种类型的可以归纳为序列(一维)型的。
# 91 Decode Ways
[here](https://leetcode.com/problems/decode-ways/)
"12" -> "L" 或者 （A,B） 共2中解码方式

"226" -> "A, B, F"，“B,Z”, "VF(22, 6)" -> 共3种解码方式。
这也是一种序列性，符合动态规划的三个特定问题:

1. 求最大值/最小值
2. 求可不可行
3. 求方案总数

先来看看有没有共性。如果是s[0] == ""或者s[0] == "x",一位数的话，肯定是1了，假设dp[0] = 1;
当然，这个dp的大小你要和字符串同大小（为了安全，扩大一个没问题）。

两位数字,s[1,2] == "12", 由于c的数组下标从0可以，这里注意，i开始从s[1]进入了,到strlen(s)为止。

1 == i, 就是判断s[0] == "0"(为什么)，这个题目的难点就在这里，这属于剪枝的方法，s[0] == "0"了，没有以0开头的两位数，所以不符合。当s[i] != 0, d[i] == dp[i - 1], 否则就是dp[i] = 0; dp[i] = (s[i - 1] == '0') : 0 ? dp[i-1]

2 == i: s[i - 2] == '2' && s[i - 1] <= "6" 或者 s[i - 2] == '1',因为这种情况都可以拆成2个组合，dp[i] = dp[i] + dp[i - 2]

然后分别 s = "226", s = "106",代入进去观察一下执行顺序。

```c


int numDecodings(char * s){
    int len = strlen(s),ret =0;
    int *dp = (int *)malloc(sizeof(s) * len + 1);
    if (s[0]  == '0')
        return 0;
    dp[0] = 1;
    int i;
    for(i = 1; i <= len; i++){
        dp[i] = (s[i - 1] == '0') ? 0 : dp[i - 1];
        }
        if( i > 1 && (s[i - 2] == '1' || (s[i - 2] == '2' && s[i - 1] <= '6'))){
                  dp[i] = dp[i] + dp[i - 2];
        }
    }
    ret = dp[i-1];
    free(dp);
    return ret;
}
```


# 62 Unique Paths

# 509 Fibonacci Numbers
