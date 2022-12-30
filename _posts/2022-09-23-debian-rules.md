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
指定运行配置项，这也是一个需要注意的地方。

# 特殊变量
[debmake-doc](https://www.debian.org/doc/manuals/debmake-doc/ch05.en.html)
这里有一个更详细的编译顺序。

```bash
The current directory is set as: $(CURDIR)=/path/to/package-version/

DESTDIR=debian/binarypackage/ (single binary package)
DESTDIR=debian/tmp/ (multi binary package)
```
其中的DESTDIR是和Makefile的安装路径一起配合使用的。

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


### override_dh_auto_configure
```c
override_dh_auto_configure:
	# Rebuild ./configure to get build system patches working
	aclocal
	autoconf
	# --with-error-policy=retry-job # Set default job error policy to "retry-job", since it is less confusing and a better default on most machines
	# --enable-sync-on-close # Set SyncOnClose to yes; considered saner on Linux
	# --with-max-log-size=0 # Deactivate CUPS' internal logrotating, as we provide a better one, especially LogLevel debug2 gets usable now
	dh_auto_configure -- \
		$(CUPS_CONFIGURE_DISTRO_OPTIONS) \
		--with-docdir=/usr/share/cups/doc-root \
		--localedir=/usr/share/cups/locale \
                ...
```
这个片段来自[cup](https://sources.debian.org/src/cups/2.4.2-1/debian/rules/?hl=82#L82). 可以重新`configure`,然后重点看下配置项是怎么添加进去的。

### override_dh_auto_build
```bash
override_dh_auto_build:
        dh_auto_build -- "`dpkg-buildflags --export=configure`"
```

### override_dh_auto_install

```bash
override_dh_auto_install:
        make install DESTDIR=debian/dds2tar
```
自定义安装的目录，这里需要看下Makefile的支持情况。

### override_dh_installman

```bash
override_dh_installman:
        rm -rf debian/dds2tar/usr/share/man/man1
        dh_installman
```
适时的调整man手册。

# cases

这里的cases，是指遇到一些较为容易理解，自己之前没有遇到过的规则，现在总结下来，方便后面的使用。
