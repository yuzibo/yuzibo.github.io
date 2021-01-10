---
title: 分治算法入门
category: algorithm
layout: post
---
* content
{:toc}

算法学习，是一个持久的斗争，除了思维上的锻炼，更考验意志品质，说白了，对我而言，这不是简单的一个任务，必须持之以恒。

今天关注一下分治算法。个人感觉这个算法比回溯算法要难一些。 当然，形式上看着是非常简单的，但是代码写起来，未必容易理解。
# 定义
分治法，就是把一个复杂的问题分成两个或更多的相同或相似的子问题，再把子问题分成更小的子问题……直到最后子问题可以简单的直接求解，原问题的解即子问题的解的合并。

有没有看到，分成子问题的这个过程，肯定借用了递归，可以说二者是形影不离的。

## 基本思想及策略

思想： 把大问题分解成规模较小的子问题， 各个击破，分而治之。

策略: 将子问题的解进行合并。

## 使用情况

分治法所能解决的问题一般具有以下几个特征：

    1) 该问题的规模缩小到一定的程度就可以容易地解决

    2) 该问题可以分解为若干个规模较小的相同问题，即该问题具有最优子结构性质。

    3) 利用该问题分解出的子问题的解可以合并为该问题的解；

    4) 该问题所分解出的各个子问题是相互独立的，即子问题之间不包含公共的子子问题。

第一条特征是绝大多数问题都可以满足的，因为问题的计算复杂性一般是随着问题规模的增加而增加；

第二条特征是应用分治法的前提它也是大多数问题可以满足的，此特征反映了递归思想的应用；、

第三条特征是关键，能否利用分治法完全取决于问题是否具有第三条特征，如果具备了第一条和第二条特征，而不具备第三条特征，则可以考虑用贪心法或动态规划法。

第四条特征涉及到分治法的效率，如果各子问题是不独立的则分治法要做许多不必要的工作，重复地解公共的子问题，此时虽然可用分治法，但一般用动态规划法较好。


## 基本步骤

分治法在每一层递归上都有三个步骤：

    step1 分解：将原问题分解为若干个规模较小，相互独立，与原问题形式相同的子问题；

    step2 解决：若子问题规模较小而容易被解决则直接解，否则递归地解各个子问题

    step3 合并：将各个子问题的解合并为原问题的解。

## 经典问题

（1）二分搜索

（2）大整数乘法

 （3）Strassen矩阵乘法

（4）棋盘覆盖

（5）合并排序

（6）快速排序

（7）线性时间选择

（8）最接近点对问题

（9）循环赛日程表

（10）汉诺塔

以上参考[资料](https://www.cnblogs.com/steven_oyj/archive/2010/05/22/1741370.html)
# 具体题目

先看一下[leetcode 95. Unique Binary Search Trees II](https://leetcode.com/problems/unique-binary-search-trees-ii/)，题目的意思是给定一个整型数字n，打印出具有n个节点的二叉搜索树。

二叉搜索树的定义很简单，就是根节点左子树的值都小于根节点，右子树都大于根节点。

怎么思考呢？其实我是没有思路的，这个时候我们应该怎么办，正面突破不容易，得想想办法。我们首先从n等于1开始尝试.

```bash
    1
   /  \
NULL  NULL
```
如果n等于2，则有:

```bash
     1
    /  \
null    2
# and
    2
   /  \
  1   NULL
```
其实，如果把这两种情况的例子写出来，也许就容易多了，但是，对我来说，这并不容易，只能靠程序量去解决这个问题。
先上一个优秀的代码，看一下这个代码是怎么写的。
```c
class Solution {
private:
    vector<TreeNode*> helper(int start, int end){ // 这两个很好
        vector<TreeNode*> res;
        if(start > end){
            res.push_back(NULL);
            return res;
        }
        for(int i = start; i <= end; i++){
            vector<TreeNode*> lefts = helper(start, i-1);
            vector<TreeNode*> rights = helper(i+1, end);
            for(int j = 0; j < (int)lefts.size(); j++)
                for(int k = 0; k < (int)rights.size(); k++){
                    TreeNode *root = new TreeNode(i);
                    root->left = lefts[j];
                    root->right = rights[k];
                    res.push_back(root);
                }
        }
        return res;
    } 
   
public:
    vector<TreeNode*> generateTrees(int n) {
        if(n == 0) return vector<TreeNode*>(0);
        return helper(1,n);
    }
};
```

先来看一下n=1的情况，当`helper(1,1)`传入时，

```c
        vector<TreeNode*> lefts = helper(start, i-1);
        vector<TreeNode*> rights = helper(i+1, end);
```

都会返回一个NULL,并且加入进res中(也就是res.size()为1),然后在双重循环中，`new TreeNode(1)`,一定使用new去实例化。这个时候，左右子树都为NULL，最后将root压入res中。

当n=2是，helper(1,2)传入，首先i=1， `lefts = helper(start, i-1)`将会返回一个NULL，而`rights`则有些变化了。`helper(2,2)`，并不会返回一个NULL，而是返回一个只有值为2的节点。那么，到了二重for语句那里，会实例化出(i=1)作为root,然后左孩子为NULL，右孩子为节点2.这里还需要注意一个语句，`root->left = lefts[j]`,这个为啥需要[j],字面上的意思肯定是深度。这样，就完成了一个。

然后i=2时，重复上面的过程，`lefts = helper(1,1)`，所以lefts是只有一个节点值为1的节点。而此时的rights是一个NULL，
那么，在二重for，会实例化(i=2),并把1节点lefts、null节点rights赋给root，最后加入到res中。

n=1,2都好理解，当n=3时就麻烦一些了，但是，我们以其中一个例子说明。当helper(1,3)传入时，首先得到的是lefts = helper(1,0)和rights = helper(2,3),(i=1)这是第一层的。显而易见，helper(1,0)只会返回一个NULL， 还是要注意rights = helper(2,3)（i=2）,那么rights会分裂为lefts = helper(2,1)(NULL), rights=helper(3,3),这是第二层；rights=heler(3,3)返回节点3，在第三层，可以不用管了。那么在第二层中i=2时，有了lefts=NULL和rights=3，在`new TreeNode(2)`后，lefts和rights分别赋值给root(2).这里需要注意的是，这个

```bash
    2
  /   \
NULL   3
```
是在第一层的rights=helper(2,3)得来的,此时i=1，`new TreeNode(1)`,左孩子为NULL， 右孩子为上图，符合题意。

当i=2时， 会分裂为lefts=helper(1,1)和rights=helper(3,3),这个就简单了。

```bash
    2
  /   \
 1     3
```