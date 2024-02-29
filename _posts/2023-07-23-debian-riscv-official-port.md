---
title: Debian riscv official port
category: debian-riscv
layout: post
---
* content
{:toc}

如果你对本文的内容感觉到唐突的话，可以浏览一下前面的基础铺垫[Debian riscv社区过去总结及新年goal](https://www.aftermath.cn/2022/02/13/debian-riscv-plct-2022-goal/)和[Debian 开发资源列表](https://www.aftermath.cn/2022/02/23/debian-development-sources/)

2023/07/23是一个很重要的日子，原因在于在这一天，Debian 社区宣布接受riscv64为[官方支持的架构](https://lists.debian.org/debian-riscv/2023/07/msg00053.html)，可以说，我们等这一天等了太久了。

从去年这个时候开始，Debian riscv port team就开始推动official port的进程，因为Debian 12 bookworm将会在2023年上半年发布，考虑到种种因素，在当时的条件下，我们认为，这个时间点我们是可以追赶的。2022年5月份 [PLCT lab](https://github.com/plctlab/PLCT-Weekly)提供了8台Unmatched给Debian RISC-V buildd team使用，这在当时解了RISC-V buildd的构建机不够的燃眉之急，为Debian riscv64 包的状态打下了一个很好的基础。原以为这样就可以顺利的开展下去，谁知道位于Debian 非认可的机房的机器，是不能够进入official port阶段使用的。说到这里，有必须说一下Debian port的一般流程。对于一个新的架构，都是从[debian-ports](https://wiki.debian.org/PortsDocs/New)仓库开始的， 简而言之，这个仓库是对于一个新的架构、指令集开始的地方，他可以允许开发者自己搭建的打包机加入到buildd网络中并往debian-ports仓库传包。但是，这个时候，所有的FTBFS( fail to build from source) issue都有port team自己负责，也就是说，包的maintainer是可以拒绝任何与此架构改动的相关patch或者请求，实际实际中大部分maintainer是乐意接受patch的:)。当unofficial port移植到一定程度后，比如满足上面wiki的条件后，才可以继续推动该架构进入official port。

其实一开始我也有误区，任务当时的包从数量上讲已经构建的够好了，为什么还有Debian official port。其实Debian 的official port,就是在Unofficial port的基础上，在Debian 官方DSA维护的打包机重新rebuild的所有的包进行的过程。

# 时间线

## 2023/07/28
buildd正式从DSA掌控的打包机向Debian archive  upload 包。



# official port initial packages

```bash
acl apt attr audit base-files base-passwd bash binutils build-essential bzip2 cdebconf coreutils dash db5.3 debianutils diffutils dpkg dwz e2fsprogs elfutils fakeroot file findutils gcc-12 gcc-13 gcc-defaults gdbm gettext glibc gmp gnupg2 gnutls28 grep groff gzip hostname icu isl jansson keyutils krb5 libcap2 libcap-ng libffi libgcrypt20 libgpg-error libidn2 libmd libnsl libpipeline libselinux libsemanage libsepol libtasn1-6 libtirpc libunistring libxcrypt libxml2 libzstd linux lz4 m4 make-dfsg man-db mawk mpclib3 mpfr4 ncurses nettle openssl p11-kit pam patch pcre2 perl rpcsvc-proto sed shadow systemd sysvinit tar uchardet util-linux xxhash xz-utils zlib
```