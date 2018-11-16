---
layout: post
title: "mysql忘记root密码"
category: mysql
---

* content
{:toc}

# 忘记root密码 

1. 停止mysqld； 

`
/etc/init.d/mysql stop
`

(您可能有其它的方法,总之停止mysqld的运行就可以了)

2. 用以下命令启动MySQL，以不检查权限的方式启动； 

`mysqld --skip-grant-tables &`

3. 然后用空密码方式使用root用户登录 MySQL； 

`mysql -u root

4. 修改root用户的密码； 

```mysql
mysql> update mysql.user set password=PASSWORD('newpassword') where User='root'; 
mysql> flush privileges; 
mysql> quit
```
 <br>尤其注意这里的格式，你必须保没有警告。</br>
重新启动MySQL

`/etc/init.d/mysql restart`

就可以使用新密码 newpassword 登录了。

