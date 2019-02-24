---
title: "同步克隆的git仓库"
category: git
layout: post
---
* content
{:toc}

# 为什么
在github上产生[pull-request](http://www.aftermath.cn/2018/06/12/git-push/)请求后，还需要你能够及时的sync原来的仓库，要不然 你克隆的仓库就失去了价值，无法继续进行相应的开发，下面讲讲我的心得.


# step 1 clone你forked的仓库到本地目录
对，当你fork一个仓库后，就会在你的github主页上产生一个你fork的备份。以[这个](https://github.com/netoptimizer/prototype-kernel)为例，单击一下`fork`后，回到你的主页就会显示相应的仓库，这也是你产生`pull request`的第一步。

```git
#1 fork https://github.com/netoptimizer/prototype-kernel on the origin page

git clone https://github.com/yuzibo/prototype-kernel.git

#2 这儿就是你克隆自己fork的仓库

```

# step 2 添加上游的仓库
所谓的上游仓库就是你刚才fork的原来的仓库，添加一个`upstream`的标签，这个就是为了同步用的。

```git
git remote add upstream https://github.com/netoptimizer/prototype-kernel.git
```
接着使用命令：

```git
yubo-2@debian:~/git/yubo-prototype$ git remote -v
origin	https://github.com/yuzibo/prototype-kernel.git (fetch)
origin	https://github.com/yuzibo/prototype-kernel.git (push)
upstream	https://github.com/netoptimizer/prototype-kernel.git (fetch)
upstream	https://github.com/netoptimizer/prototype-kernel.git (push)
```
# step 3 抓取上游仓库
更新上游的最新修改,保存在本地的`upstream/master`分支。
```git
yubo-2@debian:~/git/yubo-prototype$ git fetch upstream
remote: Enumerating objects: 1, done.
remote: Counting objects: 100% (1/1), done.
remote: Total 1 (delta 0), reused 0 (delta 0), pack-reused 0
Unpacking objects: 100% (1/1), done.
From https://github.com/netoptimizer/prototype-kernel
 * [new branch]      master     -> upstream/master
```
# step 4: checkout 到你的mastere分支
```git
git checkout master
```

# step 5: 合并上游内容
从你刚才的`upstream/master`分支合并最新最全的内容到`master`分支，并且不会修改你在`master`分支所做的目录。
```git
yubo-2@debian:~/git/yubo-prototype$ git merge upstream/master
Updating ae6f3eb..a94339c
Fast-forward
kernel/Documentation/bpf/ebpf_maps_types.rst | 4 ++--
  1 file changed, 2 insertions(+), 2 deletions(-)
```

# last step: push your github
你这个时候就可以把上游的变化推进到github账户去了，接下来就可以产生相应的`pull request`了。

```git
git push origin master
```
这里需要注意就是你要推送到哪个分支，这里就是主分支，与产生[pull request](http://www.aftermath.cn/2018/06/12/git-push/)的分支是不一样的，请注意一下.
