---
title: mininet基本l命令
category: sdn
layout: post
---
* content
{:toc}

# Mininet命令
1. 输入命令后就会进入Mininet的命令行接口(CLI)
```c
-mininet>
```

2. 退出
输入**quit**或者**exit>>**

3. 清除配置
```c
mininet -c
```

# mn常用命令
1. **help**查看有用的必要信息

2. **node**列出所有由mn部署的网络设备

3. **dump**展示相应的网络设备信息

4. **net**展示相连的网络设备

5. 还可以打开属于其中一个客户端的terminal，比如，如果，你有一个h1,
```c
xterm h1
```

# Mininet拓扑选项

sudo	mn	--topo	single,4
 One	switch	connected	to	4	hosts
sudo	mn	--topo	tree,depth=3,fanout=2
 Tree	of	depth	3,	with	two	children	per	node
sudo	mn	--topo	linear,3
 3	switches,	one	aEer	the	other,	and	one	host	per	switch
下面是一个简单的命令展示:

```c
sudo mn --topo linear,4
*** Creating network
*** Adding controller
*** Adding hosts:
h1 h2 h3 h4
*** Adding switches:
s1 s2 s3 s4
*** Adding links:
(h1, s1) (h2, s2) (h3, s3) (h4, s4) (s2, s1) (s3, s2) (s4, s3)
*** Configuring hosts
h1 h2 h3 h4
*** Starting controller
c0
*** Starting 4 switches
s1 s2 s3 s4 ...
*** Starting CLI:
mininet>
```
基本参考来自这里[here](http://www.i3s.unice.fr/~lopezpac/cours/ArchRes/mininet-part2.pdf)
