---
title: "用户自动登录的解决方案"
category: shell
layout: post
---



# 主要解决的是 ssh telnet

最近登录的机器特别多,所以想点力气，这个问题目前有以下几个方案：

## expect

使用这个命令工具可能简单一些，但不是最好的方案，

```bash
#!/usr/bin/expect

spawn ssh user@host_ip
expect "password"
send "your_passwd\r"

interact
```

这里你必须注意一点，expect的基本用法，expect好比grep的功能，它
捕捉从屏幕上输出含有后面的引号内字符后面的缓冲区，接下来的send命令，
就是将输入缓冲区的字符去掉换行符后发给了expect的接受区。能完全可以使用
`set passwd xx`的形式，使用`$xx\r`就行了。

## sshpass

首先安装sshpass这个软件。

接下来可以使用这个脚本：

```bash
sshpass -p "passwd" ssh -o StrictHostKeyChecking=no your_name@host_ip

```


# 如果使用telnet的话

```bash
#!/usr/bin/expect -f

set user czzzht
set password mptczzzht
set timeout -1
set host 10.1.5.11

spawn telnet $host
expect "*ogin:*"
send "$user\r"
expect "*assword:*"
send "$password\r"

interact


```




参考文章：

[1](http://unix.stackexchange.com/questions/31071/shell-script-for-logging-into-a-ssh-server)

[2](http://stackoverflow.com/questions/12202587/automatically-enter-ssh-password-with-script)




