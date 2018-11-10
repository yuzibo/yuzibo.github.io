---
layout: post
title: "Debian7设置"
category: debian
---

本配置适用于debian7，图形界面使用的是xfce4.8，编辑器默认使用xfce中的mousepad。
其中$、#是提示符，表示当前终端账户是普通还是root,并不需要输入。

以下所有操作均使用`root`权限。
在终端下输入并回车

    $ su root

然后输入root的密码（安装debian时设定的，区别于普通用户密码）


## 设定更新源

编辑使用图形界面下的文本编辑器如xfce下的mousepad.如果使用其他的，则将mousepad换成别的即可。

     mousepad /etc/apt/sources.list


在文件最前面添加以下条目

    #######主要，开源，闭源
    deb http://mirrors.163.com/debian wheezy main non-free contrib
    deb-src http://mirrors.163.com/debian wheezy main non-free contrib

    #######wheezy-proposed-updates建议更新
    deb http://mirrors.163.com/debian wheezy-proposed-updates main contrib non-free
    deb-src http://mirrors.163.com/debian wheezy-proposed-updates main contrib non-free

    #######wheezy-updates推荐更新
    deb http://mirrors.163.com/debian wheezy-updates main contrib non-free
    deb-src http://mirrors.163.com/debian wheezy-updates main contrib non-free

    #######wheezy/updates安全更新
    deb http://mirrors.163.com/debian-security wheezy/updates main contrib non-free
    deb-src http://mirrors.163.com/debian-security wheezy/updates main contrib non-free
    deb http://http.us.debian.org/debian wheezy main contrib non-free
    deb http://security.debian.org wheezy/updates main contrib non-free

关闭文本编辑器，然后在终端中输入

     apt-get update


## 安装中文字体

安装文泉宋体

     apt-get install xfonts-wqy ttf-wqy-zenhei ttf-wqy-microhei

安装uming宋体

     aptitude install fonts-arphic-uming ttf-arphic-uming

安装外来字体

把字体文件（比如simsun.ttc）直接cp 到 ~/.fonts下，即可。


## 中文编码

要支持区域设置，首先要安装locales软件包：

     apt-get install locales

然后配置locales软件包：

     dpkg-reconfigure locales

在界面中钩选上 `zh_CN.UTF-8` ,确定，在接下来的选项中也选择 `zh_CN.UTF-8`
然后重启，到这里应该就可以显示中文了


## 为普通用户安装sudo

sudo可以让非root用户具有管理员的权限，安装好的Debian后还不能使用sudo,需要使用root用户登陆后安装sudo命令。

     apt-get install sudo

安装后，就可以给你的帐号设置管理员权限了

     mousepda /etc/sudoers

在 root ALL=(ALL:ALL) ALL 的下一行，添加一行

    username ALL=(ALL:ALL) ALL

这里的username就是你要给予一定权限的用户
然后保存，退出root，然后使用username用户登陆。应该就有sudo权限了。


## 安装NVIDIA显卡

确定电脑是使用的NVDIA卡再装,因为NVDIA的驱动之前一直是闭源的,近期才向开源社区提供,所以不能保证百分百的支持所有显卡.如果安装完后无法进入桌面的话就说明不支持你的显卡,还是重装使用默认的驱动好了.

     apt-get install nvidia-glx nvidia-kernel-dkms nvidia-xconfig nvidia-settings

     nvidia-xconfig


## 解决笔记本无法调节亮度

     mousepad /etc/X11/xorg.conf

找到这一段。

    Section "Screen"
    Identifier "Screen0"
    Device "Device0"
    ……
    Option "RegistryDwords" "EnableBrightnessControl=1"
    EndSection

即在EndSection前添加`“Option "RegistryDwords" "EnableBrightnessControl=1"”`这一行，最好加在指定行！！！不然可能无效
然后保存，退出，重启之后，你就会发现可以调节屏幕背光亮度了。


## 解决触摸板无法点击

     mousepad /usr/share/X11/xorg.conf.d/10-evdev.conf

修改这里（里面的配置很像、主要Identifier部分来辨别到底改哪的部分）

    Section "InputClass"
    Identifier "evdev touchpad catchall"
    MatchIsTouchpad "on"
    MatchDevicePath "/dev/input/event*"
    Driver "synaptics"
    Option "TapButton1" "1"
    Option "TapButton2" "2"
    Option "TapButton2" "3"
    EndSection


## 解决硬盘load/load问题

安装laptop-mode-tools

     apt-get install laptop-mode-tools

编辑配置

     mousepad /etc/hdparm.conf

将后面的配置修改为下面配置

    /dev/hda {
    mult_sect_io = 16
    write_cache = off
    dma = on
    apm = 255
    apm_battery = 127
    }


## 安装中文输入法

安装fcitx

     apt-get install fcitx fcitx fcitx-googlepinyin

安装im-switch

     apt-get install im-switch


## 安装源码工具：

     apt-get install  build-essential linux-headers-$(uname -r)


## 安装Chrome（两种方法任选一）

### A.deb包安装法：

1.切换到deb包目录下


     dpkg -i google-chrome-stable_amd64.deb

这时会提示错误，依赖关系没有满足，无法安装。

2.接下来，我们解决依赖关系。

     apt-get -f install

这样，就会先自动安装依赖的软件包，然后自动安装好deb包.

3.如果想卸载deb安装的包，先要确定安装的名字，如Chrome就是在终端中可以执行的名字

     dpkg -r chrmoe

### B.apt-get安装法：

     apt-get install chromium-browser chromium-browser-l10n


## 安装iceweasel中文包

     apt-get install iceweasel-l10n-zh-cn

运行浏览器，然后点击
浏览器菜单 ===> 编辑 ===> 首选项 ===> 内容
设置浏览器字体


## 安装Flash插件

     apt-get install gnash browser-plugin-gnash


## 安装解压缩软件

     apt-get install unrar unzip p7zip-full


## 安装版本控制软件

     apt-get install git bzr mercurial


## 安装读写ntfs分区

对ntfs分区有危险，常常让ntfs分区的文件损坏.慎重使用。

     apt-get install ntfs-3g


## 启用i386，使64位系统兼容32位软件

     dpkg --add-architecture i386

安装后 apt 会把 i386 的软件包一起 cache 起来，执行：

     apt-get update

完成后就可以安装 ia32-libs 了：

     apt-get install ia32-libs ia32-libs-gtk

安装后只要依赖关系满足，32 位的程序就能正常运行了。

如果以后不想要 i386 支持了，只要运行：

     dpkg --remove-architecture i386


## 安装FoxitReader

在http://www.foxitsoftware.cn/downloads/中->福昕阅读器 -> Desktop Linux  -> bz2
下载 FoxitReader-1.1.0.tar.bz2
解压到 /usr/local 中

     tar -jxvf FoxitReader-1.1.0.tar.bz2 -C /usr/local

重命名文件夹

     mv /usr/local/1.1-release /usr/local/FoxitReader

在 /usr/local/bin 中添加访问路径

     ln -s /usr/local/bin /usr/local/FoxitReader/FoxitReader


## 笔记本外接显示器：

外接显示器在右侧拓展:

     xrandr --output LVDS-0 --auto --left-of VGA-0

外接显示器在左侧拓展:

     xrandr --output VGA-0 --auto --left-of LVDS-0

也可以使用arandr通过图形界面来配置双屏幕

     apt-get install arandr


## 安装音频软件

这里使用audacious软件

     apt-get install audacious


## 安装截屏软件

这里使用shutter软件

     apt-get install shutter
