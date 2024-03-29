---
title: Learn from Debian mail list 
category: debian-riscv
layout: post
---
* content
{:toc}

Debian mail list有一些很好的学习资源，目前临时记录下来以作进一步的学习。

#  Update to debhelper-compat 13
```bash
Subject: [PATCH 2/5] Update to debhelper-compat 13.

---
 debian/compat  | 1 -
 debian/control | 2 +-
 debian/rules   | 9 ++++++++-
 3 files changed, 9 insertions(+), 3 deletions(-)
 delete mode 100644 debian/compat

diff --git a/debian/compat b/debian/compat
deleted file mode 100644
index 45a4fb7..0000000
--- a/debian/compat
+++ /dev/null
@@ -1 +0,0 @@
-8
diff --git a/debian/control b/debian/control
index 702a8fb..f8abb4d 100644
--- a/debian/control
+++ b/debian/control
@@ -3,7 +3,7 @@ Section: net
 Priority: optional
 Maintainer: Debian QA Group <packages@qa.debian.org>
 Homepage: http://sourceforge.net/projects/bbom/
-Build-Depends: debhelper (>= 8.0.0), pkg-config, libgtk2.0-dev, libcurl4-gnutls-dev, autotools-dev
+Build-Depends: debhelper-compat (= 13), pkg-config, libgtk2.0-dev, libcurl4-gnutls-dev
 Standards-Version: 3.9.3

 Package: bitstormlite
diff --git a/debian/rules b/debian/rules
index 9109369..eb91fdd 100755
--- a/debian/rules
+++ b/debian/rules
@@ -1,4 +1,11 @@
 #!/usr/bin/make -f

+export DEB_BUILD_MAINT_OPTIONS=hardening=+all,-format
+
 %:
-       dh $@ --with autotools_dev
+       dh $@
+
+override_dh_autoreconf:
+
+override_dh_auto_configure:
+       ./configure --build=$(DEB_HOST_MULTIARCH) --prefix=/usr --includedir=\${prefix}/include --mandir=\${prefix}/share/man --infodir=\${prefix}/share/info --sysconfdir=/etc --localstatedir=/var --disable-option-checking --disable-silent-rules --libdir=\${prefix}/lib/$(DEB_HOST_MULTIARCH) --disable-maintainer-mode --disable-dependency-tracking

```

# 打包 -dev 的 gudui

Hi,

I can sponsor this.

A few remarks, aside from the keyring change mentioned by Michel:

- all the doc build-dependencies (asciidoc, doxygen, help2man) can be
marked with <!nodoc> so that nodoc builds can be done
- are curl and fakechroot really needed to build the package, or are
they just used by self tests? if they are used only by tests, mark them
as <!nocheck>
- is pkgconf really needed instead of pkgconfig, which is the default?
- you need to add a libalpm-dev and ship the headers, pkgconfig file,
unversioned .so and manpage in it, instead of in libalpm13, and remove
the lintian override
- libalpm13 is missing Pre-Depends: ${misc:Pre-Depends}
- no need to specify the libarchive-tools and libgpgme11 dependencies
on libalpm13, they will be autogenerated
- does libalpm13 really need to depend on the binary curl executable?
- makepkg should not depend on build-essential nor on sudo
- no need to manually specify the dependency on libalpm13 in makepkg,
it will be autogenerated
- libalpm13 is missing the symbols file, you can generate it after
building the library with:
   dpkg-gensymbols -plibalpm13 -edebian/tmp/usr/lib/x86_64-linux-gnu/libalpm.so.13.0.1 -Odebian/libalpm13.symbols
- makepkg is missing a dependency on ${perl:Depends}
- are you sure all of these can run on GNU/Hurd and debian/kFreeBSD? If
not, use 'linux-any' instead of 'any' as the architecture
- it is not necessary anymore to specify the build system in
debian/rules, meson is autodetected
- use execute_before_dh_auto_clean instead of override_
- 228 tests fail when running in a pbuilder chroot, this is a strong
hint that the build might fail once uploaded
- you should try and fix the reproducible build, rather than disabling
it in the CI
- the GPL-2+ in debian/copyright says in the last paragraph:
   "On Debian systems, the full text of the GNU General Public
    License version 3 can be found in the file"
  instead of version 2

具体可以看一下这个package : pacman-package-manager