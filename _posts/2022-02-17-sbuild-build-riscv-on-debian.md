---
title: 在Debian使用sbuild构建riscv的native编译环境
category: debian-riscv
layout: post
---
* content
{:toc}

# 社区资源
常见的社区资源主要是wiki，沟通类的工具主要是mail  list，以及IRC。

## wiki
[debian-cross wiki](https://wiki.debian.org/CrossCompiling)

[debian-RISCV wiki](https://wiki.debian.org/RISC-V#)

[debian IRC lists](https://wiki.debian.org/IRC)

## mail  list
在做debian port时，主要会用到以下两个列表：

debian-riscv@lists.debian.org  

debian-cross@lists.debian.org  

## IRC
windows建议使用 x-chat2，轻巧灵活，目前我个人是在将就着使用，更多更高级的用法还没有探索。

linux下我知道有一个issri，使用的是terminal。如果有桌面环境系统，最好还是使用发行版中自带的客户端，好处时你的IRC如果因为网络环境等因素的话，图形界面的客户端在某种程度上是可以帮你保留过往的聊天记录。这一点是很多terminal做不到的(也许是我没有设置有效的配置)。

具体的频道为
1. /join #debian-riscv
2. /join #debian-cross
3. /join #debian-ports
4. /join #debian-devel #  意义不大，可以潜水

#  goal
接下来的内容是介绍如何在Debian 11(bulleyes)下创建schroot并使用sbuild搭建riscv的交叉编译环境，宿主机为amd64(为了叙述方便，下面统一使用host代指，有时在构建具体的deb时会指明 --host=riscv64,这一点尤为注意).

host os环境如下
```bash
lsb_release -a 
No LSB modules are available.
Distributor ID: Debian
Description:    Debian GNU/Linux 11 (bullseye)
Release:        11
Codename:       bullseye
```

## 创建chroot

## 安装

```bash
apt install buildd
```

### sbuild-createchroot
这一章节主要参考 [Set_up_a_chroot](https://wiki.debian.org/CrossCompiling#Set_up_a_chroot).
正如文章题目所示，这篇文章我们介绍如何使用`sbuild-createchroot`命令去创建chroot,尽管还有诸如debootstrap, mksbuild, multistrap, pbuilder create的工具也可以创建(这些工具会在后面逐一解锁)。

`sbuild-createchroot`其实也是`debootstrap`命令的上层封装，根据前者的help手册:
```bash
 sbuild-createchroot runs debootstrap(1) to create a chroot suitable for building packages with sbuild.  Note that while debootstrap may be used di‐rectly, sbuild-createchroot performs additional setup tasks such as adding additional packages and configuring various files in the chroot.  Invok‐ing  sbuild-createchroot  is  functionally  equivalent  to  running  debootstrap --variant=buildd  --include=fakeroot,build-essential, then editing /etc/apt/sources.list and /etc/hosts by hand
```
但是，还是建议在使用 `sbuild-createchroot`时，使用`mmdebstrap`去激活：
命令：

```bash
sudo sbuild-createchroot --debootstrap=mmdebstrap --arch=riscv64 \
        --include=debian-ports-archive-keyring,ca-certificates  \
        --make-sbuild-tarball=/srv/sid-riscv64-sbuild.tgz \
        sid /tmp/chroots/sid-riscv64-sbuild/ \
        http://ftp.ports.debian.org/debian-ports/
```
当然，也可以使用 中科院自己的mirror: https://mirror.iscas.ac.cn/debian-ports
解释：命令`sbuild-createchroot`会根据参数创建一个base chroot。`--include=debian-ports-archive-keyring`是指我们后面在做port时，需要使用port的source list, 为了使用这个source list,需要我们安装一个keying,就是这个包(这里不加也没有关系，后面还有补救的办法)；`tarball`可以认为是一个rootfs(其实我也没有去核对，后面有了新的发现再回来改正)， `sid`是构建的chroot基于哪一个distributor version，后面的url是指定构建完成后chroot的源。执行完上面的命令，其chroot就是一个base的chroot，其包含sid的源，下面是具体的构建log(下载软件的info被忽略)

log:

```bash
...
mkdir /srv/chroots
mkdir /srv/chroots/sid
I: SUITE: sid
I: TARGET: /srv/chroots/sid
I: MIRROR: http://deb.debian.org/debian/
I: Running debootstrap --arch=amd64 --variant=buildd --verbose --include=fakeroot,build-essential --components=main --resolve-deps --no-merged-usr sid /srv/chroots/sid http://deb.debian.org/debian/ # 这里就是具体解析了这个命令
I: Target architecture can be executed
I: Retrieving InRelease
I: Checking Release signature
I: Valid Release signature (key id A7236886F3CCCAAD148A27F80E98404D386FA1D9)
I: Retrieving Packages
I: Validating Packages
I: Resolving dependencies of required packages...
I: Resolving dependencies of base packages...
I: Checking component main on http://deb.debian.org/debian...
I: Retrieving libacl1 2.3.1-1
I: Validating libacl1 2.3.1-1
I: Retrieving adduser 3.118

I: Configuring libc-bin...
I: Base system installed successfully.
I: Configured /etc/hosts:
+------------------------------------------------------------------------
|127.0.0.1 localhost
|::1 localhost ip6-localhost ip6-loopback
|ff02::1 ip6-allnodes
|ff02::2 ip6-allrouters
|
+------------------------------------------------------------------------
I: Configured /usr/sbin/policy-rc.d:
+------------------------------------------------------------------------
|#!/bin/sh
|echo "All runlevel operations denied by policy" >&2
|exit 101
+------------------------------------------------------------------------
I: Configured APT /etc/apt/sources.list:
+------------------------------------------------------------------------
|deb http://deb.debian.org/debian sid main
|deb-src http://deb.debian.org/debian/ sid main
|
+------------------------------------------------------------------------
I: Please add any additional APT sources to /srv/chroots/sid/etc/apt/sources.list # 不知道是不是可以直接修改这里
I: schroot chroot configuration written to /etc/schroot/chroot.d/sid-amd64-sbuild-bFkC6l.
+------------------------------------------------------------------------
|[sid-amd64-sbuild]
|description=Debian sid/amd64 autobuilder
|groups=root,sbuild
|root-groups=root,sbuild
|profile=sbuild
|type=file
|file=/srv/chroots/sid-sbuild.tgz
+------------------------------------------------------------------------
I: Please rename and modify this file as required.
mkdir /etc/sbuild/chroot
I: Setting reference package list.
I: Updating chroot.
Hit:1 http://deb.debian.org/debian sid InRelease
Get:2 http://deb.debian.org/debian sid/main Sources [9550 kB]
Fetched 9550 kB in 2s (5871 kB/s)
Reading package lists... Done
Reading package lists... Done
Building dependency tree... Done
Calculating upgrade... Done
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
I: Creating tarball...
I: Done creating /srv/chroots/sid-sbuild.tgz
I: chroot /srv/chroots/sid has been removed.
I: Successfully set up sid chroot.
I: Run "sbuild-adduser" to add new sbuild users.
-----------------
sudo sbuild-adduser vimer
Adding user `vimer' to group `sbuild' ...
Adding user vimer to group sbuild
Done.

# Setup tasks for sudo users:

# BUILD
# HOME directory in chroot, user:sbuild, 0770 perms, from
# passwd/group copying to chroot, filtered
# Maybe source 50sbuild, or move into common location.

Next, copy the example sbuildrc file to the home directory of each user and
set the variables for your system:

cp /usr/share/doc/sbuild/examples/example.sbuildrc /home/vimer/.sbuildrc

Now try a build:

cd /path/to/source
sbuild-update -ud <distribution>
(or "sbuild-apt <distribution> apt-get -f install"
first if the chroot is broken)

sbuild -d <distribution> <package>_<version>
```
上面的命令构建完了chroot还不算完整，我们得继续配置：
### sbuild-adduser 
```bash
sudo sbuild-adduser <your-username>
```
这条命令能够让你当前的用户使用相关的sbuild命令。幸运的话，你就构建完了一个基本的chroot.可以使用以下命令确认下：
```bash
~$:sudo schroot -la 
[sudo] password for vimer: 
chroot:sid-amd64-sbuild
source:sid-amd64-sbuild
```

有人会奇怪这里为啥会是`amd64`,这时构建rootfs时系统自动指定的，也就是所谓的默认。
解释一下这两个输出的区别： 

1. chroot:sid-amd64-sbuild(干净的chroot)，在那里你的所有更改都不会被保存，所以每次都是一样的；
2. source:sid-amd64-sbuild，实际的chroot tarball源代码,其中的更改将再次打包并保存以备下次使用。

一般情况下通常使用干净的chroot，如果只是默认使用“sid-amd64-sbuild”；这是默认的(注意，`sbuild-shell`命令是一个例外，因为它隐式使用源代码:version,也就是使用`sbuild-shell`的话，会污染原始的chroot tarball空间)。

这里就是说，比如我想手动hack这个sid,也就是把修改保留在chroot里，可以使用`sbuild-shell`命令:

```bash
sudo sbuild-shell sid-amd64-sbuild  # 这个参数，就是schroot 得来的，千万别混淆
```

另外，如果使用上述的命令，你会发现bash相当难用、用户主目录也不对。如果这个时候你想使用tab键补全命令也是不可能的。
这时，你可以编辑`/etc/schroot/chroot.d/sid-amd64-sbuild-<id>`这个id每个人不一致的，改成以下配置：

```bash
profile=default
```
这个时候你再使用`sbuild-shell`命令去login，发现就不一样了。

### using the chroot

```bash
schroot -c sid-amd64-sbuild
```
# 登录
其实，如果这个搞定了，是可以登录进来进行操作，总比qemu要强不少。

```bash
schroot -c sid-amd64-sbuild
```
或者首先使用

```bash
sudo schroot -c sid-amd64-sbuild
```
安装sudo的配置文件，才方便安装一些依赖软件什么的。

## 手动修改chroot的source.list
默认情况下，构建的apt源是在sbuild-createchroot命令行中给出的。在上面的例子中，我们使用的Debian的sid源。

因为我们现在的目标是port riscv，同时截止到现在(2022/02/),Debian并没有官方移植支持riscv的[release版本](https://www.debian.org/ports/)，如果想要把riscv相关的toolchains安装到chroot里，需要添加[Debian ports](https://wiki.debian.org/RISC-V#Package_repository)相应的源：

步骤： 

1. 为chroot安装必要的编辑器
`sbuild-createchroot`创建的chroot默认没有太多的tools，可以手动安装你最喜爱的vim或其他：
```bash
sudo sbuild-apt sid-amd64-sbuild apt-get install vim.tiny
```
注： `sbuild-apt`: run apt-get or apt-cache in an sbuild chroot

2. 添加源
```bash
$ sudo sbuild-shell sid-amd64-sbuild 
[sudo] password for vimer: 
Useless use of a constant ("riscv64") in void context at (eval 16) line 1210.
I: /bin/sh
# cat /etc/apt/sources.list 
# sid 源我们从一开始创建时就有，看上面的log
deb http://deb.debian.org/debian sid main
deb-src http://deb.debian.org/debian/ sid main
# 以下的ports sources是这次添加进来的，参看上面的解释或者以下的url:
# https://wiki.debian.org/RISC-V#Package_repository
deb http://ftp.ports.debian.org/debian-ports/ sid main
deb http://ftp.ports.debian.org/debian-ports/ unreleased main
deb-src http://ftp.ports.debian.org/debian-ports/ sid main
# vim添加完成后，在终端下执行  exit
# 退出 chroot
```

`注意`： 不知道因为什么原因，ports的repository没有合法的签名文件，需要以下两种方式去fix这个问题，否则后面的使用`apt update`时会遇到诸如下面的error:

```bash
E: The repository 'http://ftp.ports.debian.org/debian-ports sid InRelease' is not signed.
```

1.安装一个[debian-ports-archive-keyring](https://packages.debian.org/buster/all/debian-ports-archive-keyring/download)的debian package.

这里需要多说一句，通常这个时候,chroot可用的命令实际上很少的，需要我们自己先在host(x86)下载keying的deb包，然后我们使用sbuild-shell命令进入chroot后使用`apt install`去安装这个包。具体方法如下:

```bash
# A. 绑定当前host的home目录与chroot的默认目录
# 在host上，主要是编辑这个软件: /etc/schroot/chroot.d/sid-amd64-sbuild-xx,然后把profile=subuild改为default 字段就可以。
# B. 进入你存放deb的目录下，然后安装就可以了：
sudo apt install -f ./debian-ports-archive-keyring_2019.11.05~deb10u1_all.deb
```

2.如果还是报找不到签名文件的错误，还可以使用下面的方式解决：

[https://askubuntu.com/questions/732985/force-update-from-unsigned-repository](https://askubuntu.com/questions/732985/force-update-from-unsigned-repository)

简单说就是在 sources.list 添加 ` [trusted=yes] ` 字段解决这个问题。但是不建议这么做，这本身是一种workround的方案。

添加完ports的源以后，这里可以执行`apt update`也可以不执行。 It is up to you.

### 修改sbuild.conf
这里也很重要，我当时实验时就是因为没有相关的文档，卡在这里很长时间，直到后面在社区的帮助下，才搞定 :(
执行完上面的操作后，  ` 退出`chroot,以下修改是host的操作。

编辑`etc/sbuild/sbuild.conf`文件 and 把 `$crossbuild_core_depends` 变量打开(默认是注释掉的)，
修改成以下内容:

```bash
$crossbuild_core_depends = {
        riscv64 => [ "gcc-riscv64-linux-gnu", "g++-riscv64-linux-gnu",
        "libstdc++-dev:riscv64", "libc-dev:riscv64" ]
};
```
由于我本身的理解问题，我这里并不能理解Hemlut的意思，他的原文是这样的:

```bash
...
 I think you also need to change your
sbuild.conf and change $crossbuild_core_depends to include a mapping

    riscv64 => [ "gcc-riscv64-linux-gnu", "g++-riscv64-linux-gnu",
    "libstdc++-dev:riscv64", "libc-dev:riscv64" ]

as build-essential does not build a crossbuild-essential-$arch package
for ports.
```
大体的这个改动的意思是，我个人认为是： 告诉sbuild，如果被告知需要编译的arch为riscv64
(后面有相关的用法)，则需要chroot自己使用ports源里面已有的riscv相关的toolchains，而不是
现场编译crossbuild-essential-$arch这个tool。

以上就是sbuild(chroot)相关的操作，如果一切顺利可以执行下面的操作。

## 下载source code
tool(载体或者chroot)已经准备好了，我们得找一个合适的packages去做移植。引文聚焦riscv，所以我们以riscv为例。

[FTBFS, packages that Fail To Build From Source (in riscv64)](https://wiki.debian.org/RISC-V#FTBFS.2C_packages_that_Fail_To_Build_From_Source_.28in_riscv64.29) 是一个不错的开始，正如作者所说:
“So it's a nice place to start looking at things that need to be fixed” [https://udd.debian.org/cgi-bin/ftbfs.cgi?arch=riscv64](https://udd.debian.org/cgi-bin/ftbfs.cgi?arch=riscv64).

但是这里也不是那么容易找出来，有的是因为他们本身依赖的底层软件没有riscv的构建，形成了“猫吃尾巴”的圈圈。

除此之外，还可以看看 “Bugs (BTS) Usertags for user debian-riscv@lists.debian.org (UDD):riscv64: all bugs related to the Debian riscv64 port”这块，尤其是[UDD](https://udd.debian.org/cgi-bin/bts-usertags.cgi?user=debian-riscv@lists.debian.org)
中[riscv64](https://udd.debian.org/cgi-bin/bts-usertags.cgi?user=debian-riscv%40lists.debian.org&tag=riscv64)的标签.

这个[issue list](https://bugs.debian.org/cgi-bin/pkgreport.cgi?users=debian-riscv@lists.debian.org#_0_3_2)也挺好的，可以试一下。

在我看来，UDD的taged的软件其实有一些ports了，但是由于种种原因没有进行下去，我们可以pick一个进行实验。这里我选择是[sofia-sip](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=978498).

下载source code的第一步，首先是确认该软件应该属于那个release版本的源。这里也别考虑了，只要你手动hack的deb包，默认都应该是 sid。好，开搞！

sid就是unstable的别名，可以说就是在开发阶段的、未经大规模测试的deb包release version. 如果我们打算使用的sid的源，这里有两种方式(在host)上：

1. 根据[wikiknow](https://www.wikihow.com/Install-Debian-sid#:~:text=Run%20the%20command%20sudo%20sensible-editor%20%2Fetc%2Fapt%2Fsources.list%20and%20add,contrib%20non-free%20deb-src%20http%3A%2F%2Fdeb.debian.org%2Fdebian%20sid%20main%20contrib%20non-free)去修改sources.list:

```bash
# ...
# 添加以下内容
deb http://deb.debian.org/debian sid main
deb-src http://deb.debian.org/debian/ sid main
```
但是这种方式可能会影响host的稳定， pabs不建议这么去做。但是我这么做了，因为他说的第二种方式我不知道如何去操作。

2. 貌似使用一个虚拟的source.list,这样不影响host的其他软件( option 2 is to use chdist (from devscripts) or apt-venv to setup a virtual apt environment)。

使能上面的其中一个方案后，请使用  `apt update`去更新软件源。

### apt source
添加完`sid`源以后，执行以下命令:

```bash
mkdir build_test && cd build_test
sudo apt source sofia-sip 
[sudo] password for vimer: 
Reading package lists... Done
NOTICE: 'sofia-sip' packaging is maintained in the 'Git' version control system at:
git://git.debian.org/users/ron/sofia-sip.git
Please use:
git clone git://git.debian.org/users/ron/sofia-sip.git
to retrieve the latest (possibly unreleased) updates to the package.
Need to get 2,978 kB of source archives.
Get:1 http://deb.debian.org/debian sid/main sofia-sip 1.12.11+20110422.1-2.2 (dsc) [2,374 B]
Get:2 http://deb.debian.org/debian sid/main sofia-sip 1.12.11+20110422.1-2.2 (tar) [2,949 kB]
Get:3 http://deb.debian.org/debian sid/main sofia-sip 1.12.11+20110422.1-2.2 (diff) [27.0 kB]
Fetched 2,978 kB in 1s (3,911 kB/s)
dpkg-source: info: extracting sofia-sip in sofia-sip-1.12.11+20110422.1
dpkg-source: info: unpacking sofia-sip_1.12.11+20110422.1.orig.tar.gz
dpkg-source: info: applying sofia-sip_1.12.11+20110422.1-2.2.diff.gz
dpkg-source: info: upstream files that have been modified: 
 sofia-sip-1.12.11+20110422.1/libsofia-sip-ua/msg/msg_parser.c
 sofia-sip-1.12.11+20110422.1/libsofia-sip-ua/su/sofia-sip/su_tag.h
 sofia-sip-1.12.11+20110422.1/libsofia-sip-ua/su/su_port.h
W: Download is performed unsandboxed as root as file 'sofia-sip_1.12.11+20110422.1-2.2.dsc' couldn't be accessed by user '_apt'. - pkgAcquire::Run (13: Permission denied)
```
然后可以查看文件夹内容：
```bash
~$ls
sofia-sip-1.12.11+20110422.1  sofia-sip_1.12.11+20110422.1-2.2.diff.gz  sofia-sip_1.12.11+20110422.1-2.2.dsc  sofia-sip_1.12.11+20110422.1.orig.tar.gz

~$cd sofia-sip-1.12.11+20110422.1/
```

下载完代码我们就可以进行cross-build了:

### 构建
这个时候你还需要安装一个必要的软件在host上(x86)(如果没有安装):

```bash
sudo apt install debhelper
```
执行:
```bash
sudo sbuild  --host=riscv64 -d sid
```

这个命令是告诉sbuild，要构建riscv arch的deb包，在哪里呢？当然是基于咱们前面设置的chroot.`-d`是确定distruation。

不出意外的话(2022/02/18)，编译到最后会出现以下log:

```bash
...
dh_clean
  debian/rules build-arch
dh_testdir
mkdir -p objs
cd objs &&      ../configure --host=riscv64-linux-gnu   \
                              --build=x86_64-linux-gnu   \
                              --prefix=/usr
checking build system type... x86_64-pc-linux-gnu
checking host system type... Invalid configuration `riscv64-linux-gnu': machine `riscv64' not recognized
configure: error: /bin/bash ../config.sub riscv64-linux-gnu failed
make: *** [debian/rules:35: objs/config.status] Error 1
dpkg-buildpackage: error: debian/rules build-arch subprocess returned exit status 2
```

其实出现这个才不可怕，这个行为是预期的，因为该软件包目前还不支持riscv64下的编译吗。

可以看一下这个[log](https://buildd.debian.org/status/package.php?p=sofia-sip&suite=sid), tail of log:
```bash
fakeroot debian/rules clean
dh_testdir
dh_testroot
rm -f *-stamp
rm -f -r objs doc
dh_clean
 debian/rules build-arch
dh_testdir
mkdir -p objs
cd objs &&	../configure --host=riscv64-linux-gnu	\
			     --build=riscv64-linux-gnu	\
			     --prefix=/usr
checking build system type... Invalid configuration `riscv64-linux-gnu': machine `riscv64' not recognized
configure: error: /bin/bash ../config.sub riscv64-linux-gnu failed
make: *** [debian/rules:35: objs/config.status] Error 1
```

下一步就是如何根据这个log去修复它。

其实社区的相关人员已经提醒说，该包已经有相关的[patch](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=978498#10)了
.即便如此，剩下的工作就是如何apply这个patch以及如何follow整个debian packages的workflow。

# del chroot

```bash
sudo rm -r /srv/chroot/unstable-amd64-sbuild/
sudo rm /etc/schroot/chroot.d/unstable-amd64-sbuild-* /etc/sbuild/chroot/unstable-amd64-sbuild
```
##  del session

```bash
sudo schroot --end-session --all-sessions
```

# 创建riscv64 sid session
这里有两种方式：区别是有没有加`--foreigh`开关。

## 无 foreigh

```bash
sudo debootstrap --arch=riscv64 --keyring /usr/share/keyrings/debian-ports-archive-keyring.gpg --include=debian-ports-archive-keyring unstable /tmp/riscv-chroot https://deb.debian.org/debian-ports/
```

执行完这个命令，就可以 `chroot /tmp/riscv-chroot`进行下面的操作。

## 有 foreigh

```bash
sudo debootstrap --foreign --arch=riscv64 --keyring /usr/share/keyrings/debian-ports-archive-keyring.gpg --include=debian-ports-archive-keyring unstable /tmp/riscv-chroot http://deb.debian.org/debian-ports
# 这没有完成，你得执行第二阶段,以下是第二阶段：
sudo mkdir -p /tmp/riscv-chroot/usr/bin/
sudo cp "$(which qemu-riscv64-static)" /tmp/riscv-chroot/usr/bin/
sudo chroot /tmp/riscv-chroot/ /debootstrap/debootstrap --second-stage
```
关于这个开关的介绍:

```bash
--foreign
>        Do the initial unpack phase of bootstrapping only, for example if the  tar‐
>        get  architecture  does not match the host architecture.  A copy of deboot‐
>        strap sufficient for completing the bootstrap process will be installed  as
>        /debootstrap/debootstrap in the target filesystem.  You can run it with the
>        --second-stage option to complete the bootstrapping process.
```

## 无 foreigh

```bash
sudo debootstrap --arch=riscv64 --keyring /usr/share/keyrings/debian-ports-archive-keyring.gpg --include=debian-ports-archive-keyring unstable /tmp/riscv-chroot https://deb.debian.org/debian-ports/
```
则这一步即可一步完成。


## 使用 sbuild-createchroot

使用这个 `sbuild-createchroot`其实是带了 `--foreigh`的参数的：
```bash
sudo sbuild-createchroot --arch=riscv64 --foreign  --keyring="" --include=debian-ports-archive-keyring --make-sbuild-tarball=/srv/sid-riscv64-sbuild.tgz sid /tmp/chroots/sid-riscv64-sbuild1/  http://ftp.ports.debian.org/debian-ports/
```
`sbuild-createchroot`其实调用的也是`debootstrap`，如果上面的想要能够工作起来，还得手动打target 包。

前面可以说是创建的amd64，这个创建的是riscv，解决一些依赖不能安装的问题。

## 初次创建后尽量升级
因为我们创建的chroot可能由于某些软件的确实导致某些必须的packages没有安装进去，所以最好使用下面的命令
进行一个`update && upgrade`：

```bash
sbuild-update -ud sid-riscv64-sbuild
```

有问题及时解决~

但是这个命令编译时需要特别一点:
```bash
sudo sbuild --host=riscv64 --build=riscv64  -d sid-riscv64-sbuild
```
This is very interesting!

Enjoy it!

# fix issue

## 不能修改源码

假设
## 检查tarball source code
`--source`可以解决这个问题

## dh: error: unable to load addon python3: Can't locate
This happens because sbuild runs the "dh clean" (actually, the
"debian/rules clean" target) step *outside* of the chroot, before the
build actually starts. This means that sbuild expects you to have the
build deps installed on your host.

This is usually not desirable/required, so you can tell sbuild to not
clean the source tree by passing the --no-clean-source option to it, or
by adding the line "$clean_source = 0;" to your ~/.sbuildrc.



