---
title: "python新手注意的知识点"
category: python
layout: article
---

# 复制对象和可改变行

不可变对象是传值的，可变对象是传引用的。

其中，标量类型（整数、元组）是不可变类型， 剩下的列表、字典、类、实例都是可变的。

请看下面的例子：

```python
>>> mylist = [1, 'a', ['foo','bar']]
>>> mylist2 = list(mylist)
>>> mylist2[0] = 2
>>> mylist2[2][0] = 'biz'
>>> print mylist
[1, 'a', ['biz', 'bar']]
>>> print mylist2
[2, 'a', ['biz', 'bar']]


```
注意区分浅复制和深度复制

# 元组 ()

含有一个元素的元组(1,)， 别忘了最后的","

# 初始化程序

注意python中类的使用

```python
from time import ctime
class MyClass(object):
    def __init__(self, date):
        print "instance created at:", date

>>> m = MyClass(ctime())
instance created at: Fri May 12 11:03:06 2017
>>> ctime()
'Fri May 12 11:03:13 2017'
```

也就是这个类，使用self实例化，self类似与c++的this，上面的例子中object传递给了date


# 动态实例属性

其他语言中使用new关键字新添属性，在python中，可以直接使用。

```python
>>> class AddressBook(object):
...     def __init__(self, name, phone):
...         self.name = name
...         self.phone = phone
...
>>> john = AddressBook('john Doe', '18263896585')
>>> jane = AddressBook('Chun He', '188')
>>> print john.name
john Doe
>>> join.sex = 'Female'
Traceback (most recent call last):
  File "<console>", line 1, in <module>
NameError: name 'join' is not defined
>>> john.sex = 'Female'
>>> print john
<AddressBook object at 0xa952eec>
>>> print john.sex
Female
```

