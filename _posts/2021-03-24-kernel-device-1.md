---
title: 内核设备树简介
category: kernel
layout: post
---
* content
{:toc}

终于有机会做kernel相关的东西了，暂时先积累，后面再进行总结。

# 设备树有什么好处

针对kernel，从bootloader开始，内核需要建立虚拟地址或者打印一些log，但是，需要去哪呢？现在大部分需要写到寄存器中，但是地址在哪，如何告知？当然，我可以写死，但是，如果换个PC呢？

ARM之前就是这么干的，然后被linus骂的狗血喷头。

设备树重要的三点是: interrupts  address and custom variables


## Compiling the device tree
1. A text files (*.dts) -- “source”
2. A binary blob(*.dtb)  -- "object code"
3. A file system in a running Linux "/proc/device-tree "


## Download device tree compiler

```c
 git clone git://git.kernel.org/pub/scm/utils/dtc/dtc.git dtc
$ cd dtc
$ make
```
具体使用命令:

```bash
scripts/dtc/dtc -I dts -O dtb -o /path/to/my-tree.dtb /path/to/my-tree.dts
```

DTS的编译器dtc可以编译产生:

```c
make ARCH=arm digilent_zed_defconfig
 make ARCH=arm scripts // 产生DTC
```
 反编译回去可以使用

```bash
scripts/dtc/dtc -I dtb -O dts -o /path/to/fromdtb.dts /path/to/booted_with_this.dtb
```
## dts简介

```c
/dts-v1/;
/ {        # tree's root'
  #address-cells = <1>;
  #size-cells = <1>;
  compatible = "xlnx,zynq-zed";
  interrupt-parent = <&gic>;
  model = "Xillinux for Zedboard";
  aliases {
    serial0 = &ps7_uart_1;
  } ;
  chosen {
    bootargs = "consoleblank=0 root=/dev/mmcblk0p2 rw rootwait earlyprintk";
    linux,stdout-path = "/axi@0/uart@E0001000";
  };

  cpus {

      [ ... CPU definitions ... ]

   } ;
  ps7_ddr_0: memory@0 {
    device_type = "memory";
    reg = < 0x0 0x20000000 >;
  } ;
  ps7_axi_interconnect_0: axi@0 { # ps7_axi_interconnect_0 是label
    #address-cells = <1>;
    #size-cells = <1>;
    compatible = "xlnx,ps7-axi-interconnect-1.00.a", "simple-bus";
    ranges ;

      [ ... Peripheral definitions ... ]

  } ;
} ;
```

## 研究寄存器地址

```c
xillybus_0: xillybus@50000000 {
      compatible = "xlnx,xillybus-1.00.a";
      reg = < 0x50000000 0x1000 >;
      interrupts = < 0 59 1 >;
      interrupt-parent = <&gic>;

      xlnx,max-burst-len = <0x10>;
      xlnx,native-data-width = <0x20>;
      xlnx,slv-awidth = <0x20>;
      xlnx,slv-dwidth = <0x20>;
      xlnx,use-wstrb = <0x1>;
    } ;
```

假设probe函数如下:

```c
static int __devinit xilly_drv_probe(struct platform_device *op)
{
  const struct of_device_id *match;

  match = of_match_device(xillybus_of_match, &op->dev);

  if (!match)
    return -EINVAL;
```

## 使用寄存器
Next, the memory segment is allocated and mapped into virtual memory:

```c
  int rc = 0;
  struct resource res;
  void *registers;

  rc = of_address_to_resource(&op->dev.of_node, 0, &res);
  if (rc) {
    /* Fail */
  }

  if  (!request_mem_region(res.start, resource_size(&res), "xillybus")) {
    /* Fail */
  }

  registers = of_iomap(op->dev.of_node, 0);

  if (!registers) {
    /* Fail */
  }
```
of_address_to_resource这个函数是可以通过设备树把 resource res这个结构体赋值的。在这个例子中，`reg = < 0x50000000 0x1000 >`意味着这块内存地址分配在0x50000000开始，大小为0x1000的地方。of_address_to_resource() will therefore set res.start = 0x50000000 and res.end = 0x50000fff.

接下来的request_mem_region()则是准备注册这个内存地址, 只要有request，就差不多有锁的机制进行保护。


of_iomap() 是of_address_to_resource() and ioremap()函数的组合，这个确保了物理内存段与虚拟内存之间的映射,并返回虚拟内存的地址。

操纵这些数据的最好方式是使用iowrite32()  或者 ioread32()

## 追加中断处理
在驱动侧:

```c
 irq = irq_of_parse_and_map(op->dev.of_node, 0);

  rc = request_irq(irq, xillybus_isr, 0, "xillybus", op->dev);
```
irq_of_parse_and_map()会寻找设备树中的中断, request_irq也会在 /proc/interrupt中匹配对应的中断。第二个参数0， 表示前面的中断应该从设备树中取得。

看一下设备树中的中断:

```c
  interrupts = < 0 59 1 >;
      interrupt-parent = <&gic>;
```
前面的第一个0暗示这个中断是否为一个SPI(Shared peripheral interrupt).
一个非0值意味着它是SPI. 第二个则为中断号。



# 结合Nvidia v4l2源代码

V4L2的实现可以参阅 https://linuxtv.org/downloads/v4l-dvb-apis/

# cs_imx370.c

```c
static struct camera_common_pdata *cs_imx307_parse_dt(struct tegracam_device *tc_dev)
{
	struct device *dev = tc_dev->dev;
	struct device_node *np = dev->of_node;
	struct camera_common_pdata *board_priv_pdata;
	const struct of_device_id *match;
	//struct camera_common_pdata *ret = NULL;
	int err;
	//int gpio;


	match = of_match_device(cs_imx307_of_match, dev);
	if (!match) {
		dev_err(dev, "Failed to find matching dt id\n");
		return NULL;
	}

	board_priv_pdata = devm_kzalloc(dev,
					sizeof(*board_priv_pdata), GFP_KERNEL);
	if (!board_priv_pdata)
		return NULL;

```
从这个名字看，应该是这个device首先parse 设备树的某个文件，但是参数中的*tc_dev*是如何生成的，这也是一个有趣的问题。重点现在没有找到`of_match_device`的机制是如何的

这里有一个很好的[ov](https://stackoverflow.com/questions/38493999/how-devices-in-device-tree-and-platform-drivers-were-connected)
其中的答案中的链接非常有用，需要接下来进行更深入的了解。

在第一节中，我引用了别人的说法，正所谓，不是自己得出来的就不是自己的。
按照[lwn](https://lwn.net/Articles/448502/)的说法，目前的linux系统很容易在一个新的系统启动.需要做两件事:

1. 描述设备

2. 在启动阶段注册所有的设备。

但是呢，这样的方法也是非常的不方便。前面是集中在板级文件，目前的方案就是设备树，让内核自己去侦测应该启动内核的哪一部分。


出现在设备树中的设备名(在“compatible”属性中)往往采用标准化的形式，不一定与Linux内核中驱动程序的名称相匹配;在其他方面，设备树确实意味着可以与多个操作系统一起工作。因此，最好将特定的名称附加到平台设备上，以便与设备树一起使用。内核提供了一个of_device_id结构，可以用于这个目的:

```c
static const struct of_device_id my_of_ids[] = {
	{ .compatible = "long,funky-device-tree-name" },
	{ }
    };
```

# 有关的kernel driver必须做的事情

[参考](http://xillybus.com/tutorials/device-tree-zynq-3)

1. 当硬件插入时相应的驱动被内核加载
2. 这个驱动需要知道为外围设备分配的地址空间
3. 驱动也得需要知道设备触发哪个中断，这样驱动才能注册中断处理函数；
4. 应用层的消息也需要接受。

## 设备树
设备树中，最重要的项就是"compatible".

1. When the kernel starts up, it kicks off compiled-in drivers that match “compatible” entries it finds in the device tree

2. At a later stage (when /lib/modules is available), all kernel modules that match “compatible” entries in the device tree are loaded.

```c
static struct of_device_id xillybus_of_match[] __devinitdata = {
  { .compatible = "xlnx,xillybus-1.00.a", },
  {} // 可以加载多个 compatible
};

MODULE_DEVICE_TABLE(of, xillybus_of_match);
```
of_device_id是连接内核 driver与campatible之间的桥梁

```c
static struct platform_driver xillybus_platform_driver = {
  .probe = xilly_drv_probe,
  .remove = xilly_drv_remove,
  .driver = {
    .name = "xillybus",
    .owner = THIS_MODULE,
    .of_match_table = xillybus_of_match,
  },
};
```
然后xillybus_platform_driver必须被调用在模块初始化函数中。

An important thing to note when writing kernel modules, is that the automatic loading mechanism (modprobe, actually) depends on an entry for the “compatible” string in /lib/modules/{kernel version}/modules.ofmap and other definition files in the same directory. The correct way to make this happen for your own module, is to copy the *.ko file to somewhere under the relevant /lib/modules/{kernel version}/kernel/drivers/ directory and go

```c
# depmod -a
```

on the target platform, with that certain kernel version loaded (or define which kernel version to depmod).

# linux platform总线

这块是我之前没有涉及到的地方，可以在这里入手。

[参考](https://www.cnblogs.com/alantu2018/p/8997179.html)

引用开始
================================

1、概述：

通常在Linux中，把SoC系统中集成的独立外设单元(如：I2C、IIS、RTC、看门狗等)都被当作平台设备来处理。

从Linux2.6起，引入了一套新的驱动管理和注册机制：Platform_device和Platform_driver，来管理相应设备。

Linux中大部分的设备驱动，都可以使用这套机制，设备用platform_device表示，驱动用platform_driver进行注册。

Linux platform driver机制和传统的device_driver机制相比，一个十分明显的优势在于platform机制将本身的资源注册进内核，由内核统一管理，在驱动程序中使用这些资源时通过platform_device提供的标准接口进行申请并使用。

这样提高了驱动和资源管理的独立性，并且拥有较好的可移植性和安全性。

platform是一个虚拟的地址总线，相比pci，usb，它主要用于描述SOC上的片上资源，比如s3c2410上集成的控制器（lcd，watchdog，rtc等），platform所描述的资源有一个共同点，就是可以在cpu的总线上直接取址。

2、platform机制分为三个步骤
1）总线注册阶段：
内核启动初始化时的main.c文件中的
kernel_init() ->do_basic_setup() -> driver_init() ->platform_bus_init() ->bus_register(&platform_bus_type)，注册了一条platform总线（虚拟总线）
platform总线用于连接各类采用platform机制的设备，此阶段无需我们修改，由linux内核维护。
2）添加设备阶段：
设备注册的时候
Platform_device_register() -> platform_device_add() -> pdev->dev.bus = &platform_bus_type -> device_add()，就这样把设备给挂到虚拟的总线上。
本阶段是增加设备到plartform总线上，我们增加硬件设备，需要修改此处信息。
此部分操作一般arm/arm/mach-s3c2440/mach-smdk2440.c类似的文件中，需要我们根据硬件的实际需要修改相应代码
3）驱动注册阶段：
    Platform_driver_register() ->driver_register() -> bus_add_driver() -> driver_attach() ->bus_for_each_dev(),
对在每个挂在虚拟的platform bus的设备作__driver_attach() ->driver_probe_device()
    判断drv->bus->match()是否执行成功，此时通过指针执行platform_match-> strncmp(pdev->name , drv->name , BUS_ID_SIZE),如果相符就调用really_probe(实际就是执行相应设备的platform_driver->probe(platform_device)。)
开始真正的探测，如果probe成功，则绑定设备到该驱动。
本阶段是在编写具体的驱动程序时完成，在注册驱动时获取步骤2中已经申请的资料，一般由程序开发者完成。

========= 引用结束 ====================
