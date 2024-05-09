---
layout: post
title: "dev-ops tool ansible"
category: tools 
---

# 运维管理工具
ansible doc： https://erdong.site/ansible-notes/ch01/1.3-ansible-config.html
实战： 
首先，编辑或者创建 /etc/ansible/hosts 文件，用来存放远程主机的信息。你的公钥应该在这些机器的 authorized_keys 。您可以通过编辑/etc/ansible/ansible.cfg或~/.ansible.cfg来实现:
更简洁的可以参考这里： https://blog.51cto.com/395469372/2133486    

1. ping

```bash
 ansible all -m ping
```

2. 初次安装的系统使用密码登录的方式可以参考：

https://blog.csdn.net/Shyllin/article/details/123690458

3. 本地上传文件：
```bash
sible all -m copy -a "src=/home/vimer/ansible/pubkey.debian-ci dest=/home/debian/"
```

4. 执行命令：
```bash
ansible all -m shell -a "chmod +x /home/debian/add-user.sh"
```

4.1 sudo 命令：
```bash
debci-23 ansible_user=debian ansible_password="xx" ansible_ssh_user="xx" ansible_become_pass="xx"
```
a. 远程关机： 
```bash
ansible all -m shell -a "poweroff" -become=true
```

b.  远程修改文件属性: 
```bash
ansible all -m shell -a "usermod -aG sudo vimer" -become=true
```
