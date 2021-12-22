---
title: 记一次pstree和systemctl解决bug的过程
category: tools
layout: post
---
* content
{:toc}

# 现象
我们的声卡使用的,如下:

`lsusb`:

```bash
user@linux:/proc$ lsusb
Bus 002 Device 003: ID 0424:5744 Standard Microsystems Corp.
Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 001 Device 016: ID 10c4:ea60 Cygnal Integrated Products, Inc. CP210x UART Bridge / myAVR mySmartUSB light
Bus 001 Device 014: ID 03f0:094a Hewlett-Packard Optical Mouse [672662-001]
Bus 001 Device 012: ID 08bb:29c3 Texas Instruments PCM2903C Audio CODEC
Bus 001 Device 011: ID 0424:2514 Standard Microsystems Corp. USB 2.0 Hub
Bus 001 Device 017: ID 0424:2740 Standard Microsystems Corp.
Bus 001 Device 015: ID 1a40:0101 Terminus Technology Inc. Hub
Bus 001 Device 020: ID 1c4f:0002 SiGma Micro Keyboard TRACER Gamma Ivory
Bus 001 Device 010: ID 0424:2744 Standard Microsystems Corp.
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
```
cat一下/proc的内容:

```c
user@linux:/proc$ cat asound/cards
 0 [tegrahdaxnx    ]: tegra-hda-xnx - tegra-hda-xnx
                      tegra-hda-xnx at 0x3518000 irq 64
 1 [jetsonxaviernxa]: jetson-xaviernx - jetson-xaviernx-ape
                      jetson-xaviernx-ape
 2 [CODEC          ]: USB-Audio - USB AUDIO  CODEC
                      BurrBrown from Texas Instruments USB AUDIO  CODEC at usb-3610000.xhci-3.1, full

```
也就是IT的xhci USB芯片，这说明，声卡的驱动是没有问题的， 但是`pactl list cards`却是找不到,由于该命令输出过于
verbose，所以暂时不贴出来了。我们通过资料分析得知，pulse的默认配置文件在`/etc/pulse/default.pa`,我们已经指定了
pulse使用 IT的这个USB作为输入:

cat /etc/pulse/default.pa

```bash
### Modules to allow autoloading of filters (such as echo cancellation)
### on demand. module-filter-heuristics tries to determine what filters
### make sense, and module-filter-apply does the heavy-lifting of
### loading modules and rerouting streams.
load-module module-filter-heuristics
load-module module-filter-apply

### Make some devices default
set-default-sink alsa_output.usb-BurrBrown_from_Texas_Instruments_USB_AUDIO_CODEC-00.analog-stereo
set-default-source alsa_input.usb-BurrBrown_from_Texas_Instruments_USB_AUDIO_CODEC-00.analog-stereo
```
还有一个tip是，其实pulseaudio还有一个damon的配置文件:  /etc/pulase/daemon.conf，这个文件可以再次指定
pulse的配置文件。

现象就是: 声卡驱动可以找到，但是pulseaudio播放异常，另外，使用 `aplay -D plughw:D(card number) test.wav`
也可以正常播放。或者使用 `pulseaudio -k`也可以enable pulseaudio 工作。

# 调查
我们一个直觉是： 有人改了pulseaudio的配置文件，导致目前的配置文件不生效了。其实，这个直觉也很重要，这是debug
的一个重要能力。

## pstree
之前没有使用到这个命令，确实有点陌生。我使用 `pstree -p`看一下:

```bash
user@linux:~$ pstree -p | grep pulse
           |-pulseaudio(7914)-+-{pulseaudio}(8021)
           |                  |-{pulseaudio}(8128)
           |                  |-{pulseaudio}(8155)
           |                  |-{pulseaudio}(8213)
           |                  `-{pulseaudio}(8268)
           |-pulseaudio(8132)-+-{pulseaudio}(8237)
           |                  |-{pulseaudio}(8252)
           |                  |-{pulseaudio}(8524)
           |                  |-{pulseaudio}(8530)
           |                  `-{pulseaudio}(8602)

```
看，这里有两个pid，直觉觉得，系统有一个pulseaudio的daemon进程就够了，那为啥有两个？如果有两个，看看是哪两个呗。

## systemctl
说实话，之前对systemd是有一些误解的。在这种情况下，想知道7914和8132是谁call起来的，systemctl就可以找到。

`ystemctl status PID`

```bash
user@linux:~$ systemctl status 7914
● ems.service - e-Media service
   Loaded: loaded (/lib/systemd/system/ems.service; enabled; vendor preset: enabled)
   Active: active (running) since Wed 2021-12-22 13:35:35 CST; 3h 23min ago
  Process: 7333 ExecStart=/bin/bash -c USERNAME=$(cat /etc/passwd | grep home | grep 1000 | cut -d: -f1); sudo -u $USERNAME /usr/bin/eswin/ems; (code=exited, status=0/SUCCESS)
 Main PID: 7370 (ems)
    Tasks: 30 (limit: 4915)
   CGroup: /system.slice/ems.service
           ├─7370 /usr/bin/eswin/ems
           ├─7706 dbus-launch --autolaunch a3d9197b765643568af09eb2bd3e5ce7 --binary-syntax --close-stderr
           ├─7728 /usr/bin/dbus-daemon --syslog-only --fork --print-pid 5 --print-address 7 --session
           ├─7738 /usr/lib/at-spi2-core/at-spi-bus-launcher
           ├─7760 /usr/lib/gvfs/gvfsd
           ├─7796 /usr/lib/gvfs/gvfsd-fuse /home/user/.gvfs -f -o big_writes
           ├─7808 /usr/bin/dbus-daemon --config-file=/usr/share/defaults/at-spi2/accessibility.conf --nofork --print-address 3
           ├─7859 /usr/lib/at-spi2-core/at-spi2-registryd --use-gnome-session
           └─7914 /usr/bin/pulseaudio --start --log-target=syslog

```
另一个pid:

```bash
user@linux:~$ systemctl status 8132
● session-c5.scope - Session c5 of user user
   Loaded: loaded (/run/systemd/transient/session-c5.scope; transient)
Transient: yes
   Active: active (running) since Wed 2021-12-22 13:35:32 CST; 3h 24min ago
    Tasks: 66
   CGroup: /user.slice/user-1000.slice/session-c5.scope
           ├─6895 lightdm --session-child 12 15
           ├─6967 /usr/bin/lxsession -s LXDE -e LXDE
           ├─8005 /usr/bin/ssh-agent /usr/bin/im-launch env LD_PRELOAD=libgtk3-nocsd.so.0 /usr/bin/startlxde
           ├─8024 /usr/bin/fcitx
           ├─8034 /usr/bin/dbus-daemon --syslog --fork --print-pid 5 --print-address 7 --config-file /usr/share/fcitx/dbus/daemon.conf
           ├─8038 /usr/bin/fcitx-dbus-watcher unix:abstract=/tmp/dbus-IweAOwOXgr,guid=5fc05ee218ca40a14535b89a61c2b929 8034
           ├─8060 openbox --config-file /home/user/.config/openbox/lxde-rc.xml
           ├─8062 lxpolkit
           ├─8065 lxpanel --profile LXDE
           ├─8067 pcmanfm --desktop --profile LXDE
           ├─8068 xscreensaver -no-splash
           ├─8071 compton --backend glx -b
           ├─8075 /usr/bin/ssh-agent -s
           ├─8082 /usr/lib/deja-dup/deja-dup-monitor
           ├─8097 update-notifier
           ├─8101 nm-applet
           ├─8103 python3 /usr/share/nvpmodel_indicator/nvpmodel_indicator.py
           ├─8105 zeitgeist-datahub
           ├─8132 /usr/bin/pulseaudio --start --log-target=syslog
```
显而易见，8132是系统级别的，一般的情况下，我们无法触动他的启动，7914是我们开发的ems引发的，大概率问题出现在这里面。
经过询问相关的同事，确实在代码里调用了`pulseaudio`.

# 结论
其实，这个过程更像是debug的一个回顾:

1. 相关命令工具的使用；
2. 解决bug的思路。
3. 培养如何预见bug的能力。

