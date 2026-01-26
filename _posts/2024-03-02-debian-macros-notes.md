---
layout: post
title: "Debian 打包 宏使用"
category: debian
---

# 一些内置的宏可以使用
```bash 
include /usr/share/dpkg/pkg-info.mk
export DEB_VERSION_UPSTREAM
```

具体的:

```bash
DEB_SOURCE = $(call dpkg_late_eval,DEB_SOURCE,dpkg-parsechangelog -SSource)
DEB_VERSION = $(call dpkg_late_eval,DEB_VERSION,dpkg-parsechangelog -SVersion)
DEB_VERSION_EPOCH_UPSTREAM = $(call dpkg_late_eval,DEB_VERSION_EPOCH_UPSTREAM,echo '$(DEB_VERSION)' | sed -e 's/-[^-]*$$//')
DEB_VERSION_UPSTREAM_REVISION = $(call dpkg_late_eval,DEB_VERSION_UPSTREAM_REVISION,echo '$(DEB_VERSION)' | sed -e 's/^[0-9]*://')
DEB_VERSION_UPSTREAM = $(call dpkg_late_eval,DEB_VERSION_UPSTREAM,echo '$(DEB_VERSION_EPOCH_UPSTREAM)' | sed -e 's/^[0-9]*://')
DEB_DISTRIBUTION = $(call dpkg_late_eval,DEB_DISTRIBUTION,dpkg-parsechangelog -SDistribution)
```
