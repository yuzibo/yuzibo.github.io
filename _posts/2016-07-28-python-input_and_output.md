---
title: "python输入和输出"
category: python
layout: article
---

这是我的python基础教程，入门级别的

# 中文编码

如果在源代码中插入中文的话，可能会报编码错误，需要在头文件中加入：

```python
#!/usr/bin/python
# -*- coding: UTF-8 -*-
```

print "你好，世界";

# 输入输出

```python
name = raw_input();
print 'hello',name

name = raw_input('please enter your name');
print 'hello', name

# 输入非数字的话，就会报错
birth = int(raw_input('birth:'))

```

# 使用end = ‘ ’

在python2.x中，无法使用

```python
print(x,end=' ')
```

必须在前面导入模块，

```python
from __future__ import print_function
```

# 字符表示

```bash
print '\\\n\\\'

## 打印
# \
# \

## 防止转义

print r'\\\n\\\'

## 多行内容使用三引号 ‘'''...'''
print ''' hello
world
yubo
'''
## 打印布尔值
print 3>2

## unicode编码转换成utf-8
print u'ABC'.encode('utf-8')
print u'中文'.encode('utf-8')

## 格式化输出 这里？？？

# 格式转换
print 'Hello, %s' % 'wrold'
```

# python 常见的三种符号

### () 不可变序列

### [] 可变列表

直接创建：

```python
list('python')
```

output is here:

```c
['p', 'y', 't', 'h', 'o', 'n']
```

### { }

这是字典。
