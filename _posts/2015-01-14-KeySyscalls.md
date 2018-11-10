---
layout: post
title: "12 linux 系统呼叫函数和 strace"
category: kernel
---
# 强大的调试工具 strace
strace是一个优秀的调试工具，它调用的是系统函数ptrace(),缺点是导致应用程序运行的非常慢。

# 使用

	strace -e open target-file
	strace -o out ls

{% highlight bash %}
# Slow the target command and print details for each syscall:
strace command

# Slow the target PID and print details for each syscall:
strace -p PID

# Slow the target PID and any newly created child process, printing syscall details:
strace -fp PID

# Slow the target PID and record syscalls, printing a summary:
strace -cp PID

# Slow the target PID and trace open() syscalls only:
strace -eopen -p PID

# Slow the target PID and trace open() and stat() syscalls only:
strace -eopen,stat -p PID

# Slow the target PID and trace connect() and accept() syscalls only:
strace -econnect,accept -p PID

# Slow the target command and see what other programs it launches (slow them too!):
strace -qfeexecve command

# Slow the target PID and print time-since-epoch with (distorted) microsecond resolution:
strace -ttt -p PID

# Slow the target PID and print syscall durations with (distorted) microsecond resolution:
strace -T -p PID
{% endhighlight %}

# syscall, must to read xx man

### read: read bytes from a file descriptor(file,socket)

	#include <unistd.h>

	ssize_t read(int fd, void *buf, size_t count)

### write: write bytes into a file descriptor(file,socket)



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
