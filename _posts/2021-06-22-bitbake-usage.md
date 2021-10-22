---
title: Yocto/bitbake的基本用法
category: OpenEmbeded
layout: post
---
* content
{:toc}

# 简介
openembeded 有三个关键词:

bitbake: 可以想象成make

recipes: 是bitbake的入口文件，涉及到构建依赖 源码下载 配置 编译 build install 卸载等动作

layers: 在OpenEmbeded中，layer的概念是一个 recipes和相关配置文件的搜集整理集合,典型的分层主题是:
    kernel bsp  board等。

最有用的layers是位于 build/conf/bblayers.conf 中

```bash
vimer@user-HP:~/riscv_test/w500/freedom-u-sdk$ cat build/conf/bblayers.conf
# LAYER_CONF_VERSION is increased each time build/conf/bblayers.conf
# changes incompatibly
LCONF_VERSION = "7"

BBPATH = "${TOPDIR}"
BBFILES ?= ""

BBLAYERS ?= " \
  /home/vimer/riscv_test/w500/freedom-u-sdk/openembedded-core/meta \
  /home/vimer/riscv_test/w500/freedom-u-sdk/meta-openembedded/meta-oe \
  /home/vimer/riscv_test/w500/freedom-u-sdk/meta-openembedded/meta-python \
  /home/vimer/riscv_test/w500/freedom-u-sdk/meta-openembedded/meta-multimedia \
  /home/vimer/riscv_test/w500/freedom-u-sdk/meta-openembedded/meta-filesystems \
  /home/vimer/riscv_test/w500/freedom-u-sdk/meta-openembedded/meta-networking \
  /home/vimer/riscv_test/w500/freedom-u-sdk/meta-openembedded/meta-gnome \
  /home/vimer/riscv_test/w500/freedom-u-sdk/meta-openembedded/meta-xfce \
  /home/vimer/riscv_test/w500/freedom-u-sdk/meta-riscv \
  /home/vimer/riscv_test/w500/freedom-u-sdk/meta-clang \
  /home/vimer/riscv_test/w500/freedom-u-sdk/meta-sifive \
  /home/vimer/riscv_test/w500/freedom-u-sdk/meta-tensorflow-lite \
...
```
在上面的这些layers中，里面每一层的recipes文件，bitbake根据他们create task: fetch configure compile package.

上面的meta-\*是每一个顶级layer,里面一般包含三种bitbake的元数据:

## conf 目录

```bash
vimer@user-HP:~/riscv_test/w500/freedom-u-sdk$ tree meta-sifive/conf/ -L 1
meta-sifive/conf/
├── layer.conf
└── machine

1 directory, 1 file

```

## Recipes

```bash
./recipes-*/ (recipe files with .bb extension)
```

Good practices with Layers:

Only the maintainer of a layer is supposed to modify it
Anyone willing to add or modify recipes need to create a separate layer that should be appended to the previous ones

bitbake是OpenEmbeded的基础构建，目前工作中需要对这个命令有一个基本的了解，所以这里
暂时记录一下，方便我们后面的使用。

# bitbake

参考以下资料： https://www.kancloud.cn/digest/yocto/138624

## 初始化
一般的工程，都有一个初始化的脚本来enable bitbake的命令
以 freedom-u-sdk 为例，他的setup.sh为：

```bash
. ./meta-sifive/setup.sh
```

## 确定包的名字

命令:   bitbake -s

```bash
vimer@user-HP:~/riscv_test/w500/freedom-u-sdk/build$ bitbake -s | grep qemu
nativesdk-qemu                                      :6.0.0-r0
nativesdk-qemu-helper                                 :1.0-r9
nativesdk-qemuwrapper-cross                           :1.0-r0
qemu                                                :6.0.0-r0
qemu-helper-native                                    :1.0-r1
qemu-native                                         :6.0.0-r0
qemu-system-native                                  :6.0.0-r0
qemuwrapper-cross                                     :1.0-r0
```

# OE相关

## bitbake-layers show-layers

```bash
vimer@user-HP:~/riscv_test/w500/freedom-u-sdk/build$ bitbake-layers show-layers
NOTE: Starting bitbake server...
layer                 path                                      priority
==========================================================================
meta                  /home/vimer/riscv_test/w500/freedom-u-sdk/openembedded-core/meta  5
meta-oe               /home/vimer/riscv_test/w500/freedom-u-sdk/meta-openembedded/meta-oe  6
meta-python           /home/vimer/riscv_test/w500/freedom-u-sdk/meta-openembedded/meta-python  7
meta-multimedia       /home/vimer/riscv_test/w500/freedom-u-sdk/meta-openembedded/meta-multimedia  6
meta-filesystems      /home/vimer/riscv_test/w500/freedom-u-sdk/meta-openembedded/meta-filesystems  6
meta-networking       /home/vimer/riscv_test/w500/freedom-u-sdk/meta-openembedded/meta-networking  5
meta-gnome            /home/vimer/riscv_test/w500/freedom-u-sdk/meta-openembedded/meta-gnome  7
meta-xfce             /home/vimer/riscv_test/w500/freedom-u-sdk/meta-openembedded/meta-xfce  7
meta-riscv            /home/vimer/riscv_test/w500/freedom-u-sdk/meta-riscv  6
meta-clang            /home/vimer/riscv_test/w500/freedom-u-sdk/meta-clang  7
meta-sifive           /home/vimer/riscv_test/w500/freedom-u-sdk/meta-sifive  8
meta-tensorflow-lite  /home/vimer/riscv_test/w500/freedom-u-sdk/meta-tensorflow-lite  6
```
结合这里，我才意思到，OE的一点初步的设计思想，确实需要好好读一读spec。

## create-layer

这里，bitbake-layers是利用了分层的思想，也就是后面你想对一个已经存在的工程进行修改，最好的方法是增加自己
的layers，去修改自己的东西，就比如上图中的数字就是这个层的执行顺序，可以暂时浅显的理解。下面新添加一个layers做下实验.

```bash
build$
bitbake-layers create-layer --priority 9 ../meta-test/mets-my-test-layer
NOTE: Starting bitbake server...
Add your new layer with 'bitbake-layers add-layer ../meta-test/mets-my-test-layer'
```

新的layers具有以下的文件清单:

```bash
vimer@user-HP:~/riscv_test/w500/freedom-u-sdk$ tree meta-test/
meta-test/
└── mets-my-test-layer
    ├── conf
    │   └── layer.conf
    ├── COPYING.MIT
    ├── README
    └── recipes-example
        └── example
            └── example_0.1.bb

4 directories, 4 files
```

对于一个new layer, recommended actions are:

1. Update the REDEME

2. Update the priority in conf/layer.conf file

3. Apply your modifications and/or addons for the distrubtion.

但是这里有一个问题，就是使用针对原来 setup.sh不会把这个新的layer添加进入 show-layer命令，这个还有待考察如何做。

## add-layers

上面已经新建了一个layer, 但是还没有添加进去，这里使用 bitbake-layer add-layer 命令添加。

```bash
vimer@user-HP:~/riscv_test/w500/freedom-u-sdk$ cd meta-sifive/
vimer@user-HP:~/riscv_test/w500/freedom-u-sdk/meta-sifive$ bitbake-layers add-layer ../meta-test/mets-my-test-layer/
NOTE: Starting bitbake server...
Unable to find bblayers.conf
```
你看他最后报的错误，是找不到一个文件，那么，这个文件是在哪里呢？在build目录下:

```bash
vimer@user-HP:~/riscv_test/w500/freedom-u-sdk/meta-sifive$ cd ../build/
vimer@user-HP:~/riscv_test/w500/freedom-u-sdk/build$ bitbake-layers add-layer ../meta-test/mets-my-test-layer/
NOTE: Starting bitbake server...
vimer@user-HP:~/riscv_test/w500/freedom-u-sdk/build$ bitbake-layers show-layers
NOTE: Starting bitbake server...
layer                 path                                      priority
==========================================================================
meta                  /home/vimer/riscv_test/w500/freedom-u-sdk/openembedded-core/meta  5
meta-oe               /home/vimer/riscv_test/w500/freedom-u-sdk/meta-openembedded/meta-oe  6
meta-python           /home/vimer/riscv_test/w500/freedom-u-sdk/meta-openembedded/meta-python  7
meta-multimedia       /home/vimer/riscv_test/w500/freedom-u-sdk/meta-openembedded/meta-multimedia  6
meta-filesystems      /home/vimer/riscv_test/w500/freedom-u-sdk/meta-openembedded/meta-filesystems  6
meta-networking       /home/vimer/riscv_test/w500/freedom-u-sdk/meta-openembedded/meta-networking  5
meta-gnome            /home/vimer/riscv_test/w500/freedom-u-sdk/meta-openembedded/meta-gnome  7
meta-xfce             /home/vimer/riscv_test/w500/freedom-u-sdk/meta-openembedded/meta-xfce  7
meta-riscv            /home/vimer/riscv_test/w500/freedom-u-sdk/meta-riscv  6
meta-clang            /home/vimer/riscv_test/w500/freedom-u-sdk/meta-clang  7
meta-sifive           /home/vimer/riscv_test/w500/freedom-u-sdk/meta-sifive  8
meta-tensorflow-lite  /home/vimer/riscv_test/w500/freedom-u-sdk/meta-tensorflow-lite  6
mets-my-test-layer    /home/vimer/riscv_test/w500/freedom-u-sdk/meta-test/mets-my-test-layer  9
```
看，这个时候就有咱们自己的新层了。

# devtool

有了自己的layers, 这个时候就应该考虑如何往他里面添加app了。也就是添加recipes等文件

## devtool add

1. 首先在build目录中新建一个目录:

```bash
vimer@user-HP:~/riscv_test/w500/freedom-u-sdk/build$ mkdir my_sources
vimer@user-HP:~/riscv_test/w500/freedom-u-sdk/build/my_sources$ devtool add my-app my_app/
NOTE: Starting bitbake server...
NOTE: Starting bitbake server...
NOTE: Reconnecting to bitbake server...
NOTE: Retrying server connection (#1)...
NOTE: Reconnecting to bitbake server...
NOTE: Reconnecting to bitbake server...
NOTE: Retrying server connection (#1)...
NOTE: Retrying server connection (#1)...
NOTE: Starting bitbake server...
INFO: Using source tree as build directory since that would be the default for this recipe
INFO: Recipe /home/vimer/riscv_test/w500/freedom-u-sdk/build/workspace/recipes/my-app/my-app.bb has been automatically created; further editing may be required to make it fully functional
```

devtool 创建了一个名为 my-app的workspace, 用来存放  recipe 等文件的,在build目录下。

workspace的目录结构如下:

```bash
vimer@user-HP:~/riscv_test/w500/freedom-u-sdk/build$ tree workspace/
workspace/
├── appends
│   └── my-app.bbappend
├── conf
│   └── layer.conf
├── README
└── recipes
    └── my-app
        └── my-app.bb
```

## devtool build

```bash
vimer@user-HP:~/riscv_test/w500/freedom-u-sdk/build/my_sources$ devtool build my-app
NOTE: Starting bitbake server...
NOTE: Reconnecting to bitbake server...
NOTE: Retrying server connection (#1)...
Loading cache: 100% |                                                                            | ETA:  --:--:--
Loaded 0 entries from dependency cache.
Parsing recipes: 100% |###########################################################################| Time: 0:00:19
Parsing of 2658 .bb files complete (0 cached, 2658 parsed). 4031 targets, 186 skipped, 1 masked, 0 errors.
NOTE: Reconnecting to bitbake server...
NOTE: Previous bitbake instance shutting down?, waiting to retry...
NOTE: Retrying server connection (#1)...
Loading cache: 100% |#############################################################################| Time: 0:00:01
Loaded 4030 entries from dependency cache.
Parsing recipes: 100% |###########################################################################| Time: 0:00:00
Parsing of 2658 .bb files complete (2657 cached, 1 parsed). 4031 targets, 186 skipped, 1 masked, 0 errors.
NOTE: Resolving any missing task queue dependencies

Build Configuration:
BB_VERSION           = "1.51.1"
BUILD_SYS            = "x86_64-linux"
NATIVELSBSTRING      = "universal"
TARGET_SYS           = "riscv64-oe-linux"
MACHINE              = "unmatched"
DISTRO               = "nodistro"
DISTRO_VERSION       = "2021.09.00"
TUNE_FEATURES        = "riscv64 sifive-7-series"
meta
meta-oe
meta-python
meta-multimedia
meta-filesystems
meta-networking
meta-gnome
meta-xfce
meta-riscv
meta-clang
meta-sifive
meta-tensorflow-lite
mets-my-test-layer
workspace            = "w500-dev:59cf33b17066bd50c8827b64cf18f70f18407e6e"

Initialising tasks: 100% |########################################################################| Time: 0:00:00
Sstate summary: Wanted 14 Local 0 Network 0 Missed 14 Current 63 (0% match, 81% complete)
Removing 10 stale sstate objects for arch riscv64: 100% |#########################################| Time: 0:00:00
NOTE: Executing Tasks
NOTE: my-app: compiling from external source tree /home/vimer/riscv_test/w500/freedom-u-sdk/build/my_sources/my_app
NOTE: Tasks Summary: Attempted 553 tasks of which 505 didn't need to be rerun and all succeeded.
NOTE: Writing buildhistory
NOTE: Writing buildhistory took: 1 seconds
NOTE: Build completion summary:
NOTE:   do_populate_sysroot: 0.0% sstate reuse(0 setscene, 6 scratch)
NOTE:   do_package: 0.0% sstate reuse(0 setscene, 5 scratch)
NOTE:   do_packagedata: 0.0% sstate reuse(0 setscene, 5 scratch)
```


