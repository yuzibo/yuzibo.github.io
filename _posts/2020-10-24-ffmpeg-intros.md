---
title: ffmpeg使用入门
category: video
layout: post
---
* content
{:toc}

# 入门

使用 ffmpeg 的入门 ：

[入门](https://zhuanlan.zhihu.com/p/27366331)

最简单的命令:

```c
ffmpeg -i buka.flv -c copy -ss 00:00:00 -t 00:10:03.446 edu17-264.mp4
```
其中，这个`-c`可以指定编码格式(包括解码器)。

## 主要参数

>   -i 设定输入流

>   -f 设定输出格式

>   -ss 开始时间

>   -c 指定编解码器


## 视频参数

* -b 设定视频的音视频码率(-b:v和-b:a)，默认为200Kbit/s
* -r 设定帧速率，默认为25
* -s 设定分辨率，即画面的宽与高
* -aspect 设定画面的比例
* -vn 不处理视频
* -vcodec 设定视频编解码器，未设定时则使用与输入流相同的编解码器
* -ss 开始时间
* -t 持续时间
* -bf B帧数目控制，
* -g 关键帧间隔控制

## 音频参数

* -ar 设定采样率
* -ac 设定声音的Channel数
* -acodec 设定声音编解码器，未设定时则使用与输入流相同的编解码器
* -an 不处理音频

```bash
 ffmpeg -i buka.flv -vcodec h264 -ss 00:00:00 -t 00:10:03.446 edu17-2-264.mp4 
```
指定video的编码格式为h264