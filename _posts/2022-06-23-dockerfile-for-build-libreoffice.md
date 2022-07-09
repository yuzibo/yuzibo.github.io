---
title: 构建libreoffice的docker构建环境
category: docker
layout: post
---
* content
{:toc}

# upstream tarball

我们暂时定于使用 http://download.documentfoundation.org/libreoffice/src/7.3.4/ 的tarball包。

## 安装依赖

```bash
apt-get install git build-essential zip ccache junit4 libkrb5-dev nasm graphviz python3 python3-dev qtbase5-dev libkf5coreaddons-dev libkf5i18n-dev libkf5config-dev libkf5windowsystem-dev libkf5kio-dev autoconf libcups2-dev libfontconfig1-dev gperf default-jdk doxygen libxslt1-dev xsltproc libxml2-utils libxrandr-dev libx11-dev bison flex libgtk-3-dev libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev ant ant-optional libnss3-dev libavahi-client-dev
xz-utils  pkg-config  autoconf make gcc libfontconfig1-dev libarchive-zip-perl libclucene-dev libxmlsec1-dev librevenge-dev libodfgen-dev libepubgen-dev libwpd-dev  libwpg-dev libwps-dev libvisio-dev libcdr-dev libmspub-dev libmwaw-dev libetonyek-dev  libfreehand-dev libe-book-dev libabw-dev  libqxp-dev libzmf-dev libstaroffice-dev libreoffice-sdbc-hsqldb libpq-dev libcurl4-gnutls-dev libboost-dev libboost-date-time-dev libboost-filesystem-dev libboost-locale-dev  libboost-iostreams-dev  libmdds-dev  libglm-dev

```

## 解压

```bash
xz -d libreoffice-7.3.4.2.tar.xz

```

##  安装依赖:

```bash
wget -r --level=1 -nd -P <lo_root>/external/tarballs https://go.suokunlong.cn:88/dl/libreoffice/external_tarballs/
```

# riscv64 docker

docker pull riscv64/debian:unstable

# dockerfile 的使用

## build image

```bash
docker build ~/mydockerbuild -f example_dockerfile -t example_image
```

## run image
```bash
docker run example_image  # 交互模式
// 或者这样的方式去执行：
docker run -it --rm example_image bash
```

vimer@dev:~/git/LibreOffice-riscv-port/patch$ docker image ls
REPOSITORY       TAG        IMAGE ID       CREATED        SIZE
example_image    latest     27be1957beac   5 hours ago    2.02GB
<none>           <none>     34ad850bc1ca   6 hours ago    102MB
riscv64/debian   unstable   b7d0e949dda9   36 hours ago   102MB
debian           latest     4eacea30377a   3 weeks ago    124MB
hello-world      latest     feb5d9fea6a5   9 months ago   13.3kB

Delete docker image:

docker image rm <-f> example_image

