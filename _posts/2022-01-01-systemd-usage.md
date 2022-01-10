---
title: systemd usage
category: tools
layout: post
---
* content
{:toc}

# 查看系统启动时间

```bash
systemd-analyze --order
Startup finished in 3.515s (kernel) + 10min 4.683s (userspace) = 10min 8.198s
graphical.target reached after 10min 4.623s in userspace
```

然后可以看到我们的graphical.target已经达到了10min，这个是无法忍受的！那么，需要看一下是哪里引起的如此耗时。

这里还可以以图片的形式展示出来：
```bash
systemd-analyze --order plot > boot.svg
```

然后通过Chrome就可以看一下这个文件的全局了。

# 查看每个service使用的时间

```bash
user@linux:~$ systemd-analyze --order
Startup finished in 3.515s (kernel) + 10min 4.683s (userspace) = 10min 8.198s
graphical.target reached after 10min 4.623s in userspace
user@linux:~$ systemd-analyze blame
    10min 3.354s displaytouch.service
         11.693s k3s.service
          5.428s rc-local.service
          3.185s dev-zram0.device
          3.130s dev-zram1.device
          3.123s docker.service
          3.071s dev-zram2.device
          3.039s dev-zram3.device
          2.956s dev-zram5.device
          2.953s dev-zram4.device
          2.484s dev-nvme0n1p1.device
          1.930s srs.service
          1.353s apt-daily-upgrade.service
          1.272s apt-daily.service
           999ms udisks2.service
           965ms nv-l4t-usb-device-mode.service
...
```
这样系统启动在哪里卡住一目了然。

还有一个是 `systemd-analyze critical-chain xx`也是值得使用的一个命令。

# 查看fail的Unit

```bash
 sudo systemctl list-units --failed --all
```

还得最好根据`type`来定:

```bash
 systemctl list-units --type=target --all
```
