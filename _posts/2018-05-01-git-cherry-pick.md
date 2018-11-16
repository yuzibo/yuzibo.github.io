---
title: "git cherry-pick usage"
category: git
layout: post
---

* content
{:toc}

I often hear the ``cherry-pick`` usage,but, how to use it?

![2018-05-24-git-cherry-pik.png](http://yuzibo.qiniudn.com/2018-05-24-git-cherry-pik.png)

In Neomutt git repository, i translated zh_CN version on translate branch.If i did not ``checkout -b my_local_branch``.Just not on "translate branch".(Sure, i git clone -b translate url:neomutt-site).

I have finished my work(translate), at last ``git push origin translate``,the result you have seen above. This is help from [Marcel Schilling](https://github.com/mschilli87)

@yuzibo: just cherry-pik cfdf804 ontop of master and force-push to your
translate-branch, this will 'fix' this PR, so you could re-open it:

```git

# clone your fork locally
git clone https://github.com/yuzibo/neomutt.git

# enter it
cd neomutt

# fetch & checkout your broken translate branch
git checkout -b translate_broken origin/translate

# get the main repo as a remote
git remote add main https://github.com/neomutt/neomutt.git

# fetch the latest state of the main repo
git fetch main

# checkout the latest master as base for your new translate branch
git checkout -b translate main/master

# use only the last commit of the broken branch for the new one
git cherry-pick translate_broken

# overwrite you broken remote translate branch with the fixed one
git push --force origin translate
```
