---
title: shell 有趣的知识点
category: shell
layout: post
---
* content
{:toc}

这篇文章其实就是一篇杂记，讲开源代码中的有意思wiki记录下来。

# type

该命令是判断shell中的各种`关键字`的类型， 现在可以记住一个用法， `type -t`.

```bash
vimer@host:~$ type -t ls
alias
vimer@host:~$ type -t date 
file
vimer@host:~$ type -t if
keyword
```

# if test

使用`if test` 代替"["或者“[[”。

## 等于0

```bash
if test "$E1" = 0; then

fi
```

## 小于

```bash
if test "0$FF" -lt 0; then
   ...
fi
```

# test

这个test可以单独使用：

```bash
test $name = vimer
```
判断的结果会存放在"$?"中。 记住，0代表成功1代表失败。
