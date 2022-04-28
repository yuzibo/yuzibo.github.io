---
title: Port riscv64 to Debian task list --2022/04
category: debian-riscv
layout: post
---
* content
{:toc}

以下是我push的一些port riscv的情况，方便自己查看。

| 软件名称 | bug url   | 是否有patch | 最新状态 |   说明 |
| -------- | --------- | ----------- | -------- |
| sofia-sip  | [link](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=978498) |  yes           |  apply patch 后可以编译riscv64 deb |需要推动patch merge into ports's repo      |
| [yubiserver](https://udd.debian.org/cgi-bin/ftbfs.cgi?arch=riscv64)     | [link](https://buildd.debian.org/status/package.php?p=yubiserver&suite=sid)     | 无 | 自己可以fix  | |
| tbb | | 无 | 正在生成(02/22) | 无 |

# Goal

## packaging
cargo  popt cron ntp （这些包是请求帮助的）

## 加入一个打包team

nodejs(正在进行)   go   rust

## fix 

fix riscv BTFTS 的packages.

# 周进展
## 03/01-03/04
1. 寻求DD签名；
2. 打包->uploader->DM
3. 对于FTBFS(有patch)的使用MIA手段push。

## 03/07-03/10
1. 领养 jimtcl package，并按照DD的要求整改上传成为maintainer
Update: 已update upstream，但是目前有一个疑惑就是，0.79的patch如何处理:
error log:

```bash
vimer@debian-local:~/git/jimtcl/jimtcl-0.81$ debuild
 dpkg-buildpackage -us -uc -ui --changes-option=-sa
dpkg-buildpackage: info: source package jimtcl
dpkg-buildpackage: info: source version 0.81+dfsg0-1
dpkg-buildpackage: info: source distribution experimental
dpkg-buildpackage: info: source changed by vimer <tsu.yubo@gmail.com>
 dpkg-source --before-build .
dpkg-buildpackage: info: host architecture amd64
 fakeroot debian/rules clean
dh clean
   debian/rules override_dh_auto_clean
make[1]: 进入目录“/home/vimer/git/jimtcl/jimtcl-0.81”
dh_auto_clean
rm -f autosetup/jimsh0.c
rm -f libjim.so*
rm -f tests/exec.tmp1
rm -Rf static/
make[1]: 离开目录“/home/vimer/git/jimtcl/jimtcl-0.81”
   dh_clean
 dpkg-source -b .
dpkg-source: info: using source format '3.0 (quilt)'
dpkg-source: info: building jimtcl using existing ./jimtcl_0.81+dfsg0.orig.tar.gz
dpkg-source: info: using patch list from debian/patches/series
patching file Makefile.in
Hunk #1 FAILED at 177.
1 out of 1 hunk FAILED
dpkg-source: info: the patch has fuzz which is not allowed, or is malformed
dpkg-source: info: if patch '0001-Use-footer-style-none-in-asciidoc-call.patch' is correctly applied by quilt, use 'quilt refresh' to update it
dpkg-source: error: LC_ALL=C patch -t -F 0 -N -p1 -u -V never -E -b -B .pc/0001-Use-footer-style-none-in-asciidoc-call.patch/ --reject-file=- < jimtcl-0.81.orig.1TfyhX/debian/patches/0001-Use-footer-style-none-in-asciidoc-call.patch subprocess returned exit status 1
dpkg-buildpackage: error: dpkg-source -b . subprocess returned exit status 2
debuild: fatal error at line 1182:
dpkg-buildpackage -us -uc -ui --changes-option=-sa failed
```
解决方案就是 refactor it.因为上游已经有了相关的fix，可以去掉。

2. NMU上传一个riscv的package。

## 03/11-03/15
上一周定的任务目前没有完成，低估了成为一个maintainer的难度；NMU如果不是活跃的开发者一般也是拒绝。

研究下，看看如何提供buildd service。

完成一个nodsjs port riscv64.

## 04/20-04/25

计划：

1. 完成 rust-sys-info 的riscv64 ftbtfs: [done] 
   https://salsa.debian.org/rust-team/debcargo-conf/-/merge_requests/295
   
2. adopt https://github.com/nhorman/dropwatch

完成:

[Fix Debian ftbfs issue]
[rust-sys-info] https://salsa.debian.org/rust-team/debcargo-conf/-/merge_requests/295
                      https://salsa.debian.org/rust-team/debcargo-conf/-/merge_requests/296
[openvswitch] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1009969.
[ncl] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1010056
[openmsx] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1010148.
[(re)open upstream issue]
[vscode support riscv64] https://github.com/microsoft/vscode/issues/147751

[rust-fasteval test fail on riscv64] https://github.com/likebike/fasteval/issues/19 

[dealii build fail in riscv64] https://github.com/dealii/dealii/issues/13639

[kexec-tool support riscv64] http://lists.infradead.org/pipermail/kexec/2022-April/024684.html
[rust-sys-info] https://github.com/FillZpp/sys-info-rs/issues/105

## 05/01-05/14

