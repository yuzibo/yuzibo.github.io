---
title: git在本地追踪新建分支
category: git
layout: post
---
* content
{:toc}

# 场景
在aosp的gerrit中，我们知道有好几百个git repo，这如果在某一阶段需要集中精力
攻克某一个问题(局限在几个repo 中)但是不想影响其他git repo，前几次公司的做法是
直接拉一个分支，注意，这个分支是一个误导词，表面说是分支，其实是一个完整的gerrit
仓库。大 回归主线不容易。

# 解决方案
大神想了一招，就在这几个分支上拉一个真正的分支，后台CMS专家怎么拉的分支我不知道，但是
当服务器上的分支建立完成后,可以依次执行:

1. git fetch
2. git branch -a

你就可以看见 origin/ 下的新的分支:

```bash
* vimer_dev
  zhimo-aosp-d_art
  remotes/m/zhimo-aosp -> origin/zhimo-aosp
  remotes/origin/android-9-dev-v50
  remotes/origin/aosp/android-10.0.0_r20
  remotes/origin/aosp/android-10.0.0_r25
  remotes/origin/aosp/android-10.0.0_r29
  remotes/origin/aosp/android-9.0.0_r20
  remotes/origin/aosp/android-9.0.0_r3
  remotes/origin/master
  remotes/origin/zhimo-aosp
  remotes/origin/zhimo-aosp-d_art
  remotes/origin/zhimo-aosp-d_emu
```
接着：
```bash
vimer@host:~/src/aosp/art$ git branch -t  art_dev   origin/zhimo-aosp-d_art
分支 'art_dev' 设置为跟踪来自 'origin' 的远程分支 'zhimo-aosp-d_art'。
```


