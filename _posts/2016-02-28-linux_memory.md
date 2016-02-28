---
layout: article
category: linux
title: "linux的内存浅析"
---

# page
先说说有关的数据结构，内核中的这个数据结构映射的是物理地址，里面
有个`count`的数据域，它标记着这个页的使用的量。返回值是-1,就说明
这个页没有被使用。然而，内核中经常使用一个`page_conut()`的函数来
检查这个页的使用情况，通常情况是等于0(空闲)，大于0(个数就是真实的
使用量)。

## zone
与`page`有关的一个概念就是`zone`了，可以说`page`被分成了`zone`，
`zone`没有物理上的意义，只是为了方便追踪对`page`的管理，页中的`zone`
有以下几个方面的应用：

>ZONE_DMA
>ZONE_DMA32
>ZONE_NORMAL
>ZONE_HIGHMEM

这些东西是定义在`<include/linux/mmzone.h>`中的。

根据你使用的不同情况，合理的使用的标记。还有，`zone`是不能垮边界的。

# 如何得到page
最常用的一个函数是

```c
void *alloc_pages(gfp_t fp_mask, unsigned int order)
```
这样会分配一个2的order次方大小数量的页。`gfp_t`是关于你分配页的使用的
标志，定义在<linux/gfp.h>里。使用上面的函数，我们得到的页是物理地址，
还不能被进程使用，我们必须转换成进程使用的虚拟地址，才能够真正应用这个
物理页。利用：

```c
void *page_address(struct page *page)
```
就可以将分配到的物理页转化为虚拟地址，也就是进程可以使用的地址。

```c
unsigned long get_zeroed_page(
		unsigned int gfp_mask)
```
在某些情况下等于
```c
__get_free_page()
```
??

# kmalloc
这个函数是分配以字节为单位的内核空间，与用户空间的`malloc`函数特别相似。
函数定义在<linux/slab.h>

```c
void *kmalloc(size_t size, gfp_t flag)
```
`c
void *kmalloc(size_t size, gfp_t flag)
`




