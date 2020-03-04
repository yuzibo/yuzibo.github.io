---
title: Android soong简介
category: aosp
layout: post
---
* content
{:toc}

# 介绍
简单一句话就是，google打算使用soong代替庞大的mk文件群，从而让aosp的开发更方便一些.

# androidmk
使用这个工具可以将`mk`文件中的变量、模块、评论或者一些其他的条件转化为`Android.bp`文件，比较复杂的
需要手工转换。

```bash
androidmk Android.mk > Android.bp
```
mk文件和bp文件的差别在于，mk文件可以允许有相同名字的多个模块，但是bp文件就不能这样，但是后者可以有
多个变量。

整体的build逻辑使用GO的`blueprint`编写。所有的build 规则被bp文件搜集并且写入`ninja` build 文件。

流程: Android.bp  => Blueprint(soong) => Ninja file

Blueprint更像是一个库，专门来翻译blueprint文件，关于Blueprint文件格式可以参考build/blueprint/Blueprints文件，soong是在blueprint上面的扩展，基于blueprint的语法定制产生Android.bp语法，解析Android.bp文件生成ninja文件。
[来源 jianshu](https://www.jianshu.com/p/80013a768a45)

着四者之间的关系你看看下面的`build`目录就行了.

从aosp 7.0开始，aosp在`prebuilts/go/`目录下新增go语言的运行环境就是为了他们之间的转换。

# kati
kati就是上文所说的 `androidmk`的工具，源码位于:
```bash
user@host037-ubuntu-1804:~/zhimo-aosp/build$ ls
blueprint  buildspec.mk.default  CleanSpec.mk  core  envsetup.sh  kati  make  soong  target  tools
```
kati下面的内容也是居多，看来就是实现了一个虚拟机的功能(或者需要编译原理)，这个门槛怎么也绕不过去。根据他内部的文档，kati也是一个短期的项目.
目前，kati的主要 mode是 `ninja`mode.(build.ninja)

下面我翻译一下谷歌的官方文档:
<font color = "yellow"> ...相反通过他自己执行build命令，kati缠身`build.ninja`文件去执行上述命令。kati目前的形式是多次试验的结果，一些实验成功了，然而另外一些实验却失败了。我们甚至改变语言。期初，我们使用go编写的kati，我们天真的期待着在编译性能上有足够的提升。至少，我们可以得出三个结论...<font>

其实，谷歌自己也在为go的性能担心，当然，这不是这篇文章的核心，我们的目前是如何快速的编译出aosp系统，而不是讨论哪种方法更好，c的效率足够高，但是GNU的Makefile内容太臃肿.
