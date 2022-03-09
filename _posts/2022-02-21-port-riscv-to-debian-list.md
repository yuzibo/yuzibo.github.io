---
title: Port riscv64 to Debian task list --2022/03/10
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

2. NMU上传一个riscv的package。