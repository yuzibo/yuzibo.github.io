---
title: unmatched boot from nvme (debian)
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

 dd if=debian-sid-risc-v-sifive-unmatched.img of=/dev/nvme0n1 bs=512K iflag=fullblock oflag=direct conv=fsync status=progress
4211+1 records in
4211+1 records out
2208075776 bytes (2.2 GB, 2.1 GiB) copied, 1256.7 s, 1.8 MB/s

#~: sync
```

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
umount
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

