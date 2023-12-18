---
title: versionfive2 upstream 初体验
category: debian-riscv
layout: post
---
* content
{:toc}

---

# 1 构建 vf2 主线kernel
源码目录:
https://github.com/yuzibo/vf2-linux

使用 vf2 开头的分支，首先交叉编译出相应的 kernel riscv64 的 deb 包。 配置可以使用 `debian_defconfig`

或者你可以直接使用 `prebuilt image ` download from [here](https://github.com/yuzibo/vf2-linux/actions)

# 2 构造 rootfs

3.  debootstrap rootfs
```bash
sudo debootstrap --arch=riscv64  unstable /tmp/riscv64-chroot http://mirrors.tuna.tsinghua.edu.cn/debian/
```

4. 配置 debian rootfs
```bash
sudo systemd-nspawn -D /tmp/riscv64-chroot/ -M debian --bind-ro=/etc/resolv.conf
apt update
apt upgrade
apt-get install initramfs-tools openssh-server systemd-timesyncd rsync bash-completion u-boot-menu
```

4.0 安装 kernel

这里有2种方式安装 kernel, 一种是自己构建，一种是使用 prebuild
第一种方式可以参考[这里](https://blog.inuyasha.love/linuxeveryday/start-visionfive2-with-debian-sid.html#%E6%9E%84%E5%BB%BA%E5%86%85%E6%A0%B8deb%E5%8C%85)，第二种方式可以参考[这里](https://github.com/yuzibo/vf2-debian-image/blob/main/rootfs/setup_rootfs.sh#L43).
下面以 prebuilt 方式进行讲解:

```bash
# 1 download prebuild kernel image from here:
# https://github.com/yuzibo/vf2-linux *-dev branch with tag published
# then copy into /tmp/riscv64-chroot
~: ls

linux-headers-6.6.7-vf2_2023.12.14.08.37+88bd30f68_riscv64.deb
linux-image-6.6.7-vf2_2023.12.14.08.37+88bd30f68_riscv64.deb

apt install -f ./*.deb

```  

4.0.1 u-boot

接下来需要配置与启动最直接相关的  u-boot 了:
主要一个是 `/etc/default/u-boot`,另一个是 `uEnv.txt`. 引导设备最好在dd 时再操作。

```bash
cat <<EOF >> /etc/default/u-boot
U_BOOT_PARAMETERS="rw console=tty0 console=ttyS0,115200 earlycon rootwait stmmaceth=chain_mode:1 selinux=0"
EOF
$ cat /etc/default/u-boot // double check
 sed -i -e 's|root=[^ ]*|root=/dev/mmcblk1p3|' /boot/extlinux/extlinux.conf
```

Then

```bash
mkdir -p /boot/efi
```

配置 uEvn.txt

```bash
cat <<EOF > /boot/uEnv.txt
fdtdir=/boot/dtbs
fdtfile=starfive/jh7110-starfive-visionfive-2-v1.2a.dtb
kernel_comp_addr_r=0xb0000000
kernel_comp_size=0x10000000
EOF
```
change dtb file following your vf2 boards

最后:

```bash
cat <<EOF > /etc/fstab
/dev/mmcblk1p2 /boot/efi vfat umask=0077 0 1
EOF
```

4.1 配置 网络接口

```bash
cat <<EOF >> /etc/network/interfaces
allow-hotplug end0
iface end0 inet dhcp
EOF

echo vf2 > /etc/hostname

passwd # for vf2

# add new user
root@debian:/# adduser debian
info: Adding user `debian' ...
info: Selecting UID/GID from range 1000 to 59999 ...
info: Adding new group `debian' (1000) ...
info: Adding new user `debian' (1000) with group `debian (1000)' ...
info: Creating home directory `/home/debian' ...
info: Copying files from `/etc/skel' ...
New password:
Retype new password:
passwd: password updated successfully
Changing the user information for debian
Enter the new value, or press ENTER for the default
        Full Name []:
        Room Number []:
        Work Phone []:
        Home Phone []:
        Other []:
Is the information correct? [Y/n]
info: Adding new user `debian' to supplemental / extra groups `users' ...
info: Adding user `debian' to group `users' ...

# passwd for debian is `debian`
passwd debian
New password:
Retype new password:
passwd: password updated successfully

usermod -aG sudo debian
```




```

```bash
apt install locales
apt clean
exit

```

# 3 copy rootfs to sd/nvme

然后这个时候可以分别向sd或者nvme copy rootfs 了
最好需要 double check 你的设备，以免讲自己的 host 给格式化了。
可以使用命令 `lsblk` 确认。

一般情况下， sd 在 host 上显示 `/dev/mmcblk**`, 在 guest 上显示 `/dev/sd**`

nvme 在 host 上显示 `/dev/nvme0n1**`,  在 guest 上显示 `/dev/sd**`

## sd

```bash
sudo sgdisk -g --clear --new=1:0:+16M: --new=2:0:+100M: -t 2:EF00 --new=3:0:-1M: --attributes 3:set:2 -d 1 /dev/sdb
The operation has completed successfully.
```
再次确认:

```bash
sudo fdisk -l /dev/sdb
Disk /dev/sdb: 116.36 GiB, 124939927552 bytes, 244023296 sectors
Disk model: STORAGE DEVICE
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 7A77DCC4-1EFD-469D-A05E-0DAA9EC15112

Device      Start       End   Sectors   Size Type
/dev/sdb2   34816    239615    204800   100M EFI System
/dev/sdb3  239616 244021214 243781599 116.2G Linux filesystem
```

然后分别格式化对应的分区:

```
sudo mkfs.vfat /dev/sdb2
sudo mkfs.ext4  -m 0 -L root /dev/sdb3
```

mount sd:

```
sudo mkdir -p /mnt/sdcard
sudo mount /dev/sdb3 /mnt/sdcard
sudo cp -a /tmp/riscv64-chroot/* /mnt/sdcard/

# change boot dev
cd /mnt/sdcard/boot

sudo sed -i -e 's|root=[^ ]*|root=/dev/mmcblk1p3|' extlinux/extlinux.conf
# 一定注意这里两点. 1: /dev/mmcblk1p3 一定不能写成 sdb3;2. 注意 extlinux/extlinux.conf
```

double check 下，主要看这里（append root=/dev/mmcblk1p3）:

```
cat extlinux/extlinux.conf
label l0
        menu label Debian GNU/Linux trixie/sid 6.6.1+
        linux /boot/vmlinuz-6.6.1+
        initrd /boot/initrd.img-6.6.1+
        fdtdir /usr/lib/linux-image-6.6.1+/

        append root=/dev/mmcblk1p3 rw console=tty0 console=ttyS0,115200 earlycon rootwait stmmaceth=chain_mode:1 selinux=0

```

最后:

```
sync
umount /mnt/sdcard
```

这个时候就可以拔除 `sd`.

## nvme

nvme 同理，需要注意的 nvme 的 root 的分区是 `/dev/nvme0n1p3`,在使用时注意区分。
大部分细节与 sd 卡一致，其改动的部分如下:


```bash
 sudo sed -i -e 's|root=[^ ]*|root=/dev/nvme0n1p3|' extlinux/extlinux.conf
```


# boot 码

boot 码选择模式
```bash
00：1-bit QSPI Nor Flash
01： SDIO3.0
10： eMMC
11： eMMC
```

主要参考这篇文章： https://blog.inuyasha.love/linuxeveryday/start-visionfive2-with-debian-sid.html
