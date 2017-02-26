---
title: "debian系统目录"
layout: article
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
我安装python的各种软件就放在这里了




