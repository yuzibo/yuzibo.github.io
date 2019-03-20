---
title: "ipv4协议"
category: network
layout: post
---

* content
{:toc}

# ipv4 Racket Header

![2018-05-16-ipv4_racket_header.png](http://yuzibo.qiniudn.com/2018-05-16-ipv4_racket_header.png)

图片的问题因为图床的原因，所以挂了。我再找找其他方案

```bash
  0                   1                   2                   3
  0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  |Version|  IHL  |Type of Service|          Total Length         |
  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  |         Identification        |Flags|     Fragment Offset     |
  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  |  Time to Live |    Protocol   |        Header Checksum        |
  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  |                         Source Address                        |
  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  |                      Destination Address                      |
  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  |                    Options                    |    Padding    |
  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

```

看到这幅图片，请不要惊讶我的耐心，这是我发现的一个ascii利器，详细的介绍
在[这里](https://github.com/luismartingarcia/protocol) 还可以自己制定协议
字节什么的，那么，最上面的１表示什么呢?就是十位数上的数字而已.


Let's walk throught all these fields, but this is not bits in the pic:

``Version`` the first field tells us which IP version we are using, only IPv4 uses this header so you will always find decimal value 4 here.


``Header Length`` this 4 bits field tells us the length(bytes) of the IP header in 32 bit increments.If here is 20 bytes in the ip header, the value of 5 here, if the value is 15(0x1111), the IHL is 60 bytes.
Please note here, you would better to think it why it is the 5 and 20. Hint: 5 bytes = 5 * 32 (160) bits.If you have other data, must add it of 4 bytes(20, 24, 28...)

``Type of service`` This is used for Qos.

``Total Length`` The minimum size is 20 bytes(if you have no data) and the maximum size is 65536 bytes.

``Identification`` If the IP packet is fragmented then each fragment packet will use the same 16 bit identification number to identify to which IP packet they belone to.

``IP Flags`` : The first bit is alway set to 0; The second bit is called ``DF``(dont fragment) and indicates this packet should not be fragmented.The third bit is called the ``MF``(more fragments) bit and is set on all fragment packets except the last one.

``Fragment Offset``: this 13 bit field specifies the position of the fragment in the original fragmented IP packet.

``Time to live``: only ttl value is 0, the packet will be dropped. ICMP.

``Header Checksum``, ``Source address``, ``Destination Address``, ``IP option``...
