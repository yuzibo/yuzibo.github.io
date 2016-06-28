---
title: "leetcode-344 字符反转"
layout: article
category: leetcode
---

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

```
#include<stdio.h>
#include<string.h>
int main()
{
	char *str = "hello";
	printf("The length of str is %d\n",strlen(str));

}

```

则显示的结果为

>> The length of str is 5

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

整个代码如下：

```c
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
