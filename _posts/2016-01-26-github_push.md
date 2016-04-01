---
title: "在github上每次push输入用户名和密码的问题"
layout: article
category: git
---
在github上每次push要求输入密码和用户名着实烦恼,那么,怎么样可以不用这样呢

# linux

以前我好像是用的ssh的方法,需要密钥,现在明白了github的网站推荐使用https,
所以,暂时以https为主,其他的以后慢慢琢磨.可以在_本地主目录_新建`.netrc`输入以
下内容:

```c
machine github.com
	login <user>
	password <password>
```
# windows

真不容易，搞了很久才搞定。首先，你先设定HOME的环境变量，最好全局的，然后把
`_netrc`文件放到你设定的HOME文件夹里，然后再克隆下来就方便了。

# 加密
这个先不讨论了。

# 警告
所有的git使用的话必须首先`fetch origin`,再开发，否则很容易产生冲突
