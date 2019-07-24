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

 # 38 count and say
 1. 1=> 初始值1
 2. 11=》 上面就是1个1
 3. 21 =》 上面2个1
 4. 1211 =》 上面1个2，1个1
 5. 111221 =》 上面1个1 1个2 2个1

 使用两个数组，变量的使用也很讲究。
 ```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char *countAndSay(int n)
{
  if (n == 1)
    return "1";

  char *res = (char *)malloc(sizeof(char) * 2);
  res[0] = '1';
  res[1] = 0;
  int i, len;
  for(i = 2; i<= n; ++i){
    len = strlen(res);
    char *tmp = malloc(len * 3);
    memset(tmp, 0, len * 3);
    int j, idx,count = 1;
    //printf("here len is %d\n", len);
    for(j = 0,idx = 1; idx < len; idx++){
      if(res[idx] == res[idx-1]){
        count++;
        //break;
      }
      else{
        tmp[j++] = '0' + count;
        tmp[j++] = res[idx-1];
        count = 1;
      }

    }
    tmp[j++] = '0' + count;
    tmp[j++] = res[len-1];
    free(res);
    res = tmp;
  }
  return res;
}
int main()
{
  int i;
  char *s = countAndSay(4);
    printf("%s\n", s);
    free(s);
}
 ```

 # 53 Maximum Subarray
```c
Input: [-2,1,-3,4,-1,2,1,-5,4],
Output: 6
Explanation: [4,-1,2,1] has the largest sum = 6.
```
上面就是这个题目的简单示意图.

这个题目有三种解法，这里只是简单地介绍其中的几种，O(N^2)、O(NlgN)和O(N) 的算法。

### 1 O(N^2)
简单来说就是设置两个指针，分别指定两个指针为子序列的左侧。比如，序列，[1,2,3],都指向1，然后依次累加，注意这个时候就可以知道他们的最大值(累加时)；第二趟从2开始也可以知道其中的最大值，分别记录下来。

```c
int maxSubArray(int* nums, int numsSize){
    int i,j,k,max_sum = nums[0],this_sum,start = 0, end = numsSize;
    for(i = 0; i < numsSize; i++){
        this_sum = 0;
        for(j = i; j < numsSize; j++){                     
                this_sum += nums[j];
            if (this_sum > max_sum){
                max_sum = this_sum;
                start = i;
                end = j;
            }
                
        }
    }
    printf("the start is %d\t, the end is %d", start, end);
    return max_sum;
}
```
这个方案把子序列的起始点和重点全部打印出来了。
### 2 O(NlgN)
 分治算法的使用。

### 3 O（N）
根据题目的特点，我们判断每一个节点时的和是否大于0，是的话，就以当前节点相加，不是的话，就以当前节点为最大值。可惜这个算法在leetcode上只为28%
```c
int maxSubArray(int* nums, int numsSize){
    int i,j,k,max_sum = nums[0],this_sum = nums[0],start = i, end = numsSize;
    for(i = 1; i < numsSize; i++){
       if(this_sum <= 0)
           this_sum = nums[i];
        else
            this_sum += nums[i];
        if(max_sum < this_sum)
            max_sum = this_sum;
    }
   // printf("the start is %d\t, the end is %d", start, end);
    return max_sum;
}
```
都这么厉害吗 ^_^!!