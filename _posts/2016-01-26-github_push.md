---
title: "在github上每次push输入用户/密码&&编辑器&&补全"
layout: post
category: git
---
在github上每次push要求输入密码和用户名着实烦恼,那么,怎么样可以不用这样呢
* content
{:toc}


### linux

以前我好像是用的ssh的方法,需要密钥,现在明白了github的网站推荐使用https,
所以,暂时以https为主,其他的以后慢慢琢磨.可以在_本地主目录_新建`.netrc`输入以
下内容:

```c
machine github.com
login <user>
password <password>
```
### windows

真不容易，搞了很久才搞定。首先，你先设定HOME的环境变量，最好全局的，然后把
`_netrc`文件放到你设定的HOME文件夹里，然后再克隆下来就方便了。

## 加密
这个先不讨论了。

## 警告
所有的git使用的话必须首先`fetch origin`,再开发，否则很容易产生冲突

# 设置编辑器

>git config --global core.editor vim

# 设置默认语言

因为有些时候新安装的git默认使用的系统语言，导致不方便，所以，有必要修改默认

编辑系统配置文件 .profile

的语言。

```bash
alias git='LANG=en_US git'
```

并`source .profile`一下就可以了。

# 补全git命令

如果让git能够自己补全命令的话，效率非常的高

方法是将git源代码目录中`git/contrib/completion/git-completion.bash`这个文件放到用户主目录下。然后使用`source .git-completion.bash`即可。

我把配置文件放在了[github](https://github.com/yuzibo/configure_file/blob/master/git/.git-completion.bash)




