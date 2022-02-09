---
title: c语言之getopts用法
category: c/c++
layout: post
---
* content
{:toc}

原来听领导说过，Linux下目前没有类似python parse 的库，直到最近才发现，项目中有同事用到了此类技术，故在这里进行总结，以方便自己下次使用。

示例代码:

```c
...
#include <getopt.h>
...
struct CommandOptions {
    eboolean       no_preview;
    const echar    *streamUrl;
    const echar    *streamName;
    euint          deviceId;
    XXVideoFormat cameraFormat;
    euint          videoWidth;
    euint          videoHeight;
    euint          framerate;
}; // 需要自定义
...
int main(int argc, char *argv[])
{
   //... 初始化代码
    struct CommandOptions options = {
        .no_preview   = FALSE,
        .streamUrl    = "rtmp://xx/live", // live"
        .streamName   = "myChannel",
        .deviceId     = 0,
        .cameraFormat = xx_VIDEO_FORMAT_UYVY,
        .videoWidth   = 1920,
        .videoHeight  = 1080,
        .framerate    = DEFAULT_FRAME_RATE
    };

    static struct option long_options[] = {
        { "streamUrl",  required_argument, NULL,  'u' },
        { "streamName", required_argument, NULL,  'n' },
        { "deviceId",   required_argument, NULL,  'd' },
        { "camfmt",     required_argument, NULL,  'f' },
        { "no-preview", no_argument,       NULL,  'p' },
        { "width",      required_argument, NULL,  'w' },
        { "height",     required_argument, NULL,  'h' },
        { "framerate",  required_argument, NULL,  'r' },
        { "help",       no_argument,       NULL,  'H' },
        { 0,            0,                 0,     0   }
    };

    while (TRUE) {
        int c;
        int option_index = 0;

        c = getopt_long(argc, argv, "u:n:d:f:pw:h:r:H", long_options, &option_index);
        if (c == -1)
            break;

        switch (c) {
        case 'u':
            options.streamUrl = optarg;
            break;

        case 'n':
            options.streamName = optarg;
            break;

        case 'd':
            options.deviceId = atoi(optarg);
            break;

        case 'p':
            options.no_preview = TRUE;
            break;

        case 'w':
            options.videoWidth = atoi(optarg);
            break;

        case 'h':
            options.videoHeight = atoi(optarg);
            break;

        case 'r':
            options.framerate = atoi(optarg);
            break;

        case 'H':
            print_usage(argv[0]);
            exit(0);
            break;

        case 'f':
            options.cameraFormat = xx_get_video_format_from_str(optarg);
            if (options.cameraFormat == xx_VIDEO_FORMAT_UNKNOWN){
                printf("Unknown video format: %s\n", optarg);
                print_usage(argv[0]);
                exit(-1);
            }
            break;

        case '?':
            print_usage(argv[0]);
            exit(-1);
            break;

        default:
            printf("?? getopt returned unknown code 0x%x ??\n", c);
            print_usage(argv[0]);
            exit(-1);
            break;
        }
    }

    if (options.streamUrl == NULL || options.streamName == NULL) {
        printf("Stream URL and stream name must be specified!\n");
        print_usage(argv[0]);
        exit(-1);
    }

```
这里，只有`getopt_long`是系统调用，需要引入有文件 <getopt.h>,然后按照这里面的必须项和非必须项依次填充，然后整个while就可以依次解析了。