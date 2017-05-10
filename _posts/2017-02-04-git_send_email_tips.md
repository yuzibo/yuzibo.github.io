---
title: "git send-email使用技巧"
category: git
layout: article
---

# 发送普通文件

git send-email是为了提交patch而产生的，所以，你使用它提交patch会非常容易，那么，如果你想提交普通文件的话，需要使用下面的命令：

```bash
git send-email  --subject="task 08" --force --to=tsu.yubo@gmail.com task08.c
```

这对于非patch而言，还算有效，如果你有其他更有效的方法，欢迎交流。

# thread

在git send-email 发送信件时，会产生一个message-id的东西，你`--in-reply-to`这个message-id则会产生一个非常漂亮的thread。

使用下面的命令：

```bash
git send-email --to=abc@xyz.org --to=tsu.yubo@gmail.com --in-reply-to 70913afdd9ded111a87da52a2c0a66c3c3ebba52.1494013932.git.tsu.yubo@gmail.com 0002-add-foo-file.patch

```

效果：

![little.png](http://yuzibo.qiniudn.com/little.png)


