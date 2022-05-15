---
title: 使用  gbp 维护 jimtcl -- patch制作 签名 上传
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

## patch管理

[摘自这里](https://blog.hosiet.me/blog/2016/09/15/make-debian-package-with-git-the-canonical-way/)

gbp pq使用一个特殊的 Git 分支管理补丁：patch-queue/[base-branch-name]。它存储名字为[base-branch-name]的打包分支对应的补丁。请看下面几个应用实例：

最简单滴是使用如下命令创建:

```bash
gbp pq import
```
场景一:
如果以前没有补丁，这句话会创建一个与当前工作分支完全等效的分支，其名称为patch-queue/[base-branch-name]。如果以前有补丁，这些补丁会自动形成 Git 提交。不放心的话，检查一下 Git 提交历史，确认一下以前的补丁已经成功导入。

我必须在这里说一句，如果你已经有了patch-queue/[base-branch-name]这样名称的分支的话——gbp pq import这句命令是不行的，你也许要用到gbp pq rebase。但是这样会大大复杂化工作流程。我的建议是：初始化之前，干掉patch-queue分支，稍后重建也不迟。嗯，一切为了优雅和简单。

嗯？下面该干什么？下面就是开发补丁的时间！修改你想要修改的东西，在这个特殊的分支上像日常开发那样做 Git 提交，无论是自己修改做新的提交还是cherry-pick已经存在的提交都可以。注意事项有以下几点：

1. 时刻牢记，每一个提交就是一个补丁，控制好各个提交之间的关系。
2. 请认真填写 Git 提交的标题和日志信息。这些信息会成为自动生成的补丁的一部分。
3. 尽量减少各个提交之间的耦合程度。
4. 和打包工作流的原则相反，千万不要修改debian/目录下的文件。原因我想大家都可以理解。
5. 如果你确信该打的补丁都在这个分支上体现了，请进入场景二继续工作。

场景二：在patch-queue上开发完成，导出补丁至原打包工作分支
接着上面的工作，我们仍然位于patch-queue/[base-branch-name]这个特殊 Git 分支上。运行一行命令：

gbp pq export
即可。这样会自动回到打包工作分支上，同时将刚才的工作成果自动导出，debian/patches目录下的文件得到了自动的修改。大功告成！

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

debsign的设置需要去看看tools的gpg使用方法。debsign的配置文件在 `~/.devscripts`文件中，具体配置如下：
```bash

```

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

# RFS
Requestion for Sponsorship

## 可以直接看PTS的模板(推荐新手)

## reportbug

```bash
reportbug sponsorship-request --mutt
```
可以加mutt使用mutt  client。