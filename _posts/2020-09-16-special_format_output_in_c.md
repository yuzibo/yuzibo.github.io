---
title: 特殊格式输出 in c
category: c
layout: post
---
* content
{:toc}

# 缘由
因为在目前的项目中，涉及到了很多了int与hex或者bin之间转换，之前还是傻乎乎的打算计算器去手工运算，忽然
之间大佬给了一个c语言的程序，看了以后恍然大悟，原来这个是最简单的方式，

# int to hex

```c
    int d = 123;
    printf("%d == 0x%x\n", d, d);
    // output： 123 == 0x7b
    int d = 123;
    printf("%d == %x\n", d, d);
    // 123 == 7b
```
可以发现，hex的格式输出符为`%x`,  那么如果想打印出前缀`0x`,则需要在格式符`%x`添加`0x`,如果是大写的0X, 需要
大写的`0X`.

# hex

首先看"%x"更多的用法，标准的%x期待的数据类型是unsigned int.

```c
void show_bytes(unsigned char* start, int len){
        int i;
        printf("len is %d\n", len);
        for (i = 0; i < len; i++){
                printf(" 0x%02x", (unsigned int)start[i]); // 有前导0， 两位宽
        }
}

int main(){
        short x = 12345;
        show_bytes((unsigned char *) &x, sizeof(short));
} // output
// len is 2
// 0x39 0x30
```

如果这里改为int的话， 则会输出4个字节。 

```c
int main(){
        int x = 12345;
        show_bytes((unsigned char *) &x, sizeof(int));
} // output:
// len is 4
// 0x39 0x30 0x00 0x00
```
int型数据12345的二进制为0b 0011 0000 0011 1001. 这里的细节很重要， 由前面知道， %x的期待数据类型是unsigned int(8 bits),
也就是说， %x的输出位宽就是 8 bits，而一个HEx是4bits， 所以用"0x%02x"就很合适(2代表2位宽). 另一个细节就是， 12345的
二进制改写的hex应该为0x 30 39, 但实际输出确实 0x39 0x30, 也就是数的LSB在高位， 所以这样的情况属于小端机器。

# 链接
[SO1](https://stackoverflow.com/questions/3464194/how-can-i-convert-an-integer-to-a-hexadecimal-string-in-c/3464376)

