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
