---
title: "自动上传图片或者文章返回url"
layout: article
category: tools
---

# 前言

这是我在shlug组上的一个提问，看看大家伙的热情


大家好，
      本人使用github.io做文字记录，在插入图片时有一些烦恼：
由于担心图片太多，会撑爆github的个人空间，所以使用外链的形式插在文章中，
用过七牛的空间、微博相册。现在有一个想法，就是感觉手动插入图片取得图片URL
这一步是太浪费时间，我就在想，可不可以写一个自动上传图片到七牛或者微博相册
而且立即返回图片URL的自动脚本，感觉能胜任的是 python，由于没有接触过python，
不知道这样的思路对不对，或者有其他可以参考的例子吗？
谢谢！

其中，一个哥们 Zhang Cheng(stephenpcg@gmail.com)的回复实在给力。

在 python-cn 里面搜“七牛 图床”，有若干thread。

其中一个直达链接：https://groups.google.com/forum/#!searchin/python-cn/%E4%B8%83%E7%89%9B$20%E5%9B%BE%E5%BA%8A%7Csort:relevance/python-cn/kWWqC795pV0/IpbspJv5CwAJ

该thread中提到的工具：
* https://github.com/huntzhan/img2url
* https://github.com/kingname/MarkdownPicPicker
* http://yotuku.cn/#/
* https://clbin.com/

后两个我没找到源码（其实是没找）。

我现在看着第一个和最后一个，都是比较好的项目。

这是我的测试;

![test](http://7pum5d.com1.z0.glb.clouddn.com/test.png)



