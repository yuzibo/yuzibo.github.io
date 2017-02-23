---
title: "linux中关于进程之wait的认识"
layout: article
category: unix
---

这篇文章介绍wait和exit的知识。

*[1.wait](#1)

*[1.1实例](#1.1)

*[2.exit](#2)

*[2.1实例](#2.1)

<h2 id="1">1.wait</h2>

系统调用wait做两件事，首先，wait暂停调用它的进程，直到子进程结束，然后，wait取得子进程结束时传递给exit的值。



