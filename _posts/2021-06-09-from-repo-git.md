---
title: 从repo到git
category: git
layout: post
---
* content
{:toc}

再一次记录下这个操作:

```bash
repo init -u ssh://yubo@10.12.130.33:29418/metis-station/manifest -b metis-dev --repo-url=ssh://yubo@10.12.130.33:29418/tools/git-repo

```
`-b`指定分支， `--repo-url`的参考分支，主要是节约下载宽带流量的。

那么，我从gerrit上的网站看到一个URL:

```bash
http://10.12.130.33/gerrit/c/metis-station/swtest/+/532
```
如果CI工程师告诉你说，使用git clone下，这个 swtest repo, 则需要以下的命令:

```bash
# 1. # clone
git clone ssh://yubo@10.12.130.33:29418/metis-station/swtest/
# 这个时候你只是下载了一个repo，但是需要像 repo init的那样，进入对应的分支。

# 2. checkout
git checkout metis-dev

#3. git pull
git pull
```
剩下的则是git的一些操作。


