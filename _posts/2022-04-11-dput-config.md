---
title: port debian autopkgtest to riscv64
category: debian-riscv
layout: post
---
* content
{:toc}

如果是  upload mentor，需要做以下内容：
cat ~/.dput.cf
```bash
[mentors]
fqdn = mentors.debian.net
incoming = /upload
method = https
allow_unsigned_uploads = 0
progress_indicator = 2
# Allow uploads for UNRELEASED packages
allowed_distributions = .*
```

