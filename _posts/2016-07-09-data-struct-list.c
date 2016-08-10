---
title: "数据结构之链表"
layout: article
category: DS
---

# 静态单链表

静态单链表就是把一个完整的结构体数组分成两部分，一部分是正在使用的，另一部分
是尚未使用但空闲的。

```c
typedef struct {
	ElemType  data;
	int cur;  /*equal to next in linklist*/
}component, SLinkList[MAXSIZE];
```


