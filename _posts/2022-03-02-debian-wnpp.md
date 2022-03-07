---
title: Debian wnpp入门
category: debian-riscv
layout: post
---
* content
{:toc}

Debian软件众多，难免会出现有些没人维护的包。由此诞生了[wnpp](https://www.debian.org/devel/wnpp/)项目，旨在帮助维护这些 孤儿软件包。

这是另一个[资料](https://wiki.debian.org/WNPP)

# bts

To adopt, you don't submit a new report, but retitle the existing one。
use "bts" from the devscripts package。 bts retitle 993599 'RFA: jimtcl -- small-footprint implementation of Tcl named Jim' , owner it '!'

从以上的文字我们可以看出，如果我们领养一个wnpp下的package，需要使用bts去告知。另外，我也发现一个有用的[材料](https://manpages.ubuntu.com/manpages/xenial/en/man1/bts-retitle.1.html)

我们先来看四个概念:

1. RFP Request for a package

2. RFA Request for adoption of a package

3. ITP Intent to package

4. ITA Intent to adopt a package

```bash
bts-retitle bug-number ITA
```
# reportbug
这是一个软件包： 用来报告bug的，可以直接使用`apt install reportbug`安装。

初次使用的话需要configure.

```bash
vimer@debian:~/maintain_packages/neomutt$ reportbug --email tsu.yubo@gmail.com wnpp
Warning: no reportbug configuration found.  Proceeding in novice mode.
The MTA /usr/sbin/sendmail is not available; exiting.
Please run 'reportbug --configure' or specify a submission method on the command line.
```
初次配置:

```bash
vimer@debian:~/maintain_packages/neomutt$ reportbug --configure
Please choose the default operating mode for reportbug.

1 novice    Offer simple prompts, bypassing technical questions.

2 standard  Offer more extensive prompts, including asking about things that a moderately sophisticated user would be expected to know
            about Debian.

3 advanced  Like standard, but assumes you know a bit more about Debian, including "incoming".

4 expert    Bypass most handholding measures and preliminary triage routines. This mode should not be used by people unfamiliar with
            Debian's policies and operating procedures.

Select mode: [novice]

```
后面接着配置2:

```bash
Will reportbug often have direct Internet access? (You should answer yes to this question unless you know what you are doing and plan to
check whether duplicate reports have been filed via some other channel.) [Y|n|q|?]? y
What real name should be used for sending bug reports?
> neomutt
Which of your email addresses should be used when sending bug reports? (Note that this address will be visible in the bug tracking
system, so you may want to use a webmail address or another address with good spam filtering capabilities.)
[vimer@debian]> tsu.yubo@gmail.com
Do you have a "mail transport agent" (MTA) like Exim, Postfix or SSMTP configured on this computer to send mail to the Internet
[y|N|q|?]? N
Please enter the name of your SMTP host. Usually it's called something like "mail.example.org" or "smtp.example.org". If you need to use
a different port than default, use the <host>:<port> alternative format. Just press ENTER if you don't have one or don't know, and so a
Debian SMTP host will be used.
> smtp.gmail.com:587
If you need to use a user name to send email via "smtp.gmail.com:587" on your computer, please enter that user name. Just press ENTER if
you don't need a user name.
>
Do you want to encrypt the SMTP connection with TLS (only available if the SMTP host supports STARTTLS) [y|N|q|?]? y
Please enter the name of your proxy server. It should only use this parameter if you are behind a firewall. The PROXY argument should be
formatted as a valid HTTP URL, including (if necessary) a port number; for example, http://192.168.1.1:3128/. Just press ENTER if you
don't have one or don't know.
>
Default preferences file written.  To reconfigure, re-run reportbug with the "--configure" option.

```

其实就行文档中:


1. Run reportbug --configure as your normal user. This creates a ~/.reportbugrc file that stores all the configurations.

2. Follow the instructions and when asked Do you have a 'mail transport agent' (MTA) configured, choose No

3. Then enter the SMTP host for gmail: smtp.gmail.com:587

4. For the user name enter: <username>@gmail.com

5. For the question Does your SMTP host require TLS authentication?, choose Yes

这里你可以简单的自己修改`~/.reportbugrc`文件以适应自己的配置。

我们再一次实验:

入口:

```bash
reportbug --email tsu.yubo@gmail.com wnpp
```
log 如下：
```bash
vimer@debian:~/maintain_packages/neomutt$ reportbug --email tsu.yubo@gmail.com wnpp
*** Welcome to reportbug.  Use ? for help at prompts. ***
Note: bug reports are publicly archived (including the email address of the submitter).
Detected character set: UTF-8
Please change your locale if this is incorrect.

Using 'vimer <tsu.yubo@gmail.com>' as your from address.
Will send report to Debian (per lsb_release).
What sort of request is this? (If none of these things mean anything to you, or you are trying to report a bug in an existing package,
please press Enter to exit reportbug.)

1 ITP  This is an `Intent To Package'. Please submit a package description along with copyright and URL in such a report.
2 O    The package has been `Orphaned'. It needs a new maintainer as soon as possible.
3 RFA  This is a `Request for Adoption'. Due to lack of time, resources, interest or something similar, the current maintainer is asking
       for someone else to maintain this package. They will maintain it in the meantime, but perhaps not in the best possible way. In
       short: the package needs a new maintainer.
4 RFH  This is a `Request For Help'. The current maintainer wants to continue to maintain this package, but they need some help to do
       this because their time is limited or the package is quite big and needs several maintainers.
5 RFP  This is a `Request For Package'. You have found an interesting piece of software and would like someone else to maintain it for
       Debian. Please submit a package description along with copyright and URL in such a report.
```