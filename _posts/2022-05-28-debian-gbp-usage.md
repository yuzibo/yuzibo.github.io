---
title: debian gbp用法
category: debian-riscv
layout: post
---
* content
{:toc}

# import
这里有很多import的场景：

## debian 没有
对于新包来说，需要新建一个repo，创建各个分支，详情可以参考python package notes,这个需要 one by one的去做.

## debian有

### gbp import-dsc .dsc
最好使用dsc 这个选项:
```bash
gbp import-dsc --upstream-branch=upstream/latest --debian-branch=debian/main --verbose ../libunwind_1.3.2-2.dsc --pristine-tar
```

### gbp import-orig
```bash
gbp import-orig --debian-branch=debian/main --upstream-branch=upstream/latest
```


# gbp build

使用 gbp 带sbuild去编译debian package的方法如下 ：

```bash
 gbp buildpackage  --git-builder=sbuild --git-debian-branch=debian/main  --git-upstream-tree=upstream --git-pristine-tar-commit  --git-ignore-new --git-export-dir=/tmp/build-area/jimtcl   --git-verbose
```

需要  `.sbuildrc`的配合:

```bash
# -d
$distribution = 'unstable';
# -A
$build_arch_all = 1;
# -s
$build_source = 1;
# --source-only-changes (applicable for dput. irrelevant for dgit push-source).
$source_only_changes = 1;
# -v
$verbose = 1;
# parallel build
$ENV{'DEB_BUILD_OPTIONS'} = 'parallel=5';
##############################################################################
# POST-BUILD RELATED (turn off functionality by setting variables to 0)
##############################################################################
$run_lintian = 1;
$lintian_opts = ['-i', '-I'];
$run_piuparts = 1;

# 暂时停用 piuparts 检查
#$piuparts_opts = ['--schroot', 'unstable-amd64-sbuild', '--no-eatmydata'];
$run_autopkgtest = 1;
$autopkgtest_root_args = '';
$autopkgtest_opts = [ '--', 'schroot', '%r-%a-sbuild' ];

```

## 另一个可用编译选项
```bash
 gbp buildpackage  --git-builder=sbuild --arch=riscv64 -d sid  --source --git-debian-branch=debian/main --git-export-dir=../rush-build-area/  --git-ignore-new --verbose
```
不用顾虑上游源代码。

## issues

### gbp:error: upstream/22.06 is not a valid treeish

这种情况是，直接clone salsa后，里面只有一个`debian/`目录。例如 [neochat](https://salsa.debian.org/vimerbf-guest/neochat), 当clone下来之后，如果按照上面的命令进行编译，会遇到上面的issue:
```bash
gbp:error: upstream/22.06 is not a valid treeish
```
解决方案就是使用本地的upstream tarball代替upstream分支。


```bash
uscan --force-download
gpgv: Signature made Fri Jun 24 14:41:11 2022 UTC
gpgv:                using RSA key B3CB366552540BE06EE9AD9711968C44928CAEFC
gpgv: Good signature from "Bhushan Shah (mykolab address) <bshah@mykolab.com>"
gpgv:                 aka "Bhushan Shah <bhush94@gmail.com>"
gpgv:                 aka "Bhushan Shah (kde) <bshah@kde.org>"
Successfully symlinked ../neochat-22.06.tar.xz to ../neochat_22.06.orig.tar.xz.

# 直接使用下载好tarball
gbp buildpackage --git-tarball-dir=../   --git-builder=sbuild -d unstable  --git-debian-branch=debian/main --git-export-dir=../build-area/ --git-ignore-new  --verbose
```
# import

## import upstream
```bash
gbp import-orig --uscan --debian-branch=debian/main --upstream-branch=upstream/latest
```

## import tar

```bash
 gbp import-orig --verbose --upstream-branch=upstream/latest --upstream-version=2.2 ../v2.3.2.tar.gz
```
