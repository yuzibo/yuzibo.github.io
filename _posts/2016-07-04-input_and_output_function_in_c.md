---
title: "c语言的输入输出函数总结"
layout:  article 
category: c
---

输入输出函数是一个函数族，尤其在c中，这个知识点必须掌握。

# 输出函数(printf)

## 格式化控制输出

```c
 #include<stdio.h>
        main()
        {
                int a,b;
                float c,d;
                a = 15;
                b = a / 2;
                printf("%d\n",b);
                printf("%3d\n",b);
                printf("%03d\n",b);

                c = 15.3;
 d = c / 3;
                printf("%3.2f\n",d);
        }
```

上面的输出结果如下：

```c

7
   7
007
5.10
```

### %u %d %p

如果打印一个变量的地址，使用u与d都是打印的十进制的数字，这个数字是变量的地址
。姑且这么讲，它俩的区别在于一个是(unsigned),另一个是(signed),这里就涉及到了
编码的范围问题。按照stackoverflow的说法，地址使用无符号的输出才有价值。

当然，最理想的方案是使用`%p`,这个标识符就是为打印地址准备的。它的输出结果是
以0x开头的十六进制的数字，有着最起码的物理意义。

### 

# 输入函数

从一开始编程就碰上了这个问题，现在好好总结下；

比如我读两个double类型的数字：

```c
	double real;
    double img;
    while(scanf("%f %f", &real, &img) == 2)
        c[i++] = real + img * I;
		...
```

连续键入两个数字，回车，会执行while以下的动作，但是不会输入空格键后退出，如何达到这种效果呢？

_尽量避免使用scanf_

使用下面的方法：

```c
int res = 2;
   while (res == 2) {
       char buf[100];
       fgets(buf, sizeof(buf), stdin);
       res = sscanf(buf, "%f %f", &real, &img);
       if (res == 2)
           c[i++] = real + img * I;
   }
```

再举一个例子：

```c
	    int n;
        scanf("%d\n", &n);
        printf("you typed %d\n", n);
```

这样读进去的行为不如你所想的那样进行，我输入一个回车后没有反应，直到我输入另外一个数字敲回车才会把我第一个输入的数字打印出来


### 读入含空白字符字符串 

scanf中的"%s"修饰符，遇到空白字符串，




