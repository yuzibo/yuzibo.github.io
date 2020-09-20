---
title: shell 之 $() ${} () 用法总结
category: shell
layout: post
---
* content
{:toc}

其实这篇文章之所以起这个名字，并不是针对别人的，而是针对我自己的。 我不知道大家有没有一个感觉，
就是shell（主要是bash）一般来说，他的语言规则很弱，什么意思？就是说，这种语言是解释型的，任何的
语法错误只有在运行时才能够打印出来，这样导致的一点就是你无法通过强制的语法记忆去改善这种局面。
更恐怖的是，不同版本的shell更加剧了这种局面。

那么怎么办？ [github shellcheck](https://github.com/koalaman/shellcheck/)是一个很好的shellcheck
的shell 规则检查git repo，我发现这个repo基本概括了shell的一些值得注意的地方，值得关注。

# 命令替换$()与反引号用法
()也是一个数组的形式.
对我来说，我目前的做法就是在脚本中或者子函数中如果要执行相关的命令的时候，一般更倾向使用()的方式，而$()则可以将
函数调用的结果提取出来。比如:
```bash
    local T=$(gettop) # caller
    function gettop(){ # callee
        echo $T # ST is string
    }
```
我个人认为`()`这种方式比两个反引号的要好一些。$()与\` \`在语法上等同，都是用来重组命令，但是$()比\` \`又具有明显的优势与劣势：
    1. 多层嵌套$()更清晰一些
    2. 形式上更容易

反引号\`\`也不是没有优点:
    1. 移植性更好， 绝大部分unix shell都支持反引号(backticks)的用法。bash 确保可以使用$()

# 变量替换${}
哈，看到这个命令，我觉得你就会知道我接下来介绍哪个用法了。对，就是$var.首先我参考的就是[OS](https://stackoverflow.com/questions/19513174/whats-the-difference-between-varname-and-varname-in-a-shell-scripts)
我来简单说下。

## $var
像这样的变量很容易理解，一般我们打印一个字符串变量、整型变量啥的可以直接打印。
 
## ${}
英文的翻译是变量扩展，具体请看下面的解释:

> The ‘$’ character introduces parameter expansion, command substitution, or arithmetic expansion.

### ${}替换
先看一个基本的`参数替换`例子:

```bash
val=23 # want 23+abc ==> 23abc
vimer@host:~/src/aosp_art$ echo $valabc
vimer@host:~/src/aosp_art$ echo ${val}abc 
23abc
```

看一个`算数替换`的例子,也就是寻找数组的元素，更详细的例子可以看下面`()`的操作:

```bash
a=( foo bar baz )
vimer@host:~/src/aosp_art$ echo $a[0]
foo[0] # error 
vimer@host:~/src/aosp_art$ echo ${a[0]}
foo
```

后面补充命令替换的。

### ${} 删除用法
这个操作不同于前面的替换，更过的是借用其他的操作符号，比如'#', '%'，对相关的变量进行操作。

```bash
file=/dir1/dir2/dir3/my.test.txt # define a var
vimer@host:~/$ echo ${file#*/}
dir1/dir2/dir3/my.test.txt # del chars located before in the first char '/'
vimer@host:~$ echo ${file##*/} # del all chars before in the last char '/'
my.test.txt
vimer@host:~$ echo ${file#*.} # del all chars before the first char '.'
test.txt
vimer@host:~$ echo ${file##*.} # del all chars before the last char '.'
txt
vimer@host:~$ echo ${file%/*} # del the last char '/' and after it all chars
/dir1/dir2/dir3
vimer@host:~$ echo ${file%%/*} # del the first char '/' and after it all chars, so it is null

vimer@host:~$ echo ${file%.*}   #拿掉最后一个.及其右面的字符
/dir1/dir2/dir3/my.test
vimer@host:~$ echo ${file%%.*}  # 拿掉第一个.及其右面的字符
/dir1/dir2/dir3/my
```

这里细心地读者应该发现了一些特殊的处理细节。${}目前能够处理的位置只能是第一个或者最后一个指定的字符，好，我们这里总结一下:
    1. 以"$"为中心， “#”和"%"在键盘上分别位于`$`的左右两侧，所以${#}删除指定字符左边的东西；
    2. "#"可以看成从左边往右逐个赶变量，且一个"#"表示匹配到第一个字符“#*/”前的所有字符；
    3. “%”可以看成从右往左检索变量，${file%/*},包括这个变量的写法，你也要从右往左写，两个表示贪婪的用法；
    4. "*"同其他的用法， 暂且可以看成n多吧。

这一个用法，对于得到一个源文件的basename具有重要的作用。

### ${} 界定用法

```bash
vimer@host:~$ echo ${file:0:5}
/dir1
vimer@host:~$ echo ${file:5:5}
/dir2
```

基本就是在指定打印从哪位开始后面连续几位。第一个就是从0位开始连续5位字符;第二个是从第5位开始连续5位。

### ${} 变量替换

下面介绍的才是真正的变量替换的用法。

```bash
vimer@host:~$ file=/dir1/dir2/dir3/my.test.txt
vimer@host:~$ echo ${file/dir/path} # path will replace the first dir1 chars
/path1/dir2/dir3/my.test.txt
vimer@host:~$ echo ${file//dir/path} # path will replace all dir chars
/path1/path2/path3/my.test.txt 
vimer@host:~$ echo ${file//\//-} # same as above
-dir1-dir2-dir3-my.test.txt
vimer@host:~$ echo ${file/\//-}
-dir1/dir2/dir3/my.test.txt
```

总结就是:
    1. ${string/old/new} 这和bash中的正则表达式的用法很像，且一个就替换左边的第一个，两个的话就全部替换。

### ${} 变量长度

很简单，就是下面的用法:

```bash
vimer@host:~$ echo ${#file}
27
```

# ()数组介绍
shell中的数组比较特殊， 下面:

```bash
vimer@host:~$ A="a b c ef" # only define a string
vimer@host:~$ echo $A  # print whole string
a b c ef
vimer@host:~$ A=(a b c ef) # define  a char array
vimer@host:~$ echo $A
vimer@host:~$ echo ${A[@]} # 还是与${}配合打印整个数组的内容
a b c ef
vimer@host:~$ echo ${A[*]}
a b c ef
vimer@host:~$ echo ${A[2]} # print the third elemnt
c
vimer@host:~$ echo ${#A[@]} # get num of array, same as ${#file}
4
vimer@host:~$ echo ${#A[3]} # 求某个元素的长度
2
```

# $(()) 整数运算

具体可以看一个例子，需要结合上面刚刚介绍的知识。

```bash
selection=${choices[$(($answer))]}
```
这是aosp脚本中的一个语句， 其中 answer 是通过read 命令读取用户的输入的一个数字。

# 总结

$()可以看成调用函数

() 数组的形式， 也可以是命令集合，与``类似

${}多用于变量的截取 长度 数组的各种操作

 $(()) 多用于整型运算
