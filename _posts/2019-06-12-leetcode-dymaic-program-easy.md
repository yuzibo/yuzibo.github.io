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
A robot is located at the top-left corner of a m x n grid (marked 'Start' in the diagram below).

The robot can only move either down or right at any point in time. The robot is trying to reach the bottom-right corner of the grid (marked 'Finish' in the diagram below).

How many possible unique paths are there?

看看，这是标准的动态规划的问题呀人！
Example 1:

```c
Input: m = 3, n = 2
Output: 3
Explanation:
From the top-left corner, there are a total of 3 ways to reach the bottom-right corner:
1. Right -> Right -> Down
2. Right -> Down -> Right
3. Down -> Right -> Right
```
按照题目给的样例，这里有一个问题，貌似就是起点为(1,1)。
If we initial an 2-D array, it must begin from 0 to n(numbers of elements n - 1 we assume).

Yeap, In the problem, i resolved the issue that firstly was **mallocing** a 2-D array.I allocate a **M x N**array.

1. allocte int **dp

```c
int **dp = (char **)malloc(sizeof(int \*) \* m);
```
Becasue we allocate a 2-D array, which has m row(行).That is said to be allocated row's elements.

2. allocate column
```c
for(i = 0; i < m; i++)
	dp[i] = (char *)malloc(sizeof(char) * n);
```
In the statement, we alloc the each row with n (column 列元素) elements.

3. initial array
We think the program again, if "Finish" is always located in dp[i][0](0<=i <=m) or dp[0][j](0 <= j <= n).Is there has how many paths from Robots to Finish? Yes, the answer is one. Why? The Robot has two dirctories only: down and right,so.If "finish" always be located on the far side of the matrix.There is one path only.

```c
 for(i  = 0; i < n; i++)
        dp[0][i] = 1;
 for(i = 0; i < m; i++)
        dp[i][0] = 1;
```

4. state transition equation
If the "finish" be located (i, j)(1 <= i, j <= m), the previous path must be located in (i -1, j) or (i, j - 1).So, the (i, j) sum of path is dp[i - 1][j] + dp[i][j - 1]

```c
int uniquePaths(int m, int n){
    if(m == 0 || n == 0)
        return 0;
    if (m == 1 || n == 1)
        return 1;
    int **dp = (int **)malloc(sizeof(int *) * m);
    int i, j,ret = 0;;

    for(i  = 0; i < m; i++)
        dp[i] = (int *)malloc(sizeof(int) * n);
    /* malloc 2-d array */
    for(i  = 0; i < n; i++)
        dp[0][i] = 1;
    for(i = 0; i < m; i++)
        dp[i][0] = 1;
    for(i = 1; i < m;  i++)
        for(j = 1; j < n;j++){
            dp[i][j] = dp[i - 1][j] + dp[i][j - 1];
        }
    ret = dp[i- 1][j - 1];
    free(dp);
    return ret;
}
```
# 509 Fibonacci Numbers
oThe Fibonacci numbers, commonly denoted F(n) form a sequence, called the Fibonacci sequence, such that each number is the sum of the two preceding ones, starting from 0 and 1. That is,

F(0) = 0,   F(1) = 1
F(N) = F(N - 1) + F(N - 2), for N > 1.
