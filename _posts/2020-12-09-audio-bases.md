---
title: audio 基础知识
category: audio
layout: post
---
* content
{:toc}

# pcm

在学习audio的过程中，经常会遇到PCM这个设备，那什么是PCM？跟随下面的这个链接:
https://blog.csdn.net/cc289123557/article/details/78745277 来看一下这个特有名词.

> 脉冲编码调制(Pulse Code Modulation,PCM)，就是把一个时间连续，取值连续的模拟信号变换成时间离散，取值离散的数字信号后在信道中传输，这是基本原理。
> 根据此原理，在音频领域的数字音频就用pcm设备来代表，pcm也是一种音频格式，可以自定义通道数，采样率，采样精度；我们经常采用的I2S格式其实属于pcm的一种，不过I2S规定了只有2通道。
> 音频的采样率(rate)一般采用44.1K，16K，48K等,采样精度(format)一般都是8/16/24/32bit

kernel结构体设备:

```c
struct snd_pcm
struct snd_pcm_str
struct snd_pcm_substream
```
一个音频设备分播放和录音两个功能，对应到pcm就分PLAYBACK和CAPTURE，分别用结构体snd_pcm_str来表示，一个播放或者录音设备可以集成多个音频流，每个音频流用snd_pcm_substream结构体来表示
好，引用到此结束。

今天我们不聊kernel，只关注上层的应用。在ALSA(Advanced Linux Sound Architecture)中， pcm代表了一个通路。

总结来说就是， pcm设备就是kernel的抽象层，可以把计算机硬件声卡采集到的物理特性进行描述，正如上面的通道数、采样率、采样精度等。

# User space

这块属于ALSA-lib的东西了。包含一套插件机制，可以对audio进行 resampling、mixing、channel mapping等操作，

## Pulseaudio

Pulseaudio作为sound server负责集成处理各种声卡的输入输出信号。目前各大linux发行版默认安装PulseAudio了。

# Usage

## 在命令行中录音和播放

### arecord

### aplay

usage 1：

```bash
aplay -c 2 -t wav cut.wav
正在播放 WAVE 'cut.wav' : Signed 16 bit Little Endian, 频率44100Hz， Stereo
```
这个命令可以把名为cut.wav的音乐文件使用aplay播放出来。"-c 2"是2通道， -t指明类型，但是在我这里改变通道的效果没有体现出来。

这两个工具在使用的过程中遇到的一个问题是，"-L"参数只会列出该pc中的芯片设备，当你插入一个mic，并不会自己分辨出
哪个是刚才插入的mic.

```bash
arecord  -L
default
    Playback/recording through the PulseAudio sound server
null
    Discard all samples (playback) or generate zero samples (capture)
pulse
    PulseAudio Sound Server
sysdefault:CARD=PCH
    HDA Intel PCH, CX20632 Analog
    Default Audio Device
front:CARD=PCH,DEV=0
    HDA Intel PCH, CX20632 Analog
    Front speakers
dmix:CARD=PCH,DEV=0
    HDA Intel PCH, CX20632 Analog
    Direct sample mixing device
dmix:CARD=PCH,DEV=2
    HDA Intel PCH, CX20632 Alt Analog
    Direct sample mixing device
dsnoop:CARD=PCH,DEV=0
    HDA Intel PCH, CX20632 Analog
    Direct sample snooping device
dsnoop:CARD=PCH,DEV=2
    HDA Intel PCH, CX20632 Alt Analog
    Direct sample snooping device
hw:CARD=PCH,DEV=0
    HDA Intel PCH, CX20632 Analog
    Direct hardware device without any conversions
hw:CARD=PCH,DEV=2
    HDA Intel PCH, CX20632 Alt Analog
    Direct hardware device without any conversions
plughw:CARD=PCH,DEV=0
    HDA Intel PCH, CX20632 Analog
    Hardware device with all software conversions
plughw:CARD=PCH,DEV=2
    HDA Intel PCH, CX20632 Alt Analog
    Hardware device with all software conversions
```
通过man函数可知，这里面包含有soundcards和 digital sound devices

## 代码中录音和播放

类似这样:

```c
#include <stdio.h>
int main(int argc, char **argv) {
    char *cmd = "arecord -D plughw:0 -f S16_LE -c 1 -r 16000 -t raw -q -";
    char buf[256];
    FILE *fp = popen(cmd, "r");

    for (int i=0; i<16; i++) {
        int result = fread(buf, 1, sizeof(buf), fp);
        printf("read %d bytes\n", result);

    }
    pclose(fp);
    return 0;
}
```
参考: https://zhuanlan.zhihu.com/p/58834651

