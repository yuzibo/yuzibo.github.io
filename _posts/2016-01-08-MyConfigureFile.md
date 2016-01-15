---
title: 我的配置文件(java,tomcat)
layout: article
category: configure
---
#java
下载完JDK包后,路径配置我放到了 /etc/profile

export JAVA_HOME=/home/yubo/java/jdk1.8.0_31

export PATH=$PATH:$JAVA_HOME/bin
#tomcat
export CATALINA_HOME=~/apache-tomcat
export CLASSPATH=:$JAVA_HOME/lib:$CATALINA_HOME/lib
export PATH=$PATH:$CATALINA_HOME/bin
export PATH=E$
#生效 /etc/profile

	source /etc/profile

不要sudo
#更新,
经测试,这个是[可靠](http://blog.csdn.net/zhuying_linux/article/details/6583096)的
开启tomcat:
yubo@debian:~/apache-tomcat/bin$ ./catalina.sh start
那么关闭应该是同样的情况
#mysql字符问题
[这里](http://stackoverflow.com/questions/3513773/change-mysql-default-character-set-to-utf-8-in-my-cnf),而且要把已经建立的数据库删除才行.

```c
int main()
{
	printf("hello,world!\n");
}
```


