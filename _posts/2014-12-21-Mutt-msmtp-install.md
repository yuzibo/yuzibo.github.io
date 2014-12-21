---
layput: article
category: linux
tags: email
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

###2.1分步讲解

	MUA：让用户管理，如阅读、储存邮箱里的email，或者通过MSA将新的邮件发出。
	除了在unix上流行的mutt,其他较为流行的MUA还有：

	Other popular MUAs include Thunderbird, Kmail, evolution, Sylpheed,
	mulberry, pegasus, pine, and elm (mutt's predecessor)... 

 2.2	MTA: Mail Transport Agent(SMTP server)	

	MTA的功能是接受、发送email到其他的MTAs，在Internet上，MTAs与MTAs交流使用的是 the Simple Mail Transfer Protocol,简称SMTP.官网上还有很多，自己也没有看懂，先就不写了

	较流行的MTAs有
	exim
	postfix
	sendmail
	qmail

2.3	MDA: Mail Delivery Agent
	MDA的功能是从MTA接收一封email或者发送(过滤)email到用户的邮箱文件夹。

	而MDAs用的较多就是procmail.

2.4	
	MRA: Mail Retrieval Agent(POP/IMAP client)

	MRA的处理对象是POP/IMAP，很多功能和MUAs很象
	如果你能直接使用SHELL-cmd或者mutt直接读取邮件服务器的本地邮件，就
	不需要MRA了。
	我的理解是我们之所以使用MRA是我们能直接使用上面情况的机会很少，更
	多的使用是例如网易的163、126,google的gmail的邮件服务器，那么就需要
	MRA将他们服务器上的邮件转移到你这儿来

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




##安装过程

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

相关内容

从这儿我们可以看出mutt假定我们MTA已经安装，如果你确实已经安装，ok！否则，你要先安装、配置MTA,现在也就是这些，别的我也说不出来太多。

当然，mutt的全局配置文件在/etc/Muttrc中，个人用户的配置文件在用户目录("~/.muttrc" or "~/.mutt/muttrc"),配置文件的内容看不明白啊

	sudo apt-get install msmtp

msmtp 是一款专门负责邮件发送的客户端软件，基于GPL发布，支持TLS/SSL、DNS模式、IPv6、服务器端认证、多用户等特性。
2.
分别在创建/etc/msmtprc(root权限)和～/.msmtprc,内容都可以是下面一样的

	defaults
      	tls on
	tls_starttls on
	tls_trust_file /etc/ssl/certs/ca-certificates.crt

	account default
	host smtp.126.com#这里随意改
	port 25#gmail是587
	auth on
	user username@126.com
	password mypass
	from username@gmail.com
	logfile /var/msmtp.log#设置好位置，要注意文件的权限

这两个配置文件都要注意权限，

	chmod 0600 file

test send email:

	msmtp xx@126.com

Ctrl+D,you will receive a letter later.
##配置mutt
首先查看一下msmtp的安装位置

	which msmtp

编辑mutt的配置文件，～/.muttrc,root edits /etc/Muttrc

	set sendmail="/path/to/msmtp"
	set use_from=yes
	set realname="Your Name"
	set from=you@example.com
	set envelope_from=yes
	set editor="vim"

You can write email used mutt and sending it via msmtp

###test:

	echo "content:123456" | mutt -s "title" -a file yuzibode@126.com

mutt -s: subject

mutt -a: 附件

__注意__,在多个收件人的情况下,以空格键分隔收件人即可.
##Summary:
小结

对于 msmtp 的详细介绍，可以参考 http://msmtp.sourceforge.net/documentation.html 或者 man msmtp。

文档里面提供了配置示例，包括 msmtp 配合 mutt 的配置。

对于 mutt，还有很多需要配置，比如对多个邮件帐号的支持、分类文件夹等，这些会在后面的使用过程中逐渐完善。 



