---
title: "python输入输出函数和操作文件"
category: python
layout: post
---

* content
{:toc}

这是我的python基础教程，入门级别的

# 中文编码

如果在源代码中插入中文的话，可能会报编码错误，需要在头文件中加入：

```python
#!/usr/bin/python
# -*- coding: UTF-8 -*-
```

print "你好，世界";

# 输入输出raw_input和input

```python
name = raw_input();
print 'hello',name

name = raw_input('please enter your name');
print 'hello', name

# 输入非数字的话，就会报错
birth = int(raw_input('birth:'))

# 展示程序

root@yubo-2:~/test/python# cat test.py
#!/usr/bin/python
# -*- coding: UTF-8 -*-
import math

str = raw_input("请输入");
print "你输入的内容是：" , str
root@yubo-2:~/test/python# python test.py
请输入hechun
你输入的内容是： hechun
root@yubo-2:~/test/python#

# input 输入，支持python表达式

str = input("请输入");
print "你输入的内容是：", str

root@yubo-2:~/test/python# python test.py
请输入[x*5 for x in range(2,10,2)]
你输入的内容是： [10, 20, 30, 40]


```

### 控制台输入输出

上面的输入输出是文件执行的，如果需要解释器来运行，则需要导入相关的模块。

```python

>>> import sys
>>> sys.stdout.write('Python rules!\n')
Python rules!
>>> value = sys.stdin.readline()
hello, yubo
>>> value
'hello, yubo\n'
>>> print(value)
hello, yubo

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

这是字典。下面是实例

##### Dict of lists

```python

>>> my_objects = {}
>>> my_objects['id1'] = []
>>> my_objects
{'id1': []}
>>> my_objects['id2'] = []
>>> my_objects
{'id1': [], 'id2': []}
>>> my_objects['id3'] = []
>>> my_objects
{'id1': [], 'id2': [], 'id3': []}
>>> my_objects['id2'].append('some data, but could be anything')
>>> my_objects
{'id1': [], 'id2': ['some data, but could be anything'], 'id3': []}
>>> my_objects['id2'][0]
'some data, but could be anything'
```

##### Dict of dict

```python
>>> my_objects2 = {}
>>> my_objects2['id1'] = {}
>>> my_objects2['id2'] = {}
>>> my_objects2['id3'] = {}
>>> my_objects2
{'id2': {}, 'id3': {}, 'id1': {}}
>>> my_objects2['id2']['new_key'] = 'some data'
>>> my_objects
{'id2': ['some data be added'], 'id3': [], 'id1': []}
>>> my_objects2
{'id2': {'new_key': 'some data'}, 'id3': {}, 'id1': {}}
>>> my_objects2['id2']['new_key']
'some data'
```






