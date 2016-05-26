---
title: "二叉树的性质和使用"
layout: article
category:  article
---

# 摘要

二叉树是一种非常重要的数据结构，今天我们来讲讲它。

滚粗。。。老子不是遇到很好的知识点，我才懒得理你呢。。。

# 节点

如果使用数组代表二叉树的话，那么数组里的元素依次就是从根节点水平方向读取来的

如果根节点在数组的下标是从1开始,那么就有如下性质：

	PARENT(i)		return floor(i/2)

	LEFT(i)			return 2i

	RIGHT(i)		return 2i + 1

如果根节点从数组下标为0开始，那么有如下性质：

	
	PARENT(i)		return floor[(i-1)/2] 

	LEFT(i)			return 2*i+1

	RIGHT(i)		return 2i + 2
