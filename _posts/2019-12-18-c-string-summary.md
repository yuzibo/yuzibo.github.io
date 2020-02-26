---
title: c库-字符串
category: c
layout: post
---
* content
{:toc}

# strtok
这个函数还是挺特殊的，特意记录下。先看代码:
```c
int main()
{
	char str[80] = "This is my website";
	const char s[2] = " ";

	char* token;

	token = strtok(str, s);
	while(token != NULL){
		printf("%s\n", token);
		token = strtok(NULL, s);
	}
	return 0;
}
```
这里有一个违反直觉的使用方法，在while循环中，居然在使用strtok时传递给NULL参数，
这不对啊，那样的话，指针指向什么地方了？[原来](https://stackoverflow.com/questions/3889992/how-does-strtok-split-the-string-into-tokens-in-c)在第一次分割后
根据分隔符已经产生了"this",也就是token指向了"this",但是，`str`的指针存在一个静态
变量中，后面使用strtok函数传递给的参数NULL,只是一个符号。
以上，就是使用`strtok`的基本规则。
