---
layout: post
title: "DC ROMA port to debian sid"
category: debian-riscv
---

Some days(2024/06) I got one ROMA from DC donated for Debian Community. This weeks I have some time so to try run Debian sid on it.

The system on ROMA was Debian 11 with fixed version riscv64 Debian packages from debian-ports. Until now, we have no debian-ports any more, so this is a very interesting chanllenge.

# Refer to
The DC github is here[0](https://github.com/DC-DeepComputing), especially for [docs](https://github.com/DC-DeepComputing/ROMA_LAPTOP_JH7110_RV-L1B/tree/main/Docs) which tells you how to flash image to ROMA.

From my observation, there is there image boot mode: emmc, sd and nvme. The default system from emmc(/dev/mmcblk0).

One key is that: `riscv+t` can boot system from sd, then you can `mount` devices to do everything you can do.

# Some important componemts

GPU drivers: https://github.com/starfive-tech/soft_3rdpart/blob/c43d4fab94b0ef3b492a6382e2282fa7a2695b9b/IMG_GPU/out/img-gpu-powervr-bin-1.19.6345021.tar.gz

mesa: https://github.com/starfive-tech/buildroot/tree/JH7110_VisionFive2_devel/package/mesa3d

Xorg: ？

On debian riscv64, until now we have xfce4 desktop. 

# tips:

## gpu drivers

```bash
    
lshw -c display
# to recongize kernel gpu driver, otherwise UNCLAIMED".

```

## Xorg
If you want to debug Desktop env, it is good to start to from `startx`. Once you do not have any error from xorg, I think you have got it already.

```bash
Please also check the log file at "/home/vimer/.local/share/xorg/Xorg.0.log"
# permission issue generally

# normal to check issue from Xorg is from:
/var/log/Xorg.0.log
```

## apt-mark
Due to some packages built from ourself, so we have to apt-mark some package to keep graphic display works

```bash
sudo apt-mark hold libegl-mesa0 libgbm1 libglapi-mesa mesa-vulkan-drivers

# partial

```

# graphic 

1 [wiki](https://blog.csdn.net/qq_23662505/article/details/130341569)

# Thanks
Many thanks for DeepComputing which offer the hardware and help from Songsong and RevysOS.
