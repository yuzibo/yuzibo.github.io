---
title: dir why has 4k -- fs基本概念
category: unix
layout: post
---
* content
{:toc}

# UNIX文件系统

## inode
Contains file attributes, metadata of file, pointer structure

## file
Can be considered a table with 2 columns, filename and its inode, inode points to the raw data blocks on the block device

## directory
just a special file, container for other filenames. It contains an array of filenames and inode numbers for each filename. Also it describes the relationship between parent and children

## symbolic link VS hard link

## dentry (directory entries)

On typical ext4 file system (what most people use), the default inode size is 256 bytes, block size is 4096 bytes.

A directory is just a special file which contains an array of filenames and inode numbers. When the directory was created, the file system allocated 1 inode to the directory with a "filename" (dir name in fact). The inode points to a single data block (minimum overhead), which is 4096 bytes. That's why you see 4096 / 4.0K when using ls.

一个目录仅是一个文件: 包含

You can get the details by using tune2fs & dumpe2fs

[stackoverflow](https://askubuntu.com/questions/186813/why-does-every-directory-have-a-size-4096-bytes-4-k)
