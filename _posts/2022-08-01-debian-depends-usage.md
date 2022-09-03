---
title: debian depends的用法
category: debian-riscv
layout: post
---
* content
{:toc}

下面的命令可以展示tmux的具体依赖关系，当然，是以图片的方式展示的。
```bash
sudo apt-rdepends --dotty tmux | dot -Tpng > dependency-tmux-map.png
```