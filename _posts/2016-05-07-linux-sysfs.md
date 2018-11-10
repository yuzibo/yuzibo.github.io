---
title: "linux sysfs和kobject简介"
layout: post
category: kernel 
---

# 引言
sysfs是什么？---内核中，sysfs是一个动态生成的目录，断电后就玩完了。

sysfs - _the_ filesystem for exporting kernel objects.


sysfs 是kobject的？继承。只要你在配置系统的时候定义了CONFIG_SYSFS，那么挂载
的方法是

> mount -t sysfs sysfs /sys
# 一 用处

## 1.1 创造目录
只要一个kobject注册到了系统中，就在/sys目录中创造了一个目录。在kobject结构体
体中kernfs_node与这个目录有关。

## 1.2 属性

在sys_create_file(struct kobject * kobj, const struct attribute * attr),中，
那个attribute结构体需要自己写。

```c
struct attribute {
	char	* name;
	struct	*owner;
	umode_t	mode;
};
```
这里还可以丰富attribute的定义，详细情况请了解内核代码Document/filesystem/sysfs.txt.

## 1.3 子系统回调

...

# 二 kobject
kobject是组成设备模型的基本结构，类似于c++的基类。尽管不懂，但还是有种似曾相
识的感觉。
它嵌入更大的容器中--所谓的容器就是用来描述设备模型的组件，如bus,devices,都是
容器，这些容器通过kobject连接起来，形成一个树形结构，这个树状结构与/sys对应

kobject结构为大的数据结构和子系统提供了基本的对象管理，避免了类似机能的重复
使用。这些机能包括：

-对象引用计数
-维护对象链表
-对象上锁
-在用户空间的表示

## 2.1 嵌入式kobject
很少有代码会单独使用kobject,一般都是嵌入在其他结构中。把它看成一个抽象类用面
向对象的观点来看的话，这里也使用了继承的思想。内核中的link list也有这种思想
。

举个例子，drivers/uio/uio.c中：

```c
	struct uio_map{
		struct kobject	kobj;
		struct uio_map	*mem;
	
	};
```
这样，你可以轻松如意的使用uio_map的kobject.但是，问题经常会反过来：给你一个
kobject指针，怎么找到宿主结构体的指针呢？千万别假设kobject位于一个结构体的哪
个位置。使用container_of()宏即可。

> container_of(pointer, type, member);



