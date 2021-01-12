---
title: shell 有趣的知识点-判断-循环
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

## 判断一个变量是否 unset 或者是否设置为空字符串

```bash
if [ -z "${VAR}" ]; # another way:
if [ ! -z "$VAR" ];
```

不过需要注意的是，"["和"[["的用法在某些shell中是无法使用的，所以就会导致这样的一种代码:

```bash
if [ X$1 = X ]; then
    echo "the first argu is empty"
else
    echo "the first argu is $1"
fi
```
什么意思呢？ 我们想一想，这样的，如果参数1为空的话， 是不是两个"X"就是相等的，这个技巧就是利用了这个原理。在android中，经常使用的一种的代码是：

```bash
if [ "x$1" = "x--host" ]; then
        target_mode="no"
        DEX_LOCATION=$tmp_dir
        run_args="${run_args} --host"
        shift
```
这里，注意这个"x"的巧妙用法，就是这样的有趣，也就是说，如果，你想一个个解析参数列表，x后面要补全我们的参数形式。
上面的这个参数形式就是`./exe --host`.
那么，很明显的是， 关键字`shift`就是移动参数列表。

## while in shell

```bash
while true; do 
    if [ "x$1" = "x--host" ]; then
        echo "something"
        shift
    elif [ "x$1" = "x--quit" ]; then
        echo "quit"
        shift
    elif expr "x$1" : "x--" >/dev/null 2>&1; then
        echo "unknown $0 option: $1" 1>&2
        usage="yes"
        break
    else 
        break
    fi
done
```

这个代码重要的一部分是unknown选项的处理，需要后面吸收一下。