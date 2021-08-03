---
title: 解析deb包
category: debian
layout: post
---
* content
{:toc}

# 常用
我们知道，dpkg是deb包的安装后端程序，而 apt-get 则是这个命令的前端，其中， 我们使用
`apt-get install xx`会自动解决依赖问题，而 `dpkg -i xx`则不会，这个时候，需要我们在
联网的状态下运行 `apt-get install -f`即可。

# 高级
今天我们补充几个 dpkg的几个高级用法。

## dpkg-deb

使用“dpkg-deb -I somepackage.deb”，您可能会大致了解该软件包提供的具体内容。

```bash
(base) user@CI_Server:~/local$ dpkg-deb -I deepstream-5.1_5.1.0-1_arm64.deb
 new Debian package, version 2.0.
 size 572891552 bytes: control archive=18320 bytes.
    1127 字节，   10 行      control
   74007 字节，  584 行      md5sums
     855 字节，   14 行   *  postinst             #!/bin/bash
    2805 字节，   32 行   *  prerm                #!/bin/bash
 Package: deepstream-5.1
 Version: 5.1.0-1
 Architecture: arm64
 Maintainer: NVIDIA Corporation
 Installed-Size: 1631299
 Depends: cuda-cudart-10-2 | cuda-cudart-11-1, cuda-cudart-dev-10-2 | cuda-cudart-dev-11-1, cuda-npp-10-2 | libnpp-11-1, cuda-npp-dev-10-2 | libnpp-dev-11-1, cuda-cufft-10-2 | libcufft-11-1, libvisionworks (>= 1.6.0), libvisionworks-dev (>= 1.6.0), gstreamer1.0-libav, gstreamer1.0-plugins-bad, gstreamer1.0-plugins-good, libcairo2 (>= 1.15.10), libglib2.0-0 (>= 2.56.4), libgstreamer1.0-0 (>= 1.14.1), libgstreamer1.0-dev (>= 1.14.1), libgstreamer-plugins-base1.0-0 (>= 1.14.1), libgstreamer-plugins-base1.0-dev (>= 1.14.1), libnvinfer7 (>= 7.1.0), libnvinfer-dev (>= 7.1.0), libnvparsers7 (>= 7.1.0), libnvparsers-dev (>= 7.1.0), libnvonnxparsers7 (>= 7.1.0), libnvonnxparsers-dev (>= 7.1.0), libnvinfer-plugin7 (>= 7.1.0), libnvinfer-plugin-dev (>= 7.1.0), libpangocairo-1.0-0 (>= 1.40.14), libx11-6, libgstrtspserver-1.0-0, libnvvpi1 (>= 1.0.13)
 Section: Utils
 Priority: standard
 Homepage: http://developer.nvidia.com/jetson
 Description: Nvidia DeepStreamSDK runtime libraries, development files and samples
```

'dpkg-deb -c somepackage.deb' 列出将要安装的所有文件。
