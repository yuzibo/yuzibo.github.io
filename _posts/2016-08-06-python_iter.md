---
title: "python迭代器"
layout: article
category: python
---
# 这篇文章的内容有

迭代 查找单词collections.Counter()


# 文件的迭代

### open

```python
for line in open('5.py'):
	print(line.upper(), end='')
```

将5.py的每一行换成大写。

### while方法

```python
f = open('5.py')
while True:
	line = f.readline()
	if not line: break
	print(line.upper(), end = ' ')
```

# 手动迭代

在交互模式下：

```python
 L = [1,2,3]
 I = iter(L)
 I.next()
```

# 查找单词

请参阅这篇文章 [here](https://github.com/yuzibo/linux-programming/blob/master/python/py-list/common.py)

