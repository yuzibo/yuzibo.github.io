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
参考: https://sysplay.in/blog/tag/arecord/

其实这里有一个问题就是，“-L”参数并不会出现类似上面URL的资料，只有一个`-l`才可以。

```bash
vimer@host:~/pic/vs$ arecord -l
**** CAPTURE 硬體裝置清單 ****
card 0: Loopback [Loopback], device 0: Loopback PCM [Loopback PCM]
  子设备: 7/8
  子设备 #0: subdevice #0
  子设备 #1: subdevice #1
  子设备 #2: subdevice #2
  子设备 #3: subdevice #3
  子设备 #4: subdevice #4
  子设备 #5: subdevice #5
  子设备 #6: subdevice #6
  子设备 #7: subdevice #7
card 0: Loopback [Loopback], device 1: Loopback PCM [Loopback PCM]
  子设备: 8/8
  子设备 #0: subdevice #0
  子设备 #1: subdevice #1
  子设备 #2: subdevice #2
  子设备 #3: subdevice #3
  子设备 #4: subdevice #4
  子设备 #5: subdevice #5
  子设备 #6: subdevice #6
  子设备 #7: subdevice #7
card 1: PCH [HDA Intel PCH], device 0: CX20632 Analog [CX20632 Analog]
  子设备: 0/1
  子设备 #0: subdevice #0
card 1: PCH [HDA Intel PCH], device 2: CX20632 Alt Analog [CX20632 Alt Analog]
  子设备: 1/1
  子设备 #0: subdevice #0
```

这里有一个问题值得注意，这里的loopback有很好玩的东西在里面。在一个终端上:

```bash
vimer@host:~/pic/vs$ arecord -D hw:0,1,4 -f S16_LE -c 2 -r 48000 recorded.wav
正在录音 WAVE 'recorded.wav' : Signed 16 bit Little Endian, 频率48000Hz， Stereo
```

然后新开一个终端，这两个shell terminator谁前谁后无所谓的。

```bash
aplay -D hw:0,0,4 cut.wav
正在播放 WAVE 'cut.wav' : Signed 16 bit Little Endian, 频率44100Hz， Stereo
警告：频率不精确（要求=44100Hz，收到=48000Hz）
         请尝试plug插件
```

这个时候， 在第一个终端里的recorded.wav就保存了第二个终端里的 cut.wav 的audio。

尤其注意这里的 `-D` 参数， `hw:card-id,devices-id,subdevices-id`.总结出来的一个规律就是 playback 和 capture 得是同一个 card-id, 不同的devices-id, 相同的 subdeviced-id ，其中， subdevices-id 从0到7.

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

# linux下物理扬声器/话筒的辨认

为什么这么说呢？主要是因为自己在pc上（尤其是内置网卡的这种），经常会遇到插上耳机无法读取输入声音的情况，也不知道为什么？

这里做一个比较好的澄清:

输出设备，也就是所谓的喇叭，如果内置了扬声器，在我使用Ubuntu观察到的情况是，插上耳机后，系统默认使用一个`模拟耳机/内置音频`的输出项。如果我把耳机拔出来，则系统就会把刚才那个名称变化为`扬声器/内置音频`。

总结: 如果不插入耳机，则是使用内置的扬声器，如果通过mic口插入耳机，则会是模拟耳机。

同样的情况出现在 话筒。我们现在的情况很特殊，没有内置话筒，插上带有讲话功能的耳机后出现 话筒 内置音频的变化。

## pacmd

这也是一个很实用的命令，可以让你对整体的输入输出设备有一个清晰的理解。

```bash
 pacmd
Welcome to PulseAudio 11.1! Use "help" for usage information.
>>> list-links
Unknown command: list-links
>>> ^[[A^[[D
>>> own command:
>>> list-sinks
2 sink(s) available.
    index: 1
	name: <alsa_output.platform-snd_aloop.0.analog-stereo>
	driver: <module-alsa-card.c>
	flags: HARDWARE HW_VOLUME_CTRL DECIBEL_VOLUME LATENCY DYNAMIC_LATENCY
	state: SUSPENDED
	suspend cause: IDLE
	priority: 9009
	volume: front-left: 26006 /  40% / -24.08 dB,   front-right: 26006 /  40% / -24.08 dB
	        balance 0.00
	base volume: 65536 / 100% / 0.00 dB
	volume steps: 65537
	muted: no
	current latency: 0.00 ms
	max request: 0 KiB
	max rewind: 0 KiB
	monitor source: 2
	sample spec: s16le 2ch 44100Hz
	channel map: front-left,front-right
	             立体声
	used by: 0
	linked by: 0
	configured latency: 0.00 ms; range is 0.50 .. 2000.00 ms
	card: 1 <alsa_card.platform-snd_aloop.0>
	module: 28
	properties:
		alsa.resolution_bits = "16"
		device.api = "alsa"
		device.class = "sound"
		alsa.class = "generic"
		alsa.subclass = "generic-mix"
		alsa.name = "Loopback PCM"
		alsa.id = "Loopback PCM"
		alsa.subdevice = "0"
		alsa.subdevice_name = "subdevice #0"
		alsa.device = "0"
		alsa.card = "0"
		alsa.card_name = "Loopback"
		alsa.long_card_name = "Loopback 1"
		alsa.driver_name = "snd_aloop"
		device.bus_path = "platform-snd_aloop.0"
		sysfs.path = "/devices/platform/snd_aloop.0/sound/card0"
		device.form_factor = "internal"
		device.string = "front:0"
		device.buffering.buffer_size = "352800"
		device.buffering.fragment_size = "352800"
		device.access_mode = "mmap+timer"
		device.profile.name = "analog-stereo"
		device.profile.description = "模拟立体声"
		device.description = "内置音频 模拟立体声"
		alsa.mixer_name = "Loopback Mixer"
		module-udev-detect.discovered = "1"
		device.icon_name = "audio-card"
	ports:
		analog-output: 模拟输出 (priority 9900, latency offset 0 usec, available: unknown)
			properties:

	active port: <analog-output>
  * index: 3
	name: <alsa_output.pci-0000_00_1f.3.analog-stereo>
	driver: <module-alsa-card.c>
	flags: HARDWARE HW_MUTE_CTRL HW_VOLUME_CTRL DECIBEL_VOLUME LATENCY DYNAMIC_LATENCY
	state: SUSPENDED
	suspend cause: IDLE
	priority: 9039
	volume: front-left: 25486 /  39% / -24.61 dB,   front-right: 25486 /  39% / -24.61 dB
	        balance 0.00
	base volume: 65536 / 100% / 0.00 dB
	volume steps: 65537
	muted: no
	current latency: 0.00 ms
	max request: 0 KiB
	max rewind: 0 KiB
	monitor source: 5
	sample spec: s16le 2ch 44100Hz
	channel map: front-left,front-right
	             立体声
	used by: 0
	linked by: 0
	configured latency: 0.00 ms; range is 0.50 .. 371.52 ms
	card: 0 <alsa_card.pci-0000_00_1f.3>
	module: 7
	properties:
		alsa.resolution_bits = "16"
		device.api = "alsa"
		device.class = "sound"
		alsa.class = "generic"
		alsa.subclass = "generic-mix"
		alsa.name = "CX20632 Analog"
		alsa.id = "CX20632 Analog"
		alsa.subdevice = "0"
		alsa.subdevice_name = "subdevice #0"
		alsa.device = "0"
		alsa.card = "1"
		alsa.card_name = "HDA Intel PCH"
		alsa.long_card_name = "HDA Intel PCH at 0x4000100000 irq 141"
		alsa.driver_name = "snd_hda_intel"
		device.bus_path = "pci-0000:00:1f.3"
		sysfs.path = "/devices/pci0000:00/0000:00:1f.3/sound/card1"
		device.bus = "pci"
		device.vendor.id = "8086"
		device.vendor.name = "Intel Corporation"
		device.product.id = "a348"
		device.form_factor = "internal"
		device.string = "front:1"
		device.buffering.buffer_size = "65536"
		device.buffering.fragment_size = "32768"
		device.access_mode = "mmap+timer"
		device.profile.name = "analog-stereo"
		device.profile.description = "模拟立体声"
		device.description = "内置音频 模拟立体声"
		alsa.mixer_name = "Conexant CX20632"
		alsa.components = "HDA:14f15098,103c8596,00100100 HDA:8086280b,80860101,00100000"
		module-udev-detect.discovered = "1"
		device.icon_name = "audio-card-pci"
	ports:
		analog-output-lineout: 线缆输出 (priority 9900, latency offset 0 usec, available: no)
			properties:

		analog-output-speaker: 扬声器 (priority 10000, latency offset 0 usec, available: no)
			properties:
				device.icon_name = "audio-speakers"
		analog-output-headphones: 模拟耳机 (priority 9000, latency offset 0 usec, available: yes)
			properties:
				device.icon_name = "audio-headphones"
	active port: <analog-output-headphones>
>>>

```

可以看到，模拟耳机现在是可以使用的。`active port`这也是一个最明显的提示。

# arecord 重要进展

目前，经过n多次的实验，终于可以将mic(耳机的声音传进来了)， 也就是可以使用arecord命令行进行录音了。还是老问题，首先在 Ubuntu 的声音设置中，在 input 中选择正确的物理设备。我这里是插上耳机机会显示:

> 话筒/内置音频

然后使用命令：

```bash
arecord  -d 10 -c 2 -r 48000  -f S16_LE my.wav
# 正在录音 WAVE 'my.wav' : Signed 16 bit Little Endian, 频率48000Hz， Stereo
```

这个时候就会录制一段时间为10s， 2通道(Stereo) 采样率为48Khz, format为S16_LE的名为 my.wav的录音，然后你就可以使用 aplay 取播放它了。

当然，是从默认mic啦(如果插入耳机的话就是耳机了)

```bash
aplay my.wav
```

现在还有一个问题就是没法指定设备取录音，假设加上 hw:0,0 则不会录制声音。
