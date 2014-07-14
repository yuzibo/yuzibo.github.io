---
layout: article
title: "在Thinkpad E130上安装Archlinux"
category: tools
tags: linux
---


# A.简述

本配置使用于` EFI+GPT `，并且最优是单系统，如果要双系统的话需要注意变通。


# B.准备

## 下载地址：

[mirrors.163.com](http://mirrors.163.com/)


## Windows下制作安装盘软件

[rufus.akeo.ie](http://rufus.akeo.ie)


## UEFI 命令

    loader EFI/boot/bootx64.efi


## 联网

    wifi-menu
    dhcpcd
    systemctl enable dhcpcd


## 使用ssh远程登录

     passwd
     systemctl start sshd
     systemctl enable sshd


# C.分区

## 命令分区工具，用来产生硬盘前的2M空闲空间

    fdisk /dev/sda

命令参数

    n   #创建一个新分区
    t   #改变新分区类型
    w   #写入并保存设置

伪图形分区工具

    cfdisk /dev/sda                # mbr
    cgdisk /dev/sda                # gpt


## LVM命令

[参考链接](https://wiki.archlinux.org/index.php/LVM_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87\))

    pvcreate /dev/sda3                #建立物理卷
    vgcreate LVM /dev/sda3            #创建卷组
    lvcreate -C y -L 50G LVM -n root  #创建逻辑卷挂载/
    lvcreate -C y -L 9G LVM -n swap   #创建逻辑卷挂载swap
    lvcreate -l 100%FREE LVM -n home  #使用剩下的空间挂载home


## 格式化分区

    mkswap /dev/LVM/swap       #将sda3格式化成swap
    mkfs.ext4 /dev/LVM/root    #将sda1格式化成ext4
    mkfs.ext4 /dev/LVM/home    #将sda2格式化成ext4
    mkfs.vfat -F32 /dev/sda1   #将EFI分区格式化成FAT32格式，（选用）


## 挂载分区

将 live cd /mnt分区作为新系统的 / 分区

    mount /dev/LVM/root /mnt        #挂载根分区
    swapon /dev/LVM/swap            #启用swap
    mkdir /mnt/home                 #创建home目录
    mount /dev/LVM/home /mnt/home   #挂载home目录
    mkdir -p /mnt/boot/EFI          #创建EFI目录
    mount /dev/sda1 /mnt/boot/EFI   #挂载EFI目录



# D.安装基本系统

## 修改源

编辑 ` /etc/pacman.d/mirrorlist `，在文件最前面添加以下条目

    Server = http://mirror.bjtu.edu.cn/archlinux/$repo/os/$arch
    Server = http://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch
    Server = http://mirrors.163.com/archlinux/$repo/os/$arch
    Server = http://mirrors.sohu.com/archlinux/$repo/os/$arch

更新源

    pacman -Syy


## 安装基本系统

    pacstrap -i /mnt base base-devel        #在/mnt分区安装基本系统
    genfstab -U -p /mnt >> /mnt/etc/fstab   #生成磁盘挂载列表
    arch-chroot /mnt                        #切换到新系统



# E.对新系统进行基本设置

## 编码设定

    echo LANG=en_US.UTF-8 > /etc/locale.conf

    vi /etc/locale.gen

去掉en_US和zh_CN几行前的注释，然后更新编码

    locale-gen


## 配置时区

    ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    hwclock --systohc --localtime


## 配置主机名

    echo Arch > /etc/hostname


## 创建 ramdisk 环境

因为使用lvm，所以需要在在mkinitcpio.conf中加入lvm的hook，不然无法正常引导，需要保证udev和lvm2两个mkinitcpio钩子启用。udev通常已经预设好，编辑/etc/mkinitcpio.conf文件，在block和filesystem两项中间加入lvm2：
HOOKS=“...block lvm2 filesystems...”

    vi /etc/mkinitcpio.conf


## 生成内核的启动镜象

    mkinitcpio -p linux


## 安装grub

### BIOS+MBR环境下：

    pacman -S os-prober grub
    grub-install --target=i386-pc --recheck /dev/sda
    grub-mkconfig -o /boot/grub/grub.cfg

### UEFI+GPT环境下：

    mount -t efivarfs efivarfs /sys/firmware/efi/efivars     # 若已挂载则无视
    pacman -S grub efibootmgr
    grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=Arch --recheck
    grub-mkconfig -o /boot/grub/grub.cfg


## 设定root密码

    passwd


## 添加普通用户

    useradd -m yourname
    passwd yourname

将新建的普通用户添加到可以使用sudo的组中

    gpasswd -a yourname wheel
    visudo

反注释以下行，然后保存退出

    %wheel ALL=(ALL) ALL



# F.安装图形界面

## 安装显卡驱动

    pacman -S xf86-video-vesa         # 通用显卡驱动，不提供任何2D和3D加速功能
    pacman -S xf86-video-intel        # Intel
    pacman -S xf86-video-nouveau nouveau-dri  #Nvidia开源驱动。    开机无法进入系统
    pacman -S nvidia nvidia-utils     # Nvidia专有闭源驱动。适用于GT7xxx以上的显卡  
    pacman -S nvidia-304xx lib32-nvidia-libgl # Nvidia专有闭源驱动。适用于GT6/7xxx的显卡  推荐
    pacman -S xf86-video-ati          # Ati


## 安装X

    pacman -S xorg-server xorg-xinit xorg-utils xorg-server-utils

测试(非必须)

    pacman -S xorg-twm xorg-xclock xterm
    startx
    exit
    pkill X


## 安装lxde和slim

    pacman -S lxde slim

为了启动 LXDE,在 /etc/slim.conf 与 ~/.xinitrc。加入：

    exec startlxde
    exec lxde-session

设置slim开机自启动并启动lxde

    systemctl enable slim.service

启动图形界面

    slim    #在重启之前不要运行此命令

slim的登录会话信息在/usr/share/xsession文件夹下。


## 安装字体

    pacman -S wqy-zenhei wqy-microhei wqy-microhei-lite wqy-bitmapfont



# G.退出安装模式

## 退出arch-root

    exit


## 卸载分区

    umount -R /mnt

    fuser -m -v -i -k /mnt     #umount 时出现 "Device is busy" 的解法


## 重启

    reboot


# H.使用设定

## 网络管理
[参考链接](https://wiki.archlinux.org/index.php/NetworkManager_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87\))

先在任务栏上开启任务托盘，

    pacman -S networkmanager   #管理核心
    pacman -S network-manager-applet xfce4-notifyd hicolor-icon-theme gnome-icon-theme  #图形前端
    pacman -S gnome-keyring     #存储验证信息
    systemctl start NetworkManager  #立即启动
    systemctl enable NetworkManager  #开机自启动


## 安装输入法
[参考链接](https://wiki.archlinux.org/index.php/Fcitx_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87\))

    pacman -S fcitx-im fcitx-configtool

向 ~/.xinitrc 添加

    export GTK_IM_MODULE=fcitx
    export QT_IM_MODULE=fcitx
    export XMODIFIERS="@im=fcitx"


## 启动AUR

在/etc/pacman.conf中加入

    [archlinuxcn]
    SigLevel = Optional TrustAll
    Server   = http://repo.archlinuxcn.org/$arch

或者：

    [archlinux]
    Server = http://repo.archlinux.fr/$arch

安装yaourt

    pacman -S yaourt


*AUR异常处理*

错误：无法提交处理 (无效或已损坏的软件包 (PGP 签名))

解决办法：

    修改/etc/pacman.conf，将repo中的SigLevel = PackageRequired注释掉，添加SigLevel = Never即可。


## .xinitrc设置 

区域与语言设置一定要放在桌面环境前（多么痛的领悟）,这里设置的是英文环境但可以显示并输入中文

    export LANG=en_US.UTF-8
    export LC_CTYPE=zh_CN.UTF-8
    export GTK_IM_MODULE=fcitx
    export QT_IM_MODULE=fcitx
    export XMODIFIERS="@im=fcitx"
    exec startlxde
    exec lxde-session


## 32位兼容库

编辑 /etc/pacman.conf中去掉下面两行前的"#"

    [multilib]
    Include = /etc/pacman.d/mirrorlist

    pacman -S lib32-glibc



## 启用ssh远程登录

    pacman -S openssh
    systemctl enable sshd



# I.常用软件

## 应用软件

    pacman -S bash-completion gvfs gvfs-afc ntfs-3g wget axel openntpd dos2unix
    pacman -S xarchiver unzip unrar zip p7zip arj lzop cpio
    yaourt -S jdk7 chromium-pepper-flash powerpill
    pacman -S chromium leafpad gvim emacs epdfview eclipse git
    pacman -S net-tools dnsutils inetutils iproute2
    pacman -S linux-headers linux-lts-headers



# J.安装参考

[总述](https://wiki.archlinux.org/index.php/General_Recommendations_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87\))

[systemd](https://wiki.archlinux.org/index.php/Systemd_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87\))

[安装教程1](http://bbs.archlinuxcn.org/viewtopic.php?id=1037)

[安装教程2](http://www.cnblogs.com/exiahan/p/3513025.html)

[LXDE桌面配置](http://wiki.klniu.com/zh/Archlinux/LXDE%E6%A1%8C%E9%9D%A2%E7%8E%AF%E5%A2%83%E5%AE%89%E8%A3%85%E9%85%8D%E7%BD%AEs)

[ThinkPad T420](https://wiki.archlinux.org/index.php/Lenovo_ThinkPad_T420_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87\))

[ThinkPad L430](http://cuihao.is-programmer.com/posts/37388.html)

[thinkpad简单配置](http://www.lainme.com/doku.php/blog/2012/08/%E7%AE%80%E5%8D%95%E7%9A%84thinkpad%E7%9B%B8%E5%85%B3%E9%85%8D%E7%BD%AE)



# 进阶设置

## 高级配置与电源接口 acpid

    pacman -S acpid

[具体设置](https://wiki.archlinux.org/index.php/Acpid_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87\))


## cpu频率调节

    pacman -S cpupower

[具体设置](https://wiki.archlinux.org/index.php/CPU_Frequency_Scaling_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87\))


## 全新的电源挂起和电源状态设置框架

    pacman -S pm-utils

[具体设置](https://wiki.archlinux.org/index.php/Pm-utils_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87\))


## 笔记本模式

    yaourt -S laptop-mode-tools

[具体设置](https://wiki.archlinux.org/index.php/Laptop_Mode_Tools_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87\))
[参考](https://wiki.archlinux.org/index.php/Laptop_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87\))
[Power Management](https://wiki.archlinux.org/index.php/Power_Management_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87\))


## 风扇转速

    yaourt -S thinkfan

[具体操作](http://burnyfox.hostzi.com/?p=1136)


## 电源充电管理，保护电池过冲，延长寿命

    yaourt -S tpacpi-bat

[具体操作](http://blog.sina.com.cn/s/blog_49895cf10101dmvw.html)


## 待机 / 休眠到磁盘：

在linux中当计算机进入休眠后，计算机会把内存中的所有信息保存到交换分区（swap partition）... 那么要求你的交换分区有足够的空间来保存RAM信息。
为啥我休眠后唤醒却正常开机呢？原因是缺少必要设置。解决办法如下：

1）增加内核启动参数

需要添加resume参数
对于GRUB2，需要修改 /boot/grub/grub.cfg的"linux"行，例如：

    linux   /boot/vmlinuz-linux root=/dev/disk/by-uuid/818dc030-8108-4428-8859-b73a58d0b0f3 rw quiet resume=/dev/sda12

其中，sda12是swap分区。


2）resume hook 添加到 initrd image

使用ROOT权限编辑/etc/mkinitcpio.conf 并且将 resume 添加到 HOOKS 中：
HOOKS="base udev autodetect ide scsi sata resume filesystems "

其中，resume 必须放在 'ide', 'scsi' and/or 'sata' 之后 ，但必须在 'filesystems'之前。

然后，必须重新制作内核镜像：

    mkinitcpio -p linux

现在就可以了，休眠试试，开机直接就回来了。


## 安装声卡

    pacman -S alsa-utils pulseaudio


## 安装蓝牙

    yaourt -S blueman-bzr

[具体设置](https://wiki.archlinux.org/index.php/Bluetooth_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87\))

[最新设置](https://wiki.archlinux.org/index.php/Blueman)


## 安装触摸板

    pacman -S xf86-input-synaptics

新建 /etc/X11/xorg.conf.d/50-thinkpad-trackpoint.conf 写入

    Section "InputClass"
        Identifier      "ThinkPad TrackPoint"
        MatchProduct    "TPPS/2 IBM TrackPoint"
        MatchDevicePath "/dev/input/event*"
        Option          "EmulateWheel"          "true"
        Option          "EmulateWheelButton"    "2"
        Option          "XAxisMapping"          "6 7"
        Option          "YAxisMapping"          "4 5"
    EndSection

新建 /etc/X11/xorg.conf.d/50-twofingerscroll.conf 写入

    Section "InputClass"
        Identifier      "two finger scrolling"
        Driver          "synaptics"
        MatchProduct    "SynPS/2 Synaptics TouchPad"
        MatchDevicePath "/dev/input/event*"
        Option          "VertTwoFingerScroll"   "on"
        Option          "HorizTwoFingerScroll"  "on"
        Option          "EmulateTwoFingerMinW"  "8"
        Option          "EmulateTwoFingerMinZ"  "40"
        Option          "TapButton1"            "1"
    EndSection


## 时间设置

    pacman -S openntpd
    systemctl enable openntpd
    hwclock --set --date="05/13/2007 12:10:20"
    hwclock --systohc


## 下载加速


A.pacman单个包的多线程下载，编辑

    /etc/pacman.conf
	
找到，类似xfercommand的话,注释掉,加上下面这句

    XferCommand = /usr/bin/axel -o %o %u

2.yaourt的aur多线程下载,编辑

    /etc/makepkg.conf
	
找到类似的句子,改成下面这样

    http::/usr/bin/axel -o %o %u
	
(当然,https,ftp等,自己可以看情况自己照着改)

3.powerpill撑满你的带宽(powerpill的具体配置自己搜索吧里面的贴子,或者是去官方wiki),编辑

    /etc/powerpill.conf
	
找到类似句子,改成下面这样

    PacmanBin = /usr/bin/pacman-color

4.实现让yaourt在下载多个包的时候能够用powerpill同时下载，编辑

    /etc/yaourtrc
	
找到类似句子,改成下面这样

    PACMAN="powerpill"