---
title: leetcode tree for medium
category: leetcode
layout: post
---
* content
{:toc}

今天开始解锁leetcode tree medium的题目,首先你得感觉有意思。

# 解题思路

建议阅读这篇[csdn](https://blog.csdn.net/zhangxiangDavaid/article/details/37115355)

1. 中序遍历

递归和非递归。前者 使用一个void型的函数，判断左子树， 打印root的值，判断右子树。

2. 前序遍历:


# 具体题目和code

## binary-tree-inorder-traversal

中序遍历,递归版:
```c
class Solution {
public:
    void displayInorder(vector<int> &arr, TreeNode *root){
        if (root->left) displayInorder(arr, root->left);
            arr.push_back(root->val);
        if (root->right) displayInorder(arr, root->right);       
    }
    vector<int> inorderTraversal(TreeNode* root) {
        vector<int> res;
        if (root)
            displayInorder(res, root);
        return res;   
    }
};
```

非递归版:
```c
class Solution {
public:
    vector<int> inorderTraversal(TreeNode* root) {
        vector<int> res;
        stack<TreeNode*> s;
        if (!root) return res;
        TreeNode* p = root;
        while(p || !s.empty()){
            while(p){
                s.push(p);
                p = p->left;
            }
            if(!s.empty()){
                p = s.top(); s.pop();
                res.push_back(p->val);
                p = p->right;
            }  
        }
        return res; 
    }
};
```

## Binary Tree Preorder Traversal

前序遍历非递归版:

```c
class Solution {
public:
    vector<int> preorderTraversal(TreeNode* root) {
        vector<int> res;
        if(!root) return res;
        TreeNode *p = root;
        stack<TreeNode*> s;
        while(!s.empty() || p){
            while(p){
                s.push(p);
                res.push_back(p->val);
                p = p->left;               
            }
            if(!s.empty()){
                p = s.top(); s.pop();
                p = p->right;
            }
        }
        return res;       
    }
};
```
