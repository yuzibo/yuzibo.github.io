---
title: "python正则表达式的一点介绍"
category: python
layout: post
---
* content
{:toc}

# 有用的资料
[较全的各种正则表达式](https://www.cnblogs.com/zxin/archive/2013/01/26/2877765.HTML)

# python 基本re模块

# 解决需求

## 在包含有"-"的字符串中提取数字
```bash
string = "...ntrace-cms-checkjni-picimage-ndebuggable-no-jvmti-cdex-fast-1001-app-image-regions64"
```
假设我想提取1001这个数字，咋么办? 根据[re](https://docs.python.org/3/library/re.html)可以暂时使用

	(?<=...)

```bash
m = re.search(r'(?<=-)\d+', string)
print(m.group(0))
# r'(?<=-)\w+' 可以  m = re.search(r'(?<=-)\w+', 'spam-egg')
print(m.group(0))
# print egg
```

