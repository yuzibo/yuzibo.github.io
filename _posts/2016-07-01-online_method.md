---
title: "快速搭建上网工具"
category: tools
layout: article
---

# 提前声明

我真的不讨厌GFW，因为现在话语权不在我们的手中，我们必须保护自己。至于外网上
的东西，我们应该有自己的辨别能力。从内容和数量上来说，那些对china不利的网络
言论与对America不利的网络言论，根本不是一个数量级。再一个恶心的是，Youtube,
即便你是单纯的想休闲娱乐，可是不超过三次单击，有关我国的负面新闻铺面而来。
难道国外的领导人真的那么清廉。

# 应急的方法

如果其他方法暂时无法使用了，先使用最简单的ssh代理，也就是你必须随身携带一个
vps。

无论使用什么浏览器，最根本的一句命令是

```bash
ssh -N -D 7070 root@your_ip
```

### firefox

> 首选项-》高级-》网络-》设置

只使用SOCKS那个选项，主机填上127.0.0.1，端口是7070,下面的类型选择SOCKS_v5

### chromium

首先安装的话，

```bash
sudo apt-get update

apt-get install chromium chromium-l10n

```

这一个是chrome的测试版本吧，开源的，比较好用的。先用它得了。

但是它不支持Desktop，只能使用命令行，在完成上面的配置后，你可以使用如下command打开chromium

```bash
chromium --proxy-server="socks:127.0.0.1:7070"
```

# 日常使用

前面是应急使用的，正常渠道我们应该好的工具。

如果我写得不清晰，接下来请看[这篇](https://aitanlu.com/ubuntu-shadowsocks-ke-hu-duan-pei-zhi.html)

但是我还要自己写一下，以免到时用的时候找不到了。

### 服务端

这个可以自己搭建，可以购买。自己搭建的步骤我会完善，现在我的重点是在客户端上。

### client

#### insatll

[debian]

Frist, please type the command as followings:

```bash
sudo apt-get update
apt-get install python-pip python-setutools m2crypto
```

#### startup

Locally we need `sslocal`, normanlly you can use `man sslocal`,

[shell script](https://github.com/yuzibo/configure_file/blob/master/online/shadowsocks/ss.sh)

Laterlly, you can add SwitchyOmega plug-in.

But here is many detail to be carefully.

## 1.新建情景模式

>	名称->代理服务器 ->

在新的代理服务器下选择代理协议(SOCKS5),代理服务器为127.0.0.1, 端口为1080.
每次先打开ss客户端，再切换到这里就行了。

## 2.自动切换

这个玩的比较高深，没有弄明白它。




