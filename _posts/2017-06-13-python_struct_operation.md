---
title: "python之列表、元组的基本操作"
category: python
layout: post
---

* content
{:toc}

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

### 操作列表
操作列表，就是在列表上执行某一特定操作。

```python
# 复制A，全复制
# 你对原列表的改动，可以影响复制后的列表
>> yubo = ['123','hello','world']
>>> hechun = yubo
>>> yubo.append('456')
>>> print (yubo)
['123', 'hello', 'world', '456']
>>> print (hechun)
['123', 'hello', 'world', '456']
# 复制列表，但对于复制后的不影响
>>> test = yubo[:]
>>> print (yubo)
['123', 'hello', 'world', '456']
>>> yubo.append('789')
>>> print (yubo)
['123', 'hello', 'world', '456', '789']
>>> print (test)
['123', 'hello', 'world', '456']

```

# 字典
字典里面可以储存更多的信息，理解它后，你就可以更加准确的为各种真实物体建模了。字典是一系列`键-值`对，

```python
# 访问元素
>>> alien_0 = {'color': 'green','point':5}
>>> ptinr(alien_0['color'])
>>> print(alien_0['color'])
green
# 加入有这么一个游戏，是你现在获得的point
# 注意str函数，这是将列表、元组或者字典里面的字符转化为字符串
>>> new_point = alien_0['point']
>>> print("You just earned" + str(new_point) + "points!" )
You just earned5points!

# 添加元素,注意，字典添加元素使用[]添加进去的
>>> alien_0['x_position'] = 0
>>> alien_0['y_position'] = 25
>>> print(alien_0)
{'color': 'green', 'y_position': 25, 'x_position': 0, 'point': 5}
# 修改某一键值
>>> alien_0['color'] = 'yellow'
>>> print(alien_0)
{'color': 'yellow', 'y_position': 25, 'x_position': 0, 'point': 5}
# 删除键, 注意，永远消失
>>> del alien_0['point']
>>> print(alien_0)
{'color': 'yellow', 'y_position': 25, 'x_position': 0}
# 遍历字典 items()
>>> alien_0.items()
[('color', 'yellow'), ('y_position', 25), ('x_position', 0)]
#使用for, 分别得到键、值.注意，对于数值型的字符，注意转换
>>> for attr, value in alien_0.items():
...     print("\n attr: " + attr)
...     print("\n value: " + str(value))
...

attr: color
value: yellow
attr: y_position
value: 25
attr: x_position
value: 0
# 只得到键, 实际上，它得到一个列表
>>> for value in alien_0.keys():
...     print(str(value))
...
color
y_position
x_position

#只得到值，返回一个列表
for value in alien_0.values():

# 多个字典在一个字典中
# 注意这里，将三个字典放入一个字典中，使用列表包围起来
alien_0 = {'color': 'green', 'point':5}
alien_1 = {'color': 'yellow','point':10}
alien_2 = {'color':'red', 'point': 15}
aliens = [alien_0, alien_1, alien_2]
print(alines)

# 字典里储存列表

pizza = {
        'crust': 'thick',
        'toppings': ['mushroom', 'extra sheese'],
        }

print("You ordered a " + pizza['crust'] + "-crust pizza" +
        " with the following the topping:")

for topping in pizza['toppings']:
    print("\t" + topping)
# 再看一个简单的例子
favorite_languages = {
        'yubo' : ['c,','python'],
        'hechun' : ['math', 'c', 'shell'],
        'hecheng' : ['shell'],
        }

for name, language in favorite_languages.items():
    print("Person's name is " + name.title())
    for lan in language:
        print("\t" + str(lan) + " ")

# 字典里面嵌套字典

```

下面这段代码综合利用了上面的知识：

```python
# 注意字典的这样输入法
favorite_languages = {
        'yubo': 'pytthon',
        'hechun': 'math',
        'xiaoxiao': 'c',
}

friends = ['yubo', 'hechun']
# 可以使用sorted(favorite_languages.keys())进行排序后的输出
for name in favorite_languages.keys():
    print(name.title())

    if name in friends:
        print(" Hi " + name.title() +
                ", i see you favorite languages is " +
                favorite_languages[name].title() + "!")
```

用户输入填充字典， 有些东西需要raw_input()函数实现。

```python

responses = {}

polling_active = True
while polling_active:
    name = raw_input("\n What is your name? ")
    response = raw_input("Which mountain would you like to climb someday?")
    # 将答案存在字典中, 我自己这里写错了
    responses[name] = response
    # 看看是否还有其他人参与调查问卷
    repeat = raw_input("Would you like to let another people response?")
    if repeat == 'no':
        polling_active = False

print("\n-----[pull]-------\n")
for person ,mount in responses.items():
    print(person + " Would like to climb " + mount + ".")

```
