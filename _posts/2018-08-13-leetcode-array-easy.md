---
title: leetcode　array题目
category: leetcode
layout: post
---
* content
{:toc}

# 27 Remove Element
Example 1:

Given nums = [3,2,2,3], val = 3,

      Your function should return length = 2, with the first two elements of nums being 2.

      It doesn't matter what you leave beyond the returned length.

Example 2:

      Given nums = [0,1,2,2,3,0,4,2], val = 2,

      Your function should return length = 5, with the first five elements of nums containing 0, 1, 3, 0, and 4.

使用一个新的索引指向插入的位置。这里值得注意的一个地方在于，按照题目的要求，如果不开辟新的存储空间，那么，本人能想到(也是leetcode提供的)方法就是，那这个数组以引用的形式传递过去，结果返回这个删除重复元素的数组的有效个数。

```c
nt removeElement(int* nums, int numsSize, int val) {
    int i, index = 0;// 作用是标记上次移动的位置
    for(i = 0; i < numsSize; i++){
        if(nums[i] != val){
            nums[index++] = nums[i];
        }
    }
    return index;
}
```
实际上leetcode 已经说了这个提示：
```c
// nums is passed in by reference. (i.e., without making a copy)
int len = removeElement(nums, val);

// any modification to nums in your function would be known by the caller.
// using the length returned by your function, it prints the first len elements.
for (int i = 0; i < len; i++) {
    print(nums[i]);
}
```
 那么，这个方法能不能在工程中使用呢，现在不得知。
