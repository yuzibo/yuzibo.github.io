---
title: "用libvirt安装debian"
category: tools
layout: article
---

这篇文章主要聚焦于debian系统，其他的linux发行版的用法应该是一致的。

# Setup
You start by installing the needed tools, So, on my debian:

```bash
sudo apt-get install libvirt-dev virtinst libvirt-daemon libvirt-daemon-system
```
如果没有找到相应的软件包，你可以尝试一下`apt-cache`命令。
(If you cant found these softwares, you can try it : apt-cache)
系统提示你缺少什么软件就安装什么软件。

```bash
sudo apt-cache search libvirt
```
你还可以使用通配符进行模糊查找。
(You can fuzzy search with wildcard)

Then you got a `libvirtd` process running on your machine:

```bash
yubo@debian:~/git$ sudo ps u -C libvirtd
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root     4470  1.4  0.7 787416 30212 ?        Ssl  20:38   0:00 /usr/sbin/libvi

```

The role of `libvirtd` is quite important. It takes care of managing the VMSrunning on your host.You can control it with command `virsh`.

# First few steps with libvirt

Before anything else, you should know that libvirt and `virsh` not only allow you to control VMs running on your own system, but can control VMs running on the remote systems or a cluster of physical machines. Every time you use `virsh`, With qemu,you need type it looks like:

```bash
qemu://xxx/system
qemu://xxx/session
```

I will introduce more details about virsh in another article,now i am focus on the libvirt-vms.

# Managing system VMS

Here, `libvirtd` is listening the command send to `/var/run/libvirt`,so you may add a credential user for libvirt, and you have opportunity to write socket, which needs a user to belong to the `libvirt` group.

If you edit `/etc/libvirt/libvirtd.conf`, you can configure libvirt to wait for a commands using a variety of different mechanisms, including for example SSL encrypted TCP sockets.

```bash
yubo@debian:~/git$ sudo usermod -a -G libvirt yubo

```

Add my user name into libvirt group.

# Defining a network

```bash
yubo@debian:~/git$ virsh -c qemu:///system net-list
 Name                 State      Autostart     Persistent
 ----------------------------------------------------------
```
This means that there are no active virtual networks, Try one more time adding `--all`:

```bash
yubo@debian:~/git$ virsh -c qemu:///system net-list --all
 Name                 State      Autostart     Persistent
 ----------------------------------------------------------
  default              inactive   no            yes

```

#### note

Now your network's is `default`.

And notice the default network, If you want to inspect or change the configure file of the network, you can use either `net-dumpxml` or `net-edit`


```bash

h -c qemu:///system net-dumpxml default
<network>
  <name>default</name>
  <uuid>e46e2c1b-5263-4428-b8fc-bfa4805a2ebc</uuid>
  <forward mode='nat'/>
  <bridge name='virbr0' stp='on' delay='0'/>
  <mac address='52:54:00:34:36:d3'/>
  <ip address='192.168.122.1' netmask='255.255.255.0'>
	<dhcp>
	  <range start='192.168.122.2' end='192.168.122.254'/>
	</dhcp>
  </ip>
</network>
```

I guess you could understand what is meaning above.Now your VM bridge name is virbbr0...

You can configure networking in many different ways, with nat, with bridging,with simple gateway fowarding... You can find all parameters [on the page](http://libvirt.org/formatnetwork.html).

And you can change the definition by using `net-edit`.

```bash
net-undefine default # forever eliminate the default network
net-define file.xml #to define a new network starting from an .xml file
#you can
virsh ... net-dumpxml default > file.xml
then edit and then
virsh ... net-define file.xml
```

# Starting and stopping networks

`net-start default`, to start the named `default` network
`net-destory default`, to stop the named `default`network,with the ability of starting it again in the future.

`net-autostart default`, to automatically start the default network at boot.

```bash
yubo@debian:~/git$ virsh -c qemu:///system net-start default
Network default started

yubo@debian:~/git$ ps aux | grep libvirt

root      4470  0.0  0.7 1377240 30292 ?     Ssl  20:38   0:00 /usr/sbi..
nobody    5155  0.0  0.0  52228   408 ?     S    21:40   0:00 /usr/sb..
root      5156  0.0  0.0  52200   408 ?  S   21:40   0:00 /usr/sbin/dnsmasq
----------------
yubo@debian:~/git$ sudo netstat -nulp
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address  Foreign Address State  PID/Program name
udp   0       0    192.168.122.1:53      0.0.0.0:*         5155/dnsmasq
udp  0        0     0.0.0.0:67           0.0.0.0:*          5155/dnsmasq
-----------------
yubo@debian:~/git$ sudo netstat -ntlp
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address Foreign Address  State PID/Program name
tcp   0      0      192.168.122.1:53   0.0.0.0:*   LISTEN     5155/dnsmasq
tcp   0      0       0.0.0.0:22        0.0.0.0:*   LISTEN      546/sshd

```

libvirt started `dnsmasq`, which is a simple dhcp server with ability to also provide DNS.So you can try:

```bash
yubo@debian:~/git$ ip address show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
    valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
    valid_lft forever preferred_lft forever
2: enp1s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast
state UP group default qlen 1000
      link/ether 94:c6:91:04:e6:91 brd ff:ff:ff:ff:ff:ff
      inet 222.195.244.235/24 brd 222.195.244.255 scope global dynamic
      enp1s0
      valid_lft 2670sec preferred_lft 2670sec
     inet6 fe80::96c6:91ff:fe04:e691/64 scope link
	            valid_lft forever preferred_lft forever
3: virbr0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue
state DOWN group default qlen 1000
   link/ether 52:54:00:34:36:d3 brd ff:ff:ff:ff:ff:ff
   inet 192.168.122.1/24 brd 192.168.122.255 scope global virbr0
   valid_lft forever preferred_lft forever
4: virbr0-nic: <BROADCAST,MULTICAST> mtu 1500 qdisc pfifo_fast master
virbr0 state DOWN group default qlen 1000
   link/ether 52:54:00:34:36:d3 brd ff:ff:ff:ff:ff:ff
```

you can use iptables to see what happened:

```bash
sudo iptables -nvL
&&
sudo iptables -t nat -nvL

```

# Managing storage

Now we have a network running for our VMs,we need to worry about storage.This is similar to lvm, On this article, i just dedicated a directory  to storing images and volums.

But, you should mdkir needed dir with

```bash
sudo mkdir -p /opt/kvms/pools/devel
```
and try it:

```bash
yubo@debian:~$ virsh -c qemu:///system \
		> pool-define-as devel \
		> dir --target /opt/kvms/pools/devel
		Pool devel defined

```

Here, we create a pool called devel in a directory , we can see this pool with:

```bash
yubo@debian:~$ virsh -c qemu:///system pool-list --all
 Name                 State      Autostart
 -------------------------------------------
  devel                inactive   no

```
`--all` as before, now we need to start it automatically with command:

```bash
yubo@debian:~$ virsh -c qemu:///system pool-autostart devel
Pool devel marked as autostarted

```
and start it with(must):

```bash
yubo@debian:~$ virsh -c qemu:///system pool-start devel
```

And you can see it again:

```bash
yubo@debian:~$ virsh -c qemu:///system pool-list --all
 Name                 State      Autostart
 -------------------------------------------
  devel                active     yes

```
To create and manage volumes, you can use `vol-create`,`vol-delete`,`vol-resize`,all the `vol-*` can be used.

For examole:

```bash
yubo@debian:~$ virsh -c qemu:///system vol-list devel
 Name                 Path
 ------------------------------------------------------

```


# Installing a virtual machine

With `virt-install`

```bash
yubo@debian:~$ virt-install -n debian-9 --ram 2048 --vcpus=2 \
--cpu=host -c ~/software/debian-9.1.0-amd64-xfce-CD-1.iso \
--os-type=linux --os-variant=debian \
--disk=pool=devel,size=10,format=qcow2 \
-w network=default --graphics=vnc
```

You must use `sudo` command to execute the command,next, you will enter into linux's installing procession.

`-n` just a name.

`-c` is your debian-iso where it is located. Remember here, you just define a pool named devel, however, you not have 'create it'

`--disk=pool=devel,size=10,format=qcow2` means it have 10GB space disk to support your VMs.



# Managing a vitual machine
This is my first wrong step to try it.I missed it.

After installing VMs, you would better to use `virt-viewer` to start it.

Frist,you can start it with virsh:

```bash
virsh start my-vms #my vms-name is debian-9 or:
virsh autostart my-vms # debian-9.
```

So, you type `virsh` into virsh's world.

```bash
yubo@debian:~$ sudo virsh
[sudo] yubo 的密码：
Welcome to virsh, the virtualization interactive terminal.

Type:  'help' for help with commands
       'quit' to quit

       virsh # list
        Id    Name                           State
	----------------------------------------------------
	 8     debian-9                       running

```

Remember, you use it with sudo.Here, you can see your vms's  id is 8,

# how to start vm with virsh
Again, your vm-id is 8,so next:

```bash
sudo virt-viewer --connect qemu:///system 8

```

Congratulations! Enjoy it:)


# 后记
For example, when you in trouble reboot the virtual machine,how to do?
In my case, after shutdown the system installed, now i want to reboot,
But, the libvirt warn me: failed to match domain "".I don't' know to do.
Until i have googled: first, use `define` to edit the configure file with XML type.Yes, when you installed a system, you will get a XML file in /etc/libvirt/qemu/(or somewhere). My way to slove the problem is `cp` the xml file to a directory and then `sudo virsh define xx.xml`.If get any errors you can disappear it according to hints.

I will post a new blog to show how to resize the pool size in KVMS.See you!
