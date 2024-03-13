---
title: debian dput配置
category: debian-riscv
layout: post
---
* content
{:toc}

# mentor

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

# DM

DM 的操作可以参考这里 [DM](https://wiki.debian.org/DebianMaintainer/Tutorial)

```bash
[ftp-master]
fqdn                    = ftp.upload.debian.org
incoming                = /pub/UploadQueue/
login                   = anonymous
allow_dcut              = 1
method                  = ftp
```

Source only upload:

```bash
debsign -k 0xE2521CB8175736A97052B2F8954E6A70100598A2 xdoctest_1.1.2-1_source.changes
dput ftp-master xdoctest_1.1.2-1_source.changes
```
# 请仔细核对一下内容

在正式 upload 之前，请确保以下内容:

## UNRELEASE -> unstable

## commit log 与 提交是否对应

## upload to archive后， 别忘记打 debian/ tag 
