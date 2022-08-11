---
title: debian gbp用法
category: debian-riscv
layout: post
---
* content
{:toc}


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

# import

## import upstream
```bash
gbp import-orig --uscan --debian-branch=debian/main --upstream-branch=upstream/latest
```

## import tar

```bash
 gbp import-orig --verbose --upstream-branch=upstream/latest --upstream-version=2.2 ../v2.3.2.tar.gz
```