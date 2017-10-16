---
title: "python之列表、的基本操作"
category: python
layout: article
---

# list

## 基本操作

列表的基本操作。

比如构造一个`1、3、5、7...`的列表，使用什么方法呢。这是比较笨的方法。
```python
L = []
i = 1
while i <= 99:
    L.append(i)
    i = i + 2

print (L)

# or
j = 1
k = 0
while j <= 99:
    L[k] = j
    j = j + 2
    k = k + 1

print (L)
```
效果虽然一样，但是还是有点问题的。问题之一就是效率，写的太啰嗦了。

### 切片

切片就是在列表中，以下标的方式读取元素的方法。举个例子

```python
L = ["1",'2', '3', '4']
print L[0:2] # 打印从第0个到第2个的元素
# 等价于
print L[:2]
#  还可以
print L[1:2] # 从第1个元素到第2个元素
# 还可以
print L[-1] # 这个打印的是倒数第一个元素 4
```

请看下面的例子：

```python
>>> l = ['1','2','3','4']
>>> print l[-1]
4
>>> print l[:-1] # 从正数第一个取到倒数第一个(但是并不会取到)。
['1', '2', '3']
>>> print l[-1:] # 从倒数第一个取，取到最后，只有他自己
['4']
>>> print l[-3 :-1] # 从倒数第一取到倒数第1，
['2', '3']
>>> print l[-2:] # 从倒数第2取到最后
['3', '4']
>>>
```

首先新建一个包含100个元素的列表。

```python
>>> yubo = list(range(100))
>>> print (yubo)

```

### 添加、插入、删除

详情可以参考注释。

```python
>>> hechun = ['yubo','hehe','haha']
>>> print (hechun)
['yubo', 'hehe', 'haha']
>>> hechun.append(123)
>>> print (hechun)
['yubo', 'hehe', 'haha', 123]
# 在指定位置插入元素
>>> hechun.insert(1, 'csl')
>>> print (hechun)
['yubo', 'csl', 'hehe', 'haha', 123]
# 删除指定元素,其元素已不在list中
>>> del hechun[1]
>>> print (hechun)
['yubo', 'hehe', 'haha', 123]
# 使用pop方法，并可以继续访问这个值
>>> tmp = hechun.pop()
>>> print (tmp) #默认是最后一个元素
123
>>> tmp = hechun.pop(0) #可以指定元素位置
>>> print (tmp)
yubo
>>> print (hechun)
['hehe', 'haha', '123']
>>> hechun.remove('haha')
>>> print (hechun)
['hehe', '123']
```

### 组织列表

这里有排序、打印、长度等操作

```python
# 排序
>>> print (hechun)
['hehe', '123']
>>> hechun.sort()
>>> print (hechun)
['123', 'hehe']
#反序
>>> hechun.sort(reverse=True)
>>> print (hechun)
['hehe', '123']
#使用sorted（）可以保存原来列表的内容，你可以将新的列表
#复制给新的列表

### 倒序打印列表
>>> print (hechun)
['hehe', '123']
>>> hechun.reverse()
>>> print (hechun)
['123', 'hehe']
```
