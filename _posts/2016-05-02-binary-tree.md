---
title: "二叉树的性质和使用"
layout: article
category: DS 
---

# 摘要

二叉树是一种非常重要的数据结构，今天我们来讲讲它。

滚粗。。。老子不是遇到很好的知识点，我才懒得理你呢。。。

# 重要特性 

以下性质暗含root node 为第一层

1. 第i层上顶多有2^(i-1)个节点。

证明：数学归纳法。

i=1时，显然2^(1-1) = 2^0 = 1个节点是对的

现在假设对所有的j，1<=j<i,第j层上至多有2^(j-1)个节点，那么可以证明j=i时命题
也成立。

由归纳假设，第i-1层上至多有2^(i-2)个节点，由于二叉树的每个度最多为2，故第i层
上节点数为第i-1层上的2倍，即2*2^(i-2).

2. 深度为k的二叉树最多有2^k - 1个节点。

证明： 根据上面的1，每层最多节点数之和是一个等比数列，故证之。

3. 对于任何一棵二叉树T，其终端节点（叶子节点）为n0，度为2的节点数为n2，则n0=
n2+1

证明：设度为1的节点为n1，则二叉树T中节点总数n等于n=n1+n2+n0.
如二叉树T分枝数为B，因为二叉树中除了根节点没有入度，其余节点都有一个入度，所
以n=B+1.又因为这些分支由度为1或者2的节点射出的，则B=n1+2n2，所以有
1+n1+2n2=n1+n2+n0 ==> n0=n2+1

4. 具有N个节点的完全二叉树的深度为floor(LOG2N) + 1.
(这里是以2为低，对数为N的运算)


# 以数组表示二叉树

如果使用数组代表二叉树的话，那么数组里的元素依次就是从根节点水平方向读取来的

如果根节点在数组的下标是从1开始,那么就有如下性质：

	PARENT(i)		return floor(i/2)

	LEFT(i)			return 2i

	RIGHT(i)		return 2i + 1

如果根节点从数组下标为0开始，那么有如下性质：

	
	PARENT(i)		return floor[(i-1)/2] 

	LEFT(i)			return 2*i+1

	RIGHT(i)		return 2i + 2

# 以链表表示二叉树

```c
typedef struct Node{
    struct Node* left;
    struct Node* right;
    int data;
}Node;
```

## 二叉树的几个操作

新建一个二叉树

```c
Node* newNode(int data)
{
    Node* node=(Node*)malloc(sizeof(Node));
    node->left=node->right=NULL;
    node->data=data;
    return node;
}
```

得到二叉树的高度

```c
/* 将root == NULL的返回值置为-1或者0，结果不一样*/
int getHeight(Node* root)
{
	if(root == NULL)
		return -1;
    /* 返回为0， 结果是从根节点到叶子节点的节点数，
    *  返回为-1， 是经历的路径长度 */
	int left_height = getHeight(root->left);
	int right_height = getHeight(root->right);
	return (left_height > right_height ? left_height  : right_height ) + 1 ;
}
```

计算节点的数目

```c
/* The number of node*/
int node_num_tree(Node* root)
{
    if(root == NULL)
        return 0;
    /* 这里的返回 0 还是有区别的 */
    return 1 + node_num_tree(root->left) + node_num_tree(root->right);
}
```

计算叶子的数目

```c
/* the numbers of leaves */
int leaf_num_tree(Node* root)
{
    if(root == NULL)
        return 0;
    if(root->left == NULL && root->right == NULL)
        return 1;
    return leaf_num_tree(root->left) + leaf_num_tree(root->right);

}
```
[代码](https://github.com/yuzibo/DS/blob/master/data_struct/tree/bst.c)