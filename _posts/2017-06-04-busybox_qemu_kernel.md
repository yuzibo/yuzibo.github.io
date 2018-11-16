---
title: "qemu,busybox调试linux kernel"
category: tools
layout: post
---

* content
{:toc}

# 安装自己编译的内核

基本上这篇[文章](http://www.cnblogs.com/senix/archive/2013/02/21/2921221.html)就够了。

### 1 安装busybox

下载busybox源码，进行安装。最好使用git，这样可以进行最新的跟踪。

https://busybox.net/source.html

配置busybox,你可以使用 `make menuconfig`命令。这里，有几点是需要我们注意的。

因为Linux运行环境当中是不带动态库的，所以必须以静态方式来编译BusyBox。修改

1. Busybox Settings --->
     Build Options --->
         [*] Build BusyBox as a static binary(no shared libs)

2. CONFIG_DESKTOP=n

不需要配置DESKTOP。

```bash
make
make install
```

这样安装完成后，在busybox目录下有个_install目录，这里面就是创造root fs的源代码。


3. 建立initial ramdisk



```bash
mkdir initramfs
cd initramfs
mkdir -pv bin lib dev etc mnt proc root sbin sys tmp

cd dev
sudo mknod ram0 b 1 0  # all one needs is ram0
sudo mknod ram1 b 1 1
ln -s ram0 ramdisk
sudo mknod initrd b 1 250
sudo mknod mem c 1 1
sudo mknod kmem c 1 2
sudo mknod null c 1 3
sudo mknod port c 1 4
sudo mknod zero c 1 5
sudo mknod core c 1 6
sudo mknod full c 1 7
sudo mknod random c 1 8
sudo mknod urandom c 1 9
sudo mknod aio c 1 10
sudo mknod kmsg c 1 11
sudo mknod sda b 8 0
sudo mknod tty0 c 4 0
sudo mknod ttyS0 c 4 64
sudo mknod ttyS1 c 4 65
sudo mknod tty c 5 0
sudo mknod console c 5 1
sudo mknod ptmx c 5 2
sudo mknod ttyprintk c 5 3

ln -s ../proc/self/fd fd
ln -s ../proc/self/fd/0 stdin # process i/o
ln -s ../proc/self/fd/1 stdout
ln -s ../proc/self/fd/2 stderr
ln -s ../proc/kcore     kcore
cd ..

```
[file](https://github.com/yuzibo/configure_file/blob/master/busybox/exe.sh)
最后一条命令返回到了主目录，然后将busybox文件下的_install文件复制到initramfs的主目录下。

由于我们已经将busybox构建为一个静态的库(static libs), 原作者所说的加载动态库的步骤已经不需要了。

然后在initramfs文件夹下面新建init文件，这个文件是kernel启动后的第一个文件。

```bash
#!/bin/sh
/bin/mount -t proc none /proc
/bin/mount -t sysfs sysfs /sys
/sbin/mdev -s
/sbin/ifconfig lo 127.0.0.1 netmask 255.0.0.0 up
/sbin/ifconfig eth0 up 10.0.2.15 netmask 255.255.255.0 up
/sbin/route add default gw 10.0.2.2

echo 'Enjoy your Linux system!'

/usr/bin/setsid /bin/cttyhack /bin/sh
exec /bin/sh
```
[file](https://github.com/yuzibo/configure_file/blob/master/busybox/init)

最后，将init文件执行以下：

```bash
chmod 755 init
find . -print0 | cpio --null -ov --format=newc > ../myinitrd.cpio
```

4. 编译内核

对于编译内核，这里不会陌生，我看到这里的原作者编译进去了这些。

CONFIG_64BIT=y
CONFIG_EMBEDDED=n
CONFIG_PRINTK=y
CONFIG_PCI_QUIRKS=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=/pathto/myinitrd.cpio
CONFIG_BLOCK=y
CONFIG_SMP=y
CONFIG_PCI=y
CONFIG_MTTR=y
CONFIG_BINFMT_ELF=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_EXT2_FS=y
CONFIG_INOTIFY_USER=y
CONFIG_NET=y
CONFIG_PACKET=y
CONFIG_UNIX=y
CONFIG_INET=y
CONFIG_WIRELESS=n
CONFIG_ATA=y
CONFIG_NETDEVICES=y
CONFIG_NET_VENDOR_REALTEK=y
CONFIG_8139TOO=y
CONFIG_8139CP=y (unchecked all other Ethernet drivers)
CONFIG_WLAN=n
CONFIG_DEVKMEM=y
CONFIG_TTY=y
CONFIG_TTY_PRINTK=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_SYSFS=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y



尤其注意这里：

CONFIG_INITRAMFS_SOURCE=/pathto/myinitrd.cpio

这个路径是不能空缺的，否则内核是编译不过去的。
最后可以执行

make

命令来生成bzImage镜像。

5. 启动镜像

执行命令，

```bash

qemu-system-x86_64  -kernel /path-to/bzImage -initrd /path-to/myinitrd.cpio
-append "root=/dev/ram0 rootfstype=ramfs init=init console=ttyS0"
-net nic,model=rtl8139 -net user  -net dump -nographic

```

我这里没有打开smp设置，原文章上有的。

就可以打开qemu模拟器了。

[参考](https://techblog.lankes.org/2015/05/01/My-Memo-to-build-a-custom-Linux-Kernel-for-Qemu/)


# 后记

下面的代码是针对[这篇文章](http://www.aftermath.cn/qemu_debug_debian.html)


打开qemu终端，缺点是不能复制。

```bash
qemu-system-x86_64 -kernel arch/x86/boot/bzImage \
-initrd ~/initramfs/rootfs.img.gz \
-append "root=/dev/ram rdinit=sbin/init noapic"
```
改进一下：

```bash
hehe
```

## 配置网络

```bash
ifconfig lo 127.0.0.1
route add -net 127.0.0.0 netmask 255.255.255.0 lo
ifconfig eth0 192.168.10.0
route add -net 192.168.10.0 netmask 255.255.255.0 eth0
```




