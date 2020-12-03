---
title: 机器学习入门
category: ml
layout: post
---
* content
{:toc}

目前，因为项目需要，需要简单地对机器学习相关的概念有一个初步了解，故总结记录在这里，其中，主要参考了这一系列文章:
https://scruel.gitee.io/ml-andrewng-notes/week2.html

#	机器学习入门

## 	什么是机器学习

两种定义(正式或非正式: 下棋，过滤垃圾邮件)

# 机器学习算法

`监督学习`和`无监督学习`，区别在于是否需要人工参与数据结果的标注。
监督学习(Supervised Learning):有反馈。给予计算机一定的输入和对应的结果(训练集)，建模拟合，让计算机推测结果。

## 监督学习

### 回归问题(Regression)

回归问题就是预测一系列的连续值；比如，根据照片推测年龄。

### 分类问题(Classification)

分类问题就是预测一系列的离散值。判别类的一些应用就是该类型。这里提了一下支持向量机。

## 无监督学习(Unsupervised Learning)

这里的训练集没有标记结果，即计算机执行完毕后不知道最后的结果的成功率。分为几个簇，也叫聚类算法。一般有两种:
1.	聚类(Clustering) 比如， 新闻聚合 天文数据分析 市场细分
2.	非聚类(Non-Clustering): 鸡尾酒问题: 语音识别一个人可以做的非常好，但是多人的话就识别不好。
1.3	单变量线性回归(Linear Regression with one variable)

### 模型

1.	房屋价格预测训练集，往年的价格，这不就是咱们当面学习的线性回归的方程嘛
2.	Model 训练集->训练算法, 然后输入x，预测y的值。接着上面的问答，关键就是在求系数。

### 代价函数(Cost function)

计算整个训练集所有损失函数之和的平均值。

### 损失函数(Loss function)

计算单个样本的误差。

#### 梯度下降(Gradient Descent)

解决在特征值很大的情况下，引入梯度下降的概念，让计算机自动找出最小化代价函数时对应的塞塔值。

#### 线性回归的梯度下降(Gradient Descent for Linear Regression)

这部分就和高等数学紧密相连了，感觉有些难度，暂时搁浅。
https://scruel.gitee.io/ml-andrewng-notes/week1.html

# 多变量线性回归(Linear Regression with Multiple Variables)

## 多特征(Multi feature)

