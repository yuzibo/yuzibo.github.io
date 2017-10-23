---
title: "python之文件操作"
category: python
layout: article
---

使用`with`的打开方式更加符合python的变成习惯，希望你能喜欢这种编程风格。
下面使用一个文件pi.txt 来测试一下这个问题。

pi.txt:

3.1415926535
  8979323846
  2643383279

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
#注意，使用with的方式，open()方法返回的对象只能在with代码块内使用，
#如果想在其他地方使用代码，可以使用readlines()方法。

file_name = 'pi.txt'

with open(file_name) as object:
    lines = object.readlines()

for line in lines:
    print(line.rstrip())

```
为了更加美好的展现这个函数的特征，我们新建立一个代码段：

```python

file_name = 'pi.txt'

with open(file_name) as object:
    lines = object.readlines()

pi_string = ''
for line in lines:
    pi_string += line.rstrip()

print(pi_string)
print(len(pi_string))
```
他的输出是这样的:

```bash
3.1415926535  8979323846  2643383279
36
```
我们看到这样的输出，也许并不完美，也许并不满足你的要求，现在，我们这样：

```python
file_name = 'pi.txt'

with open(file_name) as object:
    lines = object.readlines()

pi_string = ''
for line in lines:
    pi_string += line.strip()

print(pi_string)
print(len(pi_string))
```
这样就会将好几行数字浓缩在一行之中。注意，python会将所有读取的内容视为文本内容，如果你的内容是数字，而且你还打算使用这个数字，就应该使用int()或者float()函数转化过来。

### 写入文件
从文件读取，我们知道使用open(), 那么写入呢？对了，是write，但是，这个write只是一个文件的方法。

```python

filename = 'name.txt'

with open(filename, 'w') as object:
    object.write("hello, world")
```
这个东西与ｃ语言的open(),read(),close()...多么的相近。这里的open()后面的参数
可以有'w', 'r','a','r+',最后一种是即可读取也可写入。如果不是人为的指定参数，
那么就是只读模式打开文件.

同时，注意，python只能写入文本，所以像数字的内容写入文件的时候，必须使用str()
函数转化，这样才可以

当然在写入的同时可以使用制表符"\n","\t"等等。


### file的基本操作

```python
root@yubo-2:~/test/python# cat test.py
#!/usr/bin/python
# -*- coding: UTF-8 -*-
import math
fo = open("yubo.txt", "wb")
print "文件名", fo.name
print "是否已经关闭：", fo.closed
print "访问模式：", fo.mode
print "末尾是否强制加空格：", fo.softspace
```

### File对象的属性

file.closed	返回true如果文件已被关闭，否则返回false。

file.mode	返回被打开文件的访问模式。

file.name	返回文件的名称。

file.softspace	如果用print输出后，必须跟一个空格符，则返回false。否则返回true。

记得在打开一个文件后需要 file-objection.close();

### 读写文件

write()方法不会在字符串的后面添加'\n'.

```python
#!/usr/bin/python
# -*- coding: UTF-8 -*-
import math
fo = open("yubo.txt", "wb")
print "文件名", fo.name
print "是否已经关闭：", fo.closed
print "访问模式：", fo.mode
print "末尾是否强制加空格：", fo.softspace

fo.write("www.aftermath.cn\nVery good\n");

fo.close();
```

read()方法读取一个参数

```python
#!/usr/bin/python
# -*- coding: UTF-8 -*-
import math
fo = open("yubo.txt", "r+")
str = fo.read(10);
print "读取的字符串是：", str
fo.close();

```

这里的read参数是读取的字节数。

seek()文件定位

```python
#!/usr/bin/python
# -*- coding: UTF-8 -*-
import math
fo = open("yubo.txt", "r+")
str = fo.read(10);
print "读取的字符串是：", str

# 查看当前位置
position = fo.tell();
print "当前文件位置：", position

# 把指针再次重新定位到文件开头

position = fo.seek(0,0);
str = fo.read(10);
print "重新读取字符串：", str

# 关闭打开的文件
fo.close();

```

## 重命名和删除文件

需要导入os模块。

### 重命名

os.rename("file-name1","file-name2");

将文件1重命名为文件2。

### 删除文件

os.remove("file-name");

# 目录操作

### mkdir()

这块文件类似于shell命令

chdir(): 改变目录。

getcwd(): 当前目录

rmdir(): 删除目录

这几个函数都有参数，必须注意。

