---
title: git撤销已经commit的文件
category: git
layout: post
---
* content
{:toc}

比如，git已经commit了两个文件的修改，该commit包含两个文件的修改： A和B。

修改了好几次，最终决定不适用了A， 我们只保留B文件的修改，请问怎么操作？

https://www.cnblogs.com/Sir-Lin/p/7307865.html

# git reset

```bash
# 1
git reset HEAD^ --soft
# 2
git reset HEAD A

# 3
git commit
```

唯一不好的一点就是，git这时候会产生一个新的commit id，如果我们使用gerrit系统的话，可以
提前把之前的 CHange-id抄过来，这样就可以接着使用原先的gerrit提交了。


# git rm

说实话，目前这种我没有尝试过。

```bash
# 1

git rm --cached A

# 2

git commit --amend
```
