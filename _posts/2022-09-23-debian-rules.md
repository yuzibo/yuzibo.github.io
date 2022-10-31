---
title: Debian rules 文件解析
category: debian-riscv
layout: post
---
* content
{:toc}

debian/rules文件是debian打包脚本中的核心文件，规定了debian对upstream 项目进行配置、编译、安装一系列的动作。下面，主要是通过code example来学习下众多的rule case.

# 一般解析

```bash
export PYBUILD_NAME=tpm2-pkcs11-tools
export PYBUILD_DIR=$(CURDIR)/tools

D=$(CURDIR)/debian
D_PY=$D/python3-tpm2-pkcs11-tools
D_TOOLS=$D/libtpm2-pkcs11-tools

export DEB_LDFLAGS_MAINT_APPEND=-Wl,-z,now

override_dh_auto_configure:
        dh_auto_configure -- --enable-unit

override_dh_auto_build-indep:
        dh_auto_build --buildsystem pybuild

override_dh_auto_install-indep:
        dh_auto_install --buildsystem pybuild
        mkdir -p -- '${D_TOOLS}/usr/bin'
        mv -- '${D_PY}/usr/bin/tpm2_ptool' '${D_TOOLS}/usr/bin/'
        rmdir -- '${D_PY}/usr/bin'
%:
        dh $@ --exclude=.la --exclude=.pc

```
其中， $(CURDIR)默认是Debian的临时编译文件存放的目录，这里可以灵活修改自己想要掌控的目录。
全局的针对编译系统的一个变量是`DEB_LDFLAGS_MAINT_APPEND`,或者还有`CFLAGS`，这里有一个wiki专门介绍了这点。

```bash
override_dh_auto_configure:
        dh_auto_configure -- --enable-unit
```
指定运行测试单元，这也是一个需要注意的地方。

# 特殊变量
[debmake-doc](https://www.debian.org/doc/manuals/debmake-doc/ch05.en.html)
这里有一个更详细的编译顺序。

```bash
The current directory is set as: $(CURDIR)=/path/to/package-version/

DESTDIR=debian/binarypackage/ (single binary package)
DESTDIR=debian/tmp/ (multi binary package)
```

## dh
dh是一个来自debhelper包的辅助命令，如下：

```bash
dh clean : clean files in the source tree.
dh build : build the source tree
dh build-arch : build the source tree for architecture dependent packages
dh build-indep : build the source tree for architecture independent packages
dh install : install the binary files to $(DESTDIR)
dh install-arch : install the binary files to $(DESTDIR) for architecture dependent packages
dh install-indep : install the binary files to $(DESTDIR) for architecture independent packages
dh binary : generate the deb file
dh binary-arch : generate the deb file for architecture dependent packages
dh binary-indep : generate the deb file for architecture independent packages
```

备注： For debhelper “compat >= 9”, the dh command exports compiler flags (CFLAGS, CXXFLAGS, FFLAGS, CPPFLAGS and LDFLAGS) with values as returned by dpkg-buildflags if they are not set previously. (The dh command calls set_buildflags defined in the Debian::Debhelper::Dh_Lib module.)

# test

1. https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1021936 [kopanocore patch]
2.  https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1010807#25 [isc-dhcp update]
3.  https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1022270 [QA] [RC] [RFS ladvd]
4. https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1022540 [build-essential patch]
5. https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1022757[RM src: fizmo]
6.  https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1022808 [NMU RC srg]
7. https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1021619 [lazy-loader done]