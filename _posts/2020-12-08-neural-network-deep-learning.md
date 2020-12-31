---
title: 机器学习-神经网络基础入门
category: ml
layout: post
---
* content
{:toc}

# 数学资料

[注意这篇文章](https://blog.csdn.net/Luo_da/article/details/76026677),基本上涵盖了线性代数的方方面面。

# base

开门说，三个inputs影响一个决定，这三个inputs可以使用权重去影响。

## 图像的基本知识

[有关通道数的概念](https://tinacristal.github.io/2018/09/24/%E5%85%B3%E4%BA%8Eopencv%E7%9A%84%E9%80%9A%E9%81%93/)

## 卷积层
卷积神经网络中每层卷积层（Convolutional layer）由若干卷积单元组成，每个卷积单元的参数都是通过反向传播算法最佳化得到的。卷积运算的目的是提取输入的不同特征，第一层卷积层可能只能提取一些低级的特征如边缘、线条和角等层级，更多层的网路能从低级特征中迭代提取更复杂的特征。

### 反向传播
有关反向传播的说明请看这篇文章:
[article](https://www.cnblogs.com/charlotte77/p/5629865.html) 基本上的意思就是利用一个激活函数=>sigmoid 函数,反向的把输入参数的权重进行调整，使输出与结果预期差不太多。

### 卷积核-kernel
可以看这边[中文](https://www.cnblogs.com/yibeimingyue/p/11964515.html), 其中文中的[参考](https://towardsdatascience.com/types-of-convolution-kernels-simplified-f040cb307c37), 直接看英文就行了，这样就齐全了。

Convolution is using a ‘kernel’ to extract certain ‘features’ from an input image. Let me explain. A kernel is a matrix, which is slid across the image and multiplied with the input such that the output is enhanced in a certain desirable manner.

这里还有一个kernel及filter的概念区别。再澄清一次，kernel就是一个权重矩阵，利用矩阵的乘法，将输入的image提取出特征值。矩阵的维度也就是该神经网络的维度.

而filter则是多个kernel的"拼接"，我也不知道使用这个名词怎么样，其中，这里面的每一层kernel都被赋予为特殊的输入通道。Filter一直比kernel多一维，

> So for a CNN layer with kernel dimensions h*w and input channels k, the filter dimensions are k*h*w.

#### 1D卷积

1D卷积网络基本上处理的是时间序列，因为一维的嘛，假设input是1D的，好多个连续数据，然后经过filter后就可以转化为1D output的其中一个。

#### 2D卷积

本blog暂时还不能上传图片，所以还是用文字描述。input层，就是有多个channel，然而filter也是几层kernel合并在一起，这两者进行某些数学计算从而一个二维的输出。
这个model大部分被用于计算机视觉领域。

### 线性整流层
线性整流层（Rectified Linear Units layer, ReLU layer）使用线性整流（Rectified Linear Units, ReLU）， f(x) = max(0, x).

以上来自百度百科。

### 池化层(Pooling Layer)
pooling池化的作用则体现在降采样：保留显著特征、降低特征维度，增大kernel的感受野。另外一点值得注意：pooling也可以提供一些旋转不变性。

　　池化层可对提取到的特征信息进行降维，一方面使特征图变小，简化网络计算复杂度并在一定程度上避免过拟合的出现；一方面进行特征压缩，提取主要特征。
  最大池采样在计算机视觉中的价值体现在两个方面：(1)、它减小了来自上层隐藏层的计算复杂度；(2)、这些池化单元具有平移不变性，即使图像有小的位移，提取到的特征依然会保持不变。由于增强了对位移的鲁棒性，这样可以忽略目标的倾斜、旋转之类的相对位置的变化，以此提高精度，最大池采样方法是一个高效的降低数据维度的采样方法。
  需要注意的是：这里的pooling操作是特征图缩小，有可能影响网络的准确度，因此可以通过增加特征图的深度来弥补（这里的深度变为原来的2倍）。

　　在CNN网络中卷积池之后会跟上一个池化层，池化层的作用是提取局部均值与最大值，根据计算出来的值不一样就分为均值池化层与最大值池化层，一般常见的多为最大值池化层。池化的时候同样需要提供filter的大小、步长。

https://www.cnblogs.com/eilearn/p/9282902.html

池化层夹在连续的卷积层中间， 用于压缩数据和参数的量，减小过拟合。简而言之，如果输入是图像的话，那么池化层的最主要作用就是压缩图像。

对卷积层来说，其会从高、宽和深，三个维度均改变原始像素矩阵的维度，特别是深度方面的维度，由卷积核的数量所决定。。而对于池化层来说，池化层只是在高和宽的方向上对像素矩阵进行改变，深度方向不存在变化（没有池化矩阵个数的概念）。。你说得很好，卷积核的参数受到反向传播的影响，每次迭代均会改变，而对于池化层，并没有迭代过程中的参数调整。。同时，由于对物体边缘而言，其像素值一般都较大，通过最大池化，便可以保留关键信息。

参考这篇文章: https://blog.csdn.net/weixin_38145317/article/details/89310404


## image patch

如果涉及到non local去噪算法的话，patch表示某一点关联的一片区域（正方形区域），而点和点之间的权要用到patch和patch之间的距离，然后把搜索区域内的点加权平均，

在超分辨率重建中，patch是图像片，如3*3或5*5大小的片。得看具体的应用背景。

通过阅读，“patch”似乎是CNN输入图像的其中一小块，但它究竟是什么呢?当使用CNN解决问题时，“patch”什么时候开始起作用?为什么我们需要“patch”? “patch”和内核(即特征检测器)之间有什么关系?

在CNN学习训练过程中，不是一次来处理一整张图片，而是先将图片划分为多个小的块，内核 kernel (或过滤器或特征检测器)每次只查看图像的一个块，这一个小块就称为 patch，然后过滤器移动到图像的另一个patch，以此类推。

当将CNN过滤器应用到图像时，它会一次查看一个 patch 。

CNN内核/过滤器一次只处理一个 patch，而不是整个图像。这是因为我们希望过滤器处理图像的小块以便检测特征(边缘等)。这也有一个很好的正则化属性，因为我们估计的参数数量较少，而且这些参数必须在每个图像的许多区域以及所有其他训练图像的许多区域都是“好”的。

所以 patch 就是内核 kernel 的输入。这时内核的大小便是 patch 的大小。(不能保证这个结论是正确的)

https://blog.csdn.net/wills798/article/details/97974617

一个有关图像的更全面的资料。


