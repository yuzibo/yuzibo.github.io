---
layout: article
title: "linux kernel 配置"
category: linux
---
#前言
在真的机子上debian的内核一次没有配置成功，我要用两天的时间把配置的内容探个究竟。
##工具
在编译内核之前最好使用  

	make mrproper

清扫一下。

我使用的是git，clone的linus的版本，一切准备妥当后，我们要选择合适的配置工具。
我选的是 make menuconfig,注意无论哪一种都需要相应的软件包。
#配置
在配置前的方括号中按下“y”，就是built-in,这是将相关代码编译进内核，默认与目标机相关的硬件的代码必须内建进内核，这些东西就如同人的基本器官，不可无;另一种就是M，这是将相关的选项编译成模块，这样就可以是编译的内核的体积不过于太大，精简内核是我们必须掌握的知识点;最后一种就是按下"space",什么也不做，就是回答“no”。
##补充
内核的发展太快了，当我写这篇文章的时候，代码还可以是最新的(git pull),但是很快就update的，不过，有些东西是不会变动太大。

###说明：下面的项目就是我自己的内核的配置，后边的字母代表我的选项。

64-bit kernel  : n

General setup -->

Cross-compile tool prefix : n

Compile also drivers which not load(NEW) : n

Local version - append to kernel release : yubo (按回车键即可进去)

Automatically append version information to the version string : n

kernel compression mode : default

Support for paging of anonymous memory (swap) : y

System V IPC : y 

POSIX Message Queues : y
	
	POSIX Message Queues is message queues(a form of interprocess communciation) where have a priority.

Enable process_vm_readv/writev syscall : y

uselib syscall : y

Enable system-call auditing support : n
	系统中的一些相关操作都会写进日志文件，不要

IRQ subsystem  -> (IRQ is a signal from the hardware to the processor to temporarily stop a runing program and allow a special program to execute in its space)

2>>Export hardware/virtual IRQ mapping via debugfs[IRQ_DOMAIN_DEBUG] : n

Timer tick handing >> 1. Old Idle dynticks config [NO_HZ] : y 向后与配置文件保持兼容

2. High Resolutions Timer Support [High_RES_TIMERS] : N (与你的机器有关)

###CPU/Task time and stats accounting

A. Cputime accounting (Simple tick based cputime  accounting ) >> 1.Simple tick based cputime accounting [TICK CPU_ACCOUNTING] : Y (it checks /proc/stat on every CPU tick)

2. Fine granularity task level IRQ time accounting [IRQ_TIME_ACCOUNTING] : n

B. BSD Process Accounting [BSD_PROCESS_ACCT] : N (A variety of information for each process that closes).

C. Export task/process statistics through netlink [TASKSTATS] ： （NETLINK IS A FORM OF IPC between kernel and user space processes）: y

D.Enable per-task delay accounting(TASK_DELAY_ACCT) [TASK_DELAY_ACCT] : (watches the processes and delays concerning the access of resources) : y

E. Enable extanded accounting over taskstats (TASK_XACCT) : n (collects extra accounting data)

###RCU subsystem (The Read-Copy-Update)

A. Rcu Implementation 

> Tree-Based hierarchical RCU [Tree_Rcu] : y (large SMP cpus and small is ok)

B.
 [ ] Task_based RCU implementation using voluntary context switch │ │  

  │ │    (32) Tree-based hierarchical RCU fanout value                    │ 
  
  │ │    (16) Tree-based hierarchical RCU leaf-level fanout value (NEW)   │  
  │ │    [ ] Disable tree-based hierarchical RCU auto-balancing           │   
  │ │    [ ] Accelerate last non-dyntick-idle CPU's grace periods         │   
  │ │    [ ] Offload RCU callback processing from boot-selected CPUs (NEW)│   
  │ │                                                        




	
