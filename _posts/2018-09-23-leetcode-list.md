---
title: leetcode链表题目汇总
category: leetcode
layout: post
---
* content
{:toc}

# easy

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

