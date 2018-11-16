---
layout: post
title: "Debian编译linux内核"
category: kernel
---

* content
{:toc}

# 终于成功一次了
之前重新编译了好多次，可惜没有一次成功的，说实话，借助Debian强大的dpkg软件包管理，使得重新编译内核仅仅像安装软件一样简单，我都觉得这不是正宗的编译内核，好了，废话不多说，马上进入主题。

## 下载内核源代码(1)
我没有使用最新的内核源代码，用的 3.2.64,我们可以在[http://www.lkml.org](http://www.lkml.org)下载，注意这里我们下载的是.xz文件,需要解压两次。至于源代码放在哪里，完全取决于你自己，你想放在哪里就放在哪里，我直接放在在用户主目录都可以啊。

## 解压

>xz -d linux-xx

(xx就是你下载的内核源代码的版本)，这时生成.tar文件，然后

>tar -xvf linux-xx

## 安装所需的软件包

	sudo apt-get install kernel-package libncurses5-dev fakeroot build-essential bc

## 使用git

利用git得到linus的最新 kernel,然后执行 ```make clean ```,接下来执行

``` make menuconfig```

### tips
如果你想单独编译某个模块,可以单独地编译那个模块(不建立镜像)

	make drivers/usb/serial

下面可以建立镜像

	make M=drivers/usb/serial

如果你想把内核镜像编译在别处,那么则可以使用

	make O=~/linux-kernel-image-dir



## 配置内核
这个怎么说呢，在你没有对内核配置选项有个清醒的认识之前，我的建议是使用你本机的默认配置吧，我之前配置失败就是想弄清楚配置选项的每一个，结果备受挫折，先看看编译内核是什么样的，以后我们再说这些也不错啊。

>cd linux-XX

先进入目录，我们如使用默认配置的话，


__"cp /boot/config-`uname -r` .config"__,如果我们自己一定要配置，我建议使用 __make menuconfig__

## 使用git获取源代码(2)

## 编译内核1
首先,

	make-kpkg clean

稍微等一会，我们接着使用命令

>fakeroot make-kpkg --initrd --revesion=1.0.xx  kernel_image

# Update:
不用debian的软件包,自己完全可以手动解决问题:配置完config后,就可以执行

	make

	make modules_install install




## 再更新,请参阅下面的make dep-pkg

===================================
===================================
舍不得del，但是这段真的没有多大的用处
===================================
===================================


现在，在我的机子上，上面的方法已经不好使了。我重新按照原来的方法在安装新的 kernel
我们有必要讲讲make-kpkg与fakeroot这两个软件包，前者是可以自动替换

```bash
make dep;
make clean;
make bzImage;
make modules
```

命令序列的脚本，而--append-to-version就是让我们来指定一个额外的内核版本，这个版本是成为内核名的一部分，我们可以使用数字，“+”，“,”,但是不能使用“_”,在这里的用法我借鉴网上同学的例子，使用当天日期来解决不同的版本号问题。内核模块位于/lib/modules子目录下，每一个内核都有它自己的子目录，所以每次我们创建新内核时使用新的内核名字，这个包安装程序就会在/lib/modules目录下创建一个新的子目录来保存它自己的模块。

注意，--revesion只会影响Debian软件包本身的名字而不是内核的名字，Debian kernel-image文件的名字格式如下：

kernel-image-(kernel-version)(--append-to-version)_(--version)_(architecture).deb.至于什么是fakeroot这一点我也不是很清楚，好像是模拟root环境来创建一个kernel-image软件包。

## 创建Ramdisk

经过漫长的等待后，我们在代码目录的上一层目录就得到一个linux-image-3.2.64.141111_3.2.64.141111-10.00.Custom_i386.deb的软件包，别急，我们还有一步工作需要完善。

下面是废话，可以忽略。我们有一个问题是boot过程中mount根文件系统的“先有鸡还是先有蛋的问题”，一般来说，根文件在形形色色的存储设备上，不同的设备又要不同的硬件厂商的驱动，比如intel的ide/sata驱动，VIA的南桥需要VIA的ide/sata驱动，根文件系统也不同的文件系统的可能，假如把所有的驱动/模块都编译进内核，那自然没问题，可现实（内核的精神或本质）是我们把驱动/模块都驻留在根文件系统本身/lib/modules/xxx,那么“鸡蛋”问题就就来了，要mount根文件系统却需要根文件系统上的文件系统，怎么办？于是，就想出了下面的ramdisk,内核总是能安装ramdisk的(__因为ramdisk临时文件和内核一样，也是由bootloader通过低级读写命令（uboot用nand read，而不用通过系统层提供的高级读写接口）加载进内存，因此内核可以挂载ramdisk文件系统），然后把所有要使用到的驱动/模块都放在ramdisk上，首先，让内核将ramdisk当作根文件来安装，然后再利用这个根文件系统上的驱动来真正安装根文件系统，就将这个问具体解决了。补充，有时间你可以到/boot文件目录下看看，会有一个initrd.img的文件，initrd大体上就是 包含根文件系统的ramdisk。说了这么多，重点还没有解决，也就是我们需要创建这么一个文件-initrd，将我们新编译的内核在根文件系统挂载前能装进内存，那么，我们该怎么样解决这个问题呢？

  首先，使用vi编辑/boot/config-3.2.64.141111文件，将代码__CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"__这句话注释掉（在句首用#），否则我们就不会成功。接下来执行

>mkinitramfs -o /boot/initrd.img-3.2.64.141111  3.2.64.141111

直观上我们可以理解生成目标文件initrd.img-3.2.64.141111,我们做的所有工作你最后在/boot目录下会发现的。


===================================
===================================
舍不得del，但是这段真的没有多大的用处
===================================
===================================

# make deb-pkg

在执行下面的命令前，首先执行:

	sudo apt install dpkg-dev

这个命令能解决诸多dpkg-*的错误，比如： `dpkg-buildpackage`: command not found

如果说在debian中，最能体现debian的特色了，莫过于debian的软件包管理了。上面删除线的内容，在几年前可能是真实的，但是现在，不知道为什么会出现这样那样的问题
，而debian的维护者又开发了一种新的编译内核的方法，相对来说，简单不少。

[请参考](https://debian-handbook.info/browse/stable/sect.kernel-compilation.html)

在完成内核的配置后，在linux kernel tree代码目录中键入

	make deb-pkg

这条命令会在tree的父目录产生5个*.deb,这样的条件下，你只需要使用：

	dpkg -i xx,

依我的为例，产生了：

```bash
inux-firmware-image-4.10.0-rc8+_4.10.0-rc8+-1_i386.deb
linux-headers-4.10.0-rc8+_4.10.0-rc8+-1_i386.deb
linux-image-4.10.0-rc8+_4.10.0-rc8+-1_i386.deb
linux-image-4.10.0-rc8+-dbg_4.10.0-rc8+-1_i386.deb
linux-libc-dev_4.10.0-rc8+-1_i386.deb
```

还有一个 .tar文件，先使用 __dpkg__ 安装*_headers_*包，接着安装镜像文件。

当然，你还可以使用 dpkg命令去删除他们，这和你使用 apt-get命令去装软件是一样的，维护了软件包之间的关系完整性。


## 更新grub

我又安装了grub2,使用命令

	update-grub2


## 感谢
首先感谢我女友春春的理解和支持，有她在背后，我感觉很幸福;这篇文章我重点参考了[The blog](http://www.blog.csdn.mylxiaoyi/post/details/1499397)

### 最后更新

这篇文章需要重写，步骤有很多的过时的。

说白了，在安装完了新的内核后，之后主要的问题就是grub的配置了。

我需要记一篇关于grub的文章。这里先简单的说下我的问题。

之前使用 kernel自带的万用的的 make && make install modules_insatll,然后直接改写 /boot/grub/grub.cfg,这明显是针对的 grub v2,说明的grub是v2。怎么改呢，就是copy  menuentry,将initrd-xx和image-xx的路径写正确，但是最近几次，在启动的时候报 uuid的错误，搜寻了n多网页，实在没辙了。偶然间，发现：

/boot/grub/grub.cfg 这个文件是系统生成的，不能手动改写 （但是我已经动了），，这个文件的构建基于/etc/default/grub 和/etc/grub.d/*,而且只要 update-grub(其实应该是update-grub2),会自动写入/boot/grub/grub.cfg.但是我的不能，这次启动新的内核，是由于修改了/etc/default/grub 的 GRUB_DISABLE_UUID=true,然后手动改写了/boot/grub/grub.cfg,这才成功的。

也就说，你得知道你的grub是什么版本的。这里我只是说一下 grub2.安装grub2会重写
grub的引导项，因为我是在一个硬盘安装了双系统，所以在安装的过程中会问你引导项安装到什么地方，我选择的是整块硬盘。

执行 __update-grub2__ 即可发现了新的kernel.

最后总结一点，就是，如果你的grub是v1,在启动的时候遇到了麻烦，那么可以直接试着修改   /boot/grub/grub.cfg,如果遇到了uuid的错误，那么就将/etc/default/grub中的GRUB_DISABLE_UUID=true.

上面是不提倡的一种做法，还要使用debian的官方提倡的做法，使用grub2,这样，安装内核就像安装普通的软件包一样可以那样。


