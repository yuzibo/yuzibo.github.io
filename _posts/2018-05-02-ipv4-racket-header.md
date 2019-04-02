---
title: "ipv4协议－通过实验参看三次握手"
category: network
layout: post
---

* content
{:toc}


# 访问daytime

首先，我们可以写一个简单的网络服务测试，基于客户端的，产生一个最基本的tcp访问，然后通过tcpdump把里面的各个过程展示出来。
daytime是一个unix的很老的服务了，其端口号是13. debian下面的daytime由**xinetd**,安装完成后是默认不开启服务的，需要自己:

```c
ls /etc/xinetd.d/
chargen  daytime  discard  echo     time
```
把daytime的配置文件中的disable字段设置`no`. 接着使用:

```bash
/etc/init.d/xinetd status  # 查看状态
/etc/init.d/xinetd start/restart/stop # 控制xinetd的行为
```
# 实验
我在debian的系统里面使用了一个虚拟机，该虚拟机在主机上面的网卡叫**virbr0**，这个可以通过　
**ifconfig**命令去查看。

```c
       122.1  virbr0   122.173
	host <=======> vm1

```
通过在host去访问vm1中的daytime服务，建立一个最基本的tcp链接，观察三次握手过程。

## 虚拟机
 在虚拟机里面编译以下程序，作为访问daytime服务的client程序。
```c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <netdb.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <string.h> // bzero
#include <arpa/inet.h>

#define MAXSIZEDATA 2048
int main(int argc, char **argv)
{
	int socketfd, nbytes;
	char recvline[MAXSIZEDATA + 1];
	struct sockaddr_in serveraddr;

	if (argc != 2){
		perror("Usage, too small ");
		exit(1);
	}

	if ((socketfd = socket(AF_INET, SOCK_STREAM, 0)) < 0)
	{

		perror("socket error\n");
		exit(1);
	}

	bzero(&serveraddr, sizeof(serveraddr));
	/* 上面就是一个简单的申请*/
	/* 填充 socket 封装头　*/
	serveraddr.sin_family = AF_INET;
	serveraddr.sin_port = htons(13);

	if (inet_pton(AF_INET, argv[1], &serveraddr.sin_addr) <= 0){
		perror("inet_pton is error\n");
	}
	/* 如果有domin的话，需要使用 inet_pton 转化为　ip*/
	if (connect(socketfd, (struct sockaddr *)&serveraddr, sizeof(struct sockaddr)) == -1){
		perror("connect error\n");
		exit(1);
	}

	while(( nbytes = read(socketfd, recvline, MAXSIZEDATA)) > 0){
		recvline[nbytes] = '\0'; /* 网络编程尤其注意这一点　*/
		if (fputs(recvline, stdout) == EOF)
			perror("fputs, error");
	}

	if (nbytes < 0)
		perror("read error\n");

	exit(0);
}

```
这个代码可以直接gcc,并不依赖其他的网络库。
```c
gcc -g tcp_capture.c -o tcp
```

# host捕捉
使用**tcpdump**去捕捉相应的包即可。在主机中，使用:
```c
sudo tcpdump -i virbr0 tcp port 13 -X -s0
```
其中，　**-i**是指定网卡，**tcp**是制定捕捉的协议，**-X**为以十六进制，
就是以十六进制打印数据报文，但是不显示以太网祯的报头，只显示IP层的内容
**-s0**是抓报长度，一般设置为0，即65535字节

同时在虚拟机里面：
```c
yubo-2@debian:~/test$ ./tcp 192.168.122.1
22 MAR 2019 15:31:32 HKT
```
这个时候在主机就会产生：

```c
yubo@debian:~$ sudo tcpdump -i virbr0 tcp port 13 -x -s0
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on virbr0, link-type EN10MB (Ethernet), capture size 262144 bytes
15:31:32.411059 IP bogon.59432 > bogon.daytime: Flags [S], seq 3886862313, win 29200, options [mss 1460,sackOK,TS val 2598220276 ecr 0,nop,wscale 7], length 0
	0x0000:  4500 003c 8fac 4000 4006 3510 c0a8 7aad
	0x0010:  c0a8 7a01 e828 000d e7ac cfe9 0000 0000
	0x0020:  a002 7210 762e 0000 0204 05b4 0402 080a
	0x0030:  9add b1f4 0000 0000 0103 0307
15:31:32.411099 IP bogon.daytime > bogon.59432: Flags [S.], seq 1126042841, ack 3886862314, win 65160, options [mss 1460,sackOK,TS val 457846070 ecr 2598220276,nop,wscale 7], length 0
	0x0000:  4500 003c 0000 4000 4006 c4bc c0a8 7a01
	0x0010:  c0a8 7aad 000d e828 431e 0cd9 e7ac cfea
	0x0020:  a012 fe88 762e 0000 0204 05b4 0402 080a
	0x0030:  1b4a 2d36 9add b1f4 0103 0307
15:31:32.411275 IP bogon.59432 > bogon.daytime: Flags [.], ack 1, win 229, options [nop,nop,TS val 2598220276 ecr 457846070], length 0
	0x0000:  4500 0034 8fad 4000 4006 3517 c0a8 7aad
	0x0010:  c0a8 7a01 e828 000d e7ac cfea 431e 0cda
	0x0020:  8010 00e5 7626 0000 0101 080a 9add b1f4
	0x0030:  1b4a 2d36
15:31:32.411364 IP bogon.daytime > bogon.59432: Flags [P.], seq 1:27, ack 1, win 510, options [nop,nop,TS val 457846071 ecr 2598220276], length 26
	0x0000:  4500 004e 6f21 4000 4006 5589 c0a8 7a01
	0x0010:  c0a8 7aad 000d e828 431e 0cda e7ac cfea
	0x0020:  8018 01fe 7640 0000 0101 080a 1b4a 2d37
	0x0030:  9add b1f4 3232 204d 4152 2032 3031 3920
	0x0040:  3135 3a33 313a 3332 2048 4b54 0d0a
15:31:32.411380 IP bogon.daytime > bogon.59432: Flags [F.], seq 27, ack 1, win 510, options [nop,nop,TS val 457846071 ecr 2598220276], length 0
	0x0000:  4500 0034 6f22 4000 4006 55a2 c0a8 7a01
	0x0010:  c0a8 7aad 000d e828 431e 0cf4 e7ac cfea
	0x0020:  8011 01fe 7626 0000 0101 080a 1b4a 2d37
	0x0030:  9add b1f4
15:31:32.411583 IP bogon.59432 > bogon.daytime: Flags [.], ack 27, win 229, options [nop,nop,TS val 2598220276 ecr 457846071], length 0
	0x0000:  4500 0034 8fae 4000 4006 3516 c0a8 7aad
	0x0010:  c0a8 7a01 e828 000d e7ac cfea 431e 0cf4
	0x0020:  8010 00e5 7626 0000 0101 080a 9add b1f4
	0x0030:  1b4a 2d37
15:31:32.412117 IP bogon.59432 > bogon.daytime: Flags [F.], seq 1, ack 28, win 229, options [nop,nop,TS val 2598220277 ecr 457846071], length 0
	0x0000:  4500 0034 8faf 4000 4006 3515 c0a8 7aad
	0x0010:  c0a8 7a01 e828 000d e7ac cfea 431e 0cf5
	0x0020:  8011 00e5 7626 0000 0101 080a 9add b1f5
	0x0030:  1b4a 2d37
^C
7 packets captured
8 packets received by filter
1 packet dropped by kernel

```
看到没有，这个时候就是７个包，可以说就是完整的包含了三次握手、四次挥手的过程。其实，这个说法是不准确的。
其中有一次是发送的数据，四次挥手的最后一次没有完成。

还有，在我们这个实验模型中，上面的数据来自**bogon.59432**是客户端，**bogon.daytime**是服务端，观看数据的时候
应该首先弄清楚是由谁发出来的，发到哪里去

我们以第一个数据包进行分析。

# ipv4 Racket Header
##８ 报文分析
```c
t-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-2
|            ip报头             |        IP数据区 　　　        |  ip
t-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-2
|                    　　 　    ｜       TCP报头 |　　tcp数据区 |  tcp
t-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-2
```
这只是我简化的一个示意图，就是这两种协议大概的协议布局。


```c
15:31:32.411059 IP bogon.59432 > bogon.daytime: Flags [S], seq 3886862313, win 29200, options [mss 1460,sackOK,TS val 2598220276 ecr 0,nop,wscale 7], length 0
	0x0000:  [[4500 003c    8fac 4000 4006 3510 c0a8 7aad
	0x0010:    c0a8 7a01]] {e828 000d e7ac cfe9 0000 0000
	0x0020:    a002 7210    762e 0000 0204 05b4 0402 080a
	0x0030:    9add b1f4    0000 0000 0103 0307}
```
上面**[[]]**即为ip报文，**{}**即为tcp头部。


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
字节什么的，那么，最上面的１表示什么呢?就是十位数上的数字而已.一个十六进制的
数字是4bits.


Let's walk throught all these fields, but this is not bits in the pic:

**Version** the first field tells us which IP version we are using, only IPv4 uses this header so you will always find decimal value 4 here.
上面的就是0x4,表示ipv4。我居然在一次面试中回答2bits???
[0x4] 4 bits

**Header Length** this 4 bits field tells us the length(bytes) of the IP header in 32 bit increments.If here is 20 bytes in the ip header, the value of 5 here, if the value is 15(0x1111), the IHL is 60 bytes.
Please note here, you would better to think it why it is the 5 and 20. Hint: 5 bytes = 5 * 32 (160) bits.If you have other data, must add it of 4 bytes(20, 24, 28...).And i think you must master it : the description is **32bits(4 bytes)** unit.

[0x5] 4 bits 就是表示5个32bits(一个32bits就是4个字节)，所以这个ip包的头部有5\*4=20B.也就是这个ip报文没有其他数据,"[[]]"中的内容就是.也就是数１０个２ｂｙｔｅｓ。

**Type of service** This is used for Qos.
[0x00] 6 bits 这个和后面的流量分类有关系，先搁着


**Total Length** The minimum size is 20 bytes(if you have no data) and the maximum size is 65536 bytes.
[0x003c] 16 bits 单位是字节，那么换算一下，就是3\*16^1 + c\*16^0 = 48 + 12 = 60 字节.你可以数一下上面的报文明确是30个0x0000(一个0x0000是２字节)

``Identification`` If the IP packet is fragmented then each fragment packet will use the same 16 bit identification number to identify to which IP packet they belone to.

[0x8fac] 16 bits 用来标识数据报，通常每发送一个就加1,当ip报文有切片时，这个字段是相同的，用来将分片的报文进行组合.在我们的试验中，你可以发现，
由 **bogon.59432**发出的数据，这个字段依次为:[0x8fac]->[0x8fad]->[0x8fae]->[0x8faf].说明没有分片。

``IP Flags`` : The first bit is alway set to 0; The second bit is called ``DF``(dont fragment) and indicates this packet should not be fragmented.The third bit is called the ``MF``(more fragments) bit and is set on all fragment packets except the last one.
[0x4]=>[0b0100] 3 bits 其实，虽然占了4位，但是只使用了3bits.剩下的那一位和下面的一起使用.按照协议，第一位不应该设置为１，**flag**的第一位被称为**evei bits**.
这里有一个问题就是，虽然ip　flag的位数是３ bits，但是在0x进制下还是４bits，就会导致0x40的情况，感觉是第一位被置１了。注意。

``Fragment Offset``: this 13 bit field specifies the position of the fragment in the original fragmented IP packet.
[0x000] : 13 bits 要借用前面的一位。本分片在原先数据报文中相对首位的偏移位。（需要再乘以8）

``Time to live``: only ttl value is 0, the packet will be dropped. ICMP.
[0x40] 6 bits:　IP 报文所允许通过的路由器的最大数量。每经过一个路由器，TTL减1，当为 0 时，路由器将该数据报丢弃。TTL 字段是由发送端初始设置一个 8 bit字段.推荐的初始值由分配数字 RFC 指定。发送 ICMP 回显应答时经常把 TTL 设为最大值 255。TTL可以防止数据报陷入路由循环 本报文设置为64.

_protocol_: ip报文携带的哪种协议，以便目的主机的ip 层能知道将数据包上交到哪个进程。tcp的协议号为６UOP的协议号为１７，ICMP为１，　ＩＧＭＰ为２，具体可以看
[参考这里](https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml) 很遗憾的是，内核中定义的部分没有找到.待定
[0x06] 是8bits.

_ip Header checksum_:
When a packet arrives at a router, the router calculates the checksum of the header and compares it to the checksum field. If the values do not match, the router discards the packet. Errors in the data field must be handled by the encapsulated protocol. Both UDP and TCP have checksum fields. When a packet arrives at a router, the router decreases the TTL field. Consequently, the router must calculate a new checksum.

[0x3510] 16 bits:HOW?  [这里](https://blog.csdn.net/jasenwan88/article/details/7772999)
首先，由发送端填充。 简单的说一点，就是将这个字段首先设置为０，其他几项依次加起来。有时间把这个函数实现出来
```c
0x4500 + 0x003c + 0x8fac + 0x4000 + 0x4006 + 0x0000
+ 0xc0a8 + 0x7aad + 0xc0a8 + 0x7a01 = 0x3 CAEC
# 其中，再令　0xCAEC + 0x0003 = 0xCAEF
# 接着取反 ~(0xCAEF) = 3510 这样就与0x3510对应起来
```
接收端验证时，同样把上面所有的字段加起来同时，将校验和填充进去
```c
0x3 CAEC + 0x3510 = 0x3 FFFC 　//因为上面使用的0x0000这个校验和字段
0x3 FFFC + 0x3 = 0xffff //全一　正确　或者按位取反
```
_Source address_
[0xc0a87aad] 32 bits 通过使用python脚本：
```python
>>> import socket
>>> import struct
>>> int_ip = int("0xc0a87aad",16)
>>> socket.inet_ntoa(struct.pack('I', socket.htonl(int_ip)))
'192.168.122.173'
>>>
```
_Destination Address_
[0xc0a87a01]
打印出来结果：

```python
>>> dst_ip = int("0xc0a87a01", 16)
>>> socket.inet_ntoa(struct.pack('I', socket.htonl(dst_ip)))
'192.168.122.1'
```
由于该报文首部长度为 20B，因此没有可变长部分.

好，ipv4就复习完了。 内核文件在(include/uapi/ip.h)

# tcp
首先上图：

```c
 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 |          Source Port          |        Destination Port       |
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 |                        Sequence Number                        |
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 |                     Acknowledgment Number                     |
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 | Offset| Res |N|C|E|U|A|P|R|S|F|             Window            |
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 |            Checksum           |         Urgent Pointer        |
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 |                    Options                    |    Padding    |
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

```
注： TCP 的头部必须是 4字节的倍数,而大多数选项不是4字节倍数,不足的用 NOP 填充
```c
15:31:32.411059 IP bogon.59432 > bogon.daytime: Flags [S], seq 3886862313, win 29200, options [mss 1460,sackOK,TS val 2598220276 ecr 0,nop,wscale 7], length 0
	0x0000:  [[4500 003c    8fac 4000 4006 3510 c0a8 7aad
	0x0010:    c0a8 7a01]] {e828 000d e7ac cfe9 0000 0000
	0x0020:    a002 7210    762e 0000 (0204 05b4 0402 080a
	0x0030:    9add b1f4    0000 0000 0103 0307)}
```
_source port_
[0xe828] 16 bits: 正好是十进制59432，与tcpdump显示的端口一致.

_destion port_
[0x000d] 16 bits ：正好是13。

_seq number_
[0xe7accfe9] 32 bits 正好是3886862313 ，这与上面的一致。

_Ack numbers_:
[0x00000000]: 32 bits, 为0.这个时候是第一次握手，客户端没有发送ack

_Data offset_:
[0xa]:  4 bits,	Specifies the size of the TCP header in 32-bit words. The minimum size header is 5 words and the maximum is 15 words thus giving the minimum size of 20 bytes and maximum of 60 bytes, allowing for up to 40 bytes of options in the header. This field gets its name from the fact that it is also the offset from the start of the TCP segment to the actual data
也叫 offset，其实也就是数据从哪里开始。10 \*4 = 40B,40B-20B = 20B,也就是可选项为20B,没有数据部分。

_Res_:
[0b000]: 3 bits: For future use and should be set to zero.

_flags_:
[0b000000010]: 9 bits:

1. NS (1 bit): ECN-nonce - concealment protection (experimental: see RFC 3540).
2. CWR (1 bit): Congestion Window Reduced (CWR) flag is set by the sending host to indicate that it received a TCP segment with the ECE flag set and had responded in congestion control mechanism (added to header by RFC 3168).
3. ECE (1 bit): ECN-Echo has a dual role, depending on the value of the SYN flag. It indicates:
If the SYN flag is set (1), that the TCP peer is ECN capable.
If the SYN flag is clear (0), that a packet with Congestion Experienced flag set (ECN=11) in the IP header was received during normal transmission (added to header by RFC 3168). This serves as an indication of network congestion (or impending congestion) to the TCP sender.
4. URG (1 bit): indicates that the Urgent pointer field is significant
5. ACK (1 bit): indicates that the Acknowledgment field is significant. All packets after the initial SYN packet sent by the client should have this flag set.
6. PSH (1 bit): Push function. Asks to push the buffered data to the receiving application.
7. RST (1 bit): Reset the connection
8. SYN (1 bit): Synchronize sequence numbers. Only the first packet sent from each end should have this flag set. Some other flags and fields change meaning based on this flag, and some are only valid when it is set, and others when it is clear.
9. FIN (1 bit): Last packet from sender.
从这里我们发现，只有SYN置为1.只有第一个包发出时才置１只有第一个包发出时才置１

剩下的三次握手可以着重观看一下这些字段，

_windows_:
[0x7210] 16 bits: 十进制29200。正好与tcpdump的win大小一致。
The size of the receive window, which specifies the number of window size units (by default, bytes) (beyond the segment identified by the sequence number in the acknowledgment field) that the sender of this segment is currently willing to receive (see Flow control and Window Scaling)

_checksum_:
[0x762e]: 16 bits . 由发送端填充，接收端对 TCP 报文段执行 CRC 算法，以检验 TCP 报文段在传输过程中是否损坏，如果损坏这丢弃。
检验范围包括首部和数据两部分，这也是 TCP 可靠传输的一个重要保障

_Urgen pointer_:
[0x0000]: 16 bits. Urgent pointer (if URG set)

### 可选部分
tcp的头部已经介绍完了就剩下可选部分了.前面已经说了是20Ｂ.也就是数据中的()部分。
The length of this field is determined by the data offset field. Options have up to three fields: Option-Kind (1 byte), Option-Length (1 byte), Option-Data (variable). The Option-Kind field indicates the type of option, and is the only field that is not optional. Depending on what kind of option we are dealing with, the next two fields may be set: the Option-Length field indicates the total length of the option, and the Option-Data field contains the value of the option, if applicable. For example, an Option-Kind byte of 0x01 indicates that this is a No-Op option used only for padding, and does not have an Option-Length or Option-Data byte following it. An Option-Kind byte of 0 is the End Of Options option, and is also only one byte. An Option-Kind byte of 0x02 indicates that this is the Maximum Segment Size option, and will be followed by a byte specifying the length of the MSS field (should be 0x04). This length is the total length of the given options field, including Option-Kind and Option-Length bytes. So while the MSS value is typically expressed in two bytes, the length of the field will be 4 bytes (+2 bytes of kind and length). In short, an MSS option field with a value of 0x05B4 will show up as (0x02 0x04 0x05B4) in the TCP options section.

```c
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|  kind/value(1B) |    len(1B)   |        value                 |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```
为了观看方便，我们再把报文复制过来：
[0204]: 则0x02就是类型，0x04就是长度。且这个长度是包含自身的，04就是4B,则[0x0204]和[0x05b4]共4Ｂ.

```c
15:31:32.411059 IP bogon.59432 > bogon.daytime: Flags [S], seq 3886862313, win 29200, options [mss 1460,sackOK,TS val 2598220276 ecr 0,nop,wscale 7], length 0
	0x0000:  [[4500 003c    8fac 4000 4006 3510 c0a8 7aad
	0x0010:    c0a8 7a01]] {e828 000d e7ac cfe9 0000 0000
	0x0020:    a002 7210    762e 0000 (0204 05b4 0402 080a
	0x0030:    9add b1f4    0000 0000 0103 0307)}
```
【11】:
_[0x0204]_: 0x02是MSS,即这个类型的长度为0x04,也就是４Ｂ，后面的05b4就是。期初不容易理解这个选项为什么在这个时候设置，看看这个[解释](https://blog.csdn.net/wzb56_earl/article/details/20540425). kind=2是最大报文段长度选项。TCP连接初始化时，通信双方使用该选项来协商最大报文段长度（Max Segment Size，MSS）。TCP模块通常将MSS设置为（MTU-40）字节（减掉的这40字节包括20字节的TCP头部和20字节的IP头部）。这样携带TCP报文段的IP数据报的长度就不会超过MTU（假设TCP头部和IP头部都不包含选项字段，并且这也是一般情况），从而避免本机发生IP分片。对以太网而言，MSS值是1460（1500-40）字节。

_[0x05b4]_: 就是MSS的数值，十进制就为1460,这样就与tcpdump的输出对应起来.
Some options may only be sent when SYN is set; they are indicated below as [SYN]. Option-Kind and standard lengths given as (Option-Kind,Option-Length).

_[0x0402]_: kind=4是选择性确认（Selective Acknowledgment，SACK）选项。TCP通信时，如果某个TCP报文段丢失，则TCP模块会重传最后被确认的TCP报文段后续的所有报文段，这样原先已经正确传输的TCP报文段也可能重复发送，从而降低了TCP性能。SACK技术正是为改善这种情况而产生的，它使TCP模块只重新发送丢失的TCP报文段，不用发送所有未被确认的TCP报文段。选择性确认选项用在连接初始化时，表示是否支持SACK技术。我们可以通过修改/proc/sys/net/ipv4/tcp_sack内核变量来启用或关闭选择性确认选项。

_[0x080a]_: 时间戳,共10个字节TCP timestamps, defined in RFC 1323 in 1992, can help TCP determine in which order packets were sent. TCP timestamps are not normally aligned to the system clock and start at some random value. Many operating systems will increment the timestamp for every elapsed millisecond; however the RFC only states that the ticks should be proportional.

There are two timestamp fields:

a 4-byte sender timestamp value (my timestamp)
a 4-byte echo reply timestamp value (the most recent timestamp received from you).
TCP timestamps are used in an algorithm known as Protection Against Wrapped Sequence numbers, or PAWS (see RFC 1323 for details). PAWS is used when the receive window crosses the sequence number wraparound boundary. In the case where a packet was potentially retransmitted it answers the question: "Is this sequence number in the first 4 GB or the second?" And the timestamp is used to break the tie.
Also, the Eifel detection algorithm (RFC 3522) uses TCP timestamps to determine if retransmissions are occurring because packets are lost or simply out of order.
Recent Statistics show that the level of Timestamp adoption has stagnated, at ~40%, owing to Windows server dropping support since Windows Server 2008 [21].
TCP timestamps are enabled by default In Linux kernel.[22], and disabled by default in Windows Server 2008, 2012 and 2016.[23]

_[0x9add, 0xb1f4]_: 十进制2598220276 正好为tcpdump的TS　val字段一样。

_[0x0000, 0x0000]_: 十进制０，正好与tcpdump的TS ecr字段一致.

_[0x0103]_: 0x01: ＮＯＰ操作,没有 Length 和 Value 字段， 用于将TCP Header的长度补齐至 32bit 的倍数.

_[0x0103, 0x0307]_: 0x01上面已经说了，0x03为窗口扩大因子选项，0x0307 也能对应起来

0 (8 bits): End of options list

1 (8 bits): No operation (NOP, Padding) This may be used to align option fields on 32-bit boundaries for better performance.

2,4,SS (32 bits): Maximum segment size (see maximum segment size) [SYN]

3,3,S (24 bits): Window scale (see window scaling for details) [SYN][7]

4,2 (16 bits): Selective Acknowledgement permitted. [SYN] (See selective acknowledgments for details)[8]

5,N,BBBB,EEEE,... (variable bits, N is either 10, 18, 26, or 34)- Selective ACKnowledgement (SACK)[9] These first two bytes are followed by a list of 1–4 blocks being selectively acknowledged, specified as 32-bit begin/end pointers.

8,10,TTTT,EEEE (80 bits)- Timestamp and echo of previous timestamp (see TCP timestamps for details)[10]

The remaining options are historical, obsolete, experimental, not yet standardized, or unassigned. Option number assignments are maintained by the IANA[11].
[]
[wiki tcp](https://en.wikipedia.org/wiki/Transmission_Control_Protocol)
[参考这篇文章](https://segmentfault.com/a/1190000015044878)

