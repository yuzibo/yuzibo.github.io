---
layout: article
category: kernel 
title: "linux中的vfs"
---
# 什么是vfs
vfs(virtual filesystem)是内核给予用户空间、用于对内核文件操作的接口。
举个例子： `sys_write()`或者`sys_open()`.


# 主要的4类VFS对象

> 1. super block

关于文件系统的高级元数据的容器，存在于磁盘上，管理文件系统的参数：块的数量、空闲块和根索引节点，这是在磁盘上；内存中，每一个list？？维护一个super_block
块。

> 2. inode

linux使用这个数据结构管理文件系统的所有对象。该数据结构使用slab进行内存分配。里面有很多的列表，其中一个指向引用该inode的dentry;只存在于内存中；



> 3. dentry

文件系统中有一个根dentry，这也是唯一一个没有父对象的dentry.所有其他dentry都有父对象，并且一部分还有子对象。在这个结构体内，有一个super_block,注释说是这是该目录的root。该结构体仅能存在文件系统内存中，而不能存放在磁盘上，存放在磁盘上的，最终是inode。


> 4. file

内核中打开的每个文件都是一个file对象。

## super_operation
内核中处理一个文件系统。重要的函数 syn(_fs());

## inode_operation
内核中处理一个文件。

## dentry_operation
内核中处理一个目录项。

## file_operation
内核中处理一个打开的文件。

# VPS架构
VFS的内部由一个调度层(提供文件系统抽象)和许多缓存(用于改善文件系统操作的性能
)。VFS中动态管理的两个对象是dentry和inode.缓存这两个对象，用来实现后面的功能
。

