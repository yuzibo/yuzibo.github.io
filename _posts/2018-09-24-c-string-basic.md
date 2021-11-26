---
title: c语言字符串基础知识
category: c/c++
layout: post
---
* content
{:toc}

# 基本函数
c语言有关字符串的函数很多，每本教材的附录都会有一些库函数，大家可以了解一些。今天，给大家介绍几个常用的。

### strcat
**strcat(str1, str2):** 连接str2到str1中，注意str1的大小能够容下两者。

### strlen
**strlen(str1)**,计算str1的长度，不包括结尾'\0'

### strcpy
**strcpy(str1,str2)**将str2复制给str1

### puts
这一句是输出字符串，没啥好说的

### gets->fgets
这个**gets**函数不要再使用了，切记，众多的计算机安全问题就是和这个函数有关，相反，使用fgets()函数代替。
众所周知，**gets()**可以读取一个包含空格的字符串（不限量），这就是他问题的根源所在，不限制的字符读入会造成计算机的栈溢出，导致种种问题。那有同学说了，不用gets那用什么，**scanf("%s", string_array_name)**不符合要求？好，记住，大家以后使用**fgets**.

下面借助代码具体说一下： 原来的意图是：

```c
	...
	char s[20];
	gets(s);
	puts(s);
	...
```
现在用的话，使用下面的方法：

```c
	char s[20];
	fgets(s, 20, stdio);
	puts(s);
```

也就是多了两个参数，20就是你想要读入的字符串的最大值，这样就避免了无限量读入的问题，stdio表示从输入终端读取，就是那个黑色的框框。

### puts
**puts(str)**, 输出str.

# 习题

## 统计一行字符的单词数目

```c
int main()
{
	char str[100];
	printf("请输入一串字符串，最好英文，以回车键结尾\n");
	fgets(str, 100, stdin);
	int i;
	int nums = 0;
	for(i = 0; str[i] != '\0'; i++)
	{
		if(str[i] != ' ' && str[i+1] == ' ' || str[i+1] == '\0')
			nums++;
	}
	printf("the numbers of words is %d\n", nums);
}
```

以"I want to C program \0",以这个例子带进去，就可以测出来。"I"作为一个独立的单词，目前不为" ",但是紧跟着空格，所以单词加1，或者最后一个单词也得加1.

