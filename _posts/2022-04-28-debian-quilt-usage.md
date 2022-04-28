---
title: debian quilt usage
category: debian-riscv
layout: post
---
* content
{:toc}

本篇文章根据[How to prepare patches for Debian packages](https://raphaelhertzog.com/2011/07/04/how-to-prepare-patches-for-debian-packages/)和[UsingQuilt](https://wiki.debian.org/UsingQuilt)整理而成。


quilt的历史非常悠久，具体可以追溯到Alro？（内核-mm tree的维护者）开发然后被应用到kernel开发中，所以说，Debian社区真的很厉害的。好了，废话不多说，直接说主题。

以下阐述是基于 `apt source src-pkg` 操作下进行的。`apt source xx`会自动apply patch根据package里面的配置文件。

# quilt基本配置
```bash
vimer@unmatched-local:~/04/rust-ring/rust-ring-0.16.9$ cat ~/.quiltrc
QUILT_PATCHES=debian/patches
QUILT_NO_DIFF_INDEX=1
QUILT_NO_DIFF_TIMESTAMPS=1
QUILT_REFRESH_ARGS="-p ab"
QUILT_DIFF_ARGS="--color=auto" # If you want some color when using `quilt diff`.
QUILT_PATCH_OPTS="--reject-format=unified"
QUILT_COLORS="diff_hdr=1;32:diff_add=1;34:diff_rem=1;31:diff_hunk=1;33:diff_ctx=35:diff_cctx=33"
d=. ; while [ ! -d $d/debian -a `readlink -e $d` != / ]; do d=$d/..; done
if [ -d $d/debian ] && [ -z $QUILT_PATCHES ]; then
        # if in Debian packaging tree with unset $QUILT_PATCHES
        QUILT_PATCHES="debian/patches"

        if ! [ -d $d/debian/patches ]; then mkdir $d/debian/patches; fi
fi
```

# quilt用法

## quilt用于产生新的patch
1. quilt push
```bash
quilt push -a # applying all patches onto the source code tree
```

2. Creating a New patch
```bash
quilt new xx.patch # 这个意思是新建一个xx.patch
```

3. Add file you want to change
```bash
quilt add xx # for example, README, *.c, It can add multi files
```

4. quilt refresh
```bash
quilt refresh # 更新xx.patch
```

5. Add descriptions of the patch
```bash
quilt header -e # edits the header in $EDITOR
```
6. Finish your editing
```bash
quilt pop -a # 退出所有的patch，包括刚才新建的patch
```
此时这个时候在 `debian/patches`目录下就会有了刚才我们命名为xx.patch的patch，以及在series文件中也有当前的patch.

## 修改存在的patch
比如说，我们的前一个patch没有解决问题，那应该怎么办？当然是在前一个patch的基础上去搞定，而不需要新建一个patch。

1. quilt push xx.patch
2. git add/modify files
3. quilt refresh

