---
layout: article
title: "git追踪linux kerenl技巧"
category: git
---
转载(http://larmbr.me/2013/10/27/Git-for-linux-tips-for-tracking-code-history/#top)
##查看某次提交
	git show <commit Id/revsper>
##查看某个版本的代码库,下面命令中的"<>"去掉
	git checkout -b <分支名> <某个版本>
##追踪特定文件的变化记录
	git log --follow <文件名>
1.详细了解一个文件的修改过程
2.从最后提交的日期来看该代码的开发热度，对于不稳定的代码可以略读，对于稳定的代码可以详读。
##追踪文件内容的变化历史
	git blame -C -L <start>,<end> <文件名>
     该命令可以小到行的__粒度__来了解代码的变化历史, -C选项可以追踪某行代码之前是位于哪个文件中的, -L选项则是选定行范围, 这样对于很大的文件, 对整个文件运行该命令可能会比较久, 指定感兴趣的行范围可以缩短时间。这两个选项都是可选的。

使用场景:

该命令会输出每一行引入的时间, 作者, commit ID, 有了这些信息, 或者用git show命令阅读作者引入时的提交信息, 了解该改动的原因和做法; 或者, 利用这些信息, 加上lkml关键字, 用Google搜索邮件列表存档, 更深入了解当时开发者们对这一变动的所解决的问题, 解决方法的讨论。
##确定某次变化是哪次提交引入的
	git bisect start HEAD <oldVersion> --no-checkout
	git bisect run sh -c 'git show BISECT_HEAD:<path that include the struct in file > 
	grep -q "struct <struct name>"'

第一条命令，指定了查找的范围，--no-checkout 表示对于每一次检查，不检出当前版本库，加快检索速度。

当这两条命令运行结束后，引入变化的提交就被找到了，然后再利用git show命令查看更加详细的变化原因。
##创建新分支
Create a new branch called "first-patch", and checkout that branch by running:

	git checkout -b first-patch

只能初次使用
	


##删除一个分支

	git branch -D temp

##查看有目前目录有多少分支

	git branch

在内核中应该多建立分支,这样是工作不至于太乱

	git branch -a

查看远方版本库的目前使用的分支
##Update your kernel

	git fetch origin 

与原来的版本库标定

