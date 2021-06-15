---
title: i2c与EEPROM的基础知识
category: hardware
layout: post
---
* content
{:toc}

目前工作上需要处理理解这个东西，故放在这里增强记忆。

[link for microchip](https://ww1.microchip.com/downloads/en/DeviceDoc/AT24C01C-AT24C02C-I2C-Compatible-Two-Wire-Serial-EEPROM-1Kbit-2Kbit-20006111A.pdf)

# Device Default Condition from Microchip
The AT24C01C/AT24C02C is delivered with the EEPROM array set to logic ‘1’, resulting in FFh data in all
locations.

这句话的意思是, 初始化EEPROM的值为 每一个寄存器 为 FF


# i2c基础概念
[大部分参考这个内容](https://www.cnblogs.com/yuanqiangfei/p/10324120.html)
i2c目前多集中于单片机内部的通信，用于连接微处理器与外围设备，是PHILIPS串行总线。一般i2c总线由SDA和SCL两条线构成，其中

# i2cdetect
这个命令是检测i2c设备.

