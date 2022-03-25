---
title: sgdisk 与 分区表的计算
category: tools
layout: post
---
* content
{:toc}

最近需要做一个img文件，来源于这个   [wiki](https://wiki.debian.org/InstallingDebianOn/SiFive/HiFiveUnmatched#preview)

借一下code来说明问题:

```bash
# create image file
dd if=/dev/zero of=debian-sid-risc-v-sifive-unmatched.img bs=1M count=4096

# Partition image with correct disk IDs
sudo sgdisk -g --clear --set-alignment=1 \
       --new=1:34:+1M:    --change-name=1:'u-boot-spl'    --typecode=1:5b193300-fc78-40cd-8002-e86c45580b47 \
       --new=2:2082:+4M:  --change-name=2:'opensbi-uboot' --typecode=2:2e54b353-1271-4842-806f-e436d6af6985 \
       --new=3:16384:+130M:   --change-name=3:'boot'      --typecode=3:0x0700  --attributes=3:set:2  \
       --new=4:286720:-0   --change-name=4:'rootfs'       --typecode=4:0x8300 \
       debian-sid-risc-v-sifive-unmatched.img
```
首先创建一个 4G 的rootfs(raw),然后再使用sgdisk对整个img文件进行分区。这里的数值与wiki的数值是不一致的，因为wiki的数值是我修改后的，这个才是wiki修改之前的。

第三分区的boot分区，原始值给了130MB，这个值太小了，导致不能在后面的步骤中执行update boot image。所以，我们得把  boot分区扩大，但是这个值可不是随意扩展的，否则会报错的，执行不下去的。

sgdisk的具体用法不是这篇文章的本意，我们主要关注这些offset是怎么计算的来的。

我们再来看另一篇[文章](https://www.rodsbooks.com/gdisk/walkthrough.html)：

```bash
Command (? for help): p
Disk /dev/disk1: 15634432 sectors, 7.5 GiB
Logical sector size: 512 bytes
Disk identifier (GUID): 70D5FAFF-4AC9-42C6-A552-0603CE032B8D
Partition table holds up to 128 entries
First usable sector is 34, last usable sector is 15634398
Partitions will be aligned on 2048-sector boundaries
Total free space is 2014 sectors (1007.0 KiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048         8390655   4.0 GiB     0700  Microsoft basic data
   2         8390656        12584959   2.0 GiB     8300  Linux filesystem
   3        12584960        15634398   1.5 GiB     A503  FreeBSD UFS
```
如果我们能把这里搞明白了， 

```bash
容量 = (end - start + 1) * 512 /某个值
```
上面就是 (8390655-2048 + 1)*512=8388608*512=4294967296 bytes（是不是很眼熟,另外很多人忘记加1），这里还有一点就是：
这个加1是分条件的，这里是end，所以头减尾加1就可以了。但是如果你的end是下一分区的start，就没必要加1了。也就是， 前一分区加1就是下一分区的start(不知道有没有特例)

剩下的就是单位转换了：  
```bash
bytes/1024=xKB
kB/1024=MB
MB/1024=GB
```
所以， 4294967296/1024/1024/1024=4GB。所以有这个公式计算就很简单了.

再来看上面的例子:

```bash
 --new=1:34:+1M:    --change-name=1:'u-boot-spl'    --typecode=1:5b193300-fc78-40cd-8002-e86c45580b47 \
--new=2:2082:+4M:  --change-name=2:'opensbi-uboot' --typecode=2:2e54b353-1271-4842-806f-e436d6af6985 \
--new=3:16384:+130M:   --change-name=3:'boot'      --typecode=3:0x0700  --attributes=3:set:2  \ # 原始值
--new=4:286720:-0   --change-name=4:'rootfs'       --typecode=4:0x8300 \ #  原始值
```

假设我们把 boot 扩大为 400MB（因为我们是打算扩大的3分区，也就是2分区的结尾不用动，扩大3就是改动了4分区的起始位置）, 则有：

```bash
(start(下一分区开始)-16384)*512/1024/1024=400
```
则end为835584.

我们验证一下分区1的offset:  (2082-34)*512/1024/1024=1M。 但是分区2的下一分区起始地址放的有点大，不知道为什么。

