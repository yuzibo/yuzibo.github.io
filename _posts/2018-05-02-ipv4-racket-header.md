---
title: "ipv4协议"
category: network
layout: article
---

# ipv4 Racket Header

![2018-05-16-ipv4_racket_header.png](http://yuzibo.qiniudn.com/2018-05-16-ipv4_racket_header.png)

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
