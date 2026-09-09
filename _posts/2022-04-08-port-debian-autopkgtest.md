---
title: debian autopkgtest usgae
category: debian-riscv
layout: post
---
* content
{:toc}

autopkgtest 是根据[DEP8](https://salsa.debian.org/ci-team/autopkgtest/raw/master/doc/README.package-tests.rst)制定的，本文简单记录下这块的相关用法。

或者还可以参考这个教程  https://hackmd.io/@fourdollars/By26b5au8

# debci 环境搭建
为了与线上的环境一致，推荐使用 `debci`的方式。

## incus backend

从 forky , debci 开始使用 `incus-lxc` 作为 backend 了, 初次创建模板如下:

```bash
sudo debci setup --backend incus-lxc --suite unstable   
...
I: creating tarball...
I: skipping output/dev as requested
I: done
I: removing tempdir /tmp/mmdebstrap.8O1lJ9EjHC...
I: success in 546.2675 seconds
Image imported with fingerprint: 51038313f0aee575616ae1919633e9fa97c0347431e44b3e52790629b105d44d
I: testbed setup [unstable/amd64/incus-lxc]: finished at Wed Sep  9 23:43:42 HKT 2026
```

通过 id 也能找到, 然而这个 模板的名字就叫 `unstable/amd64/incus-lxc`

创建完成后, 使用如下命令可以查看:

```bash
vimer@njlab144:~/debci/mia/mia-2.4.7$ sudo incus image list
+-----------------------------------+--------------+--------+----------------------------------------+--------------+-----------+-----------+----------------------+
|               ALIAS               | FINGERPRINT  | PUBLIC |              DESCRIPTION               | ARCHITECTURE |   TYPE    |   SIZE    |     UPLOAD DATE      |
+-----------------------------------+--------------+--------+----------------------------------------+--------------+-----------+-----------+----------------------+
| autopkgtest/debian/unstable/amd64 | 07bfb4db1bc4 | no     | Debian unstable amd64 (20260909_12:05) | x86_64       | CONTAINER | 229.90MiB | 2026/09/09 12:11 HKT |
+-----------------------------------+--------------+--------+----------------------------------------+--------------+-----------+-----------+----------------------+

```

删除

```bash
 sudo incus  image delete autopkgtest/debian/unstable/amd64

vimer@njlab144:~/debci/mia/mia-2.4.7$ sudo incus image list
+-------+-------------+--------+-------------+--------------+------+------+-------------+
| ALIAS | FINGERPRINT | PUBLIC | DESCRIPTION | ARCHITECTURE | TYPE | SIZE | UPLOAD DATE |
+-------+-------------+--------+-------------+--------------+------+------+-------------+
```

一般来说, 刚刚删除的 incus 模板, 假设想再次并不会立即生效, 需要 -f 

```bash
vimer@njlab144:~/debci/mia/mia-2.4.7$ sudo debci setup --backend incus-lxc --suite unstable -f 
```

running the debci:

```bash
 sudo autopkgtest   --no-built-binaries   --timeout=30600   --timeout-factor=2   --apt-upgrade   --pin-packages=unstable=src
:libxml2   '--add-apt-source=deb-src http://mirrors.tuna.tsinghua.edu.cn/debian unstable main contrib non-free non-free-firmware d
eb http://mirrors.tuna.tsinghua.edu.cn/debian unstable main contrib non-free non-free-firmware'   --output-dir=/tmp/mia-autopkgtes
t   .   --   incus autopkgtest/debian/unstable/amd64 
```


以下信息有些过时了, 可以忽略了.
## autopkgtest-build-qemu

[wiki](https://wiki.debian.org/ContinuousIntegration/autopkgtest)

## 使用chroot
```bash
sudo autopkgtest --apt-upgrade ./xx.dsc -- schroot sid-riscv64-sbuild
```

## debci (online) backned
[here](https://ci.debian.net/doc/file.MAINTAINERS.html#label-How+can+I+reproduce+the+test+run+locally-3F)

```bash
1. $ sudo apt install debci autopkgtest lxc lxc-templates
2. sudo adduser YOUR_USERNAME debci
3. sudo debci setup   或者
sudo env debci_mirror=https://mirrors.tuna.tsinghua.edu.cn/debian debci setup(可选)
# 更新源，加速

```

其中， `lxc-templates` 尤为关键，否则会报找不到 `debian` template的错误。

还有一个快速验证 autopkgtest 的 命令:

```python
sudo autopkgtest-build-lxc debian testing riscv64
sudo autopkgtest file_5.38-4.dsc -- lxc autopkgtest-unstable-riscv64
```
running:

1. 源码：

```bash
$ autopkgtest --user debci --output-dir /tmp/output-dir . \
  -- lxc --sudo autopkgtest-unstable-amd64
```

其中`.`代表源代码的位置。
2. built debian package

```bash
autopkgtest --user debci --output-dir /tmp/output-dir \
  /path/to/PACKAGE_x.y-z_amd64.changes \
  -- lxc --sudo autopkgtest-unstable-amd64
```

可选 `--add-apt-source='deb https://mirror.iscas.ac.cn/debian/ sid main '`

3. 删除lxc的chroot

```bash
sudo lxc-destory autopkgtest-unstable-riscv64
```

4. 查看目前的 lxc chroot： 

```bash
ls /var/lib/lxc/ 
autopkgtest-unstable-riscv64
```

# debci riscv64 status

[britney's Job History ](https://ci.debian.net/user/britney/jobs?package=&trigger=&suite%5B%5D=unstable&arch%5B%5D=riscv64)

# autopkgtest(packaging)的一些用法

## warning
在autopkgtest中，原生的warning会被认为FAIL,所以我们在处理这样的情况时(没有warning最好)，可以使用
```bash
Restrictions: allow-stderr
```
进行约束解除。

## autopkgtest for experimential 
这里有一个页面展示了 experimential 的 autopkgtest 的情况 ：
https://release.debian.org/britney/pseudo-excuses-experimental.html

## delete lxc chroot

```python
sudo lxc-destroy -n autopkgtest-unstable-riscv64
```
