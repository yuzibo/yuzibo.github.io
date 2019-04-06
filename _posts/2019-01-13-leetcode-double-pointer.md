---
title: 算法思想--双指针
category: leetcode
layout: post
---
* content
{:toc}

#
167. Two Sum II - Input array is sorted
Given an array of integers that is already sorted in ascending order, find two numbers such that they add up to a specific target number.
The function twoSum should return indices of the two numbers such that they add up to the target, where index1 must be less than index2.
Note:
Your returned answers (both index1 and index2) are not zero-based.
You may assume that each input would have exactly one solution and you may not use the same element twice.
Example:
Input: numbers = [2,7,11,15], target = 9
Output: [1,2]
Explanation: The sum of 2 and 7 is 9. Therefore index1 = 1, index2 = 2.

```c
/**
 * Return an array of size *returnSize.
 * Note: The returned array must be malloced, assume caller calls free().
 */
int* twoSum(int* numbers, int numbersSize, int target, int* returnSize) {
    int *reval = (int *)malloc(sizeof(int) * 2);//这一个是返回的数组
    *returnSize = 2;// 这是leetcode 的一个特色，要告诉调用者分配的数组的大小，看注释要求
    int left = 0, right = numbersSize - 1;
    for(;;){
        if(numbers[left] + numbers[right] > target){
            right--;
        } else if(numbers[left] + numbers[right] < target){
            left++;
        }else
        {
            reval[0] = left + 1;
            reval[1] = right + 1;
            return reval;
        }
    }
}
```

