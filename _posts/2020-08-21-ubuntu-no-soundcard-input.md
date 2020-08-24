---
title: xubuntu 无法读取声音的设置
category: tools
layout: post
---
* content
{:toc}

因为公司使用的Ubuntu 18.04自带的桌面系统是 GNOME，个人来说非常不喜欢这个UI，
故自己更换了一个Xubuntu的桌面系统，这个桌面系统使用的kde的构件，仿佛一个
复古的debian。

在使用的过程中，也没有什么觉得不好的地方，然而在准备开会的时候发现了一个
问题，声音无法被pc拾取，这一定是哪有有问题。

经过摸索，今天终于搞定了声音输入(input)。

# pavucontrol
使用这个util打开声音设置系统，选择Input(I)[输入设置], Monitor of 内置音频 模拟立体声保持默认设置， 保持不变。

关键在于第二个选项设置，内置音频 模拟立体声， port 选择话筒(plugged in),
显示选择(ALL Input Devices), 我的机器上这个时候还不能输入声音，接着要调试
上面带锁（锁定声道）：， 多试几次就好了.
