---
title: "python爬虫之beautifulsoup用法"
category: python
layout: post
---

# 快速开始

## 软件安装

	sudo pip install beautifulsoup

python的软件安装请参[参考](http://www.aftermath.cn/python_install_packets.html)

详细教程请参考这里:

提醒大家，使用这个库，一定做好字符编码这个坑的准备

https://www.crummy.com/software/BeautifulSoup/bs4/doc/index.zh.html

```python
from bs4 import BeautifulSoup
import requests

html_doc = """
<html><head><title>The Dormouse's story</title></head>
<body>
<p class="title" name="dromouse"><b>The Dormouse's story</b></p>
<p class="story">Once upon a time there were three little sisters; and their names were
<a href="http://example.com/elsie" class="sister" id="link1"><!-- Elsie --></a>,
<a href="http://example.com/lacie" class="sister" id="link2">Lacie</a> and
<a href="http://example.com/tillie" class="sister" id="link3">Tillie</a>;
and they lived at the bottom of a well.</p>
<p class="story">...</p>
"""

soup = BeautifulSoup(html_doc, 'lxml')
print(soup.prettify())
```
当然，所有的用法是以上面的代码为基础的.
效果如下:

![png](http://yuzibo.qiniudn.com/bs_1.png)

# 几个简单的用法

下面代码中的注释就是输出内容.
```python

print soup.title
#<title>The Dormouse's story</title>

print type(soup.title)
#<class 'bs4.element.Tag'>

print soup.title.name
#title

print soup.title.string
#The Dormouse's story

print soup.title.parent.name
#head

print soup.p
# <p class="title" name="dromouse"><b>The Dormouse's story</b></p>

print soup.p['class']
#['title']

print soup.a
#<a class="sister" href="http://example.com/elsie"
#id="link1"><!-- Elsie --></a>

print soup.find_all('a')
#[class="sister" href="http://example.com/elsie" id="link1"><!-- Elsie --></a>,
#<a class="sister" href="http://example.com/lacie" id="link2">Lacie</a>,
#<a class="sister" href="http://example.com/tillie" id="link3">Tillie</a>]

print soup.find(id="link3")
#<a class="sister" href="http://example.com/tillie" id="link3">Tillie</a>
```

实际上，那个主页上面的例子有些差错，我已经发邮件说了。

大家可以先看看这个例子，慢慢地我会逐一讲解。

这里可以使用loop将链接提取出来:

```python
for link in soup.find_all('a'):
    print(link.get('href'))
#http://example.com/elsie
#http://example.com/lacie
#http://example.com/tillie

```

# 对象类型

### Tag
在上面的代码中已经出现了这个，请看<class 'bs4.element.Tag'>
这个类型有很多的属性，这里，重点记住它的属性和名称.
#### name
```python
soup = BeautifulSoup('<b class="boldest">Extremely bold</b>', 'lxml')
tag = soup.b
print type(tag)
print tag.name
# 在这里你可以更改tag的名字，这样还可以将修改反应到原生的html

tag.name = 'yubo'
print tag
#### 输出的内容:
<class 'bs4.element.Tag'>
b
<yubo class="boldest">Extremely bold</yubo>
```

#### attris
对于上面的代码来说就是这样，这里的属性就是class,也就是标签的属性。
```python
print tag['class']

# 你可以直接访问,注意这是一个字典:

print tag.attrs
{'class': ['boldest']}
```

这里有一个多值属性，就先不解释了

#### NavigableString
这个对象的含义就是一个tag对象所存储的文本内容,BeautifulSoup使用NavigableString这个类去存储文本。

```python
print tag.string
#Extremely bold

print type(tag.string)
#<class 'bs4.element.NavigableString'>
```
这里就涉及到令人烦恼的编码问题了。一个NavigableString对象就像Python Unicode字符串，你可以使用*unicode()*方法。

```python

unicode_string = unicode(tag.string)
print unicode_string
#Extremely bold

tag.string.replace_with("hello, yubo")
print tag
#<b class="boldest">hello, yubo</b>
```
这里直接引用文档中的原文:
If you want to use a NavigableString outside of Beautiful Soup, you should call unicode() on it to turn it into a normal Python Unicode string. If you don’t, your string will carry around a reference to the entire Beautiful Soup parse tree, even when you’re done using Beautiful Soup. This is a big waste of memory.

#### BeautifulSoup
因为之前有Tag的对象，这个对象就是整个页面的集合组成，基本上用的不多.

#### 评论及其他
```python
markup = "<b><!--Hey, buddy. Want to buy a used parser?--></b>"
soup = BeautifulSoup(markup)
comment = soup.b.string
type(comment)
# <class 'bs4.element.Comment'>
```

还是以上面的例子，html_doc的内容不变， 测试以下实验例句.

```python
soup = BeautifulSoup(html_doc, 'lxml')
print soup.a
# 这个语句打印匹配出第一个合适的<a>标签

print soup.find_all('a')
#这个语句就是打印出所有的<a>标签，这明显就是一个列表。
```

##### .contents 和 .children

```python

head_tag = soup.head
print head_tag
#<head><title>The Dormouse's story</title></head>

print head_tag.contents
# [<title>The Dormouse's story</title>]
# actually, you can see that soup.head is tag,
# which contents is its sub-class and it is a list


print head_tag.contents[0]
#<title>The Dormouse's story</title>
# discard list

print head_tag.contents[0].contents
# recursion... [u"The Dormouse's story"]
```

The "BeautifulSoup" object itself has children, in this case, the <html> is the child of the "BeautifulSoup".

```python
head_tag = soup.head
print len(soup.contents)
# 1

print soup.contents[0].name
# html
# You need to think the same useage like about

title_tag = soup.title
print title_tag
# <title>The Dormouse's story</title>

print title_tag.contents
#[u"The Dormouse's story"]

print title_tag.contents[0]
#The Dormouse's story
```

##### .descendants

The *.contents* and *.children* attribute only consider a tag's direct chilren. For instance, the <head> tag has a single direct child-the <title> tag:

```python

head_tag = soup.head
print head_tag
# <head><title>The Dormouse's story</title></head>

print head_tag.contents
#[<title>The Dormouse's story</title>]

```
Above, please note: The *title* tag itself has a child: "The Dormouse's story", the *.descendants* attribute just is to use it.

```python
for child in head_tag.descendants:
    print child
#<head><title>The Dormouse's story</title></head>
#<title>The Dormouse's story</title>
#The Dormouse's story
```

If a tags only one child,and that child is a *NavigableString*(??), the child is available as *.string*

```python
title_tag = soup.title
print title_tag.string
# The Dormouse's story
```

##### .string and stripped_string

```python

for string in soup.strings:
    print(repr(string))
# print a lot

for string in soup.stripped_string:
	print(repr(string))
# discard "\n"
```

### Going up

#### .parent
You can access an elements parent with *.parnet*,for instance,

```python
title_tag = soup.title
print title_tag
#<title>The Dormouse's story</title>

print title_tag.parent
#<head><title>The Dormouse's story</title></head>

```

#### .parents
```python

link = soup.a

for parent in link.parents:
    if parent is None:
        print(parent)
    else:
        print(parent.name)
# p
# body
# html
# [document]
# None
```

This is a recursion usage to iterate over all elements's parent.

#### Sideways
```python

soup_sibling = BeautifulSoup("<a><b>text1</b><c>Test2</c></b></a>", 'lxml')

print (soup_sibling.prettify())
#<html>
# <body>
#  <a>
#   <b>
#    text1
#   </b>
#   <c>
#    Test2
#   </c>
#  </a>
# </body>
#</html>

```
The <b> tag and <c> tag are at the same level: they're both direct children of the same tag.We call them *siblings*.

#### .next_siblings and .previous_sibling

```python

print soup_sibling.b.next_sibling
# <c>Test2</c>

print soup_sibling.c.previous_sibling
# <b>text1</b>

```
Certainly, there is a *next_sibling*

Here, you should know *.next_elements*and *.previous_elements*

### Searching the tree

#### A string

```python
print soup.find_all('b')
#[<b>The Dormouse's story</b>]
# This is a list.
```
#### A regular expression

```python
import re

### @1
for tag in soup.find_all(re.compile("^b")):
    print (tag.name)
##body
##b

### @2
for tag in soup.find_all(re.compile("t")):
    print (tag.name)
## html
## title

### @3
print soup.find_all(["a", "b"])

### @4
for tag in soup.find_all(True):
    print (tag.name)

### @5
def has_class_but_no_id(tag):
    return tag.has_attr('class') and not tag.has_attr('id')

print soup.find_all(has_class_but_no_id)


### @6
def not_lacie(href):
    return href and not re.compile("lacie").search(href)

print (soup.find_all(href=not_lacie))
```
@1,here, this code finds all the *tags* whose names start with the letter "b":in this case, the <body> tag and the <b> tag

@2: this code is to find tag whose name contains "t".

@3: here is a list(arguments is and results is too)

@4: The argument is bool, it will list all tags in html_doc.

@5: You will pick up a tag <p> it contains "class".This function only picks up the <p> tags. It doesn’t pick up the <a> tags, because those tags define both “class” and “id”. It doesn’t pick up tags like <html> and <title>, because those tags don’t define “class”.

@6: You will note the call for function.It will output two elements in a list,it both are <a></a> tag.

#### find_all()
The above usage is mentioned.her, *name* *keywords* argument, in a words:

```python
print soup.find_all("title")

print soup.find_all(id='link2')

print soup.find_all(href=re.compile("elsie"))
```

You can’t use a keyword argument to search for HTML’s ‘name’ element, because Beautiful Soup uses the name argument to contain the name of the tag itself. Instead, you can give a value to ‘name’ in the attrs argument.Below is code:

```python

soup = BeautifulSoup('<input name="email"/>', 'lxml')
## @1
print soup.find_all(name="email")

## @2
print soup.find_all(attrs={"name":"email"})
#[<input name="email"/>]
```

@1: it will print a empty list([]).

@2: it will print right result.

## CSS class
The *class* is a keyword in python, so you have to use *class_*

```python
print soup.find_all("a", class_ = "sister")

```

[here](https://www.crummy.com/software/BeautifulSoup/bs4/doc/index.html#going-up)

### CSS selector

Beautiful Soup supports the most commonly-used CSS selectors. Just pass a string into the .select() method of a Tag object or the BeautifulSoup object itself.

```python
soup.select("title")
```

...

## Output
The will turn BS into Unicode string.

```python
print (soup.prettify())
## it will print Unicode

str(soup)
## it will return UTF-8
```

## Encodings

Use *.original_encoding* to displays documents's encoding

```python

print soup.original_encoding
# ascii

markup = b"<h1>\xed\xe5\xec\xf9</h1>"
# 这个编码是iso-8859-8
# 如果你直接打印soup.original_encoding将会是 iso-8859-7

soup = BeautifulSoup(markup , 'lxml', from_encoding="iso-8859-8")
# 使用这个参数就会告诉BS正确的编码方式

print soup.original_encoding
#这样就会打印iso-8859-8

```
这里才是我写这篇文章的目的，BS默认是把输入文档转化为Unicode,当然，输入时的文本编码是靠BS猜的，但是有可能猜错，所以这样你最好使用*from_encoding*参数指明输入的文本的编码格式。这里用汉语写出，以突出重点.

## 输出编码(output encoding)

BS输出时默认是UTF-8.请看下面的例子:

```python

html_doc = """
<html>
    <head>
     <meta content="text/html; charset=ISO-Latin-1"
     http-equiv="Content-type" />
    </head>
    <body>
        <p>Sacr\xe9 bleu!</p>
    </body>
</html>
"""

soup = BeautifulSoup(html_doc, 'lxml')

print soup.original_encoding
#iso-latin-1

print (soup.prettify())
#<html>
#	<head>
#		<meta content="text/html;
#		charset=utf-8" http-equiv="Content-type"/>
#	</head>
#	<body>
#	<p>
#		  Sacré bleu!
#	</p>
#	</body>
#</html>
```
请问能够看出什么东西来，对，就是这样的简单，BS可以根据<html>的字符集自动分析编码集，但是使用prettify()输出的时候就是"UTF-8"的编码。

赶快拿出笔记本记重点：如果prettify()的  *UTF-8*不是你的菜，你可以使用prettify()的编码方法。

# 实例

[以这篇文章为例](http://paper.people.com.cn/rmrb/html/2017-11/15/nw.D110000renmrb_20171115_1-09.htm)

![rmrb2.png](http://yuzibo.qiniudn.com/rmrb2.png)

为了提取图中的文字，可以使用下面的代码：

```python
import urllib2
from bs4 import BeautifulSoup
import requests

import chardet
import re

if __name__ == '__main__':
#    target = 'http://paper.people.com.cn/rmrb/html/2017-11/15/nbs.D110000renmrb_09.htm'
    target = 'http://paper.people.com.cn/rmrb/html/2017-11/15/nw.D110000renmrb_20171115_1-09.htm'
    req = requests.get(url=target)
    req.encoding = 'utf-8'
    content = req.text
    bf = BeautifulSoup(content ,'lxml')
    context = bf.find(id='postContent')
    print bf.h1.text
    print context.text
```

参考：https://jiayi.space/post/yong-beautifulsoupti-qu-wang-ye-xin-xi-shi-li

#### 分行
这个东西从一开始就困扰我，现在还好些了，请看效果:

![rmrb3.png](http://yuzibo.qiniudn.com/rmrb3.png)

在这里，我们知道<P></P>标签就是分段的意思，同理，<br>也是同样的意思，你可以使用*.get_text*属性

```python
    bf = BeautifulSoup(content ,'lxml')
    context = bf.find(id='postContent')
    print context.get_text(separator = u'\n')
```

Please to see the picture:

![rmrb4.png](http://yuzibo.qiniudn.com/rmrb4.png)



