---
layout: post
category: tools
title: "Debian 安装FTP"
---

# 零
    最近又想折腾 LFS，在debian系统上安装了个 VirtualBox,里面也安装了 linxu，突然想到要使用文件传输的功能，最直接的想到了 ftp ，这里简单把安装过程记录一下。
	首先，

	apt-get install vsftpd

	然后配置vsftpd

	vi /etc/vsftpd.conf

	打开后找到anonymous_enable=YES替换成 anonymous_enable=NO

	找到__local_enable=YES__, 将前面的#去掉
	找到 __Write_enable=NO__,将前面的#去掉，改成 YES

	在配置文件的最后一行加上__chroot_local_user=YES

# 一
	接下来创建用户组

	__groupadd ftp__

	创建用户

	__useradd -g ftp -d /xx/xx__

	后面的目录是指定用户登录到哪个目录

	然后输入密码两次

	__passwd user__
   重启 vsftpd服务
   __invoke-rc.d vsftpd restart__
# 实例

    只能下载的anonymous用户和能上传、下载的ftpuser用户
    登录都是进入/var/ftp目录，且无法离开该目录(被chroot）
    ftpuser可以在 /var/ftp/pub目录中建立目录和上传文件
    匿名用户下载限速50kb/s，ftpuser限速500kb/s。
    可联接的最多客户数为100,每ip可联接的最多客户数为5
## /etc/vsftpd.conf
<pre>
# 接受匿名用户
anonymous_enable=YES
# 匿名用户login时不询问口令
no_anon_password=YES
# 接受本地用户
local_enable=YES

# 可以上传(全局控制).若想要匿名用户也可上传则需要设置anon_upload_enable=YES,若想要匿名用户可以建立目录则需要设置anon_mkdir_write_enable=YES.这里禁止匿名用户上传,所以不设置这两项.
write_enable=YES
# 本地用户上传文件的umask
local_umask=022

# 使用上传/下载日志,日志文件默认为/var/log/vsftpd.log,可以通过xferlog_file选项修改
xferlog_enable=YES
# 日志使用标准xferlog格式
xferlog_std_format=YES

# login时的欢迎信息
ftpd_banner=Welcome to KingArthur's FTP service.
# 设置的话将覆盖上面的ftpd_banner设置,用户login时将显示/etc/vsftpd/banner中的内容
banner_file=/etc/vsftpd/banner
# 为YES则进入目录时显示此目录下由message_file选项指定的文本文件(,默认为.message)的内容
dirmessage_enable=YES
# 本地用户login后所在目录,若没有设置此项,则本地用户login后将在他的home目录(/etc/passwd的第六个字段)中.匿名用户的对应选项是anon_root
local_root=/var/ftp

# 设置为YES则下面的控制有效
chroot_list_enable=YES
# 若为NO,则记录在chroot_list_file选项所指定的文件(默认是/etc/vsftpd.chroot_list)中的用户将被chroot在登录后所在目录中,无法离开.如果为YES,则所记录的用户将不被chroot.这里选择YES.
chroot_local_user=YES

# 若设置为YES则记录在userlist_file选项指定文件(默认是/etc/vsftpd.user_list)中的用户将无法login,并且将检察下面的userlist_deny选项
userlist_enable=YES
# 若为NO,则仅接受记录在userlist_file选项指定文件(默认是/etc/vsftpd.user_list)中的用户的login请求.若为YES则不接受这些用户的请求.
userlist_deny=NO
# 注意!!!vsftpd还要检察/etc/vsftpd.ftpusers文件,记录在这个文件中的用户将无法login!!
# 服务器以standalong模式运行,这样可以进行下面的控制
listen=YES
# 匿名用户的传输比率(b/s)
anon_max_rate=51200
# 本地用户的传输比率(b/s)
local_max_rate=512000
# 可接受的最大client数目
max_clients=100
# 每个ip的最大client数目
max_per_ip=5

connect_from_port_20=YES
tcp_wrappers=YES
pam_service_name=vsftpd
</pre>
下面是我的/etc/vsftpd.user_list

	ftpuser
	anonymous

/etc/vsftpd.ftpusers可以使用系统自带的文件 /etc/vsftpd.chroot_list内容为空

## 账号

接着建立系统用户ftpuser,将他加入ftp组并将/etc/passwd中他的记录的最后一个字段改成/sbin/nologin(禁止本地登录). 设置/var/ftp的所有者和所有组为root,权限为755 设置/var/ftp/pub的所有者为root,所有组为ftp,权限为775

如果需要使本地用户ftpput可以login,只需要将他加入/etc/vsftpd.user_list,要使他可以上传,只需将他加入ftp组. 接着我们可以在/var/ftp下的各个目录(包括/var/ftp)下建立.message文件,这样用户进入这个目录时vsftpd将显示. message的内容,你可以在这里面写上欢迎信息或者注意事项等等.另外可以编辑/etc/vsftpd/banner,建立login时的欢迎信息, 让你的ftp更加个性化.


