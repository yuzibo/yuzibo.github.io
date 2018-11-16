---
title: "虚拟机扩充容量"
category: kvms
layout: post
---
# 一
* content
{:toc}

好不容易使用libvirt库结合qemu把虚拟机装起来，但是没有想到在跑项目的时候居然dik　space 太小了，看来是自己当初安装虚拟机的时候把容量给小了，想办法在整回去呗.

# 二
首先声明，我使用的是qemu自带的qcow2文件格式，但是好像这个并不会影响的使用。现在，我的kvms已经扩充完毕，有些数据已经拿不到了，但是思路还在的，我可以使用我的笔记再一次演示一遍的.

# 步骤
我的pool文件定义在`/opt/kvms/pools/devel/debian-9.qcow2`,

1.  stop your VM

2. Use `qemu-img resize /opt/kvms/pools/devel/debian-9.qcow2 +25G`

3. Restart your VM

4. Adjust your VM LVM partition

First, the result  below is updated,

```bash
 sudo fdisk -l
 Disk /dev/vda: 55 GiB, 59055800320 bytes, 115343360 sectors
 Units: sectors of 1 * 512 = 512 bytes
 Sector size (logical/physical): 512 bytes / 512 bytes
 I/O size (minimum/optimal): 512 bytes / 512 bytes
 Disklabel type: dos
 Disk identifier: 0x57a2ec91
Device     Boot Start       End   Sectors Size Id Type
/dev/vda1  *     2048 115343359 115341312  55G 83 Linux

```

But you must know, my `/dev/vda1` is 10G size only,the 55G is result i resized it.

Next we use the fdisk tool to temporarily `delete` partition `/dev/vda1`,then create it bigger.

Here: section start 2048.

In fact, The fdisk have detected the space is 55G, but my `/dev/vda1` is 10G only, because i dont't resize the `/dev/vda1` filesystem.

The process is:

```bash
# fdisk /dev/vda

Welcome to fdisk (util-linux 2.27.1).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Command (m for help): d
Selected partition 1
Partition 1 has been deleted.

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1): 1
First sector (2048-62914559, default 2048): 2048
Last sector, +sectors or +size{K,M,G,T,P} (2048-62914559, default 62914559): [ENTER for default]

Created a new partition 1 of type 'Linux' and of size 30 GiB.

Command (m for help): t
Selected partition 1
Partition type (type L to list all types): 83
Changed type of partition 'Linux' to 'Linux'.

Command (m for help): a
Selected partition 1
The bootable flag on partition 1 is enabled now.

Command (m for help): p
Disk /dev/vda: 30 GiB, 32212254720 bytes, 62914560 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x3ac5a058

Device     Boot Start      End  Sectors Size Id Type
/dev/vda1  *     2048 62914559 62912512  30G 83 Linux

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Re-reading the partition table failed.: Device or resource busy

The kernel still uses the old table. The new table will be used at the next reboot or after you run partprobe(8) or kpartx(8).
```

1. First we enter `d` to delete a partition, As there is only one partition(/dev/vda1) it is automatically selected.

2. Next we create a new partioion

`n` to start the new partition function

`p` for a primary partition

`1` to create /dev/vda1

`2048` as our start sector

3. `t` is to set partition type, then enter `83` to set it to linux.

4. To set the bootable, press `a` for the boot function and enter `1` if prompted for the partition number.

5. Enter `p` to print the new partition table.

6. `w` is write to the partition table.

Ok, we have finished the partition　table.And you have noted the output, you have to use bash command to tell kerenl to load the new partition table.

```bash
partprobe /dev/vda
```
If success there is no output.

# At last

The last step is very important for the process, because you donnot resize /dev/vda1 filesystem.We have expanded the partition but the filesystem has not been expanded to fill it. How? `resize2fs`

```bash
resize2fs /dev/vda1
```

Hope it works!



