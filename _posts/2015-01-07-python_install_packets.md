---
layout: article
title: "python安装软件"
category: python
---

# debain安装python3

因为debian在自带的python为2.7,在执行其他的一些东西时会碰上各种各样的问题,所以,升级版本是唯一的选择.

1、下载python3.3安装包

	wget http://www.python.org/ftp/python/3.3.0/Python-3.3.0.tgz

2、解压安装包

	tar -zxvf Python-3.3.0.tgz

3、进入解压后目录

	cd Python-3.3.0

4、创建安装目录

	mkdir /usr/local/python3.3

5、编译安装

	./configure --prefix=/usr/local/python3.3

6、执行

	make
	make install

7、此时已完成新版本的安装，但由于老版本还在系统中，所以需要将原来/usr/bin/python链接改为新的连接：
先修改老的连接，执行

	mv /usr/bin/python /usr/bin/python_bak

再建立新连接

	ln -s /usr/local/python3.3/bin/python3.3 /usr/bin/python

8、查询python版本，执行：

	python --version

# easy_install 安装软件
现在主流系统不推荐使用这种方法了，但是有时候为了方便，会简单的使用一下，比如，我的这篇文章[install django](http://www.aftermath.cn/django_1.html),但是当我日后想要卸载旧版的 Django遇上问题了，不知道使用的哪个方法安装的，现在简单的记录下：

可以再重新安装一遍，找到egg包。

```python
sudo easy_install install -m django
#  在输出的界面上有这个egg的位置
rm -rf path-sth-egg
```
这两篇文章有点相互引用的味道，够了。

# pip

[here](https://stackoverflow.com/questions/1231688/how-do-i-remove-packages-installed-with-pythons-easy-install),在这篇文章里，人家给了一个比较好的原因说使用pip,下面看看怎么使用吧。

```python

wget https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py
# 注意，使用 pip install -U pip检查最新的pip版本
```
这里多说一句，你觉得是不是应该将python设置最新的？不一定的，但是更新最新版本，有好处。django最新版本，就是面向了python 3.6
这里多说一句，你觉得是不是应该将python设置最新的？不一定的，但是更新最新版本，有好处。django最新版本，就是面向了python 3.6..

## 卸载
这个软件可以使用 "uninstall"选项，甚至可以删除`easy_install`软件安装的包。

# 建立虚拟环境
使用Django软件啥的，就需要一个虚拟环境，这个环境就是系统的一个位置，你可以在其中安装包，并将其与其他Python包分离，这样做是有益的。

## 安装

书上说，python 3 以上可以直接使用

	 python -m venv ll_env

来建立虚拟环境但是在我的机器上有些问题，现在先放下[question].

可以使用virtualenv包，这样就问题不大了。

```python
pip install --user virtualenv
```

下面就是建立一个目录mysite, 然后创建一个虚拟环境.

```bash
virtualenv ll_env
# 激活
source ll_env/bin/activate

#禁用
deactivate
```
