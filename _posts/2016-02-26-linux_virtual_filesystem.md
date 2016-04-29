---
layout: article
category: kernel 
title: "linux中的vfs"
---
# 什么是vfs
vfs(virtual filesystem)是内核给予用户空间、用于对内核文件操作的接口。
举个例子： `sys_write()`

# 主要的4类VFS对象

> 1. super block

> 2. inode

> 3. dentry

> 4. file

## super_operation
内核中处理一个文件系统。重要的函数 syn(_fs());

## inode_operation
内核中处理一个文件。

## dentry_operation
内核中处理一个目录项。

## file_operation
内核中处理一个打开的文件。

