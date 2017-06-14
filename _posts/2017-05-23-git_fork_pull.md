---
title: "git fork && pull 工作流"
category: git
layout: article
---

# 创造一个Fork

首先在github上创造一个fork，就是在你想要贡献的项目上的右上角，会有一个fork按钮。单击，就将这个项目fork到你的账户上了（fork俗称复制）

然后，你在本地git clone你刚刚fork的项目，记住，是git clone你github上的项目。

```git
git clone https://github.com/yuzibo/neomutt.git
```


比如，我想fork [neomutt](https://github.com/neomutt/neomutt)项目，frok后我的账户下面就会多了这个：[here](https://github.com/yuzibo/neomutt).

# 保持实时更新

当然，你的commit不应该落后于upstream,否则你就会制造conflict.此时你就需要添加上游分支。

```git
git remote add upstream https://github.com/neomutt/neomutt.git
```
然后你就可以证实是否添加了上游分支。

```git
git remote -v
```

无论什么时候做开发工作，你需要将主分支上commit更新过来。

```git
git fetch upstream

#then view all branch

git branch -av
```

现在，切换到你的master分支and合并上游的主分支。

```git
git checkout master

git merge upstream/master

```

# 做你的工作

## 创建一个分支

这个工作有很多的益处，你自己所做的修改在自己的分支上，这样，很容易分离、独自管理，不会出现混乱。master是广播中的北京时间，自己的分支是你我自己手表上的时间，我们调整自己的时间，仅仅而且必须依靠北京时间。

首先，确保你是从master分支创建其他分支，这还是类似于标准北京时间。

```git
git checkout master

#创建一个新分支，名字要自己的
# 或者使用git checkout -b new-fix 命令
git branch new-fix

#切换到你的新分支
git checkout new-fix
```

# 提交pull

## 清除你自己的工作

在你想要提交自己的pull 请求时，或许做一些清理工作以便使上游维护者更容易测试、接受和合并你的工作。

这里，首先，你的更新主分支上的commit。

```git

# first, fetch master(for your master && upstream/master)
git fetch upstream
git checkout master
git merge upstream/master

# Rebase all commits on your branch

git checkout new-fix
git rebase master

```
## 提交

这里假设你了解commit和push的流程，可以参考[这里](http://www.aftermath.cn/GitTest.html)

然后，返回你的github项目，选择你的开发branch。


[参考](https://gist.github.com/Chaser324/ce0505fbed06b947d962)


## 问题

初次使用，难免会出现各种问题，下面是解决方法汇总。

[merge](https://stackoverflow.com/questions/10298291/cannot-push-to-github-keeps-saying-need-merge)








