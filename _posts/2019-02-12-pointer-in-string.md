---
title: c 指针在string中的使用
category: c/c++
layout: post
---
* content
{:toc}

# 起因
原因还是非常的简单，对指针的理解不透彻。
是这样的，在一个字符串中，有大小写的字符，请将其中的大写字母转化为小写字母，让你们见笑了。

## way one

```c

char* toLowerCase(char* str) {
    int len = strlen(str);
    int i;
    /*　第一种情况：　*/
    for(i = 0; i < len; i++){
        if(str[i] >= 'A' && str[i] <= 'Z')
            str[i] = str[i] + 32;
    }
    return str;
```

## way two
使用指针，这里有个问题：

```c
 	char *p = str;
    	while(*p){

        	if(*p >= 'A' && *p <= 'Z')
            		*p = *p + 32;
        	p++;
    	}
   	 p = p - len;
   	 return p;
```
你如果想要返回字符指针也就是p,必须将指针调整回原头步，即减去移动的长度，也可以直接返回**str**.

## way three

```c
char* toLowerCase(char* str) {
    int len = strlen(str);
    while(*str){
        if(*str >= 'A' && *str <= 'Z')
            *str +=  32;
        str++;
    }
    str = str - len;
    return str;
}
```
其中，way three比way two 快太多了

