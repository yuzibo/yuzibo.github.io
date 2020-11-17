---
title: execl之vba编程
category: word
layout: post
---
* content
{:toc}

越来越体会到编程的好处了，真的能够提高工作效率。

# 最基本的代码

是这样，我女友现在需要统计一个复杂的表， 这个sheet3的公式需要在sheet1传过来，我目前还没有掌握更好的方法，只能使用vba对付一下。

## 基本语法

```basic
Sub MyCode()
    Range("p9") = "=COUNT(输入!C112:C166)"
End Sub
```

很简单，以Sub开始， End Sub结尾， 上述的语句就是在这个sheet3上面的P9位置，使用execl自带的COUNT函数，执行的结果就是P9的单元格已经是公式化的，推荐使用这种。

对了，更多的功课请参阅这里[here](https://www.jianshu.com/p/c5c7434712c7)
还有这里[here](https://blog.csdn.net/qq_25245887/article/details/53292915).

上面代码的另一种写法就是

```basic
Sub MyCode()
    Dim loc As String
    loc = "p9"
    Range(loc) = "=COUNT(输入!C112:C166)"
End Sub
```

## 复制一整行的内容

》Rows(10).Select

## debug

```c
Sub MyCode()
    Dim loc As String
    loc = "p9"
    Range(loc) = "=COUNT(输入!C112:C166)"
    
    Dim arr(1 To 9) As String
    arr(1) = "b17"
    arr(2) = "c17"
    arr(3) = "d17"
    arr(4) = "e17"
    arr(5) = "f17"
    arr(6) = "g17"
    arr(7) = "h17"
    arr(8) = "i17"
    arr(9) = "j17"
    
    
    Debug.Print arr(1)
    
End Sub
```

CTRL + G 会打印 "b17"

## code

```c
Please try:
.Range("A:A, C:C, G:G").ColumnWidth = 15
and
.Range("A:C, G:G").Font.Color = vbRed
```


# 综合

```c
Public Function StringFormat(ByVal mask As String, ParamArray tokens()) As String

    Dim i As Long
    For i = LBound(tokens) To UBound(tokens)
        mask = Replace(mask, "{" & i & "}", tokens(i))
    Next
    StringFormat = mask

End Function


Sub MyCode()
    
    
    Dim row_l As String
    row_l = "33" ‘临时存储的位置
    Dim arr(1 To 9) As String
    arr(1) = "b" + row_l
    arr(2) = "c" + row_l
    arr(3) = "d" + row_l
    arr(4) = "e" + row_l
    arr(5) = "f" + row_l
    arr(6) = "g" + row_l
    arr(7) = "h" + row_l
    arr(8) = "i" + row_l
    arr(9) = "j" + row_l
    
    
    
    Debug.Print arr(1) ' debug
    
    Dim loc_s, loc_e As String
    
    loc_s = "D332" '另一个sheet的域
    loc_e = "D378"
    
    Dim fun_total, fun_126, fun_112, fun_98, fun_84, fun_70, fun_56, fun_55, tmp As String
    
    fun_total = "=COUNT(输入!{0}:{1})"
    tmp = StringFormat(fun_total, loc_s, loc_e)
    Range(arr(1)) = tmp
   
    fun_126 = "=COUNTIF(输入!{0}:{1},"">=126"")"
    tmp = StringFormat(fun_126, loc_s, loc_e)
    Range(arr(2)) = tmp
   
    
    fun_112 = "=COUNTIFS(输入!{0}:{1},"">=112"",输入!{2}:{3},""<126"")"
    tmp = StringFormat(fun_112, loc_s, loc_e, loc_s, loc_e)
    Range(arr(3)) = tmp
    
    fun_98 = "=COUNTIFS(输入!{0}:{1},"">=98"",输入!{2}:{3},""<112"")"
    tmp = StringFormat(fun_98, loc_s, loc_e, loc_s, loc_e)
    Range(arr(4)) = tmp
    
    fun_84 = "=COUNTIFS(输入!{0}:{1},"">=84"",输入!{2}:{3},""<98"")"
    tmp = StringFormat(fun_84, loc_s, loc_e, loc_s, loc_e)
    Range(arr(5)) = tmp
    
    fun_70 = "=COUNTIFS(输入!{0}:{1},"">=70"",输入!{2}:{3},""<84"")"
    tmp = StringFormat(fun_70, loc_s, loc_e, loc_s, loc_e)
    Range(arr(6)) = tmp
    
    fun_56 = "=COUNTIFS(输入!{0}:{1},"">=56"",输入!{2}:{3},""<70"")"
    tmp = StringFormat(fun_56, loc_s, loc_e, loc_s, loc_e)
    Range(arr(7)) = tmp
    
    fun_55 = "=COUNTIF(输入!{0}:{1},""<56"")"
    tmp = StringFormat(fun_55, loc_s, loc_e)
    Range(arr(8)) = tmp
    
    
End Sub
```

虽然算出来了各个分段的人数，但是人数比目前还有一点问题， 当前的arr(x)并不能在双引号中使用，
比如这样的:

> =SUM(C24:F24)/B24

