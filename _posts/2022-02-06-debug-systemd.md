---
title: 记一次debug systemd的经历
category: debug
layout: post
---
* content
{:toc}


# 起因
在上周五我们发布了新一版本的full image，到目前为止影响系统启动的crash问题暂时没有复现。下面，将本次调试的过程记录一下，以便后面遇到此类问题提供一些思路。

1. 起因&现象

由于研发需要，我们需要出一版本新的full image，但是，相关同事反馈，full image flash后一直重启，连上debug口发现是kernel crash，内容和 https://forums.developer.nvidia.com/t/kernel-panic-when-starting-a-cuda-application-as-a-service/180724/6 一致（触发的api不同）：
```c
    ···
[    3.434394] Call trace:
[    3.436848] [<ffffff800808b9f8>] dump_backtrace+0x0/0x198
[    3.436854] [<ffffff800808bfbc>] show_stack+0x24/0x30
[    3.436858] [<ffffff800845abe8>] dump_stack+0xa0/0xc8
[    3.436863] [<ffffff80081c0a00>] panic+0x12c/0x2a8
[    3.436869] [<ffffff8008cbe228>] nvhost_scale_emc_debug_init.isra.12+0x128/0x1a0
[    3.436872] [<ffffff8008cbe5d4>] nvhost_pod_event_handler+0x334/0x400
[    3.436874] [<ffffff8008cbb4fc>] devfreq_add_device+0x284/0x408
[    3.436876] [<ffffff8008cbb6e4>] devm_devfreq_add_device+0x64/0xc0
[    3.437063] [<ffffff8000fc1080>] gk20a_scale_init+0xf0/0x190 [nvgpu]
[    3.437233] [<ffffff8000fba2f8>] gk20a_pm_finalize_poweron+0x370/0x400 [nvgpu]
[    3.437393] [<ffffff8000fba540>] gk20a_busy+0x1b8/0x4f0 [nvgpu]
[    3.437398] [<ffffff800878becc>] pm_generic_runtime_resume+0x3c/0x58
[    3.437401] [<ffffff800878e214>] __rpm_callback+0x74/0xa0
[    3.437402] [<ffffff800878e274>] rpm_callback+0x34/0x98
[    3.437404] [<ffffff800878f710>] rpm_resume+0x470/0x710
[    3.437405] [<ffffff800878f9fc>] __pm_runtime_resume+0x4c/0x70
[    3.437570] [<ffffff8000fba45c>] gk20a_busy+0xd4/0x4f0 [nvgpu]
[    3.437724] [<ffffff8000f9bf1c>] gk20a_ctrl_dev_open+0x8c/0x168 [nvgpu]
[    3.437727] [<ffffff8008261f6c>] chrdev_open+0x94/0x198
[    3.437730] [<ffffff8008258918>] do_dentry_open+0x1d8/0x340
[    3.437732] [<ffffff8008259ed0>] vfs_open+0x58/0x88
[    3.437735] [<ffffff800826d3b0>] do_last+0x530/0xfd0
[    3.437737] [<ffffff800826dee0>] path_openat+0x90/0x378
[    3.437740] [<ffffff800826f450>] do_filp_open+0x70/0xe8
[    3.437741] [<ffffff800825a394>] do_sys_open+0x174/0x258
[    3.437744] [<ffffff800825a4fc>] SyS_openat+0x3c/0x50
[    3.437746] [<ffffff8008083900>] el0_svc_naked+0x34/0x38
[    3.437751] SMP: stopping secondary CPUs
[    3.442246] Kernel Offset: disabled
...
```

在上面链接的后面，reporter提示说，必须将某些服务放到 nvpmodel.service后面才可以。那我们也无法断定是哪个service触发的这个crash。

2. narrow down debug

SX12.001是上一版本的full image，肯定没问题。在xx的帮助下，我们烧录了SX12.002 ok，然后在SX12.003 重现crash，由此断定，该issue在SX12.003引入。然后在SX12.003的基础上，依次把agent 、demo app、lms、ems拿掉(实际拿掉2个)，最终定位到是ems触发的crash。其实这个问题应该更早的想到，SX12.003是ems首次集成。

3. debug details

A. 拿掉ems后系统能正常启动就好说了，大概率是ems的service有问题，然后和大佬一起看了下问题，原始的ems是 After=dbus.socket.然后使用命令  `systemd-analyze --order plot > boot.svg`可以看见详细的systemd的启动时间序列，dbus.socket明显是在nvpmodel service前面，

但是，现在的问题是，必须找到一个合适的时间让ems service启动。然后记得大佬说过，如果改为了 After=graphical,ems的启动慢的无法忍受，大约10min+，为什么呢？

我们把 ems的service放到 nvpmodel后面或者graphical后面，crash现象没有了！ 说明改动是有效的。只是桌面系统起不来，看来还是有其他服务进程影响了桌面系统.

B. 在多次的实验中，偶尔会出现 bootup is not yet finished...以及 Startup finished in 3.515s (kernel) + 10min 4.683s (userspace) = 10min 8.198s 的提示，那么，如果详细的知道每个service启动花费的时间以及没有完成的service是不是好一些？ 查了一下systemd的用法，还真有相关的命令。

```bash
...
user@linux:~$ systemd-analyze blame
    10min 3.354s displaytouch.service
         11.693s k3s.service
          5.428s rc-local.service
          3.185s dev-zram0.device
          3.130s dev-zram1.device
          3.123s docker.service
          3.071s dev-zram2.device
          3.039s dev-zram3.device
          2.956s dev-zram5.device
          2.953s dev-zram4.device
          2.484s dev-nvme0n1p1.device
          1.930s srs.service
          1.353s apt-daily-upgrade.service
          1.272s apt-daily.service
           999ms udisks2.service
           965ms nv-l4t-usb-device-mode.service
...
```

问题出在 displaytouch上面了，其他都是s级，这个是min级，而且还是如此之大。看一下 displaytouch service的内容:

```bash
[Unit]
Description=displaytouch
[Service]
Type=oneshot
PIDFile=/run/displaytouch.pid
#EnvironmentFile=/etc/systemd/displaytouch.conf
ExecStart=/etc/systemd/touch.sh
[Install]
WantedBy=multi-user.target
```

该service调用的脚本是一个10min的loop查询，结合上面的启动时间，该service应该是等待脚本执行完毕后才返回状态，这样应该不可以。详细了解下 service unit的type，发现oneshot就是阻塞模式，使用forking或者simple都可以。故改为:
```bash
[Unit]
Description=displaytouch

[Service]
Type=simple
PIDFile=/run/displaytouch.pid
#EnvironmentFile=/etc/systemd/displaytouch.conf
ExecStart=/etc/systemd/touch.sh

[Install]
WantedBy=graphical.target
```

这样，再次使用  systemd-analyze blame命令查看，发现系统service的启动时间控制在s级别以下。然后把ems的service该为：

```bash
[Unit]
Description=e-Media service
After=multi-user.target

[Service]
Environment=DISPLAY=:0
ExecStart=/bin/bash -c "USERNAME=$(cat /etc/passwd | grep home | grep 1000 | cut -d: -f1); sudo -u $USERNAME /usr/bin/eswin/ems;"
Type=forking
Restart=on-failure
RestartSec=5
StartLimitInterval=0

[Install]
WantedBy=graphical.target
```

系统的multi-user.target启动时间在graphical.target前，故我们把ems放在multi-user之后，graphical之前；现在的现象是 系统可以正常flash，桌面可以正常启动，但是ems的service没有正常启动；

C. 在大佬的建议下，看了一下 /var/log/ems的log，发现有一个 "fail to  get SN"的信息，经过沟通得知，ems需要这个信息。但是，ems是经过deb安装的，如果，通过SUP安装，这是真机安装，在deb的脚本中执行相关命令是可以得到SN并写入到目标文件中去，但是 full image安装ems的deb时是通过chroot的方式安装的deb，这样是得不到系统的SN号的，也就是说，ems经过 full image flash后，第一次

启动后，ems执行程序默认得到SN是不行的，根本就没有那个文件。所以，我们的处理是在  rc.local文件中首先判断下有无ems需要的那个文件，如果没有则立即读取并写入相应的文件，这样才搞定了ems的自启动问题。

综上，就是解决这个问题的大体脉络。目前虽然解决了full image烧录的问题，但还是需要在系统运行中检验。如果总结下来的话，我们认为log真的太重要，尤其ems的log对我们的debug太重要了。