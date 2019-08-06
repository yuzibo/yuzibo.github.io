---
title: "packet在内核中的流程"
category: network
layout: post
---
* content
{:toc}

# 为什么会有这个问题
因为这个问题在电话面试的时候被问的次数太多了，哈哈，目前，市面上也没有很好的教程去说明这个问题。

再次总结下自己的学习kernel艰苦的路程。我发现了，所谓的自己深入不进去，是自己读的太少或者认真思考的太少，包括这几次面试，都是问的一些基础知识，那为什么掌握不了呢？这需要自己好好反思了。到底哪里出了问题。

千方百计，毛主席说过的话，自己何尝努力了几分之几。对吧，这个样子，是自己不上心的后果之一。

# 简单记录
我知道的一个问题就是，自己看不懂的就不记了，其实你说这些都不能记住吗？东西也就是那么多，自己记住一点是一点。

就从网卡说起吧。 版本2.6.x

[以这篇文章为例](https://blog.csdn.net/JIANGXIN04211/article/details/48180955)这篇文章不会设计具体的函数，大体记录下简要。

```c
struct pci_device_id {
	__u32 vendor, device;
	...
}
```
大多数网卡就是一个PCI设备，然后是一个 **struct pci_device_id **的数组。

```c
static struct pci_device_id e100_id_table[] = {
        INTEL_8255X_ETHERNET_DEVICE(0x1029, 0),
        INTEL_8255X_ETHERNET_DEVICE(0x1030, 0),
        INTEL_8255X_ETHERNET_DEVICE(0x1031, 3),
……/*略过一大堆支持的设备*/}
```

同时，pci设备需要**pci\_driver**:

```c
struct pci_driver {
        struct list_head node;
        char *name;
        struct module *owner;
        const struct pci_device_id *id_table;        /* must be non-NULL for probe to be called */
        int  (*probe)  (struct pci_dev *dev, const struct pci_device_id *id);        /* New device inserted */
        void (*remove) (struct pci_dev *dev);        /* Device removed (NULL if not a hot-plug capable driver) */
        int  (*suspend) (struct pci_dev *dev, pm_message_t state);        /* Device suspended */
        int  (*resume) (struct pci_dev *dev);                        /* Device woken up */
        int  (*enable_wake) (struct pci_dev *dev, pci_power_t state, int enable);   /* Enable wake event */
        void (*shutdown) (struct pci_dev *dev);

        struct device_driver        driver;
        struct pci_dynids dynids;
};
```

在系统引导的时候，PCI设备可以被发现，其实这个引导的过程应该很有趣，实在是应该探究一番去瞧一瞧。

当内核发现一个已经检测到的设备同驱动注册的id_table中的信息相匹配时，
它就会触发驱动的probe函数，以e100为例：

```c
/*
   * 定义一个名为e100_driver的PCI设备
   * 1、设备的探测函数为e100_probe;
   * 2、设备的id_table表为e100_id_table
   */
static struct pci_driver e100_driver = {
        .name =         DRV_NAME,
        .id_table =     e100_id_table,
        .probe =        e100_probe,
        .remove =       __devexit_p(e100_remove),
#ifdef CONFIG_PM
        .suspend =      e100_suspend,
        .resume =       e100_resume,
#endif
        .driver = {
	                .shutdown = e100_shutdown,
	        }

};
```
这样，如果系统检测到与id_table 中对应的设备时， 就会调用驱动的probe函数。
驱动设备在init函数中，调用pci_module_init函数初始化PCI设备e100_driver:

```c
tatic int __init e100_init_module(void)
{
        if(((1 << debug) - 1) & NETIF_MSG_DRV) {
	      printk(KERN_INFO PFX "%s, %s/n", DRV_DESCRIPTION, DRV_VERSION);
	      printk(KERN_INFO PFX "%s/n", DRV_COPYRIGHT);
	 }
	return pci_module_init(&e100_driver);
}
```

下面的问题就很重要了，需要记忆的东西比较多
