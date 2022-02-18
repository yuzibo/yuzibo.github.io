---
title: Debian riscv社区过去总结及新年goal
category: debian-riscv
layout: post
---
* content
{:toc}

为了提前了解在 基于Debian的发行版上移植riscv软件的流程，以及为了帮助后面的同学快速融入这个社区，故总结以下信息。risc-v(以下简称riscv,暂时没有区分riscv32和riscv64)。  

# 基本情况
## 历史进程
主要根据[debian-riscv@lists.debian.org](https://lists.debian.org/debian-riscv/)搜集而来。
2016年11月份，Debian社区负责RISC-V 64移植的maintainer Manuel A. Fernandez Montecelo以及其他几位团队成员对于“riscv”在Debian上的名字还是有点争论的，期初他们叫lowriscv，想想在2016年，出现这样的情况也是合情合理。在讨论中，出现了RV64G, RV32IMA, RVBE64G和riscv64这样的命名争论，甚至还有人考虑到如何区分riscv的大小端，如 “mips64el’，有人也想通过后缀L(小端)或者B(大端)来区分。直到有个Fedora的家伙跑过来说，截止到2016年11月， Fedora已经移植2/3的packages，这时候争论才停止。类似的事情在Debian社区中较为常见，比如著名的Systemd争论。

Debian社区有一个[想法](https://lists.debian.org/debian-riscv/2017/11/msg00000.html)值得注意：

    In any case, good support for cross-compilation, for packages avoiding dependency cycles, to install packages that are needed only for arch:all(like doc), etc., will benefit RISC-V and other architectures in thefuture.  (And I like the goals of rebootstrap, even in the absence ofRISC-V).

根据我自己的经验，debian package 中的arch字段可以控制deb可以安装到什么机器上，比如arm64, x86_64什么的。但是deb包中的app是如何做到跨平台的，这个需要我接下来探究一下。

(update /2022/02/18): 在我认真看了一下相关文档以及自己摸索，Debian目前可以借助 schroot等手段构建众多ISA的编译环境，相当于独立于host的一个container环境。而这个基本的构建环境，是可以在构建包的时候，指明arch的，比如riscv64。在编译过程中，schroot是可以自动下载当面isa的cross-built 的toolchains的。

回到上面这个问题，deb包支持的arch为all，一般是指配置、doc之类的，其他的比如包含binary的deb包这样去做，难度估计不小。

（时间因素，riscv port to Debian的历史演变后面继续更新）

## 最详细的wiki
该 [wiki](https://wiki.debian.org/RISC-V#) 基本上总结了在Debian上移植riscv的最新状态。

## 目前的最新移植情况
目前的Debian社区官方的软件包大约在22k个左右，[riscv](https://wiki.debian.org/RISC-V#What_are_the_goals_of_this_project_in_particular.3F)已经移植了大约95%，剩下的5%可能是因为[llvm对riscv的支持不够](https://cloud.tencent.com/developer/article/1578935)造成的(2020年)，连带着rust相关的软件编译也受到
一定影响。我需要去了解下目前block riscv移植的重要原因是什么。

# 接下来需要做的
Debian社区有一个[page](https://udd.debian.org/cgi-bin/ftbfs.cgi?arch=riscv64)记录了当前在riscv64"机器"上编译受阻塞的软件，根据上面的wiki去复现编译log，同时向社区report自己的想法，避免做无用功。
除此之外，想要成为一名DD的话，需要从打包者  -> DM -> DD这样rule演进。这就需要自己主动的去维护那些 orphan deb packages。

今年的一个总体目标是：

### Push Debian官方支持riscv64
根据 Debian [ports](https://www.debian.org/ports/)，我们发现Debian官方(2022/02)支持9种arch架构，根据目前riscv64移植的进展，不知道让Debian官方支持应该达到什么条件。肯定的一点是，如果让官方支持，至少进入sid(unstable) release版本，还有多少具体的工作去做还未知。

### 构建Debian官方的ports riscv版本的CI构建质量报告page
这个需要与社区的Helmut与实验室的大力支持下一起去构建与维护。

### 成为Debian的包maintainer，争取DM
只有经历过deb包的maintain，才有机会成为成为DM，甚至DD。

我们目前的工作是宏伟计划的一小部分，对Debian乃至riscv相关的同学可以私聊我，或者直接访问 [plct github](https://github.com/plctlab/PLCT-Weekly/blob/master/PLCT-Roadmap-2022.md).