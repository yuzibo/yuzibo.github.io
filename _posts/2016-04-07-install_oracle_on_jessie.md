---
title: "在jessie上安装oracle 11gR2"
layout: article
category: oracle
---
# 先期条件

## apt-get install list
 sudo apt-get install gcc make binutils gawk x11-utils rpm build-essential
 libaio1 libaio-dev libmotif4 libtool expat alien ksh pdksh unixODBC 
 unixODBC-dev sysstat elfutils libelf-dev binutils  lsb-cxx libstdc++5  
 libmotif4 libmotif-common  libstdc++5 libmotif-dev expat pdksh  sysstat 
 libtool  libmotif4 pcb-lesstif libdb4.6 

 <em>没有lesstif2 用 pcb-lesstif代替,libaio1不要用这个上面的，我自己是下的源
 包，而且版本是0.3.109</em>

 在安装过程中，看到提示缺少某个库函数的时候，不要简单的中断退出来，根据问题
 的提示，利用google解决后，再retry下。

## 相关的脚本

 说明：在代码块中你可以看见"`","`"在开始和结尾处，这是一个shell文件，
 在debian上，
 直接使用:

 > sh xx.sh

 就可以使用了。当然，如果你想用手输入的话，找到对应的系统文件，敲进去就是了
 。

 相关脚本放在了[这里](https://github.com/yuzibo/configure_file.git)

### 创建oracle相关的用户

```bash
#!/bin/bash
`
groupadd oinstall;
groupadd dba;
groupadd oper;
useradd -m -s /bin/bash -g oinstall -G dba,oper oracle; #初始群组为 oinstall，有效群组为 dba、oper
passwd oracle; 
`
```
这里一定要有"-m"选项，否则在你安装的过程中以oracle用户无法登入系统。 "-s"是
指定该用户使用的shell，在debian上，当然是bash了。

### 修改内核参数
 
```bash

#!/bin/bash

echo "#">> /etc/sysctl.conf
echo "# Oracle 11gR2 entries">> /etc/sysctl.conf
echo "fs.aio-max-nr=1048576" >> /etc/sysctl.conf
echo "fs.file-max=6815744" >> /etc/sysctl.conf
echo "kernel.shmall=2097152" >> /etc/sysctl.conf
echo "kernel.shmmni=4096" >> /etc/sysctl.conf
echo "kernel.sem=250 32000 100 128" >> /etc/sysctl.conf
echo "net.ipv4.ip_local_port_range=9000 65500" >> /etc/sysctl.conf
echo "net.core.rmem_default=262144" >> /etc/sysctl.conf
echo "net.core.rmem_max=4194304" >> /etc/sysctl.conf
echo "net.core.wmem_default=262144" >> /etc/sysctl.conf
echo "net.core.wmem_max=1048586" >> /etc/sysctl.conf 
echo "kernel.shmmax=1073741824" >> /etc/sysctl.conf


sysctl -p

```
注意最后一个命令，这里是立即生效刚刚修改过的系统文件。同样，该命令我也放在了
脚本中，请注意。
在安装的过程中，有一步是检查所有的先决条件是否满足，有一个地方会说

>kernel.sem fixable

我在别的地方看见说这个警告没有影响，直到现在，我也是忽略它了，不知道有没有风
险。



### 修改系统限制

```bash

#!/bin/bash
`
cp /etc/security/limits.conf /etc/security/limits.conf.original
echo "#Oracle 11gR2 shell limits:">>/etc/security/limits.conf
echo "oracle soft nproc 2048">>/etc/security/limits.conf
echo "oracle hard nproc 16384">>/etc/security/limits.conf
echo "oracle soft nofile 1024">>/etc/security/limits.conf
echo "oracle hard nofile 65536">>/etc/security/limits.conf
`

```

### 创建安装目录

```bash

mkdir /opt/oracle;
chown oracle:oinstall /opt/oracle;
chmod 755 /opt/oracle;

mkdir /opt/oraInventory;
chown oracle:oinstall /opt/oraInventory;
chmod 755 /opt/oraInventory;
```
这个脚本创建oracle的安装目录。

### 确保用户oracle对解压的oracle安装包的权限


```bash
<BS>chmod -R 700 /home/oracle/database;
chown -R oracle:oinstall /home/oracle/database;
```

database就是将oracle的两个安装包解压后的数据包。oracle安装包[下载](http://pan.baidu.com/s/1eS36gfC)
===========================退出root，oracle用户登录===================

### 设置oracle用户的登录环境

在/home/oracle下，新建.bash_profile或者使用.bashrc,输入以下内容:

```bash
ORACLE_BASE=/opt/oracle; #安装目录
ORACLE_HOME=$ORACLE_BASE/11g; #oracle家目录
ORACLE_SID=orcl; #实例名
LD_LIBRARY_PATH=$ORACLE_HOME/lib;
PATH=$PATH:$ORACLE_HOME/bin:$HOME/bin;
export ORACLE_BASE ORACLE_HOME ORACLE_SID LD_LIBRARY_PATH PATH;

```
最后在每个环境变量后面使用export xx的方式分别导出，这样好像才可靠。

最后使用：

>source .bash_profile

使之生效。

### 安装开始

以oracle身份安装

>sh /../../datebase/runInstaller 

就进入了安装界面

# During install errors


## undefined reference to __stack_chk_fail@GLIBC_2.4

'l take error during installing Oracle 11g on Debian 8 (jessie).
Can't install 'proc' and many other "agents" (during linked libs). 
I take errors like: 
libaio.so.1 undefined reference to __stack_chk_fail@GLIBC_2.4 

解决方案寻找比较低版本的libaio库函数，默认是0.3.110，我下了.0.3.109的deb包


# B_DestroyKeyObject

```c
Edit : sysman/lib/ins_emagent.mk 

replace:
$(SYSMANBIN)emdctl:
        $(MK_EMAGENT_NMECTL)
with:
$(SYSMANBIN)emdctl:
        $(MK_EMAGENT_NMECTL) -lnnz11
```

上面是arbrc number "11".
[reference](http://www.manu.ms/Oracle/libro01_en.html)

# 安装后的首次使用
先用dbstart命令打开oracle，后使用sqlplus使用oracle

### 可以lsnrctl stsrt启动listener服务，但是使用dbstart时报错

>Failed to auto-start Oracle Net Listene using $ORACLE_HOME_LISTNER/bin/tnslsnr

返回结果:
  if [ -f $ORACLE_HOME_LISTNER/bin/tnslsnr ] ; then
    echo "Failed to auto-start Oracle Net Listene using $ORACLE_HOME_LISTNER/bin/tnslsnr"

看来可能是ORACLE_HOME_LISTNER环境变量引起的，查找 ORACLE_HOME_LISTNER

grep ORACLE_HOME_LISTNER dbstart

返回结果
# 3) Set ORACLE_HOME_LISTNER
ORACLE_HOME_LISTNER=/ade/vikrkuma_new/oracle
if [ ! $ORACLE_HOME_LISTNER ] ; then
  echo "ORACLE_HOME_LISTNER is not SET, unable to auto-start Oracle Net Listener"
  LOG=$ORACLE_HOME_LISTNER/listener.log
  if [ -f $ORACLE_HOME_LISTNER/bin/tnslsnr ] ; then
    $ORACLE_HOME_LISTNER/bin/lsnrctl start >> $LOG 2>&1 &

	...

其中有一段给ORACLE_HOME_LISTNER环境变量赋值，但是这个路径是不对的，编辑dbstart文件
vi dbstar
将该行改为export ORACLE_HOME_LISTNER=$ORACLE_HOME
保存退出，然后执行dbstart就没问题了。呵呵

# 启动oracle
首先使用oracle用户，

>sqlplus / as sysdba

进入之后使用

>startup

```c
SQL> startup
ORACLE instance started.

Total System Global Area  836976640 bytes
Fixed Size		    1339740 bytes
Variable Size		  545263268 bytes
Database Buffers	  285212672 bytes
Redo Buffers		    5160960 bytes
Database mounted.
Database opened.
SQL> 
```

想要关闭的话，使用

>shutdown immediate

```c
SQL> shutdown immediate;
Database closed.
Database dismounted.
ORACLE instance shut down.
SQL> 

```
# 检查Oracle DB监听器是否正常

>lsnrctl status

```c
oracle@debian:/opt/oracle/11g/bin$ lsnrctl status

LSNRCTL for Linux: Version 11.2.0.1.0 - Production on 07-APR-2016 01:15:40

Copyright (c) 1991, 2009, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=EXTPROC1521)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 11.2.0.1.0 - Production
Start Date                07-APR-2016 00:25:08
Uptime                    0 days 0 hr. 50 min. 32 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/oracle/11g/network/admin/listener.ora
Listener Log File         /opt/oracle/diag/tnslsnr/debian/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=EXTPROC1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=debian.debian)(PORT=1521)))
The listener supports no services
The command completed successfully
oracle@debian:/opt/oracle/11g/bin$ 
```
## 启动监听器

>lsnrctl start

## 关闭监听器
>lsnrctl stop

SQL> conn sys@orcl as sysdba
然后输入密码，sys以sysdba身份登入数据库

# 开启emctl
我在想这是不是一个网页版的数据库管理工具，我的浏览器暂时无法访问它所提供的
地址，telnet也打不通，我怀疑是防火墙的问题，先记下来，后来总结

```c
racle@debian:/opt/oracle/11g/bin$ emctl start dbconsole
Oracle Enterprise Manager 11g Database Control Release 11.2.0.1.0 
Copyright (c) 1996, 2009 Oracle Corporation.  All rights reserved.
https://debian.debian:1158/em/console/aboutApplication
Starting Oracle Enterprise Manager 11g Database Control ............... started. 
------------------------------------------------------------------
Logs are generated in directory /opt/oracle/11g/debian.debian_orcl/sysman/log 
oracle@debian:/opt/oracle/11g/bin$ 
```
目前我还无法访问。

# Oracle启动和停止脚本

1. 修改oracle系统配置文件：/etc/oratab,只用这样，oracle自带的dbstart和dbshut
才能起作用。
将最后一行的数据库的"N"改为"Y"
