---
title: git 使用 vimdiff解决冲突
category: git
layout: post
---
* content
{:toc}

# 冲突的基本概念
随着对git的使用逐渐加重，我发现了一些更有意思的问题，冲突变得更加频繁了，嗯，可以
很好的解决这个问题。

无论什么样的冲突，请记住一个模型，LOACL BASE REMOTE这三个分支，冲突基本就是围绕这三
个分支进行。

# 例子

```git
mkdir git
cd git
git init
vi test.txt // cat test.txt
# cat
# dog
# vimer_dev_tmp
# fix_tmp
```

save file.

```git
vimer@host:~/test/git$ git add test.txt
vimer@host:~/test/git$ git commit -m "Initial commit"
[master （根提交） 30a7bea] Initial commit
 1 file changed, 5 insertions(+)
 create mode 100644 test.txt
vimer@host:~/test/git$ git branch
* master
```
然后checkout fix_dev分支:

```git
vimer@host:~/test/git$ git checkout -b fix_dev
切换到一个新分支 'fix_dev'
vimer@host:~/test/git$ vim test.txt
vimer@host:~/test/git$ # change txt
```
修改 "fix_tmp" 成为"fix_into_master".

```git
vimer@host:~/test/git$ git add test.txt
vimer@host:~/test/git$ git commit -m "change fix_dev into fix_into_master"
[fix_dev 0cbd8fb] change fix_dev into fix_into_master
 1 file changed, 1 insertion(+), 1 deletion(-)
```
txt的内容为:
```bash
vimer@host:~/test/git$ cat test.txt
cat
dog
vimer_dev_tmp
fix_into_master
```
切换到master分支做以下修改:

```git
vimer@host:~/test/git$ git checkout master
切换到分支 'master'
vimer@host:~/test/git$ vim test.txt
vimer@host:~/test/git$ git add test.txt
vimer@host:~/test/git$ git commit -m "change vimer_dev into vimer_master"
[master d31bb54] change vimer_dev into vimer_master
 1 file changed, 1 insertion(+), 1 deletion(-)
```
txt的内容为:

```bash
vimer@host:~/test/git$ cat test.txt
cat
dog
vimer_master
fix_tmp
```

将"vimer_dev_tmp"改成"vimer_master"，下面进行合并:

```git
vimer@host:~/test/git$ git merge fix_dev
自动合并 test.txt
冲突（内容）：合并冲突于 test.txt
自动合并失败，修正冲突然后提交修正的结果。
```
下面可以使用 vimdiff 命令解决这个问题。`git mergetool -t vimdiff`
# vimdiff使用
可以看这个[教程](https://www.rosipov.com/blog/use-vimdiff-as-git-mergetool/)


# 解释

这个解释来自于[SO](https://stackoverflow.com/questions/14904644/how-do-i-use-vimdiff-to-resolve-a-git-merge-conflict).

这四个buffer窗口其实是一个文件的四个不同views. 左上角的那个标有LOCAL tag的是你要打算merge  into的文件：
没有办法截图很麻烦.

```bash
cat
dog
vimer_master
fix_tmp
```

其中，前两行没有颜色标注，说明没有冲突， 因为，我在master分支上使用命令:

```git
git  merge fix_dev
```

那么我master的文件就是LOCAL tag(如果不正确请指正), vimer_dev的文件就是REMOTE tag,位于右上角的窗口，其内容为:

```git
cat
dog
vimer_dev_tmp
fix_into_master
```

而上层中间的窗口则是原来的文件， 也就是两个branch没有改动之前的内容:

```git
cat
dog
vimer_dev_tmp
fix_tmp
```

最下面的窗口叫做MERGED窗口:

```git
cat
dog
<<<<<<< HEAD
vimer_master
fix_tmp
||||||| merged common ancestors
vimer_dev_tmp
fix_tmp
=======
vimer_dev_tmp
fix_into_master
>>>>>>> fix_dev
```
通过前面的分析也了解了，`<<<<<<< HEAD` 与 `|||||||`之间的是目前分支上的内容， master上的。
而`=======`与`>>>>>>>`之间的内容是你要merge分支的内容， 也就是REMOTE窗口的内容，按照本意，
我们应该合并fix_dev分支的内容， 故可以把REMOTE标签之间的内容保留。方法是在MERGED文件中， 手工
删除以上两种标签内的内容及标签。

还可以使用下面的内容，`:diffg RE`

# 手工解决
上面的操作是在 MERGED 文件中使用命令全部保留:

```c
:diffget RE // 或者
:diffg RE  " get from REMOTE
:diffg BA  " get from BASE
:diffg LO  " get from LOCAL
```

关闭所有vim窗口使用`:wqa`.

请忽略我在merge文件时个人的喜好， rebase与merge的用法还是有一点区别的。可以参观这个[the](https://www.freecodecamp.org/news/the-ultimate-guide-to-git-merge-and-git-rebase/)




