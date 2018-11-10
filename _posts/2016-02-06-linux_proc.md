---
title: "linux下/proc目录解析"
layout: post
category: kernel 
---
# /proc/cmdline

这个用于给出内核启动的命令行,它和用于进程的cmdline项非常像

yubo@debian:/proc$ cat cmdline
BOOT_IMAGE=/vmlinuz-3.2.0-4-686-pae root=UUID=84caed03-f243-4a09-afa5-15be502cbfb9 ro quiet
yubo@debian:/proc$

# /proc/cpuinfo

这个文件提供了有关系统cpu的多种信息,格式为:文件由多行构成,每行包括一个域名称,一个冒号和一个值



processor	: 0
vendor_id	: GenuineIntel
