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

# backup
下面是当时的一些印迹，故放在这里以防万一哪天会用到的:

```bash
1.
sudo sbuild-createchroot --debootstrap=mmdebstrap --arch=riscv32  \
 --include=debian-ports-archive-keyring,ca-certificates,apt       \
 --make-sbuild-tarball=/srv/sid-riscv32-sbuild.tgz    \
sid /tmp/chroots/sid-riscv32-sbuild/ \
 http://vimer.f3322.net:63017/yubos-rebootstrap-repo/

// 可以更换 yubos-repo
2. 
sudo sbuild-shell sid-riscv32-sbuild
echo "deb [trusted=yes] http://vimer.f3322.net:63017/yubos-rebootstrap-repo/ sid main" > 
/etc/apt/sources.list

echo "deb [trusted=yes] http://vimer.f3322.net:63017/yubos-base-all/ sid main"   > 
/etc/apt/sources.list
````
3. amd64 for yubos:
    ```
   // 首先创建 amd64
    sudo sbuild-createchroot --debootstrap=mmdebstrap --arch=amd64      \
       --include=debian-ports-archive-keyring,ca-certificates        \
         --make-sbuild-tarball=/srv/sid-amd64-sbuild.tgz     \
             sid /tmp/chroots/sid-amd64-sbuild/ \
              https://mirror.iscas.ac.cn/debian/
    //更换 rootfs
    sudo mmdebstrap --arch=amd64 --variant=buildd  \
     --include=fakeroot,build-essential,ca-certificates,apt-transport-https,eatmydata  \
      sid sid-amd64-yubos-sbuild.tar.xz  \
       "deb [trusted=yes] http://home.revy.cn:36013/yubos-base/ sid main " \
    "deb [trusted=yes] http://vimer.f3322.net:63017/yubos-base-all/ sid main"
    //
    sudo mv sid-amd64-yubos-sbuild.tar.xz /srv
    //
    
    ```
    
```