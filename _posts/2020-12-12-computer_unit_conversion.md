---
title: 计算机中的某些单位换算
category: OS
layout: post
---
* content
{:toc}

# 单位换算
可以首先参考这篇[文章](https://www.cnblogs.com/chenya/p/4250026.html)

## 比特bit(b)
bit是bit位，也就是一个0或者1占据的空间， 也就是最小的存储单元。 千位: Kbits

## 比特Bytes(B)
Byte是字节，为计算机存储容量大小的及基本计算单位。千字节: Kbytes （KB）我们通常说的
硬盘400GB，这里的B指的是Byte也就是字节。一般使用字节(KB)来表示文件的大小。

## 兆(英文M, million = 1000000)
M表示数值，不是单位，MB是量单位，兆字节，这个B是Byte而不是bit。Mb一般指兆位。

注意：小k通常表示1000，大K表示1024

```c
1Byte=8bit
1KB=1024B=1024*8b 
1kB=1000B=1000*8b 　　
1Kb=1024b 
1kb=1000b 
1MB=1024KB
1GB=1024MB
1T=1024GB
```

其他需要注意的地方:

```c
在这里需要说明的问题是在单位换算上有一点是极其重要的，即：
1Mb=1024kb=1024000b 
1MB=1024KB=1024*1024B=1024*1024*8b=8388608b这在数量上差的很多
1KB=1024B（大写K）
1kB=1000B（小写k）
1Mbps=1Mb=1024kb ,1024/8=128kb/s.
```

## 换算标准

cd表格中数据需要换算为下来标准单位

每帧的数据大小：KB/frame  (V*H*CD/8/1000)
每秒的数据流量：Mbps or Kbps
每像素的数据量：bytes/pixel
帧率: fps(Frames Per Second: 1秒时间内传输的图片的帧数)

*补充:
      每秒的数据流量也可称为码率，Mbps为兆位每秒，更常见的是在传输过程中与字节打交道，需要除以8，比如 100Mbps=100/8=12.5MB/s, 100Kbps=100/8=12.5KB/s.

