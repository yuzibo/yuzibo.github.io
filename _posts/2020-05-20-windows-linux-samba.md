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

 然后在`/etc/samba/smbpasswd`(没有的话可以新建) 直接输入上述条目中`valid users`的密码即可。

# 重启
 `sudo service smbd restart` 注意这里的`smbd`因为这个耽误自己很长时间的。

# 应用
 在windows中可以在文件管理器
 `\\ip\dir`,其中dir就是上面配置文件中的path（相对路径就可以），这里的dir就可以设置为pic。
 接着输入用户名和密码即可

# 场景
 哈哈  第一个就是   sublime  open-> file folder

