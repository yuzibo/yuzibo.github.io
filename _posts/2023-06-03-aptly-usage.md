---
title: aptly搭建本地仓库
category: debian
layout: post
---
* content
{:toc}

# import all 包 /aptly/

需要构建2个repo： 1个amd64 (包含fakeroot), 3个all
amd64:  思路： 首先是创建amd64的repo，  then创建快照，最后合并快照。

repo amd64:
```bash
# 1
aptly repo create -architectures amd64 -comment 'for riscv32 sbuild-creatchroot' -component main -distribution sid amd64-tmp
```
Local repo [amd64-tmp]: for riscv32 sbuild-creatchroot successfully added.
You can run 'aptly repo add amd64-tmp ...' to add packages to repository.

```bash
# 2
aptly repo add amd64-tmp tmp/fakeroot_1.31-1.2_amd64.deb

# 3. 从 repo 创建一个snapshot:
 aptly snapshot create yubos-reboostrap-0605-amd64 from repo amd64-tmp
Snapshot yubos-reboostrap-0605-amd64 successfully created.
## You can run 'aptly publish snapshot yubos-reboostrap-0605-amd64' to publish snapshot as Debian repository.
# 4.
aptly snapshot merge yubos-reboostrap-new-20230606 yubos-reboostrap-new-20230605 yubos-reboostrap-0605-amd64
## 必须新建一个 snapshot
# 5.
aptly publish snapshot -distribution="sid" yubos-reboostrap-new-20230606 yubos-reboostrap/20230606
         // yubos-reboostrap-new-20230606 必须是已经存在snapshot, 也就是上一步命令中执行的。
## all snapshot
## aptly publish snapshot --architectures="all" -distribution="sid" yubos-base-all yubos-reboostrap/base-all  //
# 6.
ln -s /home/a/.aptly/public/yubos-reboostrap/20230606/ /srv/ftp.debian.org/root/yubos-rebootstrap-test

```
#  all repo   20230608

```bash
     1.  aptly repo create -architectures all -comment 'all for riscv32 sbuild-creatchroot' -component main -distribution sid all-tmp
     ```
     Local repo [all-tmp]: all for riscv32 sbuild-creatchroot successfully added.
You can run 'aptly repo add all-tmp ...' to add packages to repository.
     ```
    2. add all packages to all-tmp
    3. aptly  snapshot create yubos-base-all from repo all-tmp
    4. aptly snapshot merge yubos-reboostrap-rv32-all-0608 yubos-reboostrap-new-20230605 yubos-base-all
    5. aptly publish snapshot -distribution="sid" yubos-reboostrap-rv32-all-0608 yubos-reboostrap/20230608
    6. ln -s /home/a/.aptly/public/yubos-reboostrap/20230608/ /srv/ftp.debian.org/root/yubos-rebootstrap-test
```