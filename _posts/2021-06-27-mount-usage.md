---
title:  mount 用例
category: shell
layout: post
---
* content
{:toc}

# mount 一整块img然后 copy 出一个分区 

使用mount挂载img到一个目录上，需要先知道img的文件类型。

```bash
vimer@user-HP:~$ fdisk -l sd-blob.img
Disk sd-blob.img: 13.4 GiB, 14414774272 bytes, 28153856 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 2734708E-E386-4057-ABE7-3260FDA31366

Device         Start      End  Sectors  Size Type
sd-blob.img1  870400 28137471 27267072   13G Linux filesystem
sd-blob.img2    2048   133119   131072   64M Linux filesystem
sd-blob.img3  133120   264191   131072   64M Linux filesystem
sd-blob.img4  264192   265087      896  448K Linux filesystem
sd-blob.img5  266240   267135      896  448K Linux filesystem
sd-blob.img6  268288   397311   129024   63M Linux filesystem
sd-blob.img7  397312   398335     1024  512K Linux filesystem
sd-blob.img8  399360   399871      512  256K Linux filesystem
sd-blob.img9  401408   401919      512  256K Linux filesystem
sd-blob.img10 403456   608255   204800  100M Linux filesystem
sd-blob.img11 608256   870399   262144  128M Linux filesystem
```

我的本意是使用img1的那个分区，那个是一个正常的rootfs, 我现在做的就是把他们copy
出来。

```bash
sudo mkdir /mnt/rootfs && sudo mount -o loop,offset=445644800 sd-blob.img /mnt/rootfs
```
这里面的offset选项需要我值得特别注意，这块我也不是特别熟悉。

https://www.linuxquestions.org/questions/linux-software-2/how-to-mount-dos-img-file-4175430554/

# mount 一个外挂盘

这里需要配合 `/etc/fstab` 去实现开机自动挂载的功能， 同时，由于 `fstab` 的改动会影响正常的启动， 所以需要要有一个 mount 的检查过程， 如这个链接说明的这样:
https://blog.csdn.net/bandaoyu/article/details/123806859
