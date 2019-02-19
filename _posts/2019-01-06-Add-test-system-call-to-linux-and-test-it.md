---
title: Adding a system call and test it on userspace
category: kernel
layout: post
---
* content
{:toc}

# Make sure you have linux-headers
If you have been compiled kernel from source code,and you will have linux-headers-x.x.x (Personality i compile kernel with `make deb-pkg` command).

Next we will use add ours custom defined system call into kernel.

The aricle based on kernel-v5.0.0-rc6

The first: please know what bits belongs to your system.

```bash
uname -m #uname -m => i686

```
So, my machine system  is 32 bits

# Add systemcall source code in kernel dir

Yes, you can git clone kernel or download kernel tar file.

You extact the source code and then cd root directory and new create a dir:

```bash
mkdir eudyptula && cd eudyptula
```

# Add system call to system call table
Open the file arch/x86/kernel/syscall_table_32.S and add the following line.
(64 bits should open arch/x86/kernel/syscall_table_64.S)
```bash
387	i386	eudyptula		sys_eudyptula			__ia32_sys_eudyptula

```
This is the last one entry in the file above.

Source: Documentation/process/adding-syscalls.rst

