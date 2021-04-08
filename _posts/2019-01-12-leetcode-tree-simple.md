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
全篇没有使用 p->val == q->val 的使用条件，难以理解！ 好，下面的代码使用了这个条件，而且速度比这个快太多了。

```c
class Solution {
public:
    bool isSameTree(TreeNode* p, TreeNode* q) {
        if (p == NULL && q == NULL)
            return true; // 首先判断两个根节点(对于左右子树而言也对)
        if (!p || !q)
            return false;  // 有了前面的基础，有其中一个根节点为空，则f
        if (p->val == q->val) // 也许这一步是关键，不满足直接false
            return isSameTree(p->left, q->left) && isSameTree(p->right, q->right);
        else
            return false;
    }
};
```

### [binary-tree-paths](https://leetcode.com/problems/binary-tree-paths/)

> input: [1,2,3,null,5]
> output: ["1->2->5","1->3"]

leetcode的tree这块测试，尤其注意点，输入的可以不用管，就算考虑的可以把"["去掉。尤其注意output的格式:

不用管"[","]"这个符号的。

```c
// Runtime: 0 ms, faster than 100.00% of C++ online submissions for Binary Tree Paths.
class Solution {
public:
    void binaryTreePaths(vector<string>& result, TreeNode *root, string t){
        if (!root->left && !root->right) {
            result.push_back(t);
            return;
        }
        if (root->left) binaryTreePaths(result, root->left, t + "->" + to_string(root->left->val));
        if (root->right) binaryTreePaths(result, root->right, t + "->" + to_string(root->right->val));

    }

    vector<string> binaryTreePaths(TreeNode* root) {
        vector<string> result;
        if (root)
            binaryTreePaths(result, root, to_string(root->val));
        return result;
    }

};
```

这里有一个tip值得关注，就是 to_string,这个std::to_string可以将任何类型的参数转化为string类型。在c++中，string可以使用"+"号，这无疑对于解决一些zifu相关的算法题目提供了便利。

#### 非递归的写法

```c
 vector<string> binaryTreePaths(TreeNode* root) {
        vector<string> res;  // 返回值
        stack<TreeNode*> s; // 节点的栈
        stack<string>   path_stack; // 路径的栈
        if(!root) return res;
        s.push(root);
        path_stack.push(to_string(root->val));  // Initiliza both stack to run it.
        while(!s.empty()){ // this is a model for stack ops
            TreeNode* cur_node = s.top(); s.pop();
            string tmp_path = path_stack.top(); path_stack.pop();

            if (!cur_node->left && !cur_node->right){
                res.push_back(tmp_path); // if the cur_node is left node, then push stack to res
                continue; // key: if true, the next program will not run
            }
            if (cur_node->left){
                s.push(cur_node->left);
                path_stack.push(tmp_path + "->" + to_string(cur_node->left->val));
            }
            if (cur_node->right){
                s.push(cur_node->right);
                path_stack.push(tmp_path + "->" + to_string(cur_node->right->val));
            }
        }
        return res;
    }
```

可以说，上面是我第一次接触两个栈的使用，有意思啊。
