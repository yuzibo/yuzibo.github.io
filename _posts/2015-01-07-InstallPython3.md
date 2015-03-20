---
layout: article
title: "Debian安装python3"
category: python
---

因为debian在自带的python为2.7,在执行其他的一些东西时会碰上各种各样的问题,所以,升级版本是唯一的选择.

1、下载python3.3安装包
#wget http://www.python.org/ftp/python/3.3.0/Python-3.3.0.tgz 

2、解压安装包
#tar -zxvf Python-3.3.0.tgz 

3、进入解压后目录
#cd Python-3.3.0 

4、创建安装目录
#mkdir /usr/local/python3.3 

5、编译安装
#./configure --prefix=/usr/local/python3.3 

6、执行
#make
#make install 

7、此时已完成新版本的安装，但由于老版本还在系统中，所以需要将原来/usr/bin/python链接改为新的连接：
先修改老的连接，执行
#mv /usr/bin/python /usr/bin/python_bak
再建立新连接
#ln -s /usr/local/python3.3/bin/python3.3 /usr/bin/python 

8、查询python版本，执行：
#python 