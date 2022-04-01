---
title: unmatched boot from nvme (debian)
category: debian-riscv
layout: post
---
* content
{:toc}


# sd卡启动
首先制作debian sd的image。 根据这个[wiki](https://wiki.debian.org/InstallingDebianOn/SiFive/HiFiveUnmatched)
插上之后就可以在sd里启动debian。

# nvme

## 首先对nvme进行格式化

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
Partition name?  []? fastStorage
File system type?  [ext2]? ext4
Start?
Start?
Start? 0%
End? 100%
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
 dd if=debian-sid-risc-v-sifive-unmatched.img of=/dev/nvme0n1 bs=512K iflag=fullblock oflag=direct conv=fsync status=progress
4211+1 records in
4211+1 records out
2208075776 bytes (2.2 GB, 2.1 GiB) copied, 1256.7 s, 1.8 MB/s

#~: sync
```

### 扩容nvme的最后一个分区

```bash
# sgdisk -v 
 sgdisk -v /dev/nvme0n1
Caution: invalid backup GPT header, but valid main header; regenerating
backup header from main header.

Warning! Main and backup partition tables differ! Use the 'c' and 'e' options
on the recovery & transformation menu to examine the two tables.

Warning! One or more CRCs don't match. You should repair the disk!
Main header: OK
Backup header: ERROR
Main partition table: OK
Backup partition table: ERROR

****************************************************************************
Caution: Found protective or hybrid MBR and corrupt GPT. Using GPT, but disk
verification and recovery are STRONGLY recommended.
****************************************************************************

Caution: The CRC for the backup partition table is invalid. This table may
be corrupt. This program will automatically create a new backup partition
table when you save your partitions.

Problem: The secondary header's self-pointer indicates that it doesn't reside
at the end of the disk. If you've added a disk to a RAID array, use the 'e'
option on the experts' menu to adjust the secondary header's and partition
table's locations.

Caution: Partition 1 doesn't begin on a 8-sector boundary. This may
result in degraded performance on some modern (2009 and later) hard disks.

Caution: Partition 2 doesn't begin on a 8-sector boundary. This may
result in degraded performance on some modern (2009 and later) hard disks.

Consult http://www.ibm.com/developerworks/linux/library/l-4kb-sector-disks/
for information on disk alignment.

Identified 2 problems!

#2 sgdisk -e
 sgdisk -e /dev/nvme0n1
Caution: invalid backup GPT header, but valid main header; regenerating
backup header from main header.

Warning! Main and backup partition tables differ! Use the 'c' and 'e' options
on the recovery & transformation menu to examine the two tables.

Warning! One or more CRCs don't match. You should repair the disk!
Main header: OK
Backup header: ERROR
Main partition table: OK
Backup partition table: ERROR

****************************************************************************
Caution: Found protective or hybrid MBR and corrupt GPT. Using GPT, but disk
verification and recovery are STRONGLY recommended.
****************************************************************************
The operation has completed successfully.

#3 
 resize2fs /dev/nvme0n1
resize2fs 1.46.5 (30-Dec-2021)
resize2fs: Bad magic number in super-block while trying to open /dev/nvme0n1
Couldn't find valid filesystem superblock.

#4
sync

#5 证实
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


# fix
如果种种原因导致系统没有起来则最好使用sifive提供的原始系统救急。

操作，插上sd卡，在开机的前几秒按键，在看见 `autoboot`的界面时，就进入了U-boot的选择界面。

```bash
# 从sd卡启动
run bootcmd_mmc0
```
因为unmatched默认是从nvme启动的，这一点需要注意。



