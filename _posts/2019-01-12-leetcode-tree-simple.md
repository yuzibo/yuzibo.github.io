---
title: leetcode-tree 简单总结
category: leetcode
layout: post
---
* content
{:toc}

# 树的简单题

## convert-sorted-array-to-binary-search-tree
[convert-sorted-array-to-binary-search-tree](https://leetcode.com/problems/convert-sorted-array-to-binary-search-tree) （108）主要的一个思想就是二叉搜索树的中序遍历就是有序数组，或者说有序数组的中间位置就是BST的根节点。

## path-sum
[path-sum](https://leetcode.com/problems/path-sum)【112】
给一个数字，让你计算下从root到levies的和是否等于这个数。递归的想法；
```c
bool hasPathSum(struct TreeNode* root, int sum) {
    if (!root)
        return false;
    if (!root->left && !root->right)
        return sum == root->val;
    return hasPathSum(root->left, sum - root->val) || hasPathSum(root->right, sum - root->val);
}
```

## same-tree
给定两棵树的根节点，判断这两棵树是否为相同的树。

```c
class Solution {
public:
    bool isSameTree(TreeNode* p, TreeNode* q) {
        if (p == NULL && q == NULL)
            return true; // 根节点为空
        if((p == NULL && q != NULL) || (p != NULL && q == NULL))
            return false; 
        else if (p->val != q->val)
            return false;
        return isSameTree(p->left, q->left) && isSameTree(p->right, q->right);
    }
};
```

全篇没有使用 p->val == q->val 的使用条件，难以理解！
