---
layout: article
title: "12 linux 系统呼叫函数"
category: kernel
---
#syscall

###read: read bytes from a file descriptor(file,socket)

	#include <unistd.h>

	ssize_t read(int fd, void *buf, size_t count)

###write: write bytes into a file descriptor(file,socket)



open: open a file (return a file descriptor)

close: close a file descriptor.

fork: create a new process(current process is forked)

exec: execute a new program

connect: connect to a network host

accept: accept a network connection

stat: read file statistics

ioctl: set I/O properies, or other miscellaneous functions

mmap: map a file to the process memory address space

brk: extend the heap pointer.
