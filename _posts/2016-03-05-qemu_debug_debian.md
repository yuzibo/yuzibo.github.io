---
title: "qemu调试kernel"
layout: article
category: tools
---

之前安装过Bochs,但是本身也没有怎么用，看到网上说使用qemu效果好一些，也就简
简单单的安装下来。

# kernel

1. 先下载源代码，我这里是用的git。

```bash
$git clone
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

$cd linux

$ make menuconfig

#在kernel hacking中选中compile the kernel with debug info,

$ make bzImage

```

编译后，bzImage这个是被压缩了的，供qemu虚拟机使用，vmlinux里面带了某些信息，
没有压缩，供gdb使用。

# 安装qemu

1. 先下载源代码，git

```bash
git clone git://git.qemu-project.org/qemu.git

```

2. 简单的测试下(不是重点，而且费时):

```c

# Switch to the QEMU root directory.
cd qemu

# Prepare a native debug build.
mkdir -p bin/debug/native
cd bin/debug/native

# Configure QEMU and start the build.
../../../configure --enable-debug
make

# Return to the QEMU root directory.
cd ../../..

```
使用以下命令:

>bin/debug/native/x86_64-softmmu/qemu-system-x86_64 -L pc-bios

2. 现在只安装自己平台的东西

同时应该将上面运行后的东西删除掉。

>make clean


```bash
switch to the QEMU root directory
cd qemu
# Configure QEMU for x86_64 only - faster build
./configure --target-list=x86_64-softmmu --enable-debug

# Build in parallel - my system has 4 CPUs
make -j4
```

3. 运行调试



### gdb
启动qemu的内嵌gdbserver，监听的是本地端口1234。

### S
暂停内核的启动，以便于自己的调试。

调试：

```bash
qemu-system-x86_64 -kernel xx-bzImage -gdb tcp::1234 -S
```
其中，xx-bzImage是刚才生成的bzImage.位于你内核源代码的/arch/x86/boot/，既/linux/arch/x86/boot/bzImage。
将这个命令改写成qemu.start就可以形成一个shell脚本。
将上面的命令写成shell。

```bash
 #!/bin/bash
 qemu-system-x86_64 -kernel ./bzImage -gdb tcp::1234  -S
```

chmod +x qemu.start


./qemu.start

就可以启动了。

# 运行
然后再开一个终端，

> gdb vmlinux

这个vmlinux 是编译内核镜像时产生的。这时进入了gdb的命令界面：

```c
(gdb) target remote:1234
Remote debugging using :1234
0x0000fff0 in ?? ()
(gdb) b start_kernel
Breakpoint 1 at 0xc15116cc: file init/main.c, line 498.
(gdb)
(gdb) c
Continuing.

Breakpoint 1, start_kernel () at init/main.c:498
498	{
}
```
这时的qemu那一端就已经有信息产生了,接下来自己就一步步调试去吧:)




