---
layout: article
title: "linux中的段"
category: kernel 
---

# 简介
保护模式下段描述表分为全局描述符表(GDT)、中断描述表（IDT）、局部描述符表（LDT）。

linux使用以下段描述符：

.内核代码段

.内核数据段

.用户代码段

.用户数据段

.TSS段

.默认LDT段

GDT中的内核代码段(kernel code segment)描述表中的值如下：

	.Base = 0x00000000
	.Limit 0x00000000(2^32-1 = 4GB)
	.G(颗粒标识) = 1,表示段的大小是以页为单位的
	.S = 1,表示普通代码段或数据段
	.Type = 0xa, 表示可以读取或者可以执行的代码段
	.DPL = 0,表示内核模式

与这个段相关的线性地址是4GB, S=1 和type=0xa表示代码段，选择器在cs寄存器中，linux访问这个段选择器的宏是_KERNEL_CS.

Kernel data segment与上面的代码段相似，只是.Type的字段值为2,选择器在ds寄存器中，访问这个段选择器的宏是_KERNEL_DS

user code segment 由处于用户模式下的所有进程共享，存储在GDT中的对应段描述符的值如下：

	.Base = 0x00000000
	.Limit = 0xffffffff
	.G = 1
	.S = 1
	.Type = 0xa
	.DPL = 3
可使用_USER_CS访问
user data segment 中唯一不同的字段就是Type = 2,使用_USER_DS

除了以上的段描述表以外，GDT中还包含了用于创建每个进程的段描述 - TSS和LDT

每个TSS代表一个不同的进程，TSS中保存了每个CPU的硬件的上下文信息，它有助于切换上下文。

每个进程都有自己在GDT中存储器的对应的TSS描述符，其值如下：
	
	.Base = &tss(对应进程描述符的TSS字段的地址，例如&tss_struct)
	.Limit = 0xeb（TSS段的大小是236字节）
	.Type = 9或11
	.DPL = 0,用户模式不能访问TSS。G位被清除。



