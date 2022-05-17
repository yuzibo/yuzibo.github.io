---
title: debian dh 命令说明
category: debian-riscv
layout: post
---
* content
{:toc}

Debian的打包命令脚本中，最关键的其实 `rules/`下的dh命令。

这里有一个[wiki](https://wiki.debian.org/Autoreconf)，需要好好滴进行学习。

# mail list
## dh_auto_build
convlit fails to cross build from source, because it uses the build
architecture compiler. Letting dh_auto_build pass suitable CC to make
mostly fixes that except for one bare gcc invocation. After making that
substitutable as well, convlit cross builds successfully. Please
consider applying the attached patch.

Helmut

```bash
diff -u convlit-1.8/debian/rules convlit-1.8/debian/rules
--- convlit-1.8/debian/rules
+++ convlit-1.8/debian/rules
@@ -21,8 +21,8 @@
 build: build-stamp
 build-stamp:
        dh_testdir
-       $(MAKE) -C $(CURDIR)/lib
-       $(MAKE) -C $(CURDIR)/clit18
+       dh_auto_build --sourcedirectory=lib
+       dh_auto_build --sourcedirectory=clit18
        touch $@

 clean:
diff -u convlit-1.8/debian/changelog convlit-1.8/debian/changelog
--- convlit-1.8/debian/changelog
+++ convlit-1.8/debian/changelog
@@ -1,3 +1,12 @@
+convlit (1.8-1.1) UNRELEASED; urgency=medium
+
+  * Non-maintainer upload.
+  * Fix FTCBFS: (Closes: #-1)
+    + Let dh_auto_build pass cross tools to make.
+    + Make one plain gcc call substitutable.
+
diff -u convlit-1.8/clit18/Makefile convlit-1.8/clit18/Makefile
--- convlit-1.8/clit18/Makefile
+++ convlit-1.8/clit18/Makefile
@@ -7,3 +7,3 @@
 clit: clit.o hexdump.o drm5.o explode.o transmute.o display.o utils.o manifest.o ../lib/openclit.a
-       gcc -o clit $^  -ltommath
+       $(CC) -o clit $^  -ltommath
```

##  Pass -ffile-prefix-map

```bash
Subject: [PATCH 1/2] debian/rules: Pass -ffile-prefix-map in CFLAGS to avoid
 embedding build paths.

https://reproducible-builds.org/docs/build-path/
---
 debian/rules | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/debian/rules b/debian/rules
index 60c65ac..d18f93e 100755
--- a/debian/rules
+++ b/debian/rules
@@ -17,6 +17,10 @@ ifneq (,$(findstring noopt,$(DEB_BUILD_OPTIONS)))
 else
     CFLAGS += -O2
 endif
+
+# Avoid embedding the build path for reproducible builds
+CFLAGS += -ffile-prefix-map=$(CURDIR)=.
+
 export CFLAGS


--
2.35.1

```

##

```bash
Subject: [PATCH 2/2] debian/rules: Finish conversion to dh.

---
 debian/rules | 61 +++++++---------------------------------------------
 1 file changed, 8 insertions(+), 53 deletions(-)

diff --git a/debian/rules b/debian/rules
index d18f93e..40ffb83 100755
--- a/debian/rules
+++ b/debian/rules
@@ -11,59 +11,14 @@ export DEB_BUILD_MAINT_OPTIONS = hardening=+all
 %:
        dh $@

-CFLAGS := -Wall -g
-ifneq (,$(findstring noopt,$(DEB_BUILD_OPTIONS)))
-    CFLAGS += -O0
-else
-    CFLAGS += -O2
-endif
+override_dh_auto_build:
+       dh_auto_build --sourcedir=$(CURDIR)/lib
+       dh_auto_build --sourcedir=$(CURDIR)/clit18

-# Avoid embedding the build path for reproducible builds
-CFLAGS += -ffile-prefix-map=$(CURDIR)=.
+override_dh_auto_clean:
+       dh_auto_clean --sourcedir=$(CURDIR)/clit18
+       dh_auto_clean --sourcedir=$(CURDIR)/lib
+       dh_auto_clean

-export CFLAGS
-
-
-build: build-stamp
-build-stamp:
-       dh_testdir
-       $(MAKE) -C $(CURDIR)/lib
-       $(MAKE) -C $(CURDIR)/clit18
-       touch $@
-
-clean:
-       dh_testdir
-       dh_testroot
-       rm -f build-stamp
-       $(MAKE) -C $(CURDIR)/clit18  clean
-       $(MAKE) -C $(CURDIR)/lib     clean
-       dh_clean
-
-install: build
-       dh_testdir
-       dh_testroot
-       dh_prep
-       dh_install
-
-binary-indep:
-# do nothing
-
-binary-arch: build install
-       dh_testdir
-       dh_testroot
-       dh_installchangelogs
-       dh_installdocs
-       dh_installexamples
+override_dh_installman:
        dh_installman debian/clit.1
-       dh_link
-       dh_strip
-       dh_compress
-       dh_fixperms
-       dh_installdeb
-       dh_shlibdeps
-       dh_gencontrol
-       dh_md5sums
-       dh_builddeb
-
-binary: binary-indep binary-arch
-.PHONY: build clean binary-indep binary-arch binary install
--
```