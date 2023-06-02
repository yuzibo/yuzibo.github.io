---
title: mmdebstrap 构建 rootfs的方法
category: debian
layout: post
---
* content
{:toc}

# 构建amd64 sid

```bash
sudo mmdebstrap --arch=amd64 --variant=buildd \
  --include=fakeroot,build-essential,ca-certificates,apt-transport-https \
  sid sid-amd64-sbuild.tar.xz \
  "deb [trusted=yes]  https://mirror.iscas.ac.cn/debian/ sid main"
```

然后可以使用以下方式:

```bash
mkdir buildrootfs && cd buildrootfs
sudo tar -xvf ../sid-amd64-sbuild.tar.xz

sudo systemd-nspawn -D . --bind=../tmp:/tmp --resolv-conf=bind-host
```
和sbuild的方式是一模一样的，但是这种可以随时替换里面的东西。
