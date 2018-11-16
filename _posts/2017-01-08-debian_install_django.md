---
title: "debian安装django"
category: django
layout: post
---

* content
{:toc}

# 安装python

如果你的python版本是2.7.x，貌似不用额外安装，另外我的博客里有3.7.x的安装教程。

# setuptools

我是安装的源代码， [setuptools](https://github.com/pypa/setuptools/archive/master.tar.gz#egg=setuptools-dev),
解压后进入目录使用命令：

```python
python setup.py build
```

接着进行安装：

```python
python setup.py install
```

# django

首先下载[源代码](git clone https://github.com/django/django.git), 在相应的目录下，有这个文件： setup.py
使用如下命令：

```python
python setup.py install
```

执行完毕后你就可以看见相关的消息，

```bash
Processing dependencies for Django==1.x.y
Finished processing dependencies for Django==1.x.y
```

使用

```python
python
import django
django.VERSION
```

就可以看见相关的信息，说明安装成功.
# 卸载软件
[参考](http://www.aftermath.cn/python_install_packets.html)

