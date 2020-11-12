---
title: git reset 和 reflog用法
category: git
layout: post
---
* content
{:toc}

# git reset

git reset的作用对象就是 .git/refs/head/master, 类似一个游标，可以改变（往前或者往后），

```git
4bb86dd506 (HEAD -> dongchuan_11-11-xiawu) Support compilation 
f632f6757b (origin/d_art, m/d_art, vimer_dev) Merge 
afd74582ac Merge "READ_BARRIER_MARK_REG" into d_art
```
上面的log我做了一些处理，可以有差别的看一下。

git reset 有两种用法:
```git
git reset  --flags paths_file
git reset [--soft | --hard]
```
先来介绍第二种用法。

## --hard

```git
vimer@host:~/src/aosp_art/art$ git reset --hard HEAD^
HEAD 现在位于 f632f6757b Merge "Integration testing of Arithmetic/Condition IR." into d_art
vimer@host:~/src/aosp_art/art$ git log --oneline
f632f6757b (HEAD -> dongchuan_11-11-xiawu, origin/d_art, m/d_art, vimer_dev) Merge "Integration ...." into d_art
afd74582ac Merge "READ_BARRIER_MARK_REG" into d_art
```

这里开始涉及以前没有注意到的知识了， 比如'HEAD^'. `HEAD^`代表了HEAD的父提交，在上面的log日志找中， 我们很容易的知道
4bb86dd506是HEAD，但是呢， 该HEAD是由下面的git log诞生出来的: f632f6757b. 那么， `HEAD^`也就是寻找当前HEAD的父提交。

这个操作的作用是（慎用），直接把版本库、暂存区和工作区的原HEAD指向的commit清除了，假设如果你的commit没有upload到服务器上，
那么，你的原HEAD在本地是找不到了。下面就是使用上述命令后引用里面的值。

```git
cat .git/refs/heads/dongchuan_11-11-xiawu
f632f6757b12a
```

## --soft

`git reset --soft` 只会把引用的HEAD给替换成原来的父id， 不会影响工作区和暂存区的内容， 另外一个意思就是这个操作只会把
版本库的commit重置到HEAD的前一个（HEAD^）。结果如下：

```git
vimer@host:~/src/aosp_art/art$ git status
位于分支 dongchuan_11-11-xiawu
要提交的变更：
  （使用 "git reset HEAD <文件>..." 以取消暂存）

        新文件：   Main.java
```

### git diff HEAD

有时候经常使用`git diff`去展示目前的工作区与版本库之间的差异(肯定不对)， 其实就差了一个HEAD, 加上HEAD标签就是告诉git， 工作区的文件与谁
做对比:

```git
vimer@host:~/src/aosp_art/art$ git diff HEAD
diff --git a/Main.java b/Main.java
new file mode 100644
index 0000000000..7705266642
--- /dev/null
+++ b/Main.java
@@ -0,0 +1,79 @@
+/*
+ * Copyright (C) 2015 The Android Open Source Proje
```

### git  diff

这个命令仅是把工作区和暂存区之间的内容做对比。

## git reset paths

后面的paths就是文件， 这个命令直接将暂存区的内容回退回去。比如上面的提示就只这个意思，

```git
vimer@host:~/src/aosp_art/art$ git reset Main.java
vimer@host:~/src/aosp_art/art$ git status
位于分支 dongchuan_11-11-xiawu
未跟踪的文件:
  （使用 "git add <文件>..." 以包含要提交的内容）
```

# git reflog

这个命令是拯救git误失误的一个利器，之前也听说过，问题还是出现在HEAD或者分支上的理解上。
也就是使用这个命令时， 比如，你前面使用了`git reset --hard`命令，接下来使用这个命令一定
要将二者保持在同一分支上。比如， 文章开始我就使用了`git reset --hard`命令演示。

也就是我的HEAD原本是 4bb86dd506。

```git
vimer@host:~/src/aosp_art/art$ git reflog show dongchuan_11-11-xiawu | head -5
f632f6757b dongchuan_11-11-xiawu@{0}: reset: moving to HEAD^
3459ab0be8 dongchuan_11-11-xiawu@{1}: commit: add java test
f632f6757b dongchuan_11-11-xiawu@{2}: reset: moving to HEAD^
4bb86dd506 dongchuan_11-11-xiawu@{3}: reset: moving to dongchuan_11-11-xiawu@{1}
f632f6757b dongchuan_11-11-xiawu@{4}: reset: moving to HEAD^
```

4bb86dd506在git reflog的展示中位于第4个（从上到下）。我之前的操作是使用checkout, 这个操作的逻辑是产生新的
分支，然后如何如何怎么怎么样。现在可以直接使用`git reset --hard`命令。

```git
vimer@host:~/src/aosp_art/art$ git reflog show dongchuan_11-11-xiawu | head -5
f632f6757b dongchuan_11-11-xiawu@{0}: reset: moving to HEAD^
3459ab0be8 dongchuan_11-11-xiawu@{1}: commit: add java test
f632f6757b dongchuan_11-11-xiawu@{2}: reset: moving to HEAD^
4bb86dd506 dongchuan_11-11-xiawu@{3}: reset: moving to dongchuan_11-11-xiawu@{1}
f632f6757b dongchuan_11-11-xiawu@{4}: reset: moving to HEAD^
vimer@host:~/src/aosp_art/art$ git reset --hard dongchuan_11-11-xiawu@{5}
HEAD 现在位于 4bb86dd506 Support compilation of a method if all of its IRs can be compiled.
```

注意branch名字后的@{n},这个n需要数清 id 从上往下 数位于第几位然后再加1。接着再看一下这个命令:

```git
vimer@host:~/src/aosp_art/art$ git reflog show dongchuan_11-11-xiawu | head -6
4bb86dd506 dongchuan_11-11-xiawu@{0}: reset: moving to dongchuan_11-11-xiawu@{5}
f632f6757b dongchuan_11-11-xiawu@{1}: reset: moving to HEAD^
3459ab0be8 dongchuan_11-11-xiawu@{2}: commit: add java test
f632f6757b dongchuan_11-11-xiawu@{3}: reset: moving to HEAD^
4bb86dd506 dongchuan_11-11-xiawu@{4}: reset: moving to dongchuan_11-11-xiawu@{1}
f632f6757b dongchuan_11-11-xiawu@{5}: reset: moving to HEAD^
```

看，上面的 git reset命令也这么记录进去了。





