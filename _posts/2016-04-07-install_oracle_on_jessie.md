---
title: "在jessie上安装oracle"
layout: article
category: oracle
---
# 先期条件


# During install errors

## 
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
