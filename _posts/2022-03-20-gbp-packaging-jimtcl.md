---
title: 使用  gbp 维护 jimtcl -- 签名 上传
category: debian-riscv
layout: post
---
* content
{:toc}

jimtcl是我第一个ITP的package，目前的spononer已经被拒绝，我得重新整理一下才能进行upload。

# fork
就是在salsa上直接fork到自己下面来。

请注意，所有打包相关的提交不得修改除debian/目录以外的任何文件和文件夹。如果有必要进行修改，请将其作为补丁存放在debian/patches目录下面，具体格式请参阅前文提及的新维护人员手册中有关quilt的内容、DEP-3以及下文提到的gbp pq的使用

# 操作流程

```bash
vimer@debian-local:~/git/jimtcl/jimtcl$ git branch
* debian/main
```

然后按照提示建立分支，如果远程分支已经有的，可以使用 `git checkout `直接branch出来。

## 手动修改install
因为这些文件涉及到升级了，所以得手动修改。


## 手动打tag
打tag的时机也非常关键，下面是推送特定的tag:

首先checkout到你想打tag的分支，然后:

```bash
git tag debian/0.81
```
推送: 

```bash
git push origin upstream/0.81
```
## dpkg-buildpackage

如果因为种种原因，暂时无法使用`sbuild`去构建，那么只能使用下面的命令暂时规避下：

```bash
dpkg-buildpackage -us -uc
```

## lintian检查

```bash
lintian -i 
```

## Sign the package

```bash
debsign jimtcl_0.81+dfsg0-1_amd64.changes // 还有一个source.changes
```
然后就需要输入密码了，一定不要忘记gpg的密码。

debsign的设置需要去看看tools的gpg使用方法。

## dput上传文件(mentors)

```bash
 dput mentors jimtcl_0.81+dfsg0-1_amd64.changes
```
这两步一定是同时进行的。需要完整的写一篇有关于dput的文章。

这里有一个配置文件需要注意的:

```bash
vimer@debian:~/build_test/jimtcl$ cat ~/.dput.cf
[mentors]
fqdn = mentors.debian.net
incoming = /upload
method = https
allow_unsigned_uploads = 0
progress_indicator = 2
# Allow uploads for UNRELEASED packages
allowed_distributions = .*
```

然后再去mentors网站就可以看见你上传的包了。