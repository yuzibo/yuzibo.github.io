---
title: "leetcode easy task"
category: leetcode
layout: article
---

# 1 Two Sum
## description:

Given an array of integers, return indices of the two numbers such that they add up to a specific target.

You may assume that each input would have exactly one solution, and you may not use the same element twice.

## Example:
```c
Given nums = [2, 7, 11, 15], target = 9,

Because nums[0] + nums[1] = 2 + 7 = 9,
return [0, 1].
```

## solved:

```c
int* twoSum(int* nums, int numsSize, int target) {
	int*  sum = malloc(sizeof(int) * numsSize);
	int j,i;
	for(i = 0; i < numsSize; ++i){
		for(j = i + 1; j < numsSize; ++j){
			if (target - nums[i] == nums[j]){
				sum[0] = i;
	 			sum[1] = j;
				break;
			}
		}
	}
	return sum;
}

```

可以在本地申请，返回到主函数中释放，学习了。不过，这种方法的效率很低很低，还得研究其他的。

# 20 Valid Parentheses

## descriptions
Given a string containing just the characters '(', ')', '{', '}', '[' and ']', determine if the input string is valid.

An input string is valid if:

Open brackets must be closed by the same type of brackets.
Open brackets must be closed in the correct order.
Note that an empty string is also considered valid.

Because i want to master c, so, c is my first program language.

```c

typedef struct stack{
	char c;
	struct stack *next;
} Stack;

void create(Stack **ptop)
{
	*ptop = NULL;
}
void push(Stack **ptop, char c)
{
	Stack *tmp;
	tmp = malloc(sizeof(struct stack));
	tmp -> c = c;
	tmp -> next = *ptop;

	*ptop = tmp;
}
void pop(Stack **ptop, char *c)
{
	Stack *tmp;
	if(! *ptop)
		return;
	tmp = *ptop;
	*c = tmp->c;
	*ptop = (*ptop)->next;
	free(tmp);
}

int empty(Stack **ptop)
{
	return *ptop == NULL;
}


bool isValid(char *s){
	Stack *ss;
	char c;

	create(&ss);
	while(*s){
		switch(*s){
			case '(':
			case '[':
			case '{':
				push(&ss, *s);
				break;
			case ')':
			case ']':
			case '}':
				if (empty(&ss))
					return 0;
				pop(&ss, &c);
				if(c + 1 != *s && c +2 != *s)
					return 0;
				break;
			default:
				break;

		}
		++s;
	}
	if(!empty(&ss))
		return 0;
	return 1;
}
```
Here i will ask myself some questions:
Why can't yourself think out it;Why is The ``Stack`` is pointer to pointer?Escriplly,

```c
if(c + 1 != *s && c + 2 != *s)
```
