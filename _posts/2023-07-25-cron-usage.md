---
title: cron 用法
category: tools
layout: post
---
* content
{:toc}

---

在我看来，  cron 用法简洁，比一般的 systemd timer 要简单不少，所以，这里记录下我用  cron 时踩过的坑。

# cron
有2篇比较不多的文章：
1. https://www.cnblogs.com/kaituorensheng/p/4494321.html
2. https://blog.p2hp.com/archives/8033
3. https://www.quora.com/Is-it-possible-to-run-a-cron-job-without-the-root-user-in-Ubuntu-Server
4. 有关shell环境的执行问题，可以看下这个文章：
https://blog.csdn.net/weixin_36343850/article/details/79217611
使用特殊的用户去执行

我目前的环境是升级完系统后，需要在它的  `/etc/crontab` 修改为
SHELL=/bin/bash 

基本上可以通过以上的文章了解到 cron 的一些基本用法，这里只是简单的记录我自己在使用过程的一些心得。

## crontab -l

```bash
vimer@dev:~/check_log$ crontab -l
# 每6个小时的第15min执行一次
# https://www.cnblogs.com/kaituorensheng/p/4494321.html
15,30,45,59 * * * *  /bin/bash /home/vimer/check_log/connect_test.sh > /tmp/test.txt 2>&1
```

其实主要的问题就是 SHELL 环境变量被修改了，直接编辑 `/etc/crontab` 就可以。

https://etherpad.openeuler.org/p/cron_summary