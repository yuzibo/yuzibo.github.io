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
        if(root == nullptr) return {};  // 尤其注意"{}"在赋值时的应用
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

这个题目还可以使用dfs的思路，利用递归完成这一要求。但是有人据说，这种方法只是一个形似，然而实质上不是level遍历。
效率呢，肯定赶不上非递归的。

```c
class Solution {
public:
    vector<vector<int>> res; // 其实，也许这也就是成员变量的作用吧，但是这样监控起来太难了
    vector<vector<int>> levelOrder(TreeNode* root) {
        levelOrderHelper(root, 0);
        return res;   
    }
    void levelOrderHelper(TreeNode* root, int level){
        if (!root) return;
        if (level == res.size()) res.push_back(vector<int>()); // 按行申请空间
        res[level].push_back({root->val}); // res[level].push_back({val}) 是经典
        if (root->left) levelOrderHelper(root->left, level+1);
        if(root->right) levelOrderHelper(root->right, level+1);
    }
};
```

下面使用一个null marker，我真不明白为啥这样做;
```c
class Solution {
public:
    vector<vector<int> > levelOrder(TreeNode *root) {
        vector<vector<int> >  result;
        if (!root) return result;
        queue<TreeNode*> q;
        q.push(root);
        q.push(NULL);
        vector<int> cur_vec;
        while(!q.empty()) {
            TreeNode* t = q.front();
            q.pop();
            if (t==NULL) {
                result.push_back(cur_vec);
                cur_vec.resize(0);
                if (q.size() > 0) {
                    q.push(NULL);
                }
            } else {
                cur_vec.push_back(t->val);
                if (t->left) q.push(t->left);
                if (t->right) q.push(t->right);
            }
        }
        return result;
    }
};
```

## 637 Average of Levels in Binary Tree

这个题目的意思是就是在前面题目的基础上（层次遍历），把每个数累加然后取double，注意int溢出的问题。

```c
#include <iomanip>
class Solution {
public:
    vector<double> averageOfLevels(TreeNode* root) {
        vector<double> res;
        if (!root) return res;
        queue<TreeNode*> q;
        TreeNode* cur = NULL;
        q.push(root);
        while(!q.empty()){
            double sum = 0.0, anv = 0.0;
            int count = q.size();
            for(int i = 0; i < count; i++){
                cur = q.front(); q.pop();
                sum +=(double)(cur->val); // 避免 int overflow
                if(cur->left) q.push(cur->left);
                if(cur->right) q.push(cur->right);
            }
            anv = sum/count; 
            res.push_back(anv);
        }
        return res;
    }
};
```

# path sum

## 112. Path Sum
 
就是给你一个数字和一个二叉树，然后判断从root到leaf的和是不是等于这个数字，递归的算法如下:

```c
class Solution {
public:
    bool hasPathSum(TreeNode* root, int sum) {
        if(!root) return false;
        if(!root->left && !root->right && root->val == sum)
            return true;
        return hasPathSum(root->left, sum - root->val) || hasPathSum(root->right, sum - root->val);
    }
};
```

使用stack实现这个算法:

```c
class Solution {
public:
    bool hasPathSum(TreeNode* root, int sum) {
        stack<TreeNode*> s;
        TreeNode* cur = NULL, *tmp = NULL;
        stack<int> sum_stack;
        if (!root) return false;
        s.push(root);
        while(!s.empty()){
            cur = s.top(); s.pop();
            if(cur->left == cur->right)
                if (cur->val == sum)
                    return true;
            if (cur->left) {
                cur->left->val += cur->val;
                s.push(cur->left); 
            }
            if(cur->right) {
                cur->right->val += cur->val;
                s.push(cur->right);
            }
        }
        return false;
    }
};
```