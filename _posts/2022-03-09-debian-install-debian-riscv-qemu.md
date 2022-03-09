---
title: debian 安装  riscv qemu
category: debian-riscv
layout: post
---
* content
{:toc}

在探索pbuilder的用法时，不小心突然在Debian(bulleye)上把riscv qemu安装上了，效果体验还是不错的，故在这里记录一下，以备使用时方便参考。

# 创建 riscv64 chroot

创建riscv64 的chroot有很多种[方式](https://wiki.debian.org/RISC-V#Creating_a_riscv64_chroot):

## debootstrap
```bash
sudo apt-get install debootstrap qemu-user-static binfmt-support debian-ports-archive-keyring
sudo debootstrap --arch=riscv64 --keyring /usr/share/keyrings/debian-ports-archive-keyring.gpg --include=debian-ports-archive-keyring unstable /tmp/riscv64-chroot http://deb.debian.org/debian-ports
```

稍等几分钟，就会创建 `/tmp/riscv64-chroot`目录，顾名思义，是一个riscv64 的chroot。
debootstrap创建的chroot针对`unstable` 版本的软件，如果你要使用的软件是来自于`unrelease`,  则可以参考下面的`mmdebstrap`.

## mmdebstrap
```bash
$ sudo apt install mmdebstrap qemu-user-static binfmt-support debian-ports-archive-keyring
$ sudo mmdebstrap --architectures=riscv64 --include="debian-ports-archive-keyring" sid /tmp/riscv64-chroot "deb http://deb.debian.org/debian-ports/ sid main" "deb http://deb.debian.org/debian-ports/ unreleased main"
```

# 准备 virtual machine

创建好了 `/tmp/riscv64-chroot`后，可以开始准备qemu的环境了：

```bash
$ sudo chroot /tmp/riscv64-chroot
# Update package information
apt-get update
# Set up basic networking
cat >>/etc/network/interfaces <<EOF
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
EOF
# Set root password
# root的登录密码
passwd
# Disable the getty on hvc0 as hvc0 and ttyS0 share the same console device in qemu.
ln -sf /dev/null /etc/systemd/system/serial-getty@hvc0.service  
# Install kernel and bootloader infrastructure
apt-get install linux-image-riscv64 u-boot-menu
# Install and configure ntp tools
apt-get install openntpd ntpdate
sed -i 's/^DAEMON_OPTS="/DAEMON_OPTS="-s /' /etc/default/openntpd
# Configure syslinux-style boot menu
cat >>/etc/default/u-boot <<EOF
U_BOOT_PARAMETERS="rw noquiet root=/dev/vda1"
U_BOOT_FDT_DIR="noexist"
EOF
u-boot-update
exit
```

# Setting up a riscv64 virtual machine

##  安装软件
```bash
sudo apt install qemu-system-misc opensbi  u-boot-qemu
```

## 准备chroot
这个chroot就是上文阐述的riscv64 chroot

##  创建image
```bash
sudo apt-get install libguestfs-tools
sudo virt-make-fs --partition=gpt --type=ext4 --size=10G /tmp/riscv64-chroot/ rootfs.img
sudo chown ${USER} rootfs.img
```

## 启动 riscv 64 qemu

```bash
qemu-system-riscv64 -nographic -machine virt -m 1.9G \
 -bios /usr/lib/riscv64-linux-gnu/opensbi/generic/fw_jump.elf \
 -kernel /usr/lib/u-boot/qemu-riscv64_smode/uboot.elf \
 -object rng-random,filename=/dev/urandom,id=rng0 -device virtio-rng-device,rng=rng0 \
 -append "console=ttyS0 rw root=/dev/vda1" \
 -device virtio-blk-device,drive=hd0 -drive file=rootfs.img,format=raw,id=hd0 \
 -device virtio-net-device,netdev=usernet -netdev user,id=usernet,hostfwd=tcp::22222-:22
```
默认用户是root，  密码就是上面 `passwd`命令确认的。

```bash
root@debian-local:~# uname -a
Linux debian-local 5.16.0-3-riscv64 #1 SMP Debian 5.16.11-1 (2022-02-25) riscv64 GNU/Linux
```

# 退出qemu

qemu: For -nographic just enter:

`Ctrl-A X` for exit
which means

first press Ctrl + A (A is just key a, not the alt key)->then release the keys->afterwards press(X key) 