---
title: "leetcode easy task"
category: leetcode
layout: aticle
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
