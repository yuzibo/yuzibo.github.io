---
title: leetcode-tree 简单总结
category: leetcode
layout: post
---
* content
{:toc}

# 树的简单题
[convert-sorted-array-to-binary-search-tree](https://leetcode.com/problems/convert-sorted-array-to-binary-search-tree) （108）主要的一个思想就是二叉搜索树的中序遍历就是有序数组，或者说有序数组的中间位置就是BST的根节点。

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

