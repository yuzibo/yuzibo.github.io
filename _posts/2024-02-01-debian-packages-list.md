---
layout: post
title: "Debian packages lists"
category: debian
---

# goals

以 Debian 为根据地，围绕 Debian 打造自己的技术栈。

这是一个长期更新的清单，记录我所有 debian 打包的一些情况。

# 2022-2023

一共13个。see [link](https://qa.debian.org/developer.php?email=tsu.yubo%40gmail.com)

# 2024

## 02

* python-whey https://tracker.debian.org/pkg/python-whey

total: 14

## 03

* https://salsa.debian.org/python-team/packages/pytermgui 

由 BoYuan 大佬帮忙上传。 

learn: examples 可以不作为单独的包提供。

## 04

linenoise, ppx-bisect, and omd for ocaml package

## 06
* accessible-pygments https://salsa.debian.org/python-team/packages/accessible-pygments

### total
22

## 07
* lem https://salsa.debian.org/ocaml-team/lem/-/blob/debian/master/debian/rules?ref_type=heads

TIL:

```shell
include /usr/share/dpkg/pkg-info.mk
export DEB_VERSION_UPSTREAM

```

