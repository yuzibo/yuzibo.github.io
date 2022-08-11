---
title: unmatched boot from nvme and install desktop (debian)
category: debian-riscv
layout: post
---
* content
{:toc}

以下操作需要确保系统安装: `apt install parted  gdisk`.

主要参考手册是: [unmatched manual](https://sifive.cdn.prismic.io/sifive/f81e5848-875e-4ae1-baff-09057743d3a5_hifive-unmatched-sw-reference-manual-v1p1.pdf)

# sd卡启动
首先制作debian sd的image。 根据这个[wiki](https://wiki.debian.org/InstallingDebianOn/SiFive/HiFiveUnmatched)
插上之后就可以在sd里启动debian。

由于下面的操作我们需要在sd卡里的系统上安装软件和操作，需要执行以下命令：

```bash
1. ntpdate cn.pool.ntp.org
update time

2. PermitRootLogin yes
# 允许ssh root登录
```

# nvme
## 确保nvme挂载上
下面的操作既可以在unmatched的板子上，也可以在host的主机上。接下来的实例我们以在unmatched的板子上进行为例.
```bash
root@unmatched:~# ls /dev/nvme*
/dev/nvme0  /dev/nvme0n1
```
一定要注意，如果nvme为多个的话，需要仔细辨别。

## 首先对nvme进行分区

```bash
#1 
 parted /dev/nvme0n1   #一定确认是否，别出什么差错
#2 print
(parted) print
Error: /dev/nvme0n1: unrecognised disk label
Model: WDC WDS100T2B0C-00PXH0 (nvme)
Disk /dev/nvme0n1: 1000GB
Sector size (logical/physical): 512B/512B
Partition Table: unknown
Disk Flags:
#3 use gpt partitions
(parted) mklabel gpt

#4  mkpart
(parted) mkpart
Partition name?  []? fastStorage # fastStorage为name，需要键入，下面同此
File system type?  [ext2]? ext4
Start? 0% # 开始位置为 0%
End? 100%  # 结束位置为 100%，意即整块nvme
(parted) print
Model: WDC WDS100T2B0C-00PXH0 (nvme)
Disk /dev/nvme0n1: 1000GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start   End     Size    File system  Name         Flags
 1      1049kB  1000GB  1000GB  ext4         fastStorage

#4 quit parted
(parted) quit
```
此时nvme已经格式化为一个p1的分区。
## 格式化硬盘为nvme0n1p1

```bash
root@unmatched:/home/sifive# mkfs.ext4 /dev/nvme0n1p1
mke2fs 1.46.5 (30-Dec-2021)
Discarding device blocks: done
Creating filesystem with 244190208 4k blocks and 61054976 inodes
Filesystem UUID: 83e78c70-4433-4085-921e-d3121bfa73be
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
        4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968,
        102400000, 214990848

Allocating group tables: done
Writing inode tables: done
Creating journal (262144 blocks): done
Writing superblocks and filesystem accounting information: done
```

### falsh image

```bash
cat debian-sid-risc-v-sifive-unmatched.img | dd of=/dev/nvme0n1  bs=512K iflag=fullblock oflag=direct conv=fsync
status=progress

#~: sync
```

<strike>dd if=debian-sid-risc-v-sifive-unmatched.img of=/dev/nvme0n1 bs=512K iflag=fullblock oflag=direct conv=fsync status=progress
4211+1 records in
4211+1 records out
2208075776 bytes (2.2 GB, 2.1 GiB) copied, 1256.7 s, 1.8 MB/s</strike>

### 扩容nvme的最后一个分区

#### 1.  sgdisk -v 检查问题
```bash
sgdisk -v /dev/nvme0n1
root@unmatched:~# sgdisk -v /dev/nvme0n1

Problem: The secondary header's self-pointer indicates that it doesn't reside
at the end of the disk. If you've added a disk to a RAID array, use the 'e'
option on the experts' menu to adjust the secondary header's and partition
table's locations.

Identified 1 problems!
# 或者有时候会报下面的错误, 我们以上面的为准。
# Caution: invalid backup GPT header, but valid main header; regenerating
# backup header from main header.

# Warning! Main and backup partition tables differ! Use the 'c' and 'e' options
# on the recovery & transformation menu to examine the two tables.

# Warning! One or more CRCs don't match. You should repair the disk!
# Main header: OK
# Backup header: ERROR
# Main partition table: OK
# Backup partition table: ERROR

# ****************************************************************************
#Caution: Found protective or hybrid MBR and corrupt GPT. Using GPT, but disk
#verification and recovery are STRONGLY recommended.
#****************************************************************************

# Caution: The CRC for the backup partition table is invalid. This table may
# be corrupt. This program will automatically create a new backup partition
# table when you save your partitions.

# Problem: The secondary header's self-pointer indicates that it doesn't reside
# at the end of the disk. If you've added a disk to a RAID array, use the 'e'
# option on the experts' menu to adjust the secondary header's and partition
# table's locations.

# Caution: Partition 1 doesn't begin on a 8-sector boundary. This may
# result in degraded performance on some modern (2009 and later) hard disks.

# Caution: Partition 2 doesn't begin on a 8-sector boundary. This may
# result in degraded performance on some modern (2009 and later) hard disks.

# Consult http://www.ibm.com/developerworks/linux/library/l-4kb-sector-disks/
# for information on disk alignment.

# Identified 2 problems!
```

#### 2. sgdisk -e  修复问题
```bash
sgdisk -e /dev/nvme0n1

The operation has completed successfully.
```

#### 3. 调整第四个分区
```bash
root@unmatched:~# parted /dev/nvme0n1 resizepart 4 100%
Information: You may need to update /etc/fstab.
```

不过有时候使用上面的命令是不成功的，有可能是命令支持的程度的不够，所以，我们还可以分步进行操作：[参考这里](https://ahelpme.com/linux/online-resize-of-a-root-ext4-file-system-increase-the-space/)

#### 4.  使用 resize2fs扩容 p4
```bash
resize2fs /dev/nvme0n1p4
resize2fs 1.46.5 (30-Dec-2021)
resize2fs: Bad magic number in super-block while trying to open /dev/nvme0n1
Couldn\'t find valid filesystem superblock.
```

如果提示： 
```bash
root@unmatched:~# resize2fs /dev/nvme0n1p4
resize2fs 1.46.5 (30-Dec-2021)
Please run 'e2fsck -f /dev/nvme0n1p4' first.
```
则既可以按照指示敲命令即可， 选y。

#### 5. syncing
```bash
sync
```

#### 6. 证实
```bash
fdisk -l /dev/nvme0n1
Disk /dev/nvme0n1: 931.51 GiB, 1000204886016 bytes, 1953525168 sectors
Disk model: WDC WDS100T2B0C-00PXH0
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: B71606E9-731B-469A-9DAE-5A505C5DBFF4

Device          Start        End    Sectors   Size Type
/dev/nvme0n1p1     34       2081       2048     1M HiFive FSBL
/dev/nvme0n1p2   2082      10273       8192     4M HiFive BBL
/dev/nvme0n1p3  16384     835583     819200   400M Microsoft basic data
/dev/nvme0n1p4 835584 1953525134 1952689551 931.1G Linux filesystem
```
## 修改U-boot配置文件
U-boot是unmatched用来引导挂载 `/` 目录的配置文件，其我们在sd 卡默认的配置文件为:
```bash
## /boot/extlinux/extlinux.conf
default l0
menu title U-Boot menu
prompt 0
timeout 50


label l0
        menu label Debian GNU/Linux bookworm/sid 5.16.0-5-riscv64
        linux /vmlinux-5.16.0-5-riscv64
        initrd /initrd.img-5.16.0-5-riscv64
        fdt /hifive-unmatched-a00.dtb
        append root=/dev/mmcblk0p4 rw rootwait console=ttySIF0,115200 earlycon

label l0r
        menu label Debian GNU/Linux bookworm/sid 5.16.0-5-riscv64 (rescue target)
        linux /vmlinux-5.16.0-5-riscv64
        initrd /initrd.img-5.16.0-5-riscv64
        fdt /hifive-unmatched-a00.dtb
        append root=/dev/mmcblk0p4 rw rootwait console=ttySIF0,115200 earlycon single
```
其root目录挂载点指向的依旧是  `mmcblk0p4`, 即便我们刚刚往nvme里dd的img文件也是如此。所以，根据unmatched的手册，我们需要修改配置文件.

### mount /dev/nvme0n1p3
之所以挂载这个分区，是因为 '/boot'位于这个分区下，其/boot/extlinux/extlinux.conf就是要修改的。
```bash
#1. mount 
mount /dev/nvme0n1p3 /mnt

#2. change
vi /mnt/extlinux/extlinux.conf
# 将里面的 “root=/dev/mmcblk0p4”改为"root=/dev/nvme0n1p4" 
# 即nvme0n1p4的“/”分区

#3. umount
umount /mnt
```

之后重启就可以了。

# fix
如果种种原因导致系统没有起来则最好使用sifive提供的原始系统救急。

实际上，根据unmatched的手册，目前unmatched使用的Freedom-u-sdk编译的U-boot，默认的启动顺序是nvme在sd的前面。
这个启动的顺序是可以选择的。控制的时机就是在U-Boot的界面。

操作，插上sd/nvme卡，在开机的前几秒一直到开机后吐出log时按键，在看见 `autoboot`的界面时，就进入了U-boot的选择界面。

## 从sd卡启动
```bash
# 从sd卡启动
run bootcmd_mmc0
```

## 从nvme启动

```bash
run bootcmd_nvme0
```
因为unmatched默认是从nvme启动的，这一点需要注意。

#  安装桌面环境

## 首先安装 frmware

取决于你的显卡选择，我这里用的是AMD的卡，所以得安装amd的firmware:
```bash
non-free firmware-amd-graphics
```

## 安装 Display Manager
我这里选择的是 gdm3，也许ligthdm是默认的。

## 安装xfce4
安装xfce4就可以看见那熟悉的界面了。

# 修改root密码失败

如果使用recovery mode修改密码失败，则一个可能的办法是，使用  `recovery mode`进入系统，然后把相关的rootfs那个盘符
挂载上`/mnt`.

```bash
mount /dev/nvme0n1p4 /mnt
```
然后  chroot /mnt,  然后修改密码，退出，重启后就可以用新密码登陆了.
# 系统的一些配置

## 允许root ssh登录
编辑`/etc/ssh/sshd_config`文件，添加如下的配置:

```bash
PermitRootLogin yes
systemctl restart sshd
```
既可以使用root登录 unmatched.

## 更新时间
不更新时间的后面就是，`apt update`不会成功的。

```bash
ntpdate cn.pool.ntp.org
```
就可以更新时间。

## /boot is read-only

如果`/boot`是read-only 的话，会影响很多操作，所以最好?
```bash
sudo mount -o remount,rw /boot
```
https://askubuntu.com/questions/876510/booting-into-read-only-file-system

Update: 这个是由于在制作 `/boot`分区时给/etc/fstab `ro`属性,后面可以修改这个属性使用 `rw`.
然后，这里没有必要为/boot单独分区。

## GPT PMBR size mismatch

Issue:

GPT PMBR size mismatch (8388607 != 250069679) will be corrected by write.
The backup GPT table is not on the end of the device.

Solutions:

```bash
sudo parted -l
```

# 补充
这里有一份 [github](https://github.com/carlosedp/riscv-bringup/tree/master/unmatched)的资料，需要重点了解一下。

* ZSBL - Zero Stage Bootloader - Code in the ROM of the board
* FSBL - First Stage Bootloader - U-Boot SPL - Loader that is called from ROM.
* SBL - Second Bootloader - OpenSBI - Supervisor Binary Interface. Source
* U-Boot - Universal Boot Loader. Docs
* Extlinux - Syslinux compatible configuration to load Linux Kernel and DTB thru a configurable menu from a filesystem.


# update
作为buildd的机器，目前需要做一个大的rootfs，从而sd上只有


https://u-boot.readthedocs.io/en/latest/board/sifive/unmatched.html

rootfs on nvme:
https://github.com/carlosedp/riscv-bringup/blob/master/unmatched/Readme.md

# for Wuhan lab

## 基础环境
1. apt update (会失败， 使用命令 ntpdate ntp.aliyun.com 更新时间，然后update就可以)
不嫌麻烦的话还可以使用:

```bash
apt install ca-certificates
```

2. 更新source: 
将/etc/apt/sources.list更新一下内容：
```bash
 cat /etc/apt/sources.list
deb https://mirror.iscas.ac.cn/debian-ports sid main
deb-src https://mirror.iscas.ac.cn/debian sid main
```
3. 安装 openssh-server
```bash
apt install openssh-server
```

修改/etc/ssh/sshd_config 将 允许root登录打开

```bash
PermitRootLogin yes
# 允许ssh root登录
```

重启sshd： systemctl restart sshd

然后就可以ssh登录了。

4. nvme 扩容
df -h 检查下nvme0n1p3的大小，默认应该是4G不够，我们需要扩容到20G。

Step one:

```bash
root@srv1 ~ # parted /dev/nvme0n1  #  确定奥？
GNU Parted 3.2
Using /dev/sda
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) p                                                                
Model: Model: ATA Samsung SSD 850 (scsi)
Disk /dev/sda: 215GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags: 
 
Number  Start   End     Size    File system     Name  Flags
 1      1049kB  2097kB  1049kB                        bios_grub
 2      2097kB  4096MB  4094MB  linux-swap(v1)
 3      4096MB  24.0GB  19.9GB  ext4
(parted) resizepart 3 20GB                                                  
Warning: Partition /dev/sda3 is being used. Are you sure you want to continue?
parted: invalid token: -1                                                 
Yes/No? Yes                                                               
End?  [24.0GB]? -1                                                        
(parted) p                                                                
Model: Model: ATA Samsung SSD 850 (scsi)
Disk /dev/sda: 215GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags: 
 
Number  Start   End     Size    File system     Name  Flags
 1      1049kB  2097kB  1049kB                        bios_grub
 2      2097kB  4096MB  4094MB  linux-swap(v1)
 3      4096MB  215GB   211GB   ext4
 
(parted) q                                                                
Information: You may need to update /etc/fstab.
```

Step two:

```bash


root@srv ~ # resize2fs /dev/nvme0n1p3
resize2fs 1.42.13 (17-May-2015)
Filesystem at /dev/sda3 is mounted on /; on-line resizing required
old_desc_blocks = 2, new_desc_blocks = 13
The filesystem on /dev/sda3 is now 51428620 (4k) blocks long.
Check if everything is OK with


root@srv ~ # dmesg|grep EXT4
[  449.330140] EXT4-fs (vda3): resizing filesystem from 4859392 to 51428620 blocks
[  449.936044] EXT4-fs (vda3): resized filesystem to 51428620
root@srv ~ # df -h
Filesystem      Size  Used Avail Use% Mounted on
udev            3.9G     0  3.9G   0% /dev
tmpfs           798M  3.5M  795M   1% /run
/dev/sda3       193G  3.4G  182G   2% /
tmpfs           3.9G     0  3.9G   0% /dev/shm
tmpfs           5.0M     0  5.0M   0% /run/lock
tmpfs           3.9G     0  3.9G   0% /sys/fs/cgroup
tmpfs           798M     0  798M   0% /run/user/0
```