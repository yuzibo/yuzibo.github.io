---
layout: article 
title: "bits的一些操作"
category: tip
---

##首先解释下关于位操作的概念
位屏蔽(bitmask): 所谓位屏蔽(bitmask)就是利用一个二进制字串与已有的二进制字串进行(AND)运算,通过结果知道原二进制字串中的特定位上有没有1.例如,二进制10011有五个位,屏蔽码是10,则10011 AND 00010 = 00010 > 0(不等于0),说明在原始数据倒数第二位有数据1,而屏蔽码1000的运算结果 10011 AND 01000 = 00000,说明倒数第四位是数据0,没有该选项. 



##关于位的一些简单操作
