---
title: Debian 开发资源列表
category: debian-riscv
layout: post
---
* content
{:toc}

涉足Debian社区快两周了，也大体上知道了Debian开发的一些流程。但是某些东西还是停留在纸上，所有的东西都要动手去实践。

Debian社区是比较古老的、比较geek的氛围。尤其是，主导这个社区的是一群德国佬(核心开发者，肯定也有其他地区的)，出于语言、
文化等方面的影响，新人尤其是像我这种新手想要融入进去，一开始还是不少受挫折。老板说的对，脸皮厚，三观正就可以了(.

这篇文章的主要目的是把最后在开发过程中遇到的一些有用的资源放在这里以方便自己后面的工作。通过这些文档或者指南，我还是
认为，在软件行业，只有开源开发者或者 "自由职业者"才会打造经典的作品。

# Port riscv 入门级资料
## wiki
1. [debian riscv wiki](https://wiki.debian.org/RISC-V#)
2. [debian cross-compiling](https://wiki.debian.org/CrossCompiling)
3. [debian irc list](https://wiki.debian.org/IRC)

服务器是:`irc.oftc.net`,相关的几个channal:
```bash
#debian-bugs
#debian-buildd: Teams/DebianBuildd
#debian-mentors: Support for new contributors with questions on packaging and Debian infrastructure projects/services. See also the debian-mentors mailing list.
#debian-ports: https://www.ports.debian.org/
#debian-riscv: Debian RISC-V port
#devscripts: devscripts
```
## mail list
### Debian ports
在做debian port时，主要会用到以下两个列表：

debian-riscv@lists.debian.org

debian-cross@lists.debian.org


## FTBFS
以下几个资源是展示的目前Debian包在riscv上编译的情况。

1. [btbfs page](https://udd.debian.org/cgi-bin/ftbfs.cgi?arch=riscv64)
这个页面快速直达目前编译riscv有问题的debian packages list.
2. [The UDD provides an overview about patches that we currently have
pending](https://udd.debian.org/cgi-bin/bts-usertags.cgi?user=debian-riscv@lists.debian.org) 带有patch

# Debian开发者

## 邮件列表

作为Debian的开发者，还需要订阅以下邮件列表:

### [debian-devel-announce](https://lists.debian.org/debian-devel-announce/)

Announcements of development issues like policy changes, important release issues &c.
Only messages signed by a Debian developer will be accepted by this list.

注意，只有DD发的信才有可能被这个列表接受。

### [debian-news](https://lists.debian.org/debian-news/)

General news about the distribution and the project.
The current events and news about Debian are summarized in the Debian Weekly News, a newsletter regularly posted on this list.




# 如何生成patch

[prepare patches for Debian Packages ](https://raphaelhertzog.com/2011/07/04/how-to-prepare-patches-for-debian-packages/)

# [Debian Package Tracking System](https://packages.qa.debian.org/common/index.html)

    The Package Tracking System lets you follow almost everything related to the life of a package. It's of interest for co-maintainers, advanced users, QA members, ...

在这个页面上解释的很清楚，也确实这么做的。但是，我也是在查找某些软件闯进这个网站的，后面补充更高级的用法。



