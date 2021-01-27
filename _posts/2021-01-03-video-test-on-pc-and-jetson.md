---
title: 在jetson和pc上实验video
category:  video
layout:  post
---
* content
{:toc}

# 一、在pc机上进行以下实验
1.发现摄像头设备
```bash
# On linux:

vimer@host:~/pic$ v4l2-ctl --list-devices
HD Camera: HD Camera (usb-0000:00:14.0-10):
/dev/video0
/dev/video1

# On windows:

ffmpeg -list_devices true -f dshow -i dummy

[dshow @ 0000014762dda980] DirectShow video devices (some may be both video and audio devices)
[dshow @ 0000014762dda980] "Integrated Camera"
[dshow @ 0000014762dda980] Alternative name "@device_pnp_\\?\usb#vid_5986&pid_02d2&mi_00#7&7f65834&0&0000#{65e8773d-8f56-11d0-a3b9-00a0c9223196}\global"
[dshow @ 0000014762dda980] "HD Camera"
[dshow @ 0000014762dda980] Alternative name "@device_pnp_\\?\usb#vid_0bc8&pid_5880&mi_00#6&19d0255b&0&0000#{65e8773d-8f56-11d0-a3b9-00a0c9223196}\global"
[dshow @ 0000014762dda980] DirectShow audio devices
[dshow @ 0000014762dda980] "麦克风阵列 (2- Realtek High Definition Audio)"
[dshow @ 0000014762dda980] Alternative name "@device_cm_{33D9A762-90C8-11D0-BD43-00A0C911CE86}\wave_{DB187E2D-D643-4E74-9C68-1FF045E372DC}"
```


查看摄像头的直播:

```bash
~$: cheese  (On linux)

ffplay -f dshow -i video="HD Camera" (On Windows)  

```
可以直接使用"HD Camera".

2. 查询摄像头支持的格式

```bash
vimer@host:~/pic$ v4l2-ctl -d /dev/video0 --list-formats-ext
ioctl: VIDIOC_ENUM_FMT
Index : 0
Type : Video Capture
Pixel Format: 'MJPG' (compressed)
Name : Motion-JPEG
Size: Discrete 640x480
Interval: Discrete 0.033s (30.000 fps)
Size: Discrete 800x600
Interval: Discrete 0.033s (30.000 fps)
Size: Discrete 1280x720
Interval: Discrete 0.033s (30.000 fps)
Size: Discrete 1600x1200
Interval: Discrete 0.033s (30.000 fps)
Size: Discrete 1920x1080
Interval: Discrete 0.033s (30.000 fps)
Size: Discrete 2048x1536
Interval: Discrete 0.067s (15.000 fps)
Size: Discrete 2592x1944
Interval: Discrete 0.067s (15.000 fps)
Size: Discrete 3264x2448
Interval: Discrete 0.067s (15.000 fps)

Index : 1
Type : Video Capture
Pixel Format: 'YUYV'
Name : YUYV 4:2:2
Size: Discrete 640x480
Interval: Discrete 0.033s (30.000 fps)
Size: Discrete 800x600
Interval: Discrete 0.050s (20.000 fps)
Size: Discrete 1280x720
Interval: Discrete 0.100s (10.000 fps)
Size: Discrete 1600x1200
Interval: Discrete 0.200s (5.000 fps)
Size: Discrete 1920x1080
Interval: Discrete 0.200s (5.000 fps)
Size: Discrete 2048x1536
Interval: Discrete 0.500s (2.000 fps)
Size: Discrete 2592x1944
Interval: Discrete 0.500s (2.000 fps)
Size: Discrete 3264x2448
Interval: Discrete 0.500s (2.000 fps)
```


# 二、  v4l2使用摄像头抓取raw数据

```bash
vimer@host:~/pic/test$ v4l2-ctl --device /dev/video1 --stream-mmap --stream-to=frame.raw --stream-count=30
```

以`mmap`方式获取raw frame，stream-to=frame.raw 表明保存的文件为frame.raw 后面的参数指明了帧数（可以指明摄像头的默认帧数）。如果安装 ​ImageMagick 的话，可以使用下面的命令把raw转换为image。

```bash
convert -size 640x480 -depth 16 uyvy:frame10.raw frame10.png
```

[源代码](http://trac.gateworks.com/wiki/linux/v4l2)工具可以看这里

# 三、ffmpeg的关键参数-读取raw数据

在linux和windows使用ffmpeg请参考这个 [link](https://trac.ffmpeg.org/wiki/Capture/Webcam)

Constant Rate Factor   (crf)能决定在转码时的压缩效果，值越高，压缩越高，视频质量就越差。
在 264 和 265 中可以使用 --crf [0-51]. For x264, sane values are between 18 and 28. The default is 23.
ffmpeg -i input.mp4 -c:v libx264 -crf 23 output.mp4     
For x265, the default CRF is 28:

```bash
ffmpeg -i input.mp4 -c:v libx265 -crf 28 output.mp4
```

使用ffmpeg录制未压缩的视频(然后进行转码):

```bash
ffmpeg -f v4l2 -i /dev/video1 -codec:v copy rawvideo.nut （On linux）
```

其中，rawvideo.nut大小为260416KB.
```bash
ffmpeg -f dshow -i video="HD Camera" -codec:v copy raw_win.nut(On windows)
```
使用下面的命令将raw文件转换为其他格式。
```bash
ffmpeg -i rawvideo.nut -codec:v libx264 -crf 23 -preset medium -pix_fmt yuv420p -movflags +faststart output.mp4
```
output.mp4大小为 154KB

[参考资料](https://slhck.info/video/2017/02/24/crf-guide.html)

# 四、使用gsteramer记录

可以参考这个文件 https://www.ensta-bretagne.fr/zerr/dokuwiki/doku.php?id=gstreamer:main-gstreamer
```bash
gst-launch-1.0 -v filesrc location=raw_win20s.nut ! jpegdec ! videoconvert ! autovideosink
```
    （命令释义: 把raw_win20s.nut(jpeg压缩格式)文件以  jpegdec 方式进行解码 ，然后让videoconvert进行自动转码，然后存放于autovideosink）       gst以管道的形式传递参数。其中， 例如jpegdec什么的，可以看成元素。至于查看某个元素的具体信息可以使用

```bash
      gst-inspect-1.0 | grep jpegdec
```

  去查看。 当然， gst-inspect-1.0的信息更全面。
```bash
   2. gst-launch-1.0 -v v4l2src ! autovideosink (以v4l2为源文件，然后发送至autovideosink)
```
      如果找不到摄像头的合适格式、参数，可以使用使用上面的命令看下log输出，然后填入 caps，测试下面的命令是可以的:
```bash
    gst-launch-1.0 -v v4l2src device=/dev/video0 ! "video/x-raw, width=(int)3264, height=(int)2448, framerate=(fraction)2/1, format=(string)YUY2, pixel-aspect-ratio=(fraction)1/1, colorimetry=(string)2:6:5:1, interlace-mode=(string)progressive" ! autovideosink

```

# 五、转码效果比较
800\*600
```bash
源文件	   编码、大小（du -h）	转码格式-[OS]	大小-时长	命令	评价
raw_linux_dai.nut	(rawvideo  :  YUY2)   344MB	libx265  [pc]	368KB-21s	ffmpeg -i raw_linux_dai.nut -codec:v libx265 -crf 23 -preset medium -pix_fmt yuv420p -movflags +faststart h265.mp4
raw_linux_dai.nut	(rawvideo  :  YUY2)   344MB	libx265 [pc]	224KB-21s	ffmpeg -i raw_linux_dai.nut -codec:v libx265 -crf 28 -preset medium -pix_fmt yuv420p -movflags +faststart h265.mp4	最好
raw_linux_dai.nut	(rawvideo  :  YUY2)   344MB	libx265 [pc]	188KB-21s	ffmpeg -i raw_linux_dai.nut -codec:v libx265 -crf 30 -preset medium -pix_fmt yuv420p -movflags +faststart h265.mp4
raw_linux_dai.nut	(rawvideo  :  YUY2)   344MB	libx264 [pc]	912KB	ffmpeg -i raw_linux_dai.nut -codec:v libx264 -crf 20 -preset medium -pix_fmt yuv420p -movflags +faststart h264.mp4
raw_linux_dai.nut	(rawvideo  :  YUY2)   344MB	libx264 [pc]	568KB	ffmpeg -i raw_linux_dai.nut -codec:v libx264 -crf 23 -preset medium -pix_fmt yuv420p -movflags +faststart h264.mp4	最好
raw_linux_dai.nut	(rawvideo  :  YUY2)   344MB	libx264 [pc]	284KB	ffmpeg -i raw_linux_dai.nut -codec:v libx264 -crf 28 -preset medium -pix_fmt yuv420p -movflags +faststart h264.mp4
```
 
# 六、Nvidia Jetson AGX可以使用的硬件编码指令:

```bash
gst-launch-1.0 -v filesrc location=edu111-orig.mp4 ! qtdemux name=demux demux.video_0 ! queue ! h264parse ! nvv4l2decoder ! nvv4l2h265enc control-rate=0 bitrate=1000000 peak-bitrate=6500000 iframeinterval=100 ratecontrol-enable=0 quant-i-frames=30 quant-p-frames=30 quant-b-frames=30 preset-level=4 MeasureEncoderLatency=1 profile=0 ! h265parse ! qtmux ! filesink location=buka-nvv4l2decoder-nvv4l2h265enc.mp4
```
	【推荐这个参数列表】
```bash
gst-launch-1.0 -v filesrc location=edu111-orig.mp4 ! qtdemux name=demux demux.video_0 ! queue ! h264parse ! nvv4l2decoder ! nvv4l2h265enc ! h265parse ! qtmux ! filesink location=buka-nvv4l2decoder-nvv4l2h265enc-no-args.mp4 (这个命令是可以简化的最简形式，转码后的文件相当大)
  gst-launch-1.0 -v filesrc location=edu10-03.mp4 ! qtdemux name=demux demux.video_0 ! queue ! h264parse ! nvv4l2decoder ! nvv4l2h264enc control-rate=0 bitrate=1000000 peak-bitrate=6500000 iframeinterval=100 ratecontrol-enable=0 quant-i-frames=30 quant-p-frames=30 quant-b-frames=30 preset-level=4 MeasureEncoderLatency=1 profile=0 ! h264parse ! qtmux ! filesink location=test-nvv4l2decoder-nvv4l2h264enc.mp4
gst-launch-1.0 -v filesrc location=edu10-03.mp4 ! qtdemux name=demux demux.video_0 ! queue ! h264parse ! nvv4l2decoder ! nvv4l2h265enc control-rate=0 bitrate=1000000 peak-bitrate=6500000 iframeinterval=100 ratecontrol-enable=0 quant-i-frames=30 quant-p-frames=30 quant-b-frames=30 preset-level=4 MeasureEncoderLatency=1 profile=0 ! h265parse ! qtmux ! filesink location=test-nvv4l2decoder-nvv4l2h265enc.mp4
gst-launch-1.0 -v filesrc location=edu10-03.mp4 ! qtdemux name=demux demux.video_0 ! queue ! h264parse ! nvv4l2decoder ! nvv4l2h265enc iframeinterval=100 ! h265parse ! qtmux ! filesink location=test-nvv4l2decoder-nvv4l2-i-frame-100.mp4
gst-launch-1.0 -v filesrc location=edu10-03.mp4 ! qtdemux name=demux demux.video_0 ! queue ! h264parse ! nvv4l2decoder ! nvv4l2h265enc iframeinterval=30 ! h265parse ! qtmux ! filesink location=test-nvv4l2decoder-nvv4l2-i-frame-30.mp4
gst-launch-1.0 -v filesrc location=edu10-03.mp4 ! qtdemux name=demux demux.video_0 ! queue ! h264parse ! nvv4l2decoder ! nvv4l2h265enc control-rate=1 ! h265parse ! qtmux ! filesink location=test-nvv4l2decoder-nvv4l2-vbr.mp4  （Control-rate-1:VBR, 0:disable, 2:CBR, 3:Variable bit rate with frame skip. The encoder skips frames as necessary to meet the target bit rate.,4:Constant bit rate with frame skip）  （Control-rate-1:VBR, 0:disable, 2:CBR, 3:Variable bit rate with frame skip. The encoder skips frames as necessary to meet the target bit rate.,4:Constant bit rate with frame skip）
gst-launch-1.0 -v filesrc location=edu10-03.mp4 ! qtdemux name=demux demux.video_0 ! queue ! h264parse ! nvv4l2decoder ! nvv4l2h265enc control-rate=1 bitrate=6000000 peak-bitrate=6500000 ! h265parse ! qtmux ! filesink location=test-nvv4l2decoder-nvv4l2-cr3.mp4
gst-launch-1.0 -v filesrc location=edu10-03.mp4 ! qtdemux name=demux demux.video_0 ! queue ! h264parse ! nvv4l2decoder ! nvv4l2h265enc qp-range="10,30:10,35:10,35" ! h265parse ! qtmux ! filesink location=test-nvv4l2decoder-nvv4l2-qp-range.mp4
gst-launch-1.0 -v filesrc location=edu10-03.mp4 ! qtdemux name=demux demux.video_0 ! queue ! h264parse ! nvv4l2decoder ! nvv4l2h265enc preset-level=0 ! h265parse ! qtmux ! filesink location=test-nvv4l2decoder-nvv4l2-present-level.mp4
gst-launch-1.0 -v filesrc location=edu10-03.mp4 ! qtdemux name=demux demux.video_0 ! queue ! h264parse ! nvv4l2decoder ! nvv4l2h265enc preset-level=1 ! h265parse ! qtmux ! filesink location=test-nvv4l2decoder-nvv4l2-present-level.mp4
gst-launch-1.0 -v filesrc location=edu10-03.mp4 ! qtdemux name=demux demux.video_0 ! queue ! h264parse ! nvv4l2decoder ! nvv4l2h265enc profile=1 ! h265parse ! qtmux ! filesink location=test-nvv4l2decoder-nvv4l2-profile_1.mp4
gst-launch-1.0 -v filesrc location=edu10-03.mp4 ! qtdemux name=demux demux.video_0 ! queue ! h264parse ! nvv4l2decoder ! nvv4l2h265enc insert-sps-pps=1 ! h265parse ! qtmux ! filesink location=test-nvv4l2decoder-nvv4l2-insert-sps-pps.mp4
gst-launch-1.0 -v filesrc location=edu10-03.mp4 ! qtdemux name=demux demux.video_0 ! queue ! h264parse ! nvv4l2decoder ! nvv4l2h265enc EnableTwopassCBR=1 ! h265parse ! qtmux ! filesink location=test-nvv4l2decoder-nvv4l2-twopasscbr.mp4
gst-launch-1.0 -v filesrc location=edu10-03.mp4 ! qtdemux name=demux demux.video_0 ! queue ! h264parse ! nvv4l2decoder ! nvv4l2h265enc slice-header-spacing=8 bit-packetization=0 ! h265parse ! qtmux ! filesink location=test-nvv4l2decoder-slice-header.mp4
gst-launch-1.0 -v filesrc location=edu10-03.mp4 ! qtdemux name=demux demux.video_0 ! queue ! h264parse ! nvv4l2decoder ! nvv4l2h265enc slice-header-spacing=1400 bit-packetization=1 ! h265parse ! qtmux ! filesink location=test-nvv4l2decoder-slice-header-1400.mp4
gst-launch-1.0 -v filesrc location=edu10-03.mp4 ! qtdemux name=demux demux.video_0 ! queue ! h264parse ! nvv4l2decoder ! nvv4l2h265enc insert-sps-pps=1 ! h265parse ! qtmux ! filesink location=test-nvv4l2decoder-nvv4l2-insert-sps-pps.mp4
gst-launch-1.0 -v filesrc location=edu10-03.mp4 ! qtdemux name=demux demux.video_0 ! queue ! h264parse ! nvv4l2decoder ! nvv4l2h265enc EnableTwopassCBR=1 ! h265parse ! qtmux ! filesink location=test-nvv4l2decoder-nvv4l2-twopasscbr.mp4
gst-launch-1.0 -v filesrc location=edu10-03.mp4 ! qtdemux name=demux demux.video_0 ! queue ! h264parse ! nvv4l2decoder ! nvv4l2h265enc slice-header-spacing=8 bit-packetization=0 ! h265parse ! qtmux ! filesink location=test-nvv4l2decoder-slice-header.mp4
gst-launch-1.0 -v filesrc location=edu10-03.mp4 ! qtdemux name=demux demux.video_0 ! queue ! h264parse ! nvv4l2decoder ! nvv4l2h265enc slice-header-spacing=1400 bit-packetization=1 ! h265parse ! qtmux ! filesink location=test-nvv4l2decoder-slice-header-1400.mp4
gst-launch-1.0 -v filesrc location=edu10-03.mp4 ! qtdemux name=demux demux.video_0 ! queue ! h264parse ! nvv4l2decoder ! nvv4l2h265enc insert-aud=1 ! h265parse ! qtmux ! filesink location=test-nvv4l2decoder-insert-aud.mp4
gst-launch-1.0 -v filesrc location=edu10-03.mp4 ! qtdemux name=demux demux.video_0 ! queue ! h264parse ! nvv4l2decoder ! nvv4l2h265enc insert-vui=1 ! h265parse ! qtmux ! filesink location=test-nvv4l2decoder-insert-vui.mp4
```

```bash
文件	大小	原格式 - 分辨率	转码格式	转码后后大小	转码时间	命令	评价
edu111-orig.mp4	1956KB	h264	h265	1056KB	0.836s	1
edu111-orig.mp4	1956KB	h264	h265	4180KB	0.700s	2
edu10-03.mp4	184MB	h264 2K	h264 2K	58MB	0:06:30	3	文字有失真
edu10-03.mp4	184MB	h264 2k	h265 2k	53MB	0:12:13	4	文字有失真
edu10-03.mp4	184MB	h264 2k	h265 2k	243MB	0:02:21	5	  卡顿
edu10-03.mp4	184MB	h264 2k	h265 2k	247MB 	0:02:21	6	卡顿(I帧影响运行)
edu10-03.mp4	184MB	h264 2k	h265 2k	247MB	0:02:21	7 
edu10-03.mp4	184MB	h264 2k	h265 2k	373MB	0:02:01	8
edu10-03.mp4	184MB	h264 2k	h265 2k	247MB	0:01:58	9
edu10-03.mp4	184MB	h264 2k	h265 2k	244MB	0:02:09	10
edu10-03.mp4	184MB	h264 2k	h265 2k	247MB	0:01:58	11
edu10-03.mp4	184MB	h264 2k	h265 2k	247MB	0:01:58	12
edu10-03.mp4	184MB	h264 2k	h265 2k	247MB	0:01:57	13
edu10-03.mp4	184MB	h264 2k	h265 2k	328MB	0:03:33	14
edu10-03.mp4	184MB	h264 2k	h265 2k	266MB	0:02:37	15	有闪屏
edu10-03.mp4	184MB	h264 2k	h265 2k	252MB	0:01:57	16
edu10-03.mp4	184MB	h264 2k	h265 2k	247MB	0:01:57	13
edu10-03.mp4	184MB	h264 2k	h265 2k	328MB	0:03:33	14
edu10-03.mp4	184MB	h264 2k	h265 2k	266MB	0:02:37	15	有闪屏
edu10-03.mp4	184MB	h264 2k	h265 2k	252MB	0:01:57	16
edu10-03.mp4	184MB	h264 2k	h265 2k	247MB	0:01:55	21
edu10-03.mp4	184MB	h264 2k	h265 2k	247MB	0:01:55	22
```
Nvidia 硬件编码参数及含义():

```bash
名称	参考命令含义	参考命令
 I-Frame Interval	全帧中I帧的间距，不宜太大。对运动画面影响较大，数值越小，文件越大。
temporal-tradeoff	人为强制丢弃帧，以5帧内为单位。Not Supported
control-rate	0: disable,1: variable bit rate,2: CBR, 3:Variable bit rate with frame skip, 4: Constant bit rate with frame skip
peak bitrate
指定bitrate的一个范围，默认的最大值是平均值的1.2倍。
Set Quantization Range for I, P and B Frame	qp-range="10,30:10,35:10,35": [0:51] for I, P和B帧
Set Hardware Preset Level
0:UltraFastPreset,1:FastPreset,2:MediumPreset,3:SlowPreset

值越大，体积越大


Set Profile	1: Baseline profile, 2:Main profile(Not Used)(Not Used), 8: High profile（Not used）（Not used）
num-B-Frames
 254enc not supported


insert-sps-pps	a sequence parameter set (SPS) and a picture parameter set (PPS) are inserted before each IDR frame in the H.264/H.265 stream(具体作用还未清晰)
Two-Pass CBR	Two-pass CBR must be enabled along with constant bit rate (control-rate=2)
slice-header-spacing=8 bit-packetization=0	The parameter bit-packetization=0 configures the network abstraction layer (NAL) packet as macroblock (MB)-based, and slice-header-spacing=8 configures each NAL packet as 8 MB at maximum.	15
slice-header-spacing=1400 bit-packetization=1
16
num-B-Frames
 254enc not supported


insert-sps-pps	a sequence parameter set (SPS) and a picture parameter set (PPS) are inserted before each IDR frame in the H.264/H.265 stream(具体作用还未清晰)
Two-Pass CBR	Two-pass CBR must be enabled along with constant bit rate (control-rate=2)
slice-header-spacing=8 bit-packetization=0	The parameter bit-packetization=0 configures the network abstraction layer (NAL) packet as macroblock (MB)-based, and slice-header-spacing=8 configures each NAL packet as 8 MB at maximum.	15
slice-header-spacing=1400 bit-packetization=1	The parameter bit-packetization=1 configures the network abstraction layer (NAL) packet as size-based, and slice-header-spacing=1400 configures each NAL packet as 1400 bytes at maximum.	16
cabac-entropy-coding=1	 H265 Not Supported
EnableMVBufferMeta	This property enables motion vector metadata for encoding (long long time)
insert-aud	This property inserts an H.264/H.265 Access Unit Delimiter (AUD)	21
insert-vui	 Usability Information (VUI) in SPS	22
poc-type
0: POC explicitly specified in each slice header (the default)
2: Decoding/coding order and display order are the same

only 264
```








