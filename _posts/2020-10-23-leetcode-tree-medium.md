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

## Binary Tree Postorder Travelsal

使用双栈:
 
```c
class Solution {
public:
    vector<int> postorderTraversal(TreeNode* root) {
        vector<int> res;
        if(!root) return res;
        TreeNode *cur;
        stack<TreeNode*> s1;
        stack<TreeNode*> s2;
        s1.push(root);
        while(!s1.empty()){
            cur = s1.top(); s1.pop();
            if(cur->left) s1.push(cur->left);
            if(cur->right) s1.push(cur->right);
            s2.push(cur);
        }
        while(!s2.empty()){
            res.push_back(s2.top()->val);
            s2.pop();
        }
        return res;
        
    }
};
```

## binary-tree-level-order-traversal

这是解决二叉树的层次遍历题目，下面使用了两个队列，关键在于题目返回的类型是 vector<vector<int>> ,如果只是输出的话， 也就是不必存储值，
仅仅打印值的的话，一个队列就够了。

```c
class Solution {
public:
    vector<vector<int>> levelOrder(TreeNode* root) {
        vector<vector<int>> ans;
        vector<int> level; // 存储每一层的元素
        if (!root) return ans;
        std::queue<TreeNode*> s; // save output to val array
        std::queue<TreeNode*> nodes; // save left & right of root
        s.push(root); // root val in queue
        while(!s.empty()){
            TreeNode *cur = s.front(); s.pop();//得到队首元素, 并且出队
            level.push_back(cur->val);
            if (cur->left) nodes.push(cur->left); // 注意，是保存在nodes queue 中
            if (cur->right) nodes.push(cur->right);
            if(s.empty()){
                s.swap(nodes); // 这是关键，把存储叶子节点的队列中的内容交换到s queue中
                ans.push_back(level);
                level.clear(); // 清0每一行的输出结果
            }
        }
        return ans;
    }
};
```

尤其使用了 std::queue.swap() 的api，感觉拖慢了运行速度。试着一个队列怎么样？使用一个null marker。

还有一种使用一个队列的方式，如下代码:

```c
class Solution {
public:
    vector<vector<int>> levelOrder(TreeNode* root) {
        
        if(root == nullptr) return {};
        vector<vector<int>> res;
        queue<TreeNode*> q;
        q.push(root);
        
        while(!q.empty())
        {
            int count = q.size();
            vector<int> temp;
            while(count--)
            {
                TreeNode* curr = q.front();
                q.pop();
                temp.push_back(curr->val);
                if(curr->left) q.push(curr->left);
                if(curr->right) q.push(curr->right);
            }          
            res.push_back(temp);
        }
        return res;
    }
};
```