---
title: leetcode binary-search-tree
category: leetcode
layout: post
---
* content
{:toc}

# 性质

# unique-binary-search-trees

给一个数字n,试着计算以这个[1,n]为root的bst有多少独一无二的。

这是一个数学题目，其中和catalan数密切相关。catalan数有很多种应用场景，值得总结一把。

```bash
f(0) = 0;
令f(0) = 1
f(1) = f(0)*f(0)
f(2) = f(1)*f(0) + f(0)*f(1)
f(3) = f(2)*f(0) + f(1)*f(1) + f(0)*f(2)
……
f(n) = f(n-1)*f(0) + f(n-2)*f(1) +……f(0)*f(n-1)
```

由此得出规律，

对于任意以i为根节点的二叉树，

其左子树的值一定小于i，也就是[0, i - 1]区间，

而右子树的值一定大于i，也就是[i + 1, n]区间。

假设左子树有m种排列方式，而右子树有n种，则对于i为根节点的二叉树总的排列方式就是m x n

参考资料: https://www.cnblogs.com/liuliu5151/p/9108838.html

则代码如下:

```c
class Solution {
public:
    int numTrees(int n) {
        int a[n + 1];
        a[0] = a[1] = 1;
        for(int i = 2; i <=n; i++){
            a[i] = 0;
            for (int j = 0; j < i; j++)
                a[i] += a[j] * a[i-j-1]; // 这一步尤其精妙
        }
        return a[n];
    }
};
```

# 700. search in a BST

700. Search in a Binary Search Tree

这道题目是给你一个BST，然后另外给定一个值，判断这个值是否在BST中，如果在的话，返回以这个值为root的子树，
否则返回null。
期初吧，我想的是应该可能需要栈什么的操作，憋了半天，实在没什么好的办法，参考下其他人的答案吧，不丢人的。

```c
class Solution {
public:
    TreeNode* searchBST(TreeNode* root, int val) {
       while(root != nullptr && root->val != val){
           root = (root->val > val) ? (root->left) : (root->right);
       }
        return root;
    }
};
```
要么就说，好的程序员价值连城呢，如果放到古代，这种人都得是杨过 郭靖这类的大侠，像我这种，都得是不配给台词的
小罗罗。

# 653. Two Sum IV - Input is a BST

这道题目还是比较有意思的，原因在于使用另一个数据结构保存树中的某一节点，我当时想到过这个问题就是不知道运用什么方法解决妥当：考虑过
BST,让root值不停的与k（或者差进行比较），但是呢，这样很大的问题就是你不确定怎么不遗漏。原来，你像使用下面的set容器，就可以解决这个问题
还可以确定一点的是： set就是一个hashtable.

```c
class Solution {
public:
    bool findTarget(TreeNode* root, int k) {
        unordered_set<int> set;
        return dfs(root, set, k);

    }
    bool dfs(TreeNode* root, unordered_set<int>& set, int k){
        if(root == NULL) return false;
        if(set.count(k - root->val)) return true;
        set.insert(root->val);
        return dfs(root->left, set, k) || dfs(root->right, set, k);
    }
};
```

