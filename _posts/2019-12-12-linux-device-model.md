---
title: linux设备模型简介
category: kernel
layout: post
---

# linux device model
Linux设备模型是一个很大的概念，这里就借着这篇(pdf)[https://bootlin.com/pub/conferences/2019/elce/opdenacker-kernel-programming-device-model/opdenacker-kernel-programming-device-model.pdf]稍微介绍一下。

# 主要的数据结构
## bus_type

主要的数据结构涉及三类： ```struct bus_type```,which was defined in ```include/linux/device.h```.这个结构体就是定义了设备的bus类型,包括USB、PCI、I2C等总线类型。
实例化这个结构体,就代表了其中的一种协议。
```c
struct bus_type {
	const char		*name;
	const char		*dev_name;
	struct device		*dev_root;
	const struct attribute_group **bus_groups;
	const struct attribute_group **dev_groups;
	const struct attribute_group **drv_groups;

	int (*match)(struct device *dev, struct device_driver *drv);
	int (*uevent)(struct device *dev, struct kobj_uevent_env *env);
	int (*probe)(struct device *dev);
	void (*sync_state)(struct device *dev);
	int (*remove)(struct device *dev);
	void (*shutdown)(struct device *dev);

	int (*online)(struct device *dev);
	int (*offline)(struct device *dev);

	int (*suspend)(struct device *dev, pm_message_t state);
	int (*resume)(struct device *dev);

	int (*num_vf)(struct device *dev);

	int (*dma_configure)(struct device *dev);

	const struct dev_pm_ops *pm;

	const struct iommu_ops *iommu_ops;
...
}
```

## device_driver
该结构体同样定义在上述头文件中，代表了在某一种总线上控制的一种特定设备。

```c
struct device_driver {
	const char		*name;
	struct bus_type		*bus; //继承上面的一种类型

	struct module		*owner;
	const char		*mod_name;	/* used for built-in modules */

	bool suppress_bind_attrs;	/* disables bind/unbind via sysfs */
	enum probe_type probe_type;

	const struct of_device_id	*of_match_table;
	const struct acpi_device_id	*acpi_match_table;

	int (*probe) (struct device *dev);
	void (*sync_state)(struct device *dev);
	int (*remove) (struct device *dev);
	void (*shutdown) (struct device *dev);
	int (*suspend) (struct device *dev, pm_message_t state);
	int (*resume) (struct device *dev);
	const struct attribute_group **groups;
	const struct attribute_group **dev_groups;

	const struct dev_pm_ops *pm;
	void (*coredump) (struct device *dev);

	struct driver_private *p;
};
```

## device
该结构体同样在上述头文件中，代表了一个连接到总线的设备。根据内核的注释，这里有一个问题就是在linux的设备模型中，kobject代表了一个很重要的含义。

```c

struct device {
	struct kobject kobj;
	struct device		*parent;

	struct device_private	*p;

	const char		*init_name; /* initial name of the device */
	const struct device_type *type;

	struct bus_type	*bus;		/* type of bus device is on */
	struct device_driver *driver;	/* which driver has allocated this
					   device */
	void		*platform_data;	/* Platform specific data, device



```
