---
title: "内核代码静态分析工具"
layout: article
category: kernel
---

# 注意

自己在本机的 ~/maintree/linux目录下，已经git remote add linux-next树，只需获得linux-next最新的tags。在创建kernel代码数据库后，使用命令smatch_scripts/test_kernel.sh 就可以产生一个内核的warn.txt文件，这里就是他的分析工具。
