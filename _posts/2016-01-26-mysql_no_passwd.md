```
layout: article
title: "mysql每次不用密码登录的方法"
category: mysql
```

#
在主目录下写成一个名为
.my.cnf的文件，将下面的内容填入其中

```mysql
[mysql]
user=user
password=pass
[mysqladmin]
user=user
password=pass
```
