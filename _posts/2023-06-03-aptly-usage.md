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

backup:

```bash
#    aptly issue:
a@debian:~$ aptly snapshot drop yubos-reboostrap-new-20230606
Snapshot `yubos-reboostrap-new-20230606` is published currently:
 * ./sid [amd64, riscv32] publishes {main: [yubos-reboostrap-new-20230606]: Merged from sources: 'yubos-reboostrap-new-20230605', 'yubos-reboostrap-0605-amd64'}
ERROR: unable to drop: snapshot is published

这种情况只能删除 `sid`
a@debian:~$ aptly publish drop sid
Removing /home/a/.aptly/public/dists...
Removing /home/a/.aptly/public/pool...

如果这样的话，可以这样删除：
```
a@debian:~$ aptly publish list
Published repositories:
  * yubos-reboostrap/20230604/sid [amd64, riscv32] publishes {main: [yubos-reboostrap-20230604]: Snapshot from mirror [yubos-reboostrap]: http://127.0.0.1:8000/ rebootstrap}
  * yubos-reboostrap/20230605/sid [amd64, riscv32] publishes {main: [yubos-reboostrap-new-20230605]: Snapshot from local repo [yubos-rebootstrap]}
  * yubos-reboostrap/20230606/sid [amd64, riscv32] publishes {main: [yubos-reboostrap-new-20230606]: Merged from sources: 'yubos-reboostrap-new-20230605', 'yubos-reboostrap-0605-amd64'}
a@debian:~$ aptly publish drop sid yubos-reboostrap/20230606
Removing /home/a/.aptly/public/yubos-reboostrap/20230606/dists...
Removing /home/a/.aptly/public/yubos-reboostrap/20230606/pool...

```

Published repository has been removed successfully.

aptly 的使用
https://www.cnblogs.com/cookie1026/p/17039327.html
...
sudo sbuild-createchroot --debootstrap=mmdebstrap --arch=riscv32   --include=debian-ports-archive-keyring,ca-certificates,apt         --make-sbuild-tarball=/srv/sid-riscv32-sbuild.tgz       sid /tmp/chroots/sid-riscv32-sbuild/ http://vimer.f3322.net:63017/yubos-rebootstrap-exp
mkdir /tmp/chroots/sid-riscv32-sbuild/

...

a@debian:~$ aptly publish drop sid yubos-reboostrap/20230614
Removing /home/a/.aptly/public/yubos-reboostrap/20230614/dists...
Removing /home/a/.aptly/public/yubos-reboostrap/20230614/pool...

Published repository has been removed successfully.
a@debian:~$ aptly snapshot list
List of snapshots:
 * [yubo-base-part-all-exp]: Snapshot from local repo [all-tmp]: all for riscv32 sbuild-creatchroot
 * [yubos-base-all]: Snapshot from local repo [all-tmp]: all for riscv32 sbuild-creatchroot
 * [yubos-base-full-all]: Snapshot from mirror [debian-all]: https://mirror.iscas.ac.cn/debian/ sid
 * [yubos-reboostrap-0608-amd64]: Snapshot from local repo [amd64-tmp]: amd64 for riscv32 sbuild-creatchroot
 * [yubos-reboostrap-20230604]: Snapshot from mirror [yubos-reboostrap]: http://127.0.0.1:8000/ rebootstrap
 * [yubos-reboostrap-exp-20230614]: Merged from sources: 'yubo-base-part-all-exp', 'yubos-reboostrap-rv32-0614-exp'
 * [yubos-reboostrap-new-20230605]: Snapshot from local repo [yubos-rebootstrap]
 * [yubos-reboostrap-rv32-0614-exp]: Snapshot from local repo [yubos-rebootstrap]
 * [yubos-reboostrap-rv32-all-0608]: Merged from sources: 'yubos-reboostrap-new-20230605', 'yubos-base-all'
 * [yubos-rebootstrap-rv32-all-amd64]: Merged from sources: 'yubos-reboostrap-rv32-all-0608', 'yubos-reboostrap-0608-amd64'

To get more information about snapshot, run `aptly snapshot show <name>`.
a@debian:~$ aptly snapshot drop yubos-reboostrap-exp-20230614
Snapshot `yubos-reboostrap-exp-20230614` has been dropped.
a@debian:~$ aptly  snapshot drop yubos-reboostrap-rv32-0614-exp
Snapshot `yubos-reboostrap-rv32-0614-exp` has been dropped.

```

# 使用 aptly 发布仓库的一般流程


aptly 的一些常见操作：    

## repo

```bash
a@debian:~/packages/sail$ aptly repo list
List of local repos:
 * [all-tmp]: all for riscv32 sbuild-creatchroot (packages: 16)
 * [amd64-tmp]: amd64 for riscv32 sbuild-creatchroot (packages: 2)
 * [riscv64-tmp-all]: for Debian sid ROS2 on riscv64 all packages (packages: 87)
 * [riscv64-tmp]: for Debian sid ROS2 on riscv64 (packages: 1022)
 * [sail-tmp]: sail for debian (packages: 36)
 * [yubos-rebootstrap] (packages: 618)
 
 a@debian:~/packages/sail$  aptly repo show sail-tmp
Name: sail-tmp
Comment: sail for debian
Default Distribution: sid
Default Component: main
Number of packages: 36

删除 package
a@debian:~/packages/sail$ aptly repo remove sail-tmp  libsail-ocaml-dev
Loading packages...
[-] libsail-ocaml-dev_0.17.1-1_amd64 removed

添加 package
aptly repo add sail-tmp package-name

aptly是基于 snapshot 发布东西的：
a@debian:~/packages/sail$ aptly snapshot create sail-for-debian-amd64-0228 from repo sail-tmp

Snapshot sail-for-debian-amd64-0228 successfully created.
You can run 'aptly publish snapshot sail-for-debian-amd64-0228' to publish snapshot as Debian repository.

 思路就是基于 repo 进行 package的更新， 通过snapshot进行发布。然后我们看一下 已 public 的snapshot有哪些：
 
 发布 repo
 a@debian:~/packages/sail$ aptly publish snapshot -distribution="sid"  sail-for-debian-amd64-0303 sail-for-debian/20240303
Loading packages...
Generating metadata files and linking package files...
Finalizing metadata files...
Signing file 'Release' with gpg, please enter your passphrase when prompted:
Clearsigning file 'Release' with gpg, please enter your passphrase when prompted:

Snapshot sail-for-debian-amd64-0303 has been successfully published.
Please setup your webserver to serve directory '/home/a/.aptly/public' with autoindexing.
Now you can add following line to apt sources:
  deb http://your-server/sail-for-debian/20240303/ sid main
Don't forget to add your GPG key to apt with apt-key.

You can also use `aptly serve` to publish your repositories over HTTP quickly.

 a@debian:~/packages/sail$ aptly publish list
Published repositories:
  * revyos-11-06/11-06/sid [riscv64] publishes {main: [revyos-ros2]: Merged from sources: 'revyos-ros2-11-6', 'revyos-ros2-11-6-all'}
  * sail-for-debian/20240227/sid [amd64] publishes {main: [sail-for-debian-amd64-0227]: Snapshot from local repo [sail-tmp]: sail for debian}
  * yubos-reboostrap/20230604/sid [amd64, riscv32] publishes {main: [yubos-reboostrap-20230604]: Snapshot from mirror [yubos-reboostrap]: http://127.0.0.1:8000/ rebootstrap}
  * yubos-reboostrap/20230605/sid [amd64, riscv32] publishes {main: [yubos-reboostrap-new-20230605]: Snapshot from local repo [yubos-rebootstrap]}
  * yubos-reboostrap/20230608/sid [amd64, riscv32] publishes {main: [yubos-reboostrap-rv32-all-0608]: Merged from sources: 'yubos-reboostrap-new-20230605', 'yubos-base-all'}
  * yubos-reboostrap/2023060801/sid [amd64, riscv32] publishes {main: [yubos-rebootstrap-rv32-all-amd64]: Merged from sources: 'yubos-reboostrap-rv32-all-0608', 'yubos-reboostrap-0608-amd64'}
  * yubos-reboostrap/20230617/sid [amd64, riscv32] publishes {main: [yubos-reboostrap-exp-20230617]: Merged from sources: 'yubo-base-part-all-exp', 'yubos-reboostrap-rv32-0617-exp'}
  * yubos-reboostrap/base-full-all/sid (origin: Debian) [all] publishes {main: [yubos-base-full-all]: Snapshot from mirror [debian-all]: https://mirror.iscas.ac.cn/debian/ sid}

 ```
 
 然后把 publish的 `ln` 到 server
