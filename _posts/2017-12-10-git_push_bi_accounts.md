---
title: "一台电脑绑定两个github账号"
category: git
layout: post
---

![截图_2018-01-09_13-15-15.png](http://yuzibo.qiniudn.com/截图_2018-01-09_13-15-15.png)

在一台电脑上管理两个github账号，需要大家做以下步骤.

# 一、生成两个SSH Key
比如说，你有一个126的邮箱和一个gmail邮箱，名字分别取x和y.在.ssh/目录下使用下面的命令：

```bash
ssh-keygen -t rsa -C "x@126.com"

ssh-keygen -t rsa -C "y@gmail.com"
```

在键入第一条命令的时候，不要一路回车，需要你重命名一下，可以直接以*id_rsa_x*和*id_rsa_y*来命令，第二个提示框可以按回车直接进行下一步。这样就会生成四个文件:

```bash
id_rsa_x.pub      id_rsa_y.pub
id_rsa_x          id_rsa_y
```
上面以\*.pub结尾的文件需要你填入你的两个github上面的设置的*ssh key and gpg*

![2.png](http://yuzibo.qiniudn.com/2.png)

单击上面的*New ssh Key*,把pub文件的内容填入对应的ssh的对应框。

# 二、添加私钥

1. 打开ssh-agent

```bash
ssh-agent -s
```

2. 添加私钥

```bash
ssh-add ~/.ssh/id_rsa_x

ssh-add ~/.ssh/id_rsa_y
```

# 三、创建config文件

```bash

	Host x.github.com
	hostName github.com
	PreferredAuthentications publickey

	IdentityFile ~/.ssh/id_rsa_x

	User x

Host y.github.com
HostName github.com
User y
IdentityFile ~/.ssh/id_rsa_y
```

# 四、远程测试

```bash
ssh -T x.github.com

ssh -T y.github.com
```

# 五、克隆并设置git的配置文件

将你的项目_clone_到本地，

```bash
git clone git@github.com:wahtever
```

还有一个重要的问题就是你的git配置文件大部分都设置为了全局文件，那么就要设置新的config文件，这是针对你的项目而言的。

```bash
# 取消全局　用户名/邮箱　配置,下面的user.name是你的原来的真实名字
git config --global --unset user.name
git config --global --unset user.email

#为每个repo设置不同的　用户名/邮箱
git config user.email "x@x.com"
git config user.name "x"
```

# 重建origin

```bash
git remote rm origin
git remote add origin git@ieit.github.com:whatever

# 重新push

git push origin master
```

Enjoy!




