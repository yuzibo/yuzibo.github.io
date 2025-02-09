---
title: debian depends 依赖的用法
category: debian-riscv
layout: post
---
* content
{:toc}

# 具体的依赖关系
下面的命令可以展示tmux的具体依赖关系，当然，是以图片的方式展示的。
```bash
sudo apt-rdepends --dotty tmux | dot -Tpng > dependency-tmux-map.png
```

# reverse Build-depends
推荐使用 `apt install ubuntu-dev-tools`下的`reverse-depends`工具:

```bash
sudo reverse-depends python3-dbus
Reverse-Recommends
* autosuspend
* deluge-common
* gajim
* hijra-applet
* linuxcnc-uspace [amd64 arm64 armel armhf i386 mips64el mipsel ppc64el s390x]
* monajat-applet
* mps-youtube
* netatalk [amd64 arm64 armel armhf i386 mips64el mipsel ppc64el s390x]
* pithos
* python3-pantalaimon
* quodlibet
* sabnzbdplus
* solaar
* xboxdrv [amd64 arm64 armel armhf i386 mips64el mipsel ppc64el s390x]
* xpra [amd64 arm64 armel armhf i386 mips64el mipsel ppc64el s390x]

Reverse-Depends
* a2jmidid [amd64 arm64 armel armhf i386 mips64el mipsel ppc64el s390x]
* autokey-common
* autokey-gtk
...
```

# build-rdeps 

该包是 `devscripts` 工具包的一部分， 具体的用法为:

```bash
build-rdeps glyphspkg
Reverse Build-depends in testing/main:
``` 


See [#1095519](https://bugs.debian.org/1095519)
