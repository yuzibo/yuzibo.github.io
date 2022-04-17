---
title: debian ftpsync sync debian-port[riscv64] mirror
category: debian-riscv
layout: post
---
* content
{:toc}

为了提高对debian-ports等相关资源的访问速度，在本地sync debian-ports mirror是一个可选项。

# 过程

## 创建环境
```bash
# 添加专属用户
adduser --disabled-password debian_sync
# 创建mirrors目录（ 根据实际需要更改）
mkdir -p /home/debian_sync/mirrors/debian
chown -R debian_sync:debian_sync /home/debian_sync/mirrors
su - debian_sync
```
## 下载脚本
Debian官方提供一个一套sync的脚本，可以使用deb安装。不过，为了自定义方便配置，我们使用git下载脚本。
```bash
git clone git@salsa.debian.org:mirror-team/archvsync.git
```
## 修改配置文件
进入debian_sync 的主目录下， 将archvsync目录下的两个目录copy 到debian_sync下的主目录：
```bash
cp -r archvsync/etc .
cp -r archvsync/bin .
```
`etc`目录是archvsync相关的配置文件，`bin`目录是相关的执行脚本。因为我们sync的是debian-ports，而ftpsync是原生支持ports的sync，所以，我们需要更改下相关的配置。

首先，创建ftpsync-ports.conf文件：
```bash
cp ftpsync.conf  ftpsync-ports.conf
```

接着我们需要配置该文件中的关键信息:
```bash
MIRRORNAME=`hostname -f`
TO="/home/debian_sync/mirrors/debian/"
# MAILTO="$LOGNAME"
# HUB=false

########################################################################
## Connection options
########################################################################

RSYNC_HOST=ftp.de.debian.org
RSYNC_PATH=debian-ports
# RSYNC_USER=
# RSYNC_PASSWORD=

########################################################################
## Mirror information options
########################################################################

# INFO_MAINTAINER="Admins <admins@example.com>, Person <person@example.com>"
# INFO_SPONSOR="Example <https://example.com>"
# INFO_COUNTRY=DE
# INFO_LOCATION="Example"
# INFO_THROUGHPUT=10Gb

########################################################################
## Include and exclude options
########################################################################

ARCH_INCLUDE="pool-riscv64 source"
#ARCH_EXCLUDE="pool-alpha pool-hppa pool-hurd-i386 pool-ia64 pool-m68k pool-powerpc pool-ppc64 pool-sh4 pool-sparc64 pool-x32 pool-kfreebsd-amd64 pool-kfreebsd-i386"

########################################################################
## Log option
########################################################################

# LOGDIR=
```
最主要的就是RSYNC_HOST、RSYNC_PATH及 ARCH_INCLUDE的配置，目前如果按照上面的配置是可以sync mirror的，只不过还是sync的整个debian-ports。因为整个debian-ports的确实有点庞大，如何只sync riscv64的mirror还在进一步探索中，其ARCH_INCLUDE及 ARCH_EXCLUDE就可以做到这一点(目前还没有找到正确的配置)。

## 创建log目录
在主目录下创建log目录：
```bash
mkdir log
```
也就是说，准备完以上条件后，在debian_sync的主目录下，应该最少有`bin`,`etc`和`log`这三个目录。

## 执行
```bash
debian_sync@dev:~$ ./bin/ftpsync sync:archive:ports
```
此时ftpsync就会sync其配置文件指定的镜像站

#  同步
可以使用cron。