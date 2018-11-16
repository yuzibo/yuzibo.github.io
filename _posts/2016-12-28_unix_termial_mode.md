---
title: "unix终端控制模式"
layout: post
category: unix
---

* content
{:toc}

# 规范模式

(需要插入unix编程实践6.2的代码)

```bash
stty icanon
```

缓冲、回显、编辑和控制键处理都是由驱动程序完成的。也就是说你此时之所以可以完成类似的操作，是因为你现在处于规范模式(canonical processing ).

此时驱动程序输入的字符存储在缓冲中，等到用户按下Enter键才进行处理

# 非规范模式

```bash
stty -icanon
```
当缓冲功能和编辑功能被关闭时，你就处于非规范模式.
关闭规范模式，这时你在屏幕上按下任一个键会将内容即可显示在屏幕上。当然，你仍可以处理特殊键的字符处理，比如Ctrl-C、换行符和回车键的含义。

# raw模式

same as cooked[规范模式]

