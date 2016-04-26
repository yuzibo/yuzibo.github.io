---
layout: article
title: "并查集原理及实现"
category: DS
---

很久之前接触过这个东西，这是很久的事情了。现在又是重新捡起来。

简单说一下，所谓的并查集，顾名思义，就是一个合并、查找的过程。
查找的过程相对简单点，合并的过程需要防止形成单链，理解起来可能有
点麻烦。

# find
其实，很多时候都是自己的数据结构没有学好，连数据的存储形式都搞不明
白。这里我们用数组来模拟一下。

> pre[i]

比如pre[3] = 15,就是3的前导点是15,当一个pre[i] == i的时候，就说明
它的前导点就是它自己了，这也是我们的一个过程。

```c
	int find(int x){
		int r = x;
		/*直到找到自己的前导点为自己*/
		while(r != pre[r])
			r = pre[r];
		return r;

	}
```
比如说，在一个集合内含有{1,2,3,4},"1" 为根节点，那么使用
__find(4)__都可以找到1,上面的代码的作用就是这样的.其实，从上面
介绍中，我们也可以看出，这是一棵树。在下面合并的过程中，如果只是
单单把根节点合并在一起，只有两个集合还可以，有很多个集合就会费很大
的力气。为此，我们在查找的过程中，可以适当做一些优化，这一步被成为
路径压缩。比如：

```c
            1				1----
	   / \     优化成：	       /|\  |
	  2   5   ——————-->           2 4 5 6
	 /     \
	4       6
```
### 压缩路径思路
利用上面的`find`函数，找到了x的根节点，那么，我们可以认为在这个查
找的过程中，所经历的节点的根节点都是x的根节点，那么：

```c
	int find(int x){
		int r = x;
		while(r != pre[r])
			r = pre[r];
		int i, j = x;
		while(r != pre[j]){
			i = pre[j];
			/*根节点赋值给经过路径上的节点*/
			pre[j] = r;
			j = i;
		}
	}
# union
这一步就是将两个树形节点合并起来。
```c
	void union(int x, int y){
		int tx = find(x);
		int ty = find(y);
		/*将y的前导点设置为x*/
		if(tx != ty)
			pre[ty] = tx;
	}
```

# 应用

来自hdu上的题目。连通点：
>给定n的节点，m条边，接下来是m条边的两个端点，问只需要连接几条边，>就可以将所有的边连接起来且没有回路

这道题目就是简简单单的问连通集的个数，连成一条线的话就再减去1.

```c

#include<stdio.h>
int pre[1050];
int flags[1050];
int find(int x){
	/* you must don't forget */
	int r = x;
	while(r != pre[r]){
		r = pre[r];
	}

	int j = x, i;
	while(pre[j] != r){
		i = pre[j];
		pre[j] = r;
		j = i;
	}
	return r;

}

void mix(int a,int b){
	int root_a = find(a);
	int root_b = find(b);
	if(root_a != root_b)
		pre[a] = b;
}
int main()
{

	int n,m,a,b;
	int i,j;
	freopen("find.in","r",stdin);
	scanf("%d%d",&n,&m);

		for(i = 1; i <= n; i++){
			pre[i] = i;
			/*将自己本身设为自己的前导点*/
			flags[i] = 0;
		}
		for(j = 1; j <= m; j++){
			scanf("%d%d",&a,&b);
			mix(a,b);
		}

	for(i = 1; i <= n; i++){
		flags[find(i)] = 1;
	}
	int ans = 0;
	for(i = 1; i <= n; i++)
	{
		if(flags[i] == 1)
			ans++;
	}
	printf("total ans is %d\n",ans - 1);

}
```

