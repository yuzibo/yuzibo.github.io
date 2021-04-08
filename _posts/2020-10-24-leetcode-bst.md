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

# search in a BST

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



