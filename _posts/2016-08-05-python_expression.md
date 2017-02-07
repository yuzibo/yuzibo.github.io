---
title: "python基本语法"
layout: article
category: python
---

# for的使用

for的使用主要注意， 后面的冒号。

在字典中的使用 :

```python
#!/usr/bin/python

from __future__ import print_function
D = { 'a':1, 'b':2,'c':3}
for key in D:
	print(key, '=>', D[key])
```

结果：

```python
a => 1
c => 3
b => 2
```

关键注意字典的键和值。这一点在perl中也是很重要的。字典本身具有很多属性，稍微看一个。将上面的字典用items()打印出来就是

```python
L = D.items()
print(L)
```

这是python 2.x中的用法，3.x直接调用： list(D.items())

```python
for(key, value) in D.items():
	print(key, '=>', value)
```
与上面实现了同样的方法。

### 注意，*p 通用复制在2.x中不可用

#  计数器
 这里的计数器类似于c语言中的for循环，典型的用法如下：

```python
for i in range(3):
	print(x, 'pythons')
```
就会打印三个pythons.

处理字符串时利用 len()函数即可达到相同的作用。

```python
X = 'spam'
for item in X:
	print(item, end = ' ')
# 这两种循环都是一个作用。

i = 0
while i < len(X):
	print(X[i], end = ' ')
	i += 1
```

以上这两中并不是处理这类循环最佳的选择，下面的语句就可以简单的解决。

```python
for item in X: print(x, end = ' ')
```

以下两种方法实现相同的功能：

```python
S = 'abcdefghijk'
for i in range(0, len(S), 2): print(S[i], end = ' ')
print('\n')
# 使用切片技术
for c in S[::2]: print(c, end = ' ')
print('\n')
```

## 循环修改

```python
L = [1,2,4,5,6]
for i in range(len(L)):
	L[i] += 1
print(L)
```

## zip和map

```python
L1 = [1,2,4,5,6]
L2 = [2,3,5,6,7]
M = zip(L1,L2)
print(M)

for (x, y) in M:
	print(x,y, '--', x + y)
```

zip可以接受任何类型的对象，下面这个例子。

```python
L1 = [1,2,4,5,6]
L2 = [2,3,5,6,7]
L3 = [3,4,6,7,8]
print(list(zip(L1,L2,L3)))
```

打印的结果为：

```python
[(1, 2, 3), (2, 3, 4), (4, 5, 6), (5, 6, 7), (6, 7, 8)]
```

zip函数以最短的对象为准。
map以None补全不够的那一部分。

```python
S1 = 'abc'
S2 = 'hechun'
print(zip(S1, S2))

print(map(None, S1,S2))
```

可惜，3.0以上不支持这个函数了。

### zip组合字典

```python
keys = ['spam', 'eggs', 'toast']
vals = [1, 2, 3]

print(list(zip(keys, vals)))
```
处理的结果是如下图所示：

```python
[('spam', 1), ('eggs', 2), ('toast', 3)]
```

这样，我们并没有形成字典，正确的还需要多处理一步：

```python
keys = ['spam', 'eggs', 'toast']
vals = [1, 2, 3]

print(list(zip(keys, vals)))

D2 = { }
for (k, v) in zip(keys, vals): D2[k] = v

print(D2)
```

其输出的结果如下所示：

```python
[('spam', 1), ('eggs', 2), ('toast', 3)]
{'toast': 3, 'eggs': 2, 'spam': 1}
```
在2.x以后，可以直接使用dict函数。

```python
D3 = dict(zip(keys, vals))
print(D3)
```








