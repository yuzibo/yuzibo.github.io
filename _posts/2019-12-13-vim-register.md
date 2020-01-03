---
title: vim寄存器使用简介
category: tools
layout: post
---
* content
{:toc}

# 缘由
vim作为一个编辑利器一直是我的最爱，但是到目前为止，vim只有一点令我感到不爽，那就是他的粘贴复制。也许在这篇(文章)[http://www.aftermath.cn/2016/06/27/vim_tips/]中，已经简单地介绍了一下，今天，再把这个问题详细的介绍一下，以留下较深刻的印象。以下除非做特殊的说明，不然默认的操作都是在X11环境下进行的，所谓的X11就是Debian Ubuntu或者其他Unix系统默认的操作环境。与之对应的自然就是ssh（Xshell）什么的，这点需要注意。

## vim registers
vim可以拥有多达10个寄存器，当然每个寄存器都有自己的目的与作用。

每个寄存器可以使用单个双引号“ " ”去展示， 比如，`"r` 就是r寄存器。假设在视图模式下，你选择一块文本，然后使用`"r` + `y`,这个命令就是把你选择的文本暂存到`r`寄存器中，使用`"r` + `p`就可以把刚才复制的内存打印出来了。如果在一个文本中，这个命令就是`y` 和 `p`的复杂版。

上面这个r寄存器是你自己可以命名的。

## 命令格式
基本的命令格式就是 寄存器 加 动作。比如，想使用`"0`寄存器的内容，可以键入`"0` + `p`.

## 几个特殊的寄存器

`"0` 保存最后一次yanked的内容，`"1`保存最后一次删除或者修改的内容。The same way "1 holds the last delete, "2 holds the second last delete, "3 holds the third last, etc up to "9

`".` 保存最后一次插入模式的内容。

`"%`打印正在编辑文本所在的path.


`"#`:

`":`

命令`: reg`就可以打印所有寄存器的内容。

ttps://stackoverflow.com/questions/1497958/how-do-i-use-vim-registers
