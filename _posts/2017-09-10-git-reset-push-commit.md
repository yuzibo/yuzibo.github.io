---
title: "git撤销已经push到远端的commit"
category: git
layout: post
---

* content
{:toc}

# question

If you have pushed commit into remote,how to reset it?
Yes, from literly you know i means.

# ways

```git
git reset --soft <版本号>
```


Notes: ``--soft`` rollback verison before, but it retains the modifies for the local work, then restart push it.

``--hard`` discards the modify.

```git
git push origin <branch-name> --force
```

If you use the command without ```--force```, it will reject.Forcing to over cover remote branch.

Done.
