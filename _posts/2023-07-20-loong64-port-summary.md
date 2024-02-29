---
title: loong64 port to Debian (WIP)
category: loong
layout: post
---
* content
{:toc}


# 2023/07/26
暂时上游还是缺少包:
```bash
sudo debootstrap --arch=loong64 --variant=buildd --verbose --include=fakeroot,build-essential --components=main --keyring=/etc/apt/trusted.gpg.d/debian-ports-archive-2023.gpg --resolve-deps --extra-suites=unreleased unstable /home/buildd/build http://ftp.ports.debian.org/debian-ports
```

注意这里的debootstrap使用，可以使用`--extra-suites=unreleased`,但是diy的话这里需要魔改一下。