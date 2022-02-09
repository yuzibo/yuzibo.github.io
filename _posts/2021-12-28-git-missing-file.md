---
title: git 找回没有add的文件
category: git
layout: post
---
* content
{:toc}

如果我们的code 没有及时git commit,如果你还幸运的话，使用了 git add 命令，可以使用:

```bash
git fsck --lost-found
```

命令找回，然后在  .git/lost-found/other 目录下有一些 commit的id。可以grep下然后重命名得到
想找的那个文件。

注意：  必须在git add命令的前提下，如果这一步你都没做，哈哈哈哈。

[参考](https://www.cnblogs.com/hope-markup/p/6683522.html)