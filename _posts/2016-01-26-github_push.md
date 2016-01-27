---
titlei: "在github上每次push输入用户名和密码的问题"
layout: article
category: git
---
在github上每次push要求输入密码和用户名着实烦恼,那么,怎么样可以不用这样呢
#https
以前我好像是用的ssh的方法,需要密钥,现在明白了github的网站推荐使用https,所以,暂时以https为主,其他的以后慢慢琢磨.可以在本地主目录新建`.netrc`输入以下内容:
``` c
machine github.com
	login <user>
	password <password>
```
