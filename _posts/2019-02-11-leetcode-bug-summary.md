---
title: leetcode代码的一点总结
category: leetcode
layout: post
---
* content
{:toc}

# 入坑
目前，leetcode的解题思路都是运用使用python、java、c++等语言，为啥呢？
因为简单啊，一些现用的库函数拿起来就是用很爽的，但是，我的思路先用pure c
啃完大部分题目，即便是自己造轮子，这个时候就是学习积累，工作中当然使用现成的
标准库了。

# leetcode
也许leetcode从测试的角度来考虑在线提交的代码，对于c来说有点变态，也许是自己没有
考虑全面。但是，强如内核都没见这样的使用案例，下面是错误汇总。

# tree
下面是引自leetcode的官方手册：
```c
/*
The input [1,null,2,3] represents the serialized format of a binary tree using level order traversal, where null signifies a path terminator where no node exists below.

We provide a Tree Visualizer tool to help you visualize the binary tree. By opening the console panel, you should see a Tree Visualizer toggle switch under the TestCase tab. Click on it and it will show the test case's binary tree representation.
	5
       / \
      1   4
         / \
	3   6
代表:[5,1,4,null,null,3,6]

```
也就是树的遍历为层次遍历，如果节点为空，则使用null.而且，还注意：

```bash
[]

Empty tree.
The root is a reference to NULL (C/C++), null (Java/C#/Javascript), None (Python), or nil (Ruby).
```
## member access within misaligned address 0x000000000031 for type 'struct ListNode', which requires 8 byte alignment
这个错误太突然了，貌似是在某个时间点才引入这个检查。bug 重现：

```c
struct TreeNode {
	int val;
	struct TreeNode *left;
	struct TreeNode *right;
};
```
作为一个定义很常见的代码。
但是，以[convert-sorted-array-to-binary-search-tree](https://leetcode.com/problems/convert-sorted-array-to-binary-search-tree)为例：

```c
struct TreeNode *sortedArrayToBST(int *nums, int numsSize)
{
	struct TreeNode *root = (struct TreeNode *)malloc(sizeof(struct TreeNode));
 //    root->left = NULL;
 //    root->right = NULL;
 //    root->val = NULL;
	int head = 0;
    int tail;
    if (numsSize >= 1) {
	    tail = numsSize - 1;
	    toBST(root, nums, head, tail);
    }
    else 
        return root = NULL;
	printf("trace\n");
	//show(root);
	return root;
}

```
也就是说，上面的代码在提交的时候，就会报上面的错误。当你申请一个带指针成员的结构体时，一定要在
使用前初始化他，貌似这个规定内核中也不常见啊。
改正的方法就是注释掉的语句，将里面的指针成员初始化为NULL;

## 空树的特例
如果像上面的代码中，怎么处理一个空的树，如果直接
```c
return root;
```
那么结果很有可能不正确，在我的代码中，提交后会明显看到(输入[])，输出[-122541545465]
明显是个垃圾值，正确的处理方式是
```c
return root = NULL;
```