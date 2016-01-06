---
layout: article
title: "Mutt,msmtp,fetchmail,procmail的配合使用"
category: linux
---

想要真正使用mutt，必须详细了解邮件系统的运作机制

首先是安装必须的软件

	sudo apt-get install mutt fetchmail procmail msmtp

2.
邮件接收程序fetchmail和邮件分拣程序procmail后，首先分别创建各自的配置文件$ HOME/.fetchmailrc和$HOME/.procmailrc，这样为的是让我们能独立使用fetchmail和procmail这两个程序 通过pop接收并分拣邮件。

###关于mutt的一点说明

1.邮件处理分为很多部分，这取决于你想如何应用这个邮件系统。

	邮件客户端(MUA),	A mail user agent MUA:
	MUA: Mail User Agent (email client)
	MTA: Mail Transport Agent (SMTP server)

	mutt and SMTP

	MDA: Mail Delivery Agent
	MRA: Mail Retrieval Agent (POP/IMAP client)

在这里，我们使用mutt作为邮件客户端。

###分步讲解
2.1

MUA：让用户管理，如阅读、储存邮箱里的email，或者通过MSA将新的邮件发出。
除了在unix上流行的mutt,其他较为流行的MUA还有：

Other popular MUAs include Thunderbird, Kmail, evolution, Sylpheed,mulberry, pegasus, pine, and elm (mutt''s predecessor)...

2.2

MTA: Mail Transport Agent(SMTP server)

MTA的功能是接受、发送email到其他的MTAs，在Internet上，MTAs与MTAs交流使用的是 the Simple Mail Transfer Protocol,简称SMTP.官网上还有很多，自己也没有看懂，先就不写了

较流行的MTAs有

	exim
	postfix
	sendmail
	qmail

2.3

MDA: Mail Delivery Agent

MDA的功能是从MTA接收一封email或者发送(过滤)email到用户的邮箱文件夹。

而MDAs用的较多就是procmail.

2.4

MRA: Mail Retrieval Agent(POP/IMAP client)

MRA的处理对象是POP/IMAP，很多功能和MUAs很象如果你能直接使用SHELL-cmd或者mutt直接读取邮件服务器的本地邮件，就不需要MRA了。

我的理解是我们之所以使用MRA是我们能直接使用上面情况的机会很少，更多的使用是例如网易的163、126,google的gmail的邮件服务器，那么就需要MRA将他们服务器上的邮件转移到你这儿来

MRA使用较多的是

    fetchmail ( http://fetchmail.berlios.de/)
    getmail ( http://pyropus.ca/software/getmail/)
    retchmail ( http://freecode.com/projects/retchmail)

##注意

在实际应用中，上面的划分存在很多变体，与上面各个子系统的功能会有部分的叠加和交叉，其实，上面的邮件子系统也存在着很多交叉的功能，大家注意区分，毕竟，万变不离其宗。
###参考-----


     http://www.iki.fi/era/procmail/mini-faq.html#appendix-mx
     http://www.feep.net/sendmail/tutorial/intro/MUA-MTA-MDA.html
     http://ebusiness.gbdirect.co.uk/howtos/mail-system.html
     http://twiki.org/cgi-bin/view/Wikilearn/EmailServerSketches
     http://www.tldp.org/HOWTO/Mail-User-HOWTO/
     http://www.netbsd.org/docs/guide/en/chap-mail.html


=====================

前面都是基本知识,废话,下面才是重点

====================

#安装过程
## 安装mutt
建议源码安装，我自己偷懒了直接(先测试 mutt -v,若找不到，可能你的linux发行版没有安装)

	sudo apt-get install mutt

接着	mutt -v会出现


	System: xxx [using ncurses 5.2] [using libiconv 1.7]
	Compile options:
	-DOMAIN
	-DEBUG
	-HOMESPOOL  +USE_SETGID  +USE_DOTLOCK  +DL_STANDALONE
	+USE_FCNTL  -USE_FLOCK
	+USE_POP  +USE_IMAP  -USE_GSS  +USE_SSL  -USE_SASL  -USE_SASL2
	+HAVE_REGCOMP  -USE_GNU_REGEX
	+HAVE_COLOR  +HAVE_START_COLOR  +HAVE_TYPEAHEAD  +HAVE_BKGDSET
	+HAVE_CURS_SET  +HAVE_META  +HAVE_RESIZETERM
	+CRYPT_BACKEND_CLASSIC_PGP  +CRYPT_BACKEND_CLASSIC_SMIME
	-CRYPT_BACKEND_GPGME  -BUFFY_SIZE -EXACT_ADDRESS  -SUN_ATTACHMENT
	+ENABLE_NLS  -LOCALES_HACK  +HAVE_WC_FUNCS  +HAVE_LANGINFO_CODESET		+HAVE_LANGINFO_YESEXPR
	+HAVE_ICONV  -ICONV_NONTRANS  -HAVE_LIBIDN  +HAVE_GETSID			-HAVE_GETADDRINFO
	-ISPELL
	SENDMAIL="/usr/lib/sendmail"
	MAILPATH="/var/mail"
	...
	EXECSHELL="/bin/sh"

我们可以看出mutt的默认发送邮件的程序是 sendmail,下面我们使用msmtp来发送邮件,
(配置文件先不写,在msmtp的后面)
##install msmtp
	sudo apt-get install msmtp

msmtp 是一款专门负责邮件发送的客户端软件，基于GPL发布，支持TLS/SSL、DNS模式、IPv6、服务器端认证、多用户等特性。

创建msmtp的配置文件～/.msmtprc,内容如下:

vim $HOME/.msmtprc

{% highlight bash %}
defaults
tls on
tls_starttls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt

# 126
account default
host smtp.126.com
from yuzibode@126.com
auth on #

port 25
user yuzibode
password xx

logfile /var/msmtp.log


{% endhighlight %}

这个配置文件都要注意权限，

	chmod 0600 $HOME/.msmtprc



在命令行下test send email:

	msmtp xx@126.com

Ctrl+D,you will receive a letter later.

那mutt与msmtp是怎么配合的呢?

##配置mutt
首先查看一下msmtp的安装位置

	which msmtp

编辑mutt的配置文件，～/.muttrc

{% highlight bash %}
#=====================
#关于msmtp的设置

set sendmail=/usr/bin/msmtp
set use_from=yes
set realname="YU Bo"
set from=yuzibode@126.com
set envelope_from=yes
#Update:
here, you have to create serveral files that contain message from 126 and so.
For example, i can create there files orther than dir inbox, sent,
i use inbox restore message.

# received messages-folder
#set spoolfile="/var/spool/mail/yubo"
set spoolfile="~/Mail/inbox" ##It' ok
#====================
#关于信箱的设置
set folder="~/Mail" # E-mail folder
set mbox="~/Mail/seen" # save SEEN message
set record="+sent" #set save sent-mail folder
set postponed="+postponed" # 放草稿
set move=no #移动已读邮件
#====================
#
mailboxes ! +Fetchmail +slrn +mutt
set sort_browser=alpha

##############################
#使用下面的简单配置一定要小心
#只使用这几句简单的就可以把网易邮箱的东西弄到本地来
#set pop_user=yuzibode@126.com
#set pop_pass="xx"
#set pop_host=pops://pop.126.com
#set pop_last=yes
#####################

set editor="vim"

#终端显示的代码
#set charset="utf-8"

#外发邮件使用的编码
#set send_charset="UTF-8"

#auto view html
auto_view text/html


# 回信时之前的引文符号
set indent_str=">"

#macro index,pager I '<shell-escape> fetchmail -v<enter>'

{% endhighlight %}

写好配置文件后,创建一个Mail目录

	mkdir -v $HOME/Mail

其他的子目录和日志文件不用管,我就是因为这个浪费了一天的时间.

You can write email used mutt and sending it via msmtp


	echo "content:123456" | mutt -s "title" -a file yuzibode@126.com

tips:

mutt -s: subject

mutt -a: 附件

__注意__,在多个收件人的情况下,以空格键分隔收件人即可.


对于 msmtp 的详细介绍，可以参考 http://msmtp.sourceforge.net/documentation.html 或者 man msmtp。

文档里面提供了配置示例，包括 msmtp 配合 mutt 的配置。

对于 mutt，还有很多需要配置，比如对多个邮件帐号的支持、分类文件夹等，这些会在后面的使用过程中逐渐完善。

##fetchmail

	sudo apt-get install fetchmail

Fetchmail用于将其它支持pop3的邮件服务器上取回邮件并保存到本地的spool中。它的配置文件为 ~/.fetchmail,在配置好后，还需要在shell的启动脚本里写入启动fetchmail的指令。

.fetchmail文件的内容为：

{% highlight bash %}
#每隔60秒获取新邮件
set daemon 60
poll pop.126.com
with proto POP3
#and options no dns
uidl # 每次只读新的邮件
#protocol POP3
#port 25
user "yuzibode@126.com"
password "xx"
mda "/usr/bin/procmail  -d %T"
ssl
#在服务器上保留
keep
#ssl
set logfile /var/fetchmail.log


{% endhighlight %}

##procmail

	sudo apt-get install procmail

这个文件具体的运行机制我也不是特别的明白,你先照着做吧
{% highlight bash %}
PATH=/bin:/usr/bin:/usr/local/bin
MAILDIR=$HOME/Mail

#DEFAULT=$MAILDIR/inbox
VERBOSE=OFF
LOGFILE=/var/log/procmaillog

:0:
* ^TOmutt-user
mutt
{% endhighlight %}

#最后两个文件的权限最好也要设置为600

将这几个文件弄好后,在命令行下输入

	mutt

接着键入

	!
你可以在shell输入: fetchmail -v

其实刚才set daemon 60就已经弄好了,在mutt的世界里慢慢玩吧!
===================更新==2016-01-03==============
这里,我将fetchnail更换为getmail,非常不错,有一点遗憾就是没有实现将所有的邮箱回收.新增功能[0]签名[1]联系人
===================更新==2016-01-05==============
现在,直接使用mutt内置的imap,话说好用多了.
实现功能,[0]mutt客户端与gamil同步,删写同步;
[1]还要逐步把列表列出来.在认证的界面上,键入"y",就可以打开默认信箱了.同时,自己想要调试mutt时,应该
	mutt -d2

然后在主目录下有个.muttdebug0的文件,所有的调试信息都在这里面.
[3]当你把 linux kernel的邮件列表写上的话,它默认以 cc 的形式,这一点很好,把你的联系人搞全,这样就会突出重点,当别人给你写信的话,就是直接对方的名字
[4]在自己还有弄清楚之前,我发的信件还是保存一下吧


