---
title:  ovs install process
category: sdn
layout: post
---
* content
{:toc}

# 对内核源代码有要求？
是的，目前，最新的(2.11.X)不支持4.18以上的版本，这个要求有点扯啊，还好，自己可以指定版本并编译内核镜像。

# 安装后的启动
 The ovs needs the ovsdb, ovs-vswitchd, ovs-vsctl, but both of them will be closed by default after shutting down computer
 [stackoverflow](https://stackoverflow.com/questions/28506053/open-vswitch-database-connection-failure-after-rebooting)

如果你没有指定安装目录，那么：

```c
yubo@debian:~$ ovs-vsctl add-br ovs-switch
ovs-vsctl: unix:/usr/local/var/run/openvswitch/db.sock: database connection failed (No such file or directory)
```
上面的脚本位于:

```c
sudo find / -name ovs-ctl
/usr/local/share/openvswitch/scripts/ovs-ctl
^C
yubo@debian:~/git/ovs$ sudo /usr/local/share/openvswitch/scripts/ovs-ctl start
```
并且最好形成自己的脚本:

```bash
#!/bin/bash
ovsdb-server --remote=punix:/usr/local/var/run/openvswitch/db.sock \
                     --remote=db:Open_vSwitch,Open_vSwitch,manager_options \
                     --private-key=db:Open_vSwitch,SSL,private_key \
                     --certificate=db:Open_vSwitch,SSL,certificate \
                     --bootstrap-ca-cert=db:Open_vSwitch,SSL,ca_cert \
                     --pidfile --detach
ovs-vsctl --no-wait init
ovs-vswitchd --pidfile --detach
```
