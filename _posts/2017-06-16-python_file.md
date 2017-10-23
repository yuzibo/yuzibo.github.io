---
title: "python之文件操作"
category: python
layout: article
---

```python
#!/usr/bin/python
# -*- coding: UTF-8 -*-
""" 这是python打开文件的方法"""
""" 这里的文件名可以使用相对路径或者相对路径， windows使用(\)"""
""" 当然，file_path 可以事先定义"""

with open('inherit.py') as file_object:
	for line in file_object:
		print(line)

with open('inherit.py') as file_object:
	contents = file_object.read()
	print(contents)
	"""除去空格"""
	print(contents.rstrip())


""" 创建一个文件包含各行内容的列表"""
```
