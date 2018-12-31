---
title: leetcode链表题目汇总
category: leetcode
layout: post
---
* content
{:toc}

已经确认了，leetcode的题目没有头结点，都是不带头结点的。

# easy

### design the linked list
[707](https://leetcode.com/problems/design-linked-list/)
这是一道基础题，但是有许多值得称道的地方，主要是边界的处理，这么说吧，现在，数据结构参考书上很多的代码都是错的，或者说不是全面的，因为没有处理一个边界值的问题。

这个题目有几个注意的地方：

	list的长度是多少？是结点的个数。obj->1->2->null,那么这个长度是2.

	index 是从0开始的，以上面的例子举例子，也就是1是第0个，2是第1个。

我处理的失误是，删除元素没有想到最后一个元素的问题。

```c
#include <stdio.h>
#include <stdlib.h>
typedef struct list_node {
	int val;
	struct list_node *next;
} MyLinkedList;

/* Initialize data struct */
MyLinkedList *myLinkedListCreate(){
	MyLinkedList *obj = (MyLinkedList *)malloc(sizeof(MyLinkedList));
	if (obj == NULL)
	{
		printf("error\n");
	}
	/* here, the linkedlist has head node , so, when you reverse the node, you must pass the tempery list with obj->next */
	obj->next = NULL;
	return obj;
}
/* insert node with head, we must master it */
void myLinkedListAddAtHead(MyLinkedList *obj, int val){
	MyLinkedList *p = obj; // alter ways
	MyLinkedList *temp = (MyLinkedList *)malloc(sizeof(MyLinkedList));
	if (temp == NULL)
	{
		printf("error\n");
		/* code */
	}
	temp->val = val;
	temp->next = p->next;
	p->next = temp;
}
/** Append a node of value val to the last element of the linked list. */
void myLinkedListAddAtTail(MyLinkedList* obj, int val) {
	MyLinkedList *temp = (MyLinkedList *)malloc(sizeof(MyLinkedList));
	MyLinkedList *p = obj;
	if(temp == NULL)
	{
			printf("error\n");
	}
	while(p->next != NULL){
		p = p->next;
	}
	temp->val = val;
	temp->next = NULL;
	p->next = temp;

}
/* 0-index */
int myLinkedListLength(MyLinkedList *obj)
{
	int length = 0;
	MyLinkedList *p = obj;
	if (obj->next == NULL)
	{
		return 0;
		/* code */
	}
	while(p->next != NULL)
	{
		length++;
		p = p->next;
	}
	return length;
}
/** Add a node of value val before the index-th node in the linked list. If index equals to the length of linked list,
 the node will be appended to the end of linked list. If index is greater than the length, the node will not be inserted. */
void myLinkedListAddAtIndex(MyLinkedList* obj, int index, int val) {
	MyLinkedList *p = obj;
	int length = myLinkedListLength(obj);
	int i = 0;
	if( index < 0 || index > length){
		//printf("index is greater than the list\n");
		return ;
	}
	if (index == length)
	{
		myLinkedListAddAtTail(p, val);
		return ;
		/* code */
	}
	while(p->next && i < index){
		p = p->next;
		i++;
	}
	MyLinkedList *temp = (MyLinkedList *)malloc(sizeof(MyLinkedList));
	if (temp == NULL)
	{
		printf("error\n");
		/* code */
	}
	temp->val = val;
	temp->next = p->next;
	p->next = temp;
}
/* 很多程序*/
/** Delete the index-th node in the linked list, if the index is valid. */
void myLinkedListDeleteAtIndex(MyLinkedList* obj, int index) {

	MyLinkedList *p = obj->next, *p_temp;
	int length = myLinkedListLength(obj);
	int i = 0;
	if( index < 0 || index > length){
		printf("index is greater than the list\n");
		exit(1);
	}

	while(p && i < index-1){
		p = p->next;
		i++;
	}
	if (p == NULL)
		return ;
	else
	{
		p_temp = p->next;
		if (p_temp == NULL)
		{
			return ;
		}
		else
		{

			p->next = p_temp->next;
			free(p_temp);
		}

	}

}
/** Get the value of the index-th node in the linked list. If the index is invalid, return -1. */
int myLinkedListGet(MyLinkedList* obj, int index) {
	MyLinkedList *p = obj;
	int length = myLinkedListLength(obj);
	int i = 0;
	if( index < 0 || index >= length){
		//printf("index is greater than the list\n");
		return -1;
	}
	if(length == 0)
		return -1;
	while(p->next && i <= index){
		p = p->next;
		i++;
	}
	return p->val;

}
void myLinkedListFree(MyLinkedList* obj) {
	MyLinkedList *p;
	while(obj){
		p = obj->next;
		obj = p;
		free(p);
	}

}
void myLinkedListshow(MyLinkedList *obj)
{
	MyLinkedList *p = obj->next;
	while(p)
	{
		printf("%d->", p->val);
		p = p->next;
	}
}
int main()
{
	MyLinkedList *obj = myLinkedListCreate();//= myLinkListCreate();
	//int rc = myLinkedListGet(obj, 0);
	//printf("0-index is %d\n", rc);
	//myLinkedListAddAtIndex(obj, 1,2);
	//int rc2 = myLinkedListGet(obj, 0);
	myLinkedListAddAtHead(obj, 1);
//	myLinkedListAddAtTail(obj, 3);
	myLinkedListAddAtIndex(obj, 1,2);
//	myLinkedListDeleteAtIndex(obj, 1);
	//printf("b,0-index is %d\n", rc2);
	myLinkedListshow(obj);
	//int len = myLinkedListLength(obj);
int 	rc1 = myLinkedListGet(obj, 1);
int 	rc2 = myLinkedListGet(obj, 0);
int 	rc3 = myLinkedListGet(obj, 2);
	printf("\nthe is %d  %d %d  \n", rc1, rc2,rc3);
/*	myLinkedListAddAtIndex(obj, 1,2);
	myLinkedListshow(obj);
	printf("\n");
	myLinkedListDeleteAtIndex(obj, 1);
	rc = myLinkedListGet(obj, 1);
	printf("\nthe %d-th is %d\n", 1, rc);
	myLinkedListshow(obj);
	myLinkedListFree(obj);
	len = myLinkedListLength(obj);
	printf("\nthe last length is 5\n");
	*/
}
```

int main函数是我方便测试写的，希望大家注意。

### reverse-linked-list(逆置链表)

[leetcode](https://leetcode.com/problems/reverse-linked-list)

思路：

建立三个结点， pre, cur, rear,分别对应链表里的三个点，比如，==1->2->3->4->nul==, 当然，在
结点1前面还有head头指针，那么，初始化就是pre指向1, cur指向2,rear指向3.这三者之间的关系对应好之后，立马将cur的指针指向pre,==并将pre传递给cur==,这一句话非常重要，我自己经常搞混，然后，rear立即传递给cur,保证下次的循环，直至到cur == NULL。此时pre作为最后一个节点，``head -> next = null``是保证此时生产新的链表具有尾指针， ``head = pre``成功地将头结点给head.具体代码请参考下面的代码。

```c
/**
  * Definition for singly-linked list.
  * struct ListNode {
  *     int val;
  *     struct ListNode *next;
  * };
  */
struct ListNode* reverseList(struct ListNode* head) {
    struct ListNode *pre, *cur, *rear;
    if(head == NULL || head->next == NULL)
        return head;
    pre = head;
    cur = head->next;
    while(cur){
            rear = cur->next;
            cur->next = pre;
            pre = cur;
            cur = rear;
        }
    head -> next = NULL;
    head = pre;
    return head;
}
```

# intersection-of-two-linked-lists(两个链表的相同点)
[题目](https://leetcode.com/problems/intersection-of-two-linked-lists/)
Write a program to find the node at which the intersection of two singly linked lists begins.

Notes:

* If the two linked lists have no intersection at all, return null.
* The linked lists must retain their original structure after the function returns.
* You may assume there are no cycles anywhere in the entire linked structure.
* Your code should preferably run in O(n) time and use only O(1) memory.

解释说明这个算法题目不是很清晰，是这样的，intersection是指两个链表的起始部分到终点位置一直相等才可以，如果有一个不同则不符合题目要求，比如： A链==1->2->3->4->5->NULL==,B链==3->4->5->null==,那么==3->4->5==即可满足，但是,如果B链为==3->4->6==则不符合要求。也就是从起始部分到末尾一直都相同才行。
### 方案一：

```c
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     struct ListNode *next;
 * };
 */
struct ListNode *getIntersectionNode(struct ListNode *headA, struct ListNode *headB) {
    struct ListNode *p1, *p2;

    if(headA == NULL || headB == NULL)
        return NULL;
    int len1 = 0, len2 = 0;
    p1 = headA, p2 = headB;
    while(p1->next != NULL){
        len1++;
        p1 = p1->next;
    }
    while(p2->next != NULL){
        len2++;
        p2 = p2->next;
    }
    p1 = headA, p2 = headB;
    if(len1 > len2){
       p1 = headA;
       p2 = headB;

    }else{
       p1 = headB;
       p2 = headA;
    } /* 调整链表 */
    int diff = abs(len1 - len2);
    while(diff){
        p1 = p1->next;
        diff--;
    }
    while(p1 != p2){
        p1 = p1->next;
        p2 = p2->next;
    }
    return p1;


}
```
上面的代码显而易见，将长链赋给指针p1,p1自增，然后一一对比，直到结点相等，如果结点不同，会一直延顺到末尾，直接返回NULL.

### 方案二
利用上面已知的条件，还可以使用环形的概念。两条链同时遍历，如果已遍历完短链，此时将短链的头指针赋值给长链对应的元素，此时相同的话就相同了，如果首个元素不同，继续上面的步骤。

```c
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     struct ListNode *next;
 * };
 */
struct ListNode *getIntersectionNode(struct ListNode *headA, struct ListNode *headB) {
    struct ListNode *p1, *p2;
    if(headA == NULL || headB == NULL)
        return NULL;
    p1 = headA;
    p2 = headB;
    while(p1 != p2){
        if(p1 != NULL)
            p1 = p1->next;
        else
            p1 = headB;
        if(p2 != NULL)
            p2 = p2->next;
        else
            p2 = headA;
    }
    return p1;
}
```
效率只能说符合题目要求，但是还没有爆机，还得找。

# 删除重复结点
[leetcode](https://leetcode.com/problems/remove-duplicates-from-sorted-list)
很简单的一个问题，就是将一个排序好的链表中重复的结点去除掉，注意头结点的问题。

```c
struct ListNode* deleteDuplicates(struct ListNode* head) {
    struct ListNode *p = head, *q, *r;
    if(p == NULL)
        return head;
    while(p){
        for(r = p, q = p->next; q != NULL; q = q->next){
            if(q->val == p->val){
                r->next = q->next;
                free(q);
                q = r;
            }
            else
                r = r->next;
        }
        p = p->next;
    }
    return head;
    
}
```
# remove node from linked-list(删除节点)
删除节点的题目无论在计算机工作面试中还是计算机考研中，这方面的题目还是非常多的，今天的这道题目是这样的，删除给定链表的指定数据，这和删除指定位置的数据是不一样的。比如，**1->2->4->6->5->6**删除6，则为**1->2->4->5**,这道题如果使用普通的删除节点的，是有些复杂的。下面的代码是可以达到这个目的的，有些不一样，你能看的懂吗？

```c
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     struct ListNode *next;
 * };
 */
struct ListNode* removeElements(struct ListNode* head, int val) {
       struct ListNode *dump = (struct ListNode*)malloc(sizeof(struct ListNode));
       dump->next = head;

      struct ListNode *pre = dump;
      struct ListNode *cur = head;
      while(cur){
             if(cur->val == val){
                  pre->next = cur->next;
             }
             else {
              pre = cur;
              }
              cur = cur->next;
     }
     return dump->next;
												      }
```

