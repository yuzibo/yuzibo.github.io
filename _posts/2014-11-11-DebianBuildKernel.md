---
layout: article
title: "Debian编译linux内核"
category: kernel programming
---
#终于成功一次了
之前重新编译了好多次，可惜没有一次成功的，说实话，借助Debian强大的dpkg软件包管理，使得重新编译内核仅仅像安装软件一样简单，我都觉得这不是正宗的编译内核，好了，废话不多说，马上进入主题。

##下载内核源代码(1)
我没有使用最新的内核源代码，用的 3.2.64,我们可以在[http://www.lkml.org](http://www.lkml.org)下载，注意这里我们下载的是.xz文件,需要解压两次。至于源代码放在哪里，完全取决于你自己，你想放在哪里就放在哪里，我直接放在在用户主目录都可以啊。

##解压
__xz -d linux-xx__
	(xx就是你下载的内核源代码的版本)，这时生成.tar文件，然后

__tar -xvf linux-xx__
##安装所需的软件包
__sudo apt-get install kernel-package libncurses5-dev fakeroot build-essential bc__
##配置内核
这个怎么说呢，在你没有对内核配置选项有个清醒的认识之前，我的建议是使用你本机的默认配置吧，我之前配置失败就是想弄清楚配置选项的每一个，结果备受挫折，先看看编译内核是什么样的，以后我们再说这些也不错啊。

__cd linux-XX__

先进入目录，我们如使用默认配置的话，

__"cp /boot/config-`uname -r` .config"__,如果我们自己一定要配置，我建议使用__make menuconfig__
##使用git获取源代码(2)

##编译内核
首先,

	__make-kpkg clean__

稍微等一会，我们接着使用命令

__fakeroot make-kpkg --initrd --revesion=yubo.1.0  kernel_image__


我们有必要讲讲make-kpkg与fakeroot这两个软件包，前者是可以自动替换__make dep;make clean;make bzImage;make modules__命令序列的脚本，而--append-to-version就是让我们来指定一个额外的内核版本，这个版本是成为内核名的一部分，我们可以使用数字，“+”，“,”,但是不能使用“_”,在这里的用法我借鉴网上同学的例子，使用当天日期来解决不同的版本号问题。内核模块位于/lib/modules子目录下，每一个内核都有它自己的子目录，所以每次我们创建新内核时使用新的内核名字，这个包安装程序就会在/lib/modules目录下创建一个新的子目录来保存它自己的模块。

__注意__，--revesion只会影响Debian软件包本身的名字而不是内核的名字，Debian kernel-image文件的名字格式如下：

__kernel-image-(kernel-version)(--append-to-version)_(--version)_(architecture).deb__.至于什么是fakeroot这一点我也不是很清楚，好像是模拟root环境来创建一个kernel-image软件包。
##创建Ramdisk
经过漫长的等待后，我们在代码目录的上一层目录就得到一个linux-image-3.2.64.141111_3.2.64.141111-10.00.Custom_i386.deb的软件包，别急，我们还有一步工作需要完善。下面是废话，可以忽略。我们有一个问题是boot过程中mount根文件系统的“先有鸡还是先有蛋的问题”，一般来说，根文件在形形色色的存储设备上，不同的设备又要不同的硬件厂商的驱动，比如intel的ide/sata驱动，VIA的南桥需要VIA的ide/sata驱动，根文件系统也不同的文件系统的可能，假如把所有的驱动/模块都编译进内核，那自然没问题，可现实（内核的精神或本质）是我们把驱动/模块都驻留在根文件系统本身/lib/modules/xxx,那么“鸡蛋”问题就就来了，要mount根文件系统却需要根文件系统上的文件系统，怎么办？于是，就想出了下面的ramdisk,内核总是能安装ramdisk的(__因为ramdisk临时文件和内核一样，也是由bootloader通过低级读写命令（uboot用nand read，而不用通过系统层提供的高级读写接口）加载进内存，因此内核可以挂载ramdisk文件系统），然后把所有要使用到的驱动/模块都放在ramdisk上，首先，让内核将ramdisk当作根文件来安装，然后再利用这个根文件系统上的驱动来真正安装根文件系统，就将这个问具体解决了。补充，有时间你可以到/boot文件目录下看看，会有一个initrd.img的文件，initrd大体上就是 包含根文件系统的ramdisk。说了这么多，重点还没有解决，也就是我们需要创建这么一个文件-initrd，将我们新编译的内核在根文件系统挂载前能装进内存，那么，我们该怎么样解决这个问题呢？

  首先，使用vi编辑/boot/config-3.2.64.141111文件，将代码__CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"__这句话注释掉（在句首用#），否则我们就不会成功。接下来执行

__mkinitramfs -o /boot/initrd.img-3.2.64.141111  3.2.64.141111__

直观上我们可以理解生成目标文件initrd.img-3.2.64.141111,我们做的所有工作你最后在/boot目录下会发现的。

##更新grub
__grub-update__
Update:
只是简单的修改menu.lst是不行，必须将 /boot/grub/grub.cfg比着葫芦画瓢才行。你可以使用menu.lst的对照选项。

赶快重启吧，你就会发现在grub的引导菜单上有自己版本的内核了。
Upda

##感谢
首先感谢我女友春春的理解和支持，有她在背后，我感觉很幸福;这篇文章我重点参考了[The blog](http://www.blog.csdn.mylxiaoyi/article/details/1499397)
