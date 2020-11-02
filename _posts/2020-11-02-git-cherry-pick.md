---
title: git cherry-pick的用法
category: git
layout: post
---
* content
{:toc}

# 问题缘由

又解鎖了git新技能， 开心。

事情的缘由是这样的， 目前我们的gerrit是允许别人cherry-pick下来后把自己的改动推送到gerrit上去，这样的一个潜在风险是:
我们需要的gerrit链接(或者说基于的)也会再次被update， 很无语, 下面是复现这个场景:

```git
54ce0be59cb98c3a304e37d300bbcdbce3da54d9 (HEAD -> test) [Do not merge] Test cases for HNewInstance
44cc0c7487b2c5a16ac963ea4e50b8a8eef161c2 Add xx1 support Add xx2 support
3e82976b5856b2617c374e7663cfe40941f42918 Add yyz function
........................................(master, HEAD)
```

也就是说， 我的commit(54ce0b)是基于别人的commit ID(44cc0c和3e8297), 再往下就是已经merge的commit id， 可以不用管了。
我现在的问题是， 比如我的代码在test分支上无问题的，现在呢准备提交，ok，看着一切很简单的样子， git add, commit, push
一气呵成，但是， sorry， 我在gerrit服务器上一看， 别人的gerrit也有update， 最可气的是居然把别人的文件给删除了。

先不说我这种git 操作流程是否不正确，仅就目前的事情来说，必须想出一种方案，解决目前棘手的问题。那么， 我现在能想到的一个方案就是，
我保证代码在 test 分支上没有问题， 然后 移动 到一个刚从master分支上拉出来的新分支，然后在push， 这样子肯定不会影响别人，
关键是怎么做呢？ google了一番， 我的出发点是rebase或者merge啥的， 直到[here](https://mattstauffer.com/blog/how-to-merge-only-specific-commits-from-a-pull-request/)
才算解决问题。

# 解决方案 cherry-pick

针对以上的问题分析， 我们可以得出一个问题抽象模型: 如何将一个分支上的git commit移动到另一个分支上， 从我上面的问题中， 具体一点就是如何将一个分支上的HEAD移动到另一个分支上，
再一般化， 就是如何将一个分支上的任何commit移动到另一个分支上。

## checkout -b 一个新分支( 基于谁)

一般我们都是基于master分支去检出一个新分支， 这样就可以最大程度的较少冲突的可能性。

```git
git checkout master
git checkout -b test_tmp
```

## cherry-pick

然后把你想 移动的  commit的hash值放后面就可以。 

```git
git cherry-pick 54ce0b
```
该commit就会移动到你的分支上了， 对的， 被移动的commit可以位于分支上的任何位置。 我也很纳闷 git cherry-pick是如何知道
local branch的commit信息的。

# 使用情景

通过以上的问题可以发现， cherry-pick很有用， 尤其作为负责人的时候， 比如说， 一个 git pull请求， 如果有bad commit，你
不得不cherry-pick 下， 这也是文中参考资料的使用场景。 

这个时候再回味一下我之前的[fool](http://www.aftermath.cn/2018/05/01/git-cherry-pick/)



