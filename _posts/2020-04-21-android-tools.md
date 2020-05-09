---
title: android 工具基本使用
category: android
layout: post
---
* content
{:toc}

# avbtool
在aosp的源码中，`external/avb`目录下包含了这个工具，特指 Android Verified Boot 2.0,该目录
包含有tools和相关的库函数。
[avb](https://android.googlesource.com/platform/external/avb/)

```bash
vimer@host:~/src/aosp$ avbtool info_image --image out/target/product/generic_x86_64/vbmeta.img
Minimum libavb version:   1.0
Header Block:             256 bytes
Authentication Block:     576 bytes
Auxiliary Block:          1984 bytes
Algorithm:                SHA256_RSA4096
Rollback Index:           0
Flags:                    1
Release String:           'avbtool 1.1.0'
Descriptors:
    Chain Partition descriptor:
	Partition Name:          system
	Rollback Index Location: 1
	Public key (sha1):       cdbb77177f731920bbe0a0f94f84d9038ae0617d
	Prop: com.android.build.vendor.os_version -> '10'
	Hashtree descriptor:
	Version of dm-verity:  1
	Image Size:            117182464 bytes
	Tree Offset:           117182464
	Tree Size:             929792 bytes
	Data Block Size:       4096 bytes
	Hash Block Size:       4096 bytes
	FEC num roots:         2
	FEC offset:            118112256
	FEC size:              933888 bytes
	Hash Algorithm:        sha1
	Partition Name:        vendor
	Salt:                  500a5d4b28c5b94e8053a56a25f0a4a4455937e0
	Root Digest:           3d0fbf077fa15a1a04600e835153516fbcb9e3fc
	Flags:                 0
```
## Enables signing for generic boot images
[Enables signing for generic boot images](https://android-review.googlesource.com/c/platform/build/+/1306713)


