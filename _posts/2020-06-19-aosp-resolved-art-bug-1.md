---
title: 解决aosp art bug
category: aosp
layout: post
---
* content
{:toc}

# 描述
首先使用
`./emulator -show-kernel -verbose -nocache -wipe-data`
启动模拟器：
```c
adb logcat --regex="ZygoteInit |Entered the Android|StartServic es | phase |set rtc to|Setting time"
```
