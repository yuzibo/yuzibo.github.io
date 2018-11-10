---
title: "debian系统目录"
layout: post
category: debian
---

# 系统目录

这个就不用具体讲了，系统的调用就是寻找这个值。

	echo $PATH

	/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games

这个是我的值，具体添加路径是，我找找看哈：

```bash
# set PATH so it includes user s private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
EDITOR=vim; export EDITOR
```

你想使用或者需要改变这个值，就仿照上面的代码去改动，最后别忘了

	source .profile

# /usr/local/bin/
我安装python的各种软件就放在这里了, 如果在安装时不指定目录时默认安装在这里。
所有的可执行文件都放在这里，

但是，如果我在``./configure --prefix=/usr``时，这样产生的可执行文件位于/usr/bin.看来默认就是--prefix=/xx/bin中。

# /usr/bin
除了在配置编译的时候指定/usr目录，通过系统包管理器产生的文件如apt(debian)
安装的文件也会位于这个目录。(有一点很奇怪，就是./configure是默认也会在此目录下)
在我的印象中，使用源码安装的程序应该位于/usr/local/bin中。


# /usr/sbin
这个s就是systemd的意思，这个是系统管理程序。
