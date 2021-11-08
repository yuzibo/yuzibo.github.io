---
title: windows与linux共享文件之samba
category: tools
layout: post
---
* content
{:toc}

#
o以下操作仅针对debian系。

# 0x0 安装
 `sudo apt install samba`

# 配置
 在samba的系统配置文件`/etc/samba/smb.conf`中， 添加以下内容：
 ```bash
 [share]
 path = /home/vimer/pic
 public = yes
 writable = yes
 valid users = vimer
 create mask = 0644
 force create mode = 0644
 directory mask = 0755
 force directory mode = 0755
 available = yes
 ```

配置文件修改完成后，需要使用smbpasswd命令去添加smb的用户，使用手工创建smb
用户的方式是不正确的。

参考 https://blog.csdn.net/qq_29129381/article/details/106826108

```bash
service smb start # 来开启服务
smbpasswd -a XXX # 来增加用户名密码
smbpasswd -e xxx # 启用用户名
service smb restart # 重启服务
service iptables stop # 关闭防火墙
```
注意， debian中使用smbd。

# 重启
 `sudo service smbd restart` 注意这里的`smbd`因为这个耽误自己很长时间的。

# 应用
 在windows中可以在文件管理器
 `\\ip\dir`,其中dir就是上面配置文件中的设置的分享路径别名，比如，我的上面就是 share.

# 场景
 哈哈  第一个就是   sublime  open-> file folder

