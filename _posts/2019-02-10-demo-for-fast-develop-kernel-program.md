---
title: Demo for fast kernel test
category: kernel
layout: post
---
* content
{:toc}

# 回顾

之前一直在寻找快速开发linux kernel的方法，有兴趣的同学们可以参考kernel系列文章。众所周知，kernel的开发不同于用户空间的程序，一个是本身系统的复杂性，众多子系统需要一名合格的内核开发者去掌握；二是编译内核程序的复杂性，除了编写module程序。但是我相信大多数同学经历过自己编译内核的经历，以满足自身的需要。以前我在想，怎么才能让编译内核快一些，无论是时间还是空间，其中，基于libvirt的qemu是最符合我这个要求的，请参看[本文](http://www.aftermath.cn/2017/06/06/how_to_get_started_with_libvirt_on_debian/)。这个方法的思路是安装一个无图形界面的debian系统，然后使用`make deb-pkg`,生成\*.deb包，这样就可以测试你自己的kernel程序，这种方法可以，但是重新编译了整个内核，这还不是最痛苦的，最痛苦的地方在于它会生成5个包，其中包含一个gdb调戏信息的内核镜像，眼见的消耗时间是单个vmlinux\*4的数量可以，但是笨重。

还有这篇[here](http://www.aftermath.cn/2016/03/05/qemu_debug_debian/)

其中，这个链接下面还会再次提到，因为这个涉及到了qemu,本篇会继续使用这个工具。

# 更新
直到今日，本人终于找到了一个理论上最完美的一个方案，之所以这么说，是因为：一，它就是我梦中最理想的方案，几乎与我想象的一模一样，当然，我也只能想象了，行动并没有实施；二，基本再没有提高的空间，对，就是这样，没有了。

我把我的构思给大家提前分享下：

你只需重新编译很少的选项，嗯，如果只是测试某些程序，交互就用ssh就可以了，并不需要一些硬件资源，比如，键盘、屏幕、鼠标、无线...也就是最小量的编译选项，仅仅这一点，就大大节省了时间和空间。

用户空间的程序可以重用，也就是安装内核后可以接着使用原来的工具，按道理说这个要求绝大多数的编译内核都会满足。但是，我希望不借助重新启动进入新的内核去使用这些，这又节省了时间。

好了，仅凭上面的两点，我相信此方案绝对就可以独领风骚了。

# eudyptula-boot
这个是什么请自己google,这篇文章的第一个链接就是这个项目的介绍。

## KBUILD_OUTPUT
这里涉及到了kbuild的一些细节，其实也可以不使用这个，但是，使用没有坏处。

前期编译好qemu,一定对应自己的平台，可以自己私自修改。

1. 下载源代码： kernel source code
2. 在内核主目录下，使用

```bash
export KBUILD_OUTPUT=$HOME/src/kernel-build
```
这个（可能需要提前创建需要的目录),这个目录下就把源代码进行了一份拷贝并生成了可执行文件，最后组成了一个镜像文件，简而言之就是和主目录的内容一样，只不过在另外一个目录下也有同样的内容。

3. config
[下载这个脚本](https://github.com/yuzibo/configure_file/tree/master/kernel-fast-dev)，在主目录下运行`minimal-configuration`就可以生成最小量的`.config`.
4. make -j4
5. 安装内核和相关的模块
```bash
sudo make modules_install install {INSTALL_MOD_PATH,INSTALL_PATH}=$HOME/src/kernel-dev
```

也就是说，此时你在`$HONE/src`下：

```bash
yubo@debian:~$ ls src/
kernel-build  kernel-dev
```
其中，kernel-dev下是

```bash
yubo@debian:~$ ls src/kernel-dev/
config-5.0.0-rc7+  lib  System.map-5.0.0-rc7+  vmlinuz-5.0.0-rc7+
```
其实，这也是一份来自`/boot`的拷贝。至此，前期的准备工作已经完成的差不多了，其中，我可能完全不会KBUILD的使用方案，请朋友们指正。

6. 启动内核
[脚本](https://github.com/yuzibo/configure_file/tree/master/kernel-fast-dev)使用`eudyptula-boot`脚本去启动自己编译好的内核：

```bash
yubo@debian:~/git/configure_file/kernel-fast-dev$ ./eudyptula-boot --kernel ~/src/kernel-dev/vmlinuz-5.0.0-rc7+
[✔] All dependencies are met.
[✔] Found kernel 5.0.0-rc7+.
[✔] Kernel configuration checked. overlayfs present.
[✔] Modules are in /home/yubo/src/kernel-dev/lib/modules/5.0.0-rc7+.
[∗] TMP is /tmp/tmp.0NkeE3lzn9.
[✔] initrd built in /tmp/tmp.0NkeE3lzn9/initrd.gz.
[∗] Start VM eudyptula-5-0-0-rc7+.
[∗] GDB server listening on /tmp/tmp.0NkeE3lzn9/vm-eudyptula-5-0-0-rc7+-gdb.pipe.
[∗] monitor listening on    /tmp/tmp.0NkeE3lzn9/vm-eudyptula-5-0-0-rc7+-console.pipe.
[∗] ttyS1 listening on      /tmp/tmp.0NkeE3lzn9/vm-eudyptula-5-0-0-rc7+-serial.pipe.
[    0.810771] mce: Unable to init MCE device (rc: -5)
[∗] initrd started.
[∗] Loading modules.
[✔] Configuration loaded.
[✔] Root file system setup.
[✔] /tmp, /run and others are clean.
[∗] Change root.
[✔] /proc and /sys setup.
[✔] /root mounted.
[✔] /lib/modules mounted.
[…] Starting udev... starting version 232
[✔] udev started.
[✔] Network configured.
[∗] Setup terminal.

[✔] Terminal size is 80×23.
[∗] QEMU PID is 28311.
[∗] Spawning a shell.
```
其中，请注意
```bash
[∗] GDB server listening on /tmp/tmp.0NkeE3lzn9/vm-eudyptula-5-0-0-rc7+-gdb.pipe.
```
这个语句可以用来调试内核的。
看到没有，已经启动了一个VM，可以看一下内核版本：

```bash
root@eudyptula-5-0-0-rc7+:~/git/configure_file/kernel-fast-dev# uname -r
5.0.0-rc7+
```

大家发现了没有，我们在主操作系统中开了一个镜像进程，而且这个内核居然可以使用原来用户空间的程序。

# 调试内核

经过上面的准备，我们要对修改的代码进行验证才可以。
[教材](https://vincent.bernat.ch/en/blog/2014-eudyptula-boot)
这个文章就是根据这篇改编过来。

这个部分是我后来补写的，那么，`gdb server`的信息为

```bash
[∗] GDB server listening on /tmp/tmp.Aec21mkPjO/vm-eudyptula-5-0-0-next-20190306-00003-g801cbc0c69c2-dirty-gdb.pipe.
```
1. 打开一个新的终端,gdb你刚才产生的vmlinux：这个`vmlinux`可以是你内核代码源目录下的那个，也可以是`~/src/kernel-dev/lib/build/vmlinux`文件。

```bash
gdb vmlinux
GNU gdb (Debian 7.12-6) 7.12.0.20161007-git
Copyright (C) 2016 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
<http://www.gnu.org/software/gdb/documentation/>.
For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from vmlinux...done.
warning: File "/home/yubo/git/linux/scripts/gdb/vmlinux-gdb.py" auto-loading has been declined by your `auto-load safe-path' set to "$debugdir:$datadir/auto-load".
To enable execution of this file add
add-auto-load-safe-path /home/yubo/git/linux/scripts/gdb/vmlinux-gdb.py
line to your configuration file "/home/yubo/.gdbinit".
To completely disable this security protection add
set auto-load safe-path /
line to your configuration file "/home/yubo/.gdbinit".
For more information about this security protection see the
---Type <return> to continue, or q <return> to quit---
"Auto-loading safe path" section in the GDB manual.  E.g., run from the shell:
info "(gdb)Auto-loading safe path"
(gdb)

```
## 第二步，监听gdb server的地址：
```bash
(gdb) target remote | socat UNIX:/tmp/tmp.6pDwCfUhbz/vm-eudyptula-5-0-0-next-20190306-00003-g801cbc0c69c2-dirty-gdb.pipe -
Remote debugging using | socat UNIX:/tmp/tmp.6pDwCfUhbz/vm-eudyptula-5-0-0-next-20190306-00003-g801cbc0c69c2-dirty-gdb.pipe -
__read_once_size (size=<optimized out>, res=<optimized out>, p=<optimized out>)
at ./include/linux/compiler.h:197
 197		__READ_ONCE_SIZE;
(gdb)

```
注意，我的监听地址变化了好几次，请注意。注意上面的地址。
有什么问题大家可以问我，谢谢大家
