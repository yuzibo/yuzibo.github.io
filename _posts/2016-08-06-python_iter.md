---
title: "python迭代器"
layput: article
category: python
---

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

# 其他方式


