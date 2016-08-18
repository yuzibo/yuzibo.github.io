---
title: "常用算法归类"
layout: article 
category: algorithm
---

# 贪心算法(greed)

贪心算法（又称贪婪算法）是指，在对问题求解时，总是做出在当前看来是最好的选择。也就是说，不从整体最优上加以考虑，他所做出的是在某种意义上的局部最优解。
贪心算法不是对所有问题都能得到整体最优解，关键是贪心策略的选择，选择的贪心策略必须具备无后效性，即某个状态以前的过程不会影响以后的状态，只与当前状态有关

摘自百度百科

### 题目

[0-1背包问题]

马踏棋盘

最小生成树的prim和kruskal的算法

#### 最大整数

设有n个正整数，将它们连接成一排，组成一个最大的多位整数。
例如：n=3时，3个整数13，312，343，连成的最大整数为34331213。
又如：n=4时，4个整数7，13，4，246，连成的最大整数为7424613。
输入：n
N个数
输出：连成的多位数
算法分析：此题很容易想到使用贪心法，在考试时有很多同学把整数按从大到小的顺序连接起来，测试题目的例子也都符合，但最后测试的结果却不全对。按这种标准，我们很容易找到反例：12，121应该组成12121而非12112，那么是不是相互包含的时候就从小到大呢？也不一定，如12，123就是12312而非12123，这种情况就有很多种了。是不是此题不能用贪心法呢？
其实此题可以用贪心法来求解，只是刚才的标准不对，正确的标准是：先把整数转换成字符串，然后在比较a+b和b+a，如果a+b>=b+a，就把a排在b的前面，反之则把a排在b的后面。

# 递归与分治

思想： 对这k个子问题分别求解。如果子问题的规模仍然不够小，则再划分为k个子问题，如此递归的进行下去，直到问题规模足够小，很容易求出其解为止。

#### 排列问题


设计一个递归算法生成n个元素{r1,r2,…,rn}的全排列。

设R={r1,r2,…,rn}是要进行排列的n个元素，

Ri=R-{ri}

[code](https://github.com/yuzibo/DS/blob/master/algorithm/recursion/permut.c)

# 回溯(backtracking)


# 递归

举一个具体的例子

递归的理解是这样：


### 1 定义函数原型

比如，计算一个数组的前n个元素：

```c
int sum(int arr[], int n);
```

### 2 写一个简单的函数调用

```c
int result = sum(arr, n);
```
这里的参数不要写具体的值，比如10.

### 3 想出这个问题的最小情况

"最小情况" 是基本事实，也就是取一个特定的值对于n来说。

这里就是递归中比较难的一部分了， 很多人确定不了基本事实。上面的例子中，有以下三个选择：

```c

sum(arr, 2);
sum(arr, 1);
sum(arr, 0);

```

这里，就得选第三个，因为加上第0个元素可以为加上一个0.

### 4 想出最小情况的函数调用

```c
sum(arr, n);
```

这样就计算了第n个元素，我们在一个比较小的情况下需要执行最小问题的"n-1".

所以，对于sum(arr, n) 就是用 sum(arr, n -1) 加上arr[ n - 1]

### 整合

递归需要把基本事实和递归例子整合在一起。下面是递归的一般模板：

```c

if ( base case )
   // return some simple expression
else // recursive case
  {
     // some work before 
     // recursive call 
     // some work after 
  }
```

更复杂的情况是：

```c
if ( base case 1 )
   // return some simple expression
else if ( base case 2 )
   // return some simple expression
else if ( base case 3 )
   // return some simple expression
else if ( recursive case 1 )
  {
     // some work before 
     // recursive call 
     // some work after 
  }
else if ( recursive case 2 )
  {
     // some work before 
  // recursive call 
     // some work after 
  }
else // recursive case 3
  {
     // some work before 
     // recursive call 
     // some work after 
  }
```

 例子的代码在下面：

[code](https://github.com/yuzibo/DS/blob/master/algorithm/recursion/sum_recur.c)



