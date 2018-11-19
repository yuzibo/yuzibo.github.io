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
