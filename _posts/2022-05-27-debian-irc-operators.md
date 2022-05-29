---
title: debian debdiff用法
category: debian-riscv
layout: post
---
* content
{:toc}

如果针对 `d/*`下面的目录进行修改，目前没有好的方法，比如使用`quilt`或者`patch`,但是我们可以使用

```bash
$ debdiff  old/waypipe_0.8.2-3.dsc waypipe_0.8.2-3.dsc
dpkg-source: warning: extracting unsigned source package (/home/vimer/05/26_waypipe/waypipe_0.8.2-3.dsc)
diff -Nru waypipe-0.8.2/debian/rules waypipe-0.8.2/debian/rules
--- waypipe-0.8.2/debian/rules  2021-12-01 15:39:26.000000000 +0000
+++ waypipe-0.8.2/debian/rules  2021-12-01 15:39:26.000000000 +0000
@@ -16,7 +16,7 @@
        dh_auto_configure -- -Dwith_avx2=false -Dwith_avx512f=false -Dwith_neon_opts=false -Dwith_sse3=false
 endif

-ifneq (, $(filter $(DEB_HOST_ARCH),mipsel mips64el))
+ifneq (, $(filter $(DEB_HOST_ARCH),mipsel mips64el riscv64))
 override_dh_auto_test:
        @echo "Skipping tests on $(DEB_HOST_ARCH)."
 endif
```
