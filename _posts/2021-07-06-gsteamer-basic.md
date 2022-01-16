---
title: gstreamer
category: gstreamer
layout: post
---
* content
{:toc}

# 基本概念

[cnblog](https://www.cnblogs.com/xleng/p/11194226.html)的一系列文章写得非常不错，他是一个系列的。
链接中是动态创建Pipeline.

[gstreamer hello world](https://www.cnblogs.com/xleng/p/11008239.html)

[gstream element](https://www.cnblogs.com/xleng/p/11039519.html)

为了更直观的展现element，我们通常用一个框来表示一个element，在element内部使用小框表示pad。

## 三类element

1. source element:  只能生成数据的，不能接收数据的， 如 filesrc

2. sink element: 只能接收数据，不能产生数据的

3. Fliter-like element: 过滤数据，对数据进行处理

### Pad
Pad是一个element的输入输出接口，有src pad（producting data）,sink pad(consuming data)这两种类型的接口。两个element必须通过pad才能连接起来，且pad有当前element所能处理的数据类型(capabilities),需要在连接时通过比较 src pad和sink pad中所支持的能力，来选择最恰当、或者用户指定的某种数据类型进行传输。

`video/x-raw,format=RGB,width=300,height=200,framerate=30/1`
就是一个pad的样例。

作用:   1、 协商阶段选择相同的数据类型
        2、数据，消息传输

使用gstreamer工具来查看element所支持的capabilities（gst-inspect-1.0 v4l2src） 

一个例子:

```bash
...
Pad Templates:
  SRC template: 'src'
    Availability: Always
    Capabilities:
      image/jpeg
      video/mpeg
            mpegversion: 4
           systemstream: false
      video/mpeg
            mpegversion: 2
      video/mpegts
           systemstream: true
      video/x-bayer
                 format: { (string)bggr, (string)gbrg, (string)grbg, (string)rggb }
                  width: [ 1, 32768 ]
                 height: [ 1, 32768 ]
              framerate: [ 0/1, 2147483647/1 ]
      video/x-dv
           systemstream: true
      video/x-h263
                variant: itu
      video/x-h264
          stream-format: { (string)byte-stream, (string)avc }
              alignment: au
      video/x-pwc1
                  width: [ 1, 32768 ]
                 height: [ 1, 32768 ]
              framerate: [ 0/1, 2147483647/1 ]
      video/x-pwc2
                  width: [ 1, 32768 ]
                 height: [ 1, 32768 ]
              framerate: [ 0/1, 2147483647/1 ]
      video/x-raw
                 format: { (string)RGB16, (string)BGR, (string)RGB, (string)GRAY8, (string)GRAY16_LE, (string)GRAY16_BE, (string)YVU9, (string)YV12, (string)YUY2, (string)YVYU, (string)UYVY, (string)Y42B, (string)Y41B, (string)YUV9, (string)NV12_64Z32, (string)NV24, (string)NV61, (string)NV16, (string)NV21, (string)NV12, (string)I420, (string)BGRA, (string)BGRx, (string)ARGB, (string)xRGB, (string)BGR15, (string)RGB15 }
                  width: [ 1, 32768 ]
                 height: [ 1, 32768 ]
              framerate: [ 0/1, 2147483647/1 ]
      video/x-sonix
                  width: [ 1, 32768 ]
                 height: [ 1, 32768 ]
              framerate: [ 0/1, 2147483647/1 ]

```

#### pad分类(Availabilities)

always: 一直存在；

Sometimes: 在某些特定场景中才会存在；

On request: tee元件

举例：

```bash
Pad Templates:
  SINK template: 'sink'
    Availability: Always
    Capabilities:
      ANY

  SRC template: 'src_%u'
    Availability: On request
    Capabilities:
      ANY
```

tee的SINK pad是Always,也就是说他需要接收上端的src 文件，但是出去几路，需要根据用户的请求来设定。

### bin
bin是一个特殊的element，其实包含了几个其他的子elements,类似函数的概念。好处是简化Pipeline

## caps
描述某一element可以接收后者产生的所有媒体类型的集合，是由一组GstStrcut和GstStruct的GstCapsFeatures(可选)组成。

GstStruct: a collection of key/value pairs.

通过GstCapsImpl这个结构体完成的。

### Properties

使用 gst-inspect-1.0查找不同elements的允许值。

设置属性方式:  g_object_set(v4l2src, "device", "/dev/video1", NULL)

得到属性方式:  g_object_get(volume, "volume", &level, NULL)

### signals

```c
gst-inspect-1.0 appsrc
Element Signals:
  "need-data" :  void user_function (GstElement* object,
                                     guint arg0,
                                     gpointer user_data);
  "enough-data" :  void user_function (GstElement* object,
                                       gpointer user_data);
  "seek-data" :  gboolean user_function (GstElement* object,
                                         guint64 arg0,
                                         gpointer user_data);

```

Element Signals： 插件在运行过程中满足某种条件可以发出的signal.以appsrc为例： 如果设置emit-signals为true，那么在appsrc运行过程中满足某种条件就可以发出singal。
该singal可以调用用户自己定义的函数。

### Actions

Element action: 在插件中规定了用户触发某种信号所引起的行为。

## Factory Details
可以看做是一些描述：

```bash
vimer@user-HP:~$ gst-inspect-1.0 appsrc
Factory Details:
  Rank                     none (0)
  Long-name                AppSrc
  Klass                    Generic/Source
  Description              Allow the application to feed buffers to a pipeline
  Author                   David Schleef <ds@schleef.org>, Wim Taymans <wim.taymans@gmail.com>
```

code

```c
void
gst_element_class_set_metadata (GstElementClass * klass,
    const gchar * longname, const gchar * classification,
    const gchar * description, const gchar * author)
{
  g_return_if_fail (GST_IS_ELEMENT_CLASS (klass));
  g_return_if_fail (longname != NULL && *longname != '\0');
  g_return_if_fail (classification != NULL && *classification != '\0');
  g_return_if_fail (description != NULL && *description != '\0');
  g_return_if_fail (author != NULL && *author != '\0');

  gst_structure_id_set ((GstStructure *) klass->metadata,
      GST_QUARK (ELEMENT_METADATA_LONGNAME), G_TYPE_STRING, longname,
      GST_QUARK (ELEMENT_METADATA_KLASS), G_TYPE_STRING, classification,
      GST_QUARK (ELEMENT_METADATA_DESCRIPTION), G_TYPE_STRING, description,
      GST_QUARK (ELEMENT_METADATA_AUTHOR), G_TYPE_STRING, author, NULL);
}
```

### Plugin Details 
通过GST_PLUGIN_DEFINE来定义。

# element/bin/pipeline的关系

GstPipeline->GstBin->GstElement

```c
struct _GstPipeline {
  GstBin         bin;

  /*< public >*/ /* with LOCK */
  GstClock      *fixed_clock;

  GstClockTime   stream_time;
  GstClockTime   delay;

  /*< private >*/
  GstPipelinePrivate *priv;

  gpointer _gst_reserved[GST_PADDING];
};
```
摘自： gstreamer/gstreamer-1.14.5/gst/gstpipeline.h

# pipeline
构建pipeline的方式：

1. parse launch的方式：

```bash
gst-launch-1.0 videotestsrc  ! "video/x-raw,width=1920,height=1080,framerate=60/1" ! videoscale ! "video/x-raw,width=720,height=480" ! videoflip method=5 ! xvimagesink
```
不同的元件由"!"隔开。

gst_parse_launch("fakesrc ! fakesink", NULL)

2. gst_pipeline_new创建pipeline

## 创建分支pipeline
1. 普通创建
每个Element都有name的属性， 可以利用name来实现包含多个分支的复杂的Pipeline， 这常见于有多个输入输出的Element(mux, demux, tee等)

如以下命令：

```bash
vimer@user-HP:~/ms/edk_test$ gst-launch-1.0 v4l2src device=/dev/video1 ! video/x-raw,format=YUY2,width=640,height=480 ! tee name=t ! queue ! xvimagesink t. ! queue ! fakesink
```

我们注意到tee,这里会创建2路pipeline,由于上不了图片，注意`t.`那里。

```bash
   tee->queue->xvimagesink
    |
    > queue -> fakesink
```

2. 指定Element 的pad
看一下tee element：

```bash
gst-inspect-1.0 tee
SRC template: 'src_%u'
    Availability: On request
    Capabilities:
      ANY
# src_%u %就是接的用户自己创建的src pad的个数.
```
某些情况下，我们希望自己指定某个pad用于连接，我们可以指定自己命名的Element 的pad来实现，或者某些元件必须指定pad才能正常连接。

```bash
gst-launch-1.0 v4l2src device=/dev/vide01 ! video/x-raw,format=YUY2,width=640,height=480 ! tee name=t t.src_00 ! queue ! xvimagesink t.src_01 ！ queue ！ fakesink
```

这样就指定了具体的pipeline分支。

# appsrc和sppsink

gsteamer提供了可以给用户程序进行交互的方式, appsrc和appsink

appsrc： 用于将应用程序的数据发送到pipeline中，应用程序负责数据的生成，并将其作为  `GstBuffer`传输到Pipeline中去。 

appsink:  用于从Pipeline中提取数据，并发送到应用程序中去。

GstBuffer:  在GStreamer Pipeline中的plugin间传输的数据块成为buffer，在GStreamer内部成为GstBuffer。Buffer由Source Pad生成，并由Sink Pad消耗。

```bash
nvv4l2camerasrc ->(UYUV(nv memory))-> nvvidconv -> (I420 cpu memory)->appsink
```

另一个case vedio display:

```bash
appsrc->(I420 cpu memory)->nvvidconv->(I420 nv memory)->nv3dsink
```

## pipeline的数据流向
有两种： downstream(Dataflow and event) 和 upstream（event）

NULL（初始状态）-> READY （准备接受数据）-> PAUSED(Pad active status) -> PLAYING(processing data)

# tools

gst-discoverer-1.0： 查看音视频文件的详细数据。

gst-play-1.0:  播放文件

gst-device-monitor: gst-device-monitor Audio/Source

创建Pipeline的element的关系图:

```bash
GST_DEBUG_DUMP_DOT_DIR=. 

gst-launch-1.0 videotestsrc  ! "video/x-raw,width=1920,height=1080,framerate=60/1" ! videoscale ! "video/x-raw,width=720,height=480" ! videoflip method=5 ! xvimagesink

# sudo apt install graphviz

dot -T png pipeline.png xx.dot
```



