---
title: "tcpdump教程"
category: socket
layout: article
---

# WHY TCPDUMP

Tcpdump is the premier network analysis tool for information security professionals. Having a solid grasp of this user-space appalication is mandatory for anyone desiring a thorough understanding of TCP/IP.

# INTRODUCTION

## Dispaly available Interfaces

> tcpdump -D

```bash

yubo@debian:~/login$ sudo tcpdump -D
[sudo] password for yubo:
1.eth0
2.wlan0
3.nflog (Linux netfilter log (NFLOG) interface)
4.any (Pseudo-device that captures on all interfaces)
5.lo
```

## Capture packets from Specific Interface

> tcpdump -i eth0

## Capture Only N number of Packet

> tcpdump -c 2 -i event0

```bash
root@yubo-2:~# tcpdump -c 2 -i venet0
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on venet0, link-type LINUX_SLL (Linux cooked), capture size 65535 bytes
00:06:39.197531 IP yubo-2.ssh > 112.250.100.205.46493: Flags [P.], seq 1776389372:1776389580, ack 2267257061, win 292, options [nop,nop,TS val 1163336703 ecr 2017454], length 208
00:06:39.197997 IP yubo-2.40698 > 181.41.222.18.domain: 14384+ PTR? 205.100.250.112.in-addr.arpa. (46)
2 packets captured
5 packets received by filter
0 packets dropped by kernel
```

## Print captured packets in ASCII

```bash

root@yubo-2:~# tcpdump -c 2 -A -i venet0
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on venet0, link-type LINUX_SLL (Linux cooked), capture size 65535 bytes
00:09:50.581560 IP yubo-2.ssh > 112.250.100.205.46493: Flags [P.], seq 1776393404:1776393612, ack 2267259285, win 292, options [nop,nop,TS val 1163528086 ecr 2065321], length 208
E.....@.@..".e	.p.d.....i....#.....$.......
EZ......H.x.5.^i".........+4.?...G.@..E..Ez*..>...#6.!:.B...Zz.}.0.M..5..S!...1.y..~...M......5..n..{..zO.2..u..5.FX..b$iJ...@....v..=E~R.....9...,x?..<...!..>.....x..HU/...>XzK.....A.Z.<.]...%.........1ax...a.U..&P.
00:09:50.581992 IP yubo-2.50899 > 181.41.222.18.domain: 32128+ PTR? 205.100.250.112.in-addr.arpa. (46)
E..J..@.@....e	..).....5.6v.}............205.100.250.112.in-addr.arpa.....
2 packets captured
6 packets received by filter
0 packets dropped by kernel
```

## Display captured packets in HEX and ASCII

![tcp.png](http://yuzibo.qiniudn.com/tcp.png)

## Capture and save packets in a file

The tcpdump generate a .pcap file, then you can read it with tcpdump command

![tcp2.png](http://yuzibo.qiniudn.com/tcp2.png)

## Read Captured Packets File

![tcp3.png](http://yuzibo.qiniudn.com/tcp3.png)


