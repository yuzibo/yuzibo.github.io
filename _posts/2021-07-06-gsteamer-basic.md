---
title: gstreamer
category: gstreamer
layout: post
---
* content
{:toc}

# 基本概念

[cnblog](https://www.cnblogs.com/xleng/p/11194226.html)的一系列文章写得非常不错，他是一个系列的。
链接中是动态创建Pipeline.

[gstreamer hello world](https://www.cnblogs.com/xleng/p/11008239.html)

[gstream element](https://www.cnblogs.com/xleng/p/11039519.html)

为了更直观的展现element，我们通常用一个框来表示一个element，在element内部使用小框表示pad。

## 三类element

1. source element:  只能生成数据的，不能接收数据的， 如 filesrc

2. sink element: 只能接收数据，不能产生数据的
