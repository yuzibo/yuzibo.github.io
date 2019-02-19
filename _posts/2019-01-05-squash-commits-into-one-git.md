---
title: How to squash commits into one commit
category: git
layout: post
---
* content
{:toc}

<h1>如何将多个commits合并成一个commit</h1>
As an open source code management tool, Git's excellent collaboration features quickly capture the market for code management and become a qualified programmer.
Standard. You can learn this skill from 0. This article is a brief introduction to one of the features: Combine multiple commits into one
Commit.

Git作为一个开源的代码管理工具，其优异的协作特性迅速占领代码管理的市场，并且也成为一个合格程序员的
标配。你可以从0开始学习这个技能，本篇文章就是简单介绍其中的一个特性：将多个commits合并成一个
commit。

# Step 1: choose your starting commit
# 第一步：选择你想合并的开始commit

The first thing to do is to invoke git to start an interactive rebase session:
首先要做的是调用git来启动交互式rebase会话：

```git
git rebase --interactive HEAD~[N]
```

Or, shorter:
或者，简写为：

```git
git rebase -i HEAD^[N]
```
Where N is the number of commits you want to join, starting from the most recent
one. For example, i will show your my `git log` to show how to use it.

这里的N是你想要合并的commit的数量。接下来我将会使用我自己的`git log`进行展示。

```bash
commit 9d814b2a0e785dc7508b9bb345934d5bc31ed426    ----------newer commit
Author: Bo Yu <tsu.yubo@gmail.com>
Date:   Fri Feb 15 11:16:23 2019 +0800

    fs/proc: fix minor error

    Yes, it will not compile kernel if we don't fix this.

    Signed-off-by: Bo Yu <tsu.yubo@gmail.com>

commit acb685c130ea0347c251da38a367484c0ca78afd    ----------older commit
Author: Bo Yu <tsu.yubo@gmail.com>
Date:   Thu Feb 14 20:46:16 2019 +0800

    Add proc/$PID/id

    The patch for eudyptula task 14

    Signed-off-by: Bo Yu <tsu.yubo@gmail.com>

```

Now I want to combine 9d814b2a and acb685c into one commit.
现在我想将 9d814b2a 和  acb685c  合并为一个commit.

In fact, there is one commit only to squash, simple.

```git
git rebase --interactive HEAD~[2]
```

### If i have tons of commits to squash, do i have to count them one bu one?
### 如果我有成千上百的commits需要去squah,难道我一个一个去数吗？

No， not at all.You just put `git commit-hash` , which efore the first one you want
to rewrite from.
不，一点也不用，你仅仅把想要合并的那些commits中的第一个commit的hash值写上就行。
<pre>
c    b     a     old
1---->2----->3----->4-----5---->6
</pre>
For instance,a, b,c is the commits you want to squash,so,you just

```git
git rebase --interactive old
```
Remenber, please put a replace with hash-value
例如，上面中的a,b,c是你想要合并的commits，你仅仅把上面命令中的a替换成commit value就行

# Step 2:picking and squashing
# 第二步： picking and squashing

When you type command above,your editor will show up :
当你键入上面的命令，你的编辑器将会展示：

```bash
pick 9d814b2a0e78  fs/proc: fix minor error

#变基  acb685c130ea..9d814b2a0e78 到 acb685c130ea(1个提交)
...
```

Save the file and exit
保存文件并且退出

# Create a new commit
# 第三步： 创建新的commit


