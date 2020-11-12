---
title: 理解kmp
category: algorithm
layout: post
---
* content
{:toc}

首先声明， 这个阶段的文章， 大部分是参考的网上的文章，所以， 侵权必删。

next[k]表示p[k]前面有相同前缀尾缀的长度(这个长度是按最大算的)，p[next[k]]表示相同前缀的最后一个字符，如果p[next[k]]==p[k]，则可以肯定next[k+1]=next[k]+1,如果p[next[k]]!=p[k]，则思考，既然next[k]长度的前缀尾缀都不能匹配了，是不是应该缩短这个匹配的长度，到底缩短多少呢，next[next[k]]表示p[next[k]]前面有相同前缀尾缀的长度(这个长度是按最大算的)，所以一直递推就可以了，因为这个缩小后的长度都是按最大的算的

```c
static char p[] = "agctagcagctagct";
int main() {
        int len = strlen(p);
        int next[len + 1];
        printf("len is %d\n", len);

        next[0] = -1;
        int j = 0, k = -1;
        while(j <= len){
                if (k == -1 || p[k] == p[j]){
                        k++; j++;
                        next[j] = k;
                } else {
                        k = next[k];
                }
        }
        int i = 0;
        for (; i <= len; i++){
                printf("%d ", next[i]);
        }
        printf("\n");
}
```
代码写的很乱，主要是记忆其中的一些关键细节。说白了， next[]的值就是当前 j 位置 _前_
子串的最长前后缀匹配的长度。第0号没有前缀，所以该next[]的数值设定为-1， 主要做的目的主要是为了编程的方便。
