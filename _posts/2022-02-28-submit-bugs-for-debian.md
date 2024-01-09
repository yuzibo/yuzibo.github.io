---
title: Debian 缺陷跟踪系统（BTS）
category: debian-riscv
layout: post
---
* content
{:toc}

最权威的莫过于这个[页面](https://www.debian.org/Bugs/#pkgreport).

还可以参考[这个](https://www.mankier.com/1/bts).

当我们比如说，在FTBFS(https://udd.debian.org/cgi-bin/ftbfs.cgi?arch=riscv64)发现一个build fail时，我们想进一步跟进这个fix。那么，可以首先看一下这个 issue number(以[yubiserver](https://buildd.debian.org/status/package.php?p=yubiserver&suite=sid)为例):

我们单击链接进去之后，会在 [Debian Package Auto-Building](https://buildd.debian.org/status/package.php?p=yubiserver&suite=sid)这个页面上看到顶层有这个几个链接:

1. [Tracker](https://tracker.debian.org/pkg/yubiserver)
    这个是有关pkg(package)一个完整的概括，涉及到了该pkg的方方面面：维护者、action、bugs、link等等。如果你想了解另一个package的基本情况，可以在该页面的右上角进行搜索。

2. [Changelog](http://metadata.ftp-master.debian.org/changelogs/main/y/yubiserver/yubiserver_0.6-3.1_changelog)
    这个数据就是从软件包中的 `debian`目录中的Changelog文件得来的，基本可以清楚的了解到这个package的一个完整的life。

3. [bugs](https://bugs.debian.org/cgi-bin/pkgreport.cgi?src=yubiserver)
    这里我们可以看到目前该包的一些bugs情况，当然，这里我们也是可以看见有开发者对build失败做了patch了，那我们就进行测试或者push这个patch往下发展就行了。[#1002079 yubiserver fails to port with riscv](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1002079)

    这里有很多意外的情况，之所以意外是因为，在一般的社区里，我们提交了patch后会有maintainer进行merge或者review建议什么的，但是在这种Debian（非营利性社区）没有利益的OS发行版里面，肯定会有大量的packages没有人进行维护。也就是有些包没人维护了，成了孤儿了。当然，对于这种情况，我也看到了有一种选择是NMU(non-maintain-upload)，这个后面我们再说。

    还有一种就是[MIA](https://wiki.debian.org/Teams/MIA)，当然今天我们的篇幅不是聚焦在这里，这里暂且记录一下后面再新开一篇进行补充。

    <pabs> ideally the maintainer returns to work on them, failing that they will get orphaned and then anyone who wants to fix them can do that. another option is for someone who uses the package and wants to maintain it to "salvage" the package

    <pabs> links related to that: https://wiki.debian.org/Teams/MIA 

    https://wiki.debian.org/qa.debian.org/MIATeam

    https://wiki.debian.org/PackageSalvaging

4. [packages.d.o](https://packages.debian.org/source/sid/yubiserver)
    我们在使用`apt source`命令进行下载代码的任务时，你会发现他其实第一步是下载的`.dsc`文件，那么这个dsc文件在哪里呢？
    答案就是这里，我们可以点进去发现，有一个dsc文件，有一个orig的源代码文件，还有一个debian tar文件，后面我们会说这些文件是怎么来的以及怎么用。

5. [source](https://sources.debian.org/src/yubiserver/0.6-3.1/)
    可以查看在Debian org上的 code。

以上这几个就是我们常见的有关package的资源。

通过以上的分析，不知道大家有没有注意到一个现象： 目前的Debian bug有很多都没有及时推进，其实很可能就是陷入了上面第三条提到的MIA(Missing in action)，这个问题比较棘手。假设你想拯救一个package的话，首先得成为一名DM，所以，还是最快的速度upload自己维护的pkg，让社区开始接受你。



熟悉BTS的话还得需要掌握 `reportbug`工具的使用，这个会单独出一篇文章或者合并到这里面来。可以首先参考[这里](https://itsfoss.com/bug-report-debian/)

但是如果想要维护一个孤儿包的话，需要使用 `bts`命令。

# bts
是的，这里的`bts`是一个命令，Debian people在一开始就想着把所有的东西通过命令行来解决，包括bug tracker system(BTS)

我们先来看一个[bug #993599](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=993599).

message #5

```bash
From: Didier 'OdyX' Raboud <odyx@debian.org>
To: Debian Bug Tracking System <submit@bugs.debian.org>
Subject: O: jimtcl -- small-footprint implementation of Tcl named Jim
Date: Fri, 03 Sep 2021 16:27:34 +0200
```
这个O是odyx根据`reportbug`进行的report,O就是orphened（弃儿）的代表，可以参考[这里](https://www.debian.org/devel/wnpp/):

那么，如果我想收养这个遗弃的package的话，怎么做呢？  使用 `bts`命令:

```bash
vimer@debian:~$ export DEBEMAIL=tsu.yubo@gmail.com
vimer@debian:~$ bts --mutt retitle 993599 'ITA: jimtcl -- small-footprint implementation of Tcl named Jim' , owner 993599 '!'
```
上面那个变量DEBEMAIL必须设置，否则使用`bts --mutt` 无效。这里多说一点，目前针对bts的配置文件(/etc/devscripts.conf and ~/.devscripts)，相关文档不是特别[完善](https://manpages.debian.org/testing/devscripts/bts.1.en.html)，看看这里的后期是不是一个优化的方向。

`bts`这时候就会激活mutt的窗口，我们可以看到bts是向 `control@bugs.debian.org`发信的，其信件的body是

```bash
retitle 993599 ITA: jimtcl -- small-footprint implementation of Tcl named Jim
owner 993599 !
thanks
```
也就是说，我们只需在body中将bts的命令完成即可。当然，这里bts最喜欢的使用MTA，我这里是使用mutt代替的MTA。
等发信完成后，我们稍等几分钟，就会收到如下的subject:

```bash
Processed: retitle 993599 to ITA: jimtcl -- small-footprint implementation of Tcl named Jim, owner 993599
```
我们再具体看一下回的消息:

```bash
from:	Debian Bug Tracking System <owner@bugs.debian.org>
to:	vimer <tsu.yubo@gmail.com>
cc:	tsu.yubo@gmail.com,
wnpp@debian.org
date:	Mar 3, 2022, 5:54 PM
subject:	Processed: retitle 993599 to ITA: jimtcl -- small-footprint implementation of Tcl named Jim, owner 993599

Processing commands for control@bugs.debian.org:

> retitle 993599 ITA: jimtcl -- small-footprint implementation of Tcl named Jim
Bug #993599 [wnpp] O: jimtcl -- small-footprint implementation of Tcl named Jim
Changed Bug title to 'ITA: jimtcl -- small-footprint implementation of Tcl named Jim' from 'O: jimtcl -- small-footprint implementation of Tcl named Jim'.
> owner 993599 !
Bug #993599 [wnpp] ITA: jimtcl -- small-footprint implementation of Tcl named Jim
Owner recorded as vimer <tsu.yubo@gmail.com>.
> thanks
Stopping processing here.

Please contact me if you need assistance.
--
993599: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=993599
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems
```

这个时候我们在[bug=993599](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=993599)上面看到BTS已经更改了jimtcl的owner:

```bash
Owner recorded as vimer <tsu.yubo@gmail.com>. Request was from vimer <tsu.yubo@gmail.com> to control@bugs.debian.org. (Thu, 03 Mar 2022 09:54:03 GMT) (full text, mbox, link).
```
## tags
tags是一类很重要的归属标签，我们应该仔细对待这个。比如说我使用了一个`reportbug --from-buildd=<package>_<version>`报告了一个ftbfs的error：

https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1009969.

但是呢，第一次我使用reportbug上报时出现了几个错误:其中最明显的就是没有tags。下面急需补充tags

```bash
bts --mutt tags 1009969 ftbfs
```
实质性的内容是:
```bash
tags 1009969 + ftbfs
```

官方的wiki是下面的case:

```bash
# same as 'tags 123456 + patch'
          tags 123456 patch

          # same as 'tags 123456 + help security'
          tags 123456 help security

          # add 'fixed' and 'pending' tags
          tags 123456 + fixed pending

          # remove 'unreproducible' tag
          tags 123456 - unreproducible

          # set tags to exactly 'moreinfo' and 'unreproducible'
          tags 123456 = moreinfo unreproducible
	  
	  # remove the moreinfo tag and add a patch tag
	  tags 123456 - moreinfo + patch
```
## found bugnum version
found的作用是指定版本号。
```bash
bts --mutt found 1009969 2.15.0+ds1-10
```
## 删除某tag
To: debian-riscv@lists.debian.org, control <control@bugs.debian.org>
```bash
user debian-riscv@lists.debian.org
usertags 1012107 - riscv64
thanks
```
参考[https://lists.debian.org/debian-riscv/2022/05/msg00092.html](https://lists.debian.org/debian-riscv/2022/05/msg00092.html)

## moreinfo tags

```bash
Cc: 1002553@bugs.debian.org
Subject: Re: firmware-amd-graphics: Memory clock always at 100% (thinkpads w/ryzen 3XXXu)
Date: Fri, 10 Jun 2022 17:57:18 +0200
Control: tag -1 moreinfo
```
这一个用法比较灵活，直接发  `num@b.d.o` 使用 `control`指令，这个指令是添加moreinfo的意思哈。如果想取消的话：

```bash
tags 1012200 - moreinfo
```
这个应该发送给 `control@b.d.o`.  或者:

```bash
From: Nicolas Mora <nicolas@babelouest.org>
To: 1007884@bugs.debian.org
Subject: Bug#1007884: bullseye-pu: package glewlwyd/2.5.2-2+deb11u2
----------------
Control: tags -1 - moreinfo

```

# control@g.d.o
通过上面我们也发现，除了给特定num@bugs.debian.org发送指令外，还可以给`control@bugs.debian.org`邮箱发送指令，比如，我发现一个RFP,
如果想使用ITP去打包，可以直接使用以下命令控制:

```bash
retitle 1020411 ITP: sphinxcontrib-ditaa -- sphinx extension for embedding block diagram using ditaa 
owner 1020411 !
thanks
```
注意的是，ITP后面的":"要空一个格。 retitle最后空一个，不要符号就行。



# reportbug
## reportbug --from-buildd
`reportbug --from-buildd=<package>_<full_version>`

如果发现没有存在的ftbfs,则可以回车键入:

```bash
Briefly describe the problem (max. 100 characters allowed). This will be the bug email subject, so keep the summary as concise as
possible, for example: "fails to send email" or "does not start with -q option specified" (enter Ctrl+c to exit reportbug without
reporting a bug).
> ncl: FTBFS on riscv64
```
然后下面是摘自debian  riscv64 wiki（注意： 必须是new submit bug）,如果是已存在的就不需要user and userlist tag
```bash
To: submit@bugs.debian.org
Subject: foo: FTBFS on riscv64

Package: foo
Version: 1.2.3-4
X-Debbugs-CC: debian-riscv@lists.debian.org
User: debian-riscv@lists.debian.org
Usertags: riscv64
```

## reportbug --t patch
下面记录下upload patch 的操作（前提，不能使用reportbug --mutt选项，否则找不到提交patch的选项；如果使用reportbug，需要配置下.reportbugrc文件）:

首先直接 `reportbug openvswitch`.
```bash
$: reportbug openvswitch
...
Select one of these packages: 12
Please enter the version of the package this report applies to (blank OK)
> 2.15.0+ds1-10 # 接着输入版本号
Will send report to Debian (per lsb_release).
Querying Debian BTS for reports on openvswitch (source)...
2 bug reports found:

Bugs with severity normal
  1) #1008684  openvswitch-switch update leaves interfaces down
  2) #1009969  openvswitch: FTBFS on riscv64
(1-2/2) Is the bug you found listed above [y|N|b|m|r|q|s|f|e|?]? 2
Retrieving report #1009969 from Debian bug tracking system...
What do you want to do now [N|x|o|r|b|e|q|?]? ?
N - (default) Show next message (followup).
x - Provide extra information.
o - Show other bug reports (return to bug listing).
r - Redisplay this message.
b - Launch web browser to read full log.
e - Launch e-mail client to read full log.
q - I'm bored; quit please.
? - Display this help.
What do you want to do now [N|x|o|r|b|e|q|?]? N
What do you want to do now [p|N|x|o|r|b|e|q|?]? o # 选这个才可以找到patch的入口
Bugs with severity normal
  1) #1008684  openvswitch-switch update leaves interfaces down
  2) #1009969  openvswitch: FTBFS on riscv64
  (1-2/2) Is the bug you found listed above [y|N|b|m|r|q|s|f|e|?]? y # 提前新建一个  bugnum
Enter the number of the bug report you want to give more info on,
or press ENTER to exit: #1009969

Please provide a subject for your response.
[Re: openvswitch: FTBFS on riscv64]> patch for riscv64 ftbfs  # subject
Does this bug still exist in version 2.15.0+ds1-10 of this package [y|N|q|?]? y
Rewriting subject to 'openvswitch: patch for riscv64 ftbfs' # 这里是关键，会进入mutt的编辑界面
Spawning sensible-editor...
No changes were made in the editor.
Report will be sent to Debian Bug Tracking System <1009969@bugs.debian.org>
Submit this report on openvswitch (e to edit) [y|n|a|c|E|i|l|m|p|q|d|t|?]? ?
y - Submit the bug report via email.
n - Don't submit the bug report; instead, save it in a temporary file (exits reportbug).
a - Attach a file.
c - Change editor and re-edit.
E - (default) Re-edit the bug report.
i - Include a text file.
l - Pipe the message through the pager.
m - Choose a mailer to edit the report.
p - Print message to stdout.
q - Save it in a temporary file and quit.
d - Detach an attachment file.
t - Add tags.
? - Display this help.
Submit this report on openvswitch (e to edit) [Y|n|a|c|e|i|l|m|p|q|d|t|?]? t
Do any of the following apply to this report?

1 a11y      This bug is relevant to the accessibility of the package.
2 d-i       This bug is relevant to the development of debian-installer.
3 ftbfs     The package fails to build from source.
4 ipv6      This bug affects support for Internet Protocol version 6.
5 l10n      This bug reports a localization/internationalization issue.
6 lfs       This bug affects support for large files (over 2 gigabytes).
7 patch     You are including a patch to fix this problem.
8 upstream  This bug applies to the upstream part of the package.
9 none

Please select tags: (one at a time) [none] 7
- selected: patch
Please select tags: (one at a time) [done]
Report will be sent to Debian Bug Tracking System <1009969@bugs.debian.org>
Submit this report on openvswitch (e to edit) [Y|n|a|c|e|i|l|m|p|q|d|t|?]? ?
Y - (default) Submit the bug report via email.
n - Don't submit the bug report; instead, save it in a temporary file (exits reportbug).
a - Attach a file.
c - Change editor and re-edit.
e - Re-edit the bug report.
i - Include a text file.
l - Pipe the message through the pager.
m - Choose a mailer to edit the report.
p - Print message to stdout.
q - Save it in a temporary file and quit.
d - Detach an attachment file.
t - Add tags.
? - Display this help.
Submit this report on openvswitch (e to edit) [Y|n|a|c|e|i|l|m|p|q|d|t|?]? a
Choose a file to attach: ls
Can't find ls to include!
Choose a file to attach: /home/vimer/patch/fix-ftbfs-riscv64.patch
Report will be sent to Debian Bug Tracking System <1009969@bugs.debian.org>
Attachments:
 /home/vimer/patch/fix-ftbfs-riscv64.patch
Submit this report on openvswitch (e to edit) [Y|n|a|c|e|i|l|m|p|q|d|t|?]? Y
Saving a backup of the report at /tmp/reportbug-openvswitch-backup-20220422221213-1wghelpa
Connecting to smtp.gmail.com:587 via SMTP...

Bug report submitted to: Debian Bug Tracking System <1009969@bugs.debian.org>
Copies sent to:
  Debian Bug Tracking System <1009969@bugs.debian.org>
  Bo YU <tsu.yubo@gmail.com>
Thank you for using reportbug
```
# 深度
The Debian BTS starting point: [https://bugs.debian.org/](https://bugs.debian.org/). From there, there are two pages that will teach you how to communicate with the server: - [https://www.debian.org/Bugs/server-request](https://www.debian.org/Bugs/server-request) and [https://www.debian.org/Bugs/server-control](https://www.debian.org/Bugs/server-control/)

以上片段摘自[here](https://arnaudr.io/2016/10/01/publishing-a-debian-package-mentors-sponsorship/).

## RM packages

如果发现一个package有充足的理由被removed掉，可以发送RM请求让ftp-master帮忙清除掉。样例如下:

```bash
# subject
RM: src:fizmo -- NVIU; replaced by other real packages

Package: ftp.debian.org
Severity: normal

According to [0], the src:fizmo package should be removed from archive
because "fizmo-ncursesw" and "fizmo-console" which provide a virtual fizmo
package. The src:fizmo has RC reportbug[0] and should not fix it again.
Once this once, I will close the [0] also. thanks.
```
其实文件内容说说理由就行。

##  close bug

### done
比如，[https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1011367](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1011367) 是我open的bug,但是途中突然发现，我应该去关闭它，因为暂时没有比较好的解决方案，怎么处理？很简单：发送 email
body to
 
`1011367-done@bugs.debian.org`即可。

更详细的[wiki](https://www.debian.org/Bugs/Developer#closing)

如果修复了，可以在body内使用:

```bash
Version: 22.1.3-1
Tag: fixed
```
进行关闭。 只有 tag 是 fixed 的才可以标注成功。

还有一种的方法也挺好的：

```bash
To: Bo YU <tsu.yubo@gmail.com>, 1016482@bugs.debian.org

# bts-close because of the reason below
close 1016482
thanks
```

### close
```bash
1018685-close@bugs.debian.org
Subject: Bug#1018685: fixed
```
## 关联影响

```bash
To: Debian Bug Tracking System <submit@bugs.debian.org>
Source: gnuradio
Version: 3.10.2.0-1
Severity: important
Tags: ftbfs
X-Debbugs-Cc: zhsj@debian.org
Control: affects -1 src:fmtlib
```
这个bug是说明，
