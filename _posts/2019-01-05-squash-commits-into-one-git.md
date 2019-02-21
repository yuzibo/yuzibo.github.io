---
title: How to squash commits into one commit
category: git
layout: post
---
* content
{:toc}

# 如何将多个commits合并成一个commit
As an open source code management tool, Git's excellent collaboration features quickly capture the market for code management and become a qualified programmer.
Standard. You can learn this skill from 0. This article is a brief introduction to one of the features: Combine multiple commits into one
Commit.

Git作为一个开源的代码管理工具，其优异的协作特性迅速占领代码管理的市场，并且也成为一个合格程序员的
标配。你可以从0开始学习这个技能，本篇文章就是简单介绍其中的一个特性：将多个commits合并成一个
commit。

# Step 1: choose your starting commit
# 第一步：选择你想合并的开始commit

The first thing to do is to invoke git to start an interactive rebase session:
首先要做的是调用git来启动交互式rebase会话：

```git
git rebase --interactive HEAD^[N]
```

Or, shorter:
或者，简写为：

```git
git rebase -i HEAD^[N]
```
Where N is the number of commits you want to join, starting from the most recent
one. For example, i will show your my `git log` to show how to use it.

这里的N是你想要合并的commit的数量。接下来我将会使用我自己的`git log`进行展示。

```bash
commit 53130bcdf0355382a6edbf7b3f42cfd9bb0ea7f2
Author: Bo Yu <tsu.yubo@gmail.com>
Date:   Wed Feb 20 16:16:42 2019 +0800

    x86: fix warnings from checkpatch
    
    Signed-off-by: Bo Yu <tsu.yubo@gmail.com>

commit 30e75b0d0d04b2eacbdbd7042f993c7e0522eb89
Author: Bo Yu <tsu.yubo@gmail.com>
Date:   Wed Feb 20 16:12:12 2019 +0800

    x86: Add a syscall for task 15
    
    Please consider the patch into v5.0.0-rc7
    
    Signed-off-by: Bo Yu <tsu.yubo@gmail.com>

commit 40e196a906d969fd10d885c692d2674b3d657006
Merge: b5372fe5dc84 1765f5dcd009
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue Feb 19 16:13:19 2019 -0800

    Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
    
    Pull networking fixes from David Miller:
    
     1) Fix suspend and resume in mt76x0u USB driver, from Stanislaw
        Gruszka.
    
     2) Missing memory barriers in xsk, from Magnus Karlsson.
    
     3) rhashtable fixes in mac80211 from Herbert Xu.

```

Now I want to combine 53130b and 30e75b into one commit.
现在我想将 53130b 和  30e75b  合并为一个commit.

In fact, there is one commit only to squash, simple.

```git
git rebase -i 40e196a906d969fd10d885c69
```
小心，这个操作危害性很大，如果有问题，请看最后的提示。

```git
pick 30e75b0d0d04 x86: Add a syscall for task 15
pick 53130bcdf035 x86: fix warnings from checkpatch

# 变基 40e196a906d9..53130bcdf035 到 40e196a906d9（2 个提交）
#
# 命令:
# p, pick = 使用提交
# r, reword = 使用提交，但修改提交说明
# e, edit = 使用提交，但停止以便进行提交修补
# s, squash = 使用提交，但和前一个版本融合
# f, fixup = 类似于 "squash"，但丢弃提交说明日志
# x, exec = 使用 shell 运行命令（此行剩余部分）
# d, drop = 删除提交
#
# 这些行可以被重新排序；它们会被从上至下地执行。
#
#
# 如果您在这里删除一行，对应的提交将会丢失。
#
# 然而，如果您删除全部内容，变基操作将会终止。
#
# 注意空提交已被注释掉

```
注意，将上面第二行日志的`pick 53130bcd`的`pick`改为`s`,然后保存退出。
然后就进行变基了。进行完变基过程，接着又进入了一个vim 日志的系统：
```git
# 这是一个 2 个提交的组合。
# 这是第一个提交说明：

x86: Add a syscall for task 15

Please consider the patch into v5.0.0-rc7

Signed-off-by: Bo Yu <tsu.yubo@gmail.com>

# 这是提交说明 #2：

x86: fix warnings from checkpatch

Signed-off-by: Bo Yu <tsu.yubo@gmail.com>

# 请为您的变更输入提交说明。以 '#' 开始的行将被忽略，而一个空的提交
# 说明将会终止提交。
#
# 日期：  Wed Feb 20 16:12:12 2019 +0800
#
# 交互式变基操作正在进行中；至 40e196a906d9
# 最后的命令已完成（2 条命令被执行）：
#    pick 30e75b0d0d04 x86: Add a syscall for task 15
#    s 53130bcdf035 x86: fix warnings from checkpatch
# 未剩下任何命令。
# 您在执行变基操作时编辑提交。
#
# 要提交的变更：
#	修改：     arch/x86/entry/syscalls/syscall_32.tbl
#	修改：     include/linux/syscalls.h
#	修改：     kernel/sys.c

```
这个时候，就可以把这两个commit合并成一个，使用'#'注释掉相关的语句。
然后保存退出，你在屏幕上就会看到：
```git
git rebase -i 40e196a906d969fd10d885c69
[分离头指针 7947f9d65c6c] x86: Add a syscall for task 15
 Date: Wed Feb 20 16:12:12 2019 +0800
 3 files changed, 14 insertions(+)
成功变基并更新 detached HEAD。
```
### If i have tons of commits to squash, do i have to count them one bu one?
### 如果我有成千上百的commits需要去squah,难道我一个一个去数吗？

No， not at all.You just put `git commit-hash` , which efore the first one you want
to rewrite from.
不，一点也不用，你仅仅把想要合并的那些commits中的第一个commit的hash值写上就行。
<pre>
c    b     a     old
1---->2----->3----->4-----5---->6
</pre>
For instance,a, b,c is the commits you want to squash,so,you just

```git
git rebase --interactive old
```
Remenber, please put a replace with hash-value
例如，上面中的a,b,c是你想要合并的commits，你仅仅把上面命令中的a替换成commit value就行

# Step 2:picking and squashing
# 第二步： picking and squashing

When you type command above,your editor will show up :
当你键入上面的命令，你的编辑器将会展示：

```bash
pick 9d814b2a0e78  fs/proc: fix minor error

#变基  acb685c130ea..9d814b2a0e78 到 acb685c130ea(1个提交)
...
```

Save the file and exit
保存文件并且退出

# Create a new commit
# 第三步： 创建新的commit



# 补救措施
显而易见，git有很多操作容易出错，幸好今天发现了一个神奇的命令;

```git
git reflog 
```
这一个命令就是将你git仓库所有的操作commit id全部记录下来，然后你就可以根据commit id进行恢复工作了。
下面是我的操作：
1. 不知道进行了哪些操作 :(

```bash
yubo@debian:~/git/linux$ git reflog 
27b4ad621e88 HEAD@{0}: reset: moving to HEAD~
5f30dbd7fe76 HEAD@{1}: commit (amend): Merge tag 'acpi-5.0-rc6' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
e2dac603d4bc HEAD@{2}: reset: moving to HEAD^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
c5f1ac5e9afb HEAD@{3}: reset: moving to HEAD^^^^^^^^^^^^^^
85dbfa23f82e HEAD@{4}: reset: moving to HEAD^^^^
32b3093ca1ed HEAD@{5}: reset: moving to HEAD^
a468de868f42 HEAD@{6}: rebase -i (pick): net: dsa: bcm_sf2: Do not assume DSA master supports WoL
32b3093ca1ed HEAD@{7}: rebase -i (pick): net: systemport: Fix reception of BPDUs
f2b85f61b6f4 HEAD@{8}: rebase -i (pick): net: dsa: b53: Properly account for VLAN filtering
60414c196767 HEAD@{9}: rebase -i (pick): net: dsa: b53: Fix default VLAN ID
48696963a47f HEAD@{10}: rebase -i (pick): net: validate untrusted gso packets without csum offload
85dbfa23f82e HEAD@{11}: rebase -i (pick): net: Fix for_each_netdev_feature on Big endian
037bf92757d0 HEAD@{12}: rebase -i (pick): net: phy: xgmiitorgmii: Support generic PHY status read
2a551c4d4c1f HEAD@{13}: rebase -i (pick): net: ip6_gre: initialize erspan_ver just for erspan tunnels
18d06b56da1a HEAD@{14}: rebase -i (pick): mac80211: Restore vif beacon interval if start ap fails
e1b859cae128 HEAD@{15}: rebase -i (pick): mac80211: Free mpath object when rhashtable insertion fails
16a9e78e1fc0 HEAD@{16}: rebase -i (pick): mac80211: Use linked list instead of rhashtable walk for mesh tables
b5372fe5dc84 HEAD@{17}: rebase -i (start): checkout HEAD~3
53130bcdf035 HEAD@{18}: rebase -i (finish): returning to refs/heads/my_work
53130bcdf035 HEAD@{19}: rebase -i (start): checkout 40e196a906d969fd10d885c
53130bcdf035 HEAD@{20}: commit: x86: fix warnings from checkpatch
30e75b0d0d04 HEAD@{21}: commit: x86: Add a syscall for task 15
40e196a906d9 HEAD@{22}: rebase finished: returning to refs/heads/my_work
40e196a906d9 HEAD@{23}: rebase: checkout origin/master
b5372fe5dc84 HEAD@{24}: checkout: moving from master to my_work
...
```
上面倒数第五行才是我前面演示的commit id,知道了这个commit id,

```git
git reset --hard 53130bcdf035
```
则此时：

```git
yubo@debian:~/git/linux$ git log 
commit 53130bcdf0355382a6edbf7b3f42cfd9bb0ea7f2
Author: Bo Yu <tsu.yubo@gmail.com>
Date:   Wed Feb 20 16:16:42 2019 +0800

    x86: fix warnings from checkpatch
    
    Signed-off-by: Bo Yu <tsu.yubo@gmail.com>

commit 30e75b0d0d04b2eacbdbd7042f993c7e0522eb89
Author: Bo Yu <tsu.yubo@gmail.com>
Date:   Wed Feb 20 16:12:12 2019 +0800

    x86: Add a syscall for task 15
    
    Please consider the patch into v5.0.0-rc7
    
    Signed-off-by: Bo Yu <tsu.yubo@gmail.com>

commit 40e196a906d969fd10d885c692d2674b3d657006
Merge: b5372fe5dc84 1765f5dcd009
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue Feb 19 16:13:19 2019 -0800

    Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
    
    Pull networking fixes from David Miller:
    
     1) Fix suspend and resume in mt76x0u USB driver, from Stanislaw
        Gruszka.
    
     2) Missing memory barriers in xsk, from Magnus Karlsson.
    
     3) rhashtable fixes in mac80211 from Herbert Xu.
    
     4) 32-bit MIPS eBPF JIT fixes from Paul Burton.
    
     5) Fix for_each_netdev_feature() on big endian, from Hauke Mehrtens.
    
     6) GSO validation fixes from Willem de Bruijn.
    
     7) Endianness fix for dwmac4 timestamp handling, from Alexandre Torgue.
```
