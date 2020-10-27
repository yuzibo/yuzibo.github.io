---
title: "leetcode 字符串操作"
layout: post
category: leetcode
---

* content
{:toc}

# 题目

[题目](!https://leetcode.com/problems/reverse-string/)

这道题应该说很简单的，如果不按照给定的函数原型去编写。但是，我的想法是用c语
言，那么，问题来了，关于字符串指针的概念和运用再一次出现在面前。

先看一下函数原型：

```c
char* reverseString(char* s) {
}
```
那么，返回一个(char *)类型的函数，那么你先必须首先定义一个(char *)的指针用于
接收返回值。OK，char *str；关键参数里也是(char *s),你应该如何处理？我一开始
想申请一个strlen(s)长得字符数组，结果老是报告段错误，所以，不得不参考别人的
代码。

https://leetcode.com/problems/reverse-string/

```c

#include<stdio.h>
#include<stdlib.h>
#include<string.h>
char *reverseString(char *s){
	int len = strlen(s) - 1;
	if( len >= 0){
		char *str = (char*)malloc(strlen(s) + 1);
		do {
			*str = s[len];
			str++;

		}while(len--);
		*str = '\0';
		str = str - strlen(s);
		s = str;
	}
	return s;
}

```
# 注意的地方

### 字符串的长度

字符串的长度，不包括结尾的标识符'\0',例如下面：

```c
#include<stdio.h>
#include<string.h>
int main()
{
	char *str = "hello";
	printf("The length of str is %d\n",strlen(str));

}

```

则显示的结果为

> The length of str is 5

那么，你在复制字符串时要特别留意这一点。

### 如何给一个字符串指针赋值

这里你要注意，指针变量赋给指针变量，并不是把变量所包含的内容赋给左值，而是将
变量的地址传递给对方。比如：

```c
char *str1 = "hello";
char *str2;
str2 = str1;
```
这里str2的内容并不是hello，或者字母"h",而是字符串"hello"的首字母的地址。所以
，如果你想用字符指针来接受字符串，你得首先申请一个足够大的变量。

有了这个变量还不够，如何一个一个字符的赋值？

```c
do{
	*str = s[len];
	str++;
}while(len--);

```

### malloc函数

这个函数在c语言中很重要，主要在用法上。我的浅显经验是：你想分配什么类型的，
前面就是什么类型。比如：

```c
char *str = (char *)malloc(strlen(s) + 1); // 给'\0'留给空
```

### 其他事项

这里注意一点，str最后一次已经指向了最后一位，要自动的添加个"\0".

还有一点把我给搞蒙圈了，其实归根结底还是基础不牢靠。

```c
	str = str - strlen(s);
		s = str;
```

这里的s是参数，可以作为返回值。那么，为什么要有第一个式子呢？str的指针指向了
最后，如果不把指针回送到字符串首部，那样只会给s一个空的字符。str的加减操作就是移动的指针。

# leetcode-58:
Given a string s consists of upper/lower-case alphabets and empty space characters ' ', return the length of last word in the string.  If the last word does not exist, return 0.  Note: A word is defined as a character sequence consists of non-space characters only.
Example:  Input: "Hello World" Output: 5

这道题目自己思考了很久也没有一个比较好的办法，后来知道，从后往前数的效果好啊。

```c
/*
 *     File Name: leetcode-58.c
 *     Author: Bo Yu
 *     Mail: tsu.yubo@gmail.com
 *     Created Time: 2202年08月23日 星期一 08时04分21秒
 */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
/*  统计一行英文有多少单词
	for(; *p != 0 && *p != 13 && *p != 10; p++){
		if(*p == ' ' && tag == 0)
			tag = 1;
		if(*p != ' ' && tag == 1)
		{
			n++;
			tag = 0;
		}
	}
	*/
int lengthOfLastWord(char *s){
    int tag = 1;
	int num = 0;
    int i;
    for(i = strlen(s); i>= 0; i--){

        if(s[i] != 32 && s[i] != '\0'){
            num++;

            tag = 1;
        }
        else if(s[i] == 32 && tag == 1 && s[i-1] == 32){
            return num;
        }
    }
	return num;
}


```

# longest-common-prefix

从这个提交开始，改用c++提交代码*

我发现，leetcode的题目，还得先用一些方法想去做一些预处理，才有可能接下来做题目。
本身这个题目很简单， 就是在string数组里找出最长的前缀子串， 方案是首先把数组排序，然后只
找第一个字符串和最后一个字符串就可以了。

```c++
class Solution {
public:
    string longestCommonPrefix(vector<string>& strs) {
        int n = strs.size();
        if (n == 0)
            return "";

        sort(strs.begin(), strs.end());
        string str1 = strs[0], str2 = strs[n-1];
        int s1 = str1.size(), s2 = str2.size();
        int p1 = 0, p2 = 0;

        while(p1 < s1 && p2 < s2){
            if (str1[p1] == str2[p2]){
                p1++;
                p2++;
            } else
                break;
        }
        string ans = str1.substr(0, p1);
        return ans;

    };
};
```

