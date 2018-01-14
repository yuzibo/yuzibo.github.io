---
title: "linux关于无线的命令"
category: tools
layout: article
---

# 1. 首先确定你的无线网卡驱动

```bash
lspci

lspci | grep -i wireless

lspci | egrep -i --color 'wifi|wlan|wireless'

```

我的输出是

```bash
09:00.0 Network controller: Intel Corporation Centrino Wireless-N 105
(rev c4)
```

请记住 **09:00.0**利用他你可以找到设备名或者驱动名。

# 2. 找出无线网卡的驱动信息

我的机子上的信息是：

![wireless_1.png](http://yuzibo.qiniudn.com/wireless_1.png)

# 3. 禁用无线网络

[Here](https://www.cyberciti.biz/faq/linux-remove-wireless-networking-wifi-802-11-support-drivers/)

# 4. 配置一个无线网络接口

iwconfig 命令是一个类似于ifconfig命令的无线命令，顾名思义，就是管理网络的。它维护了基本的无线信息，比如ssid, mode,channel,bit rates, power或者更多其他的东西。下面是展示wlan0接口：

![wireless_2.png](http://yuzibo.qiniudn.com/wireless_2.png)

上面的图片展示了这些内容：

1. MAC 网络协议

2. ssid

3. The NWID

4. 频率

5. 接入点

6. 比特率

7. 电源管理 ...


## 查看连接质量

```bash
yubo@debian:~$ sudo iwconfig wlan0 | grep -i --color quality
          Link Quality=64/70  Signal level=-46 dBm

```

# 5. 在屏幕上查看连接质量

```bash
cat /proc/net/wireless
```

![wireless_3.png](http://yuzibo.qiniudn.com/wireless_3.png)

# 6. 别忘了Networkmanager

可惜的是，在debian的系统上，这个方法貌似不太好用，倒是在Ubuntu上使用的非常好，你可以直接新建一个（Shared）wifi热点。

# 7. wavemon

算是一个神器了，字符图形界面的，可以试一试。安装完成后就可以直接运行

	wavemon

命令即可。

还有几个命令，暂时先写在这里，后来总结的记在这里。













