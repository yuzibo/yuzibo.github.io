---
title: 解析dtb相关文件
category: kernel
layout: post
---
* content
{:toc}

请参考这个[文章](https://blog.csdn.net/FPGASOPC/article/details/113351647)

dts文件是由dtc工具编译，其工具在：   out/target/product/xxx/obj/KERNEL_OBJ/scripts/dtc/dtc

要分析编译出的dtb文件，需要将dtb文件反向解析出dts文件，使用方法如下：

dtc  -I  dtb  123.dtb  -O  dts  -o xxx.dts   //  I  大写 i ，表示输入，dtc -h 可以查看各个参数意义

dts --> dtc 用法：

dtc  -I  dts  123.dts  -O dtb  -o xxx.dtb
