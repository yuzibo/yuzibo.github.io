---
title: Debian/RevyOS 实习生 pre-task 
category: debian 
layout: post
---
* content
{:toc}

---

作为应聘 Debian/RevyOS 实习生的一个硬性条件，需要完成以下目标:

# goal 1

下载 Debian `hello` 源代码, 修改其中的 `src/hello.c` 文件，然后重新打包并安装、运行

```bash
vimer@dev:~$ hello -h
Usage: hello [OPTION]...
Print a friendly, customizable greeting.

  -h, --help          display this help and exit
  -v, --version       display version information and exit

  -t, --traditional       use traditional greeting
  -g, --greeting=TEXT     use TEXT as the greeting message
   hello, revyos
```

其中

1. `hello, revyos` 不是必须的，可出现自定义的 string 的即可。
2. amd64 或者 riscv64 包都可以。主要考察相关 chroot sbuild/quiet 的使用。


参考资料：

http://www.aftermath.cn/2022/02/17/sbuild-build-riscv-on-debian/
https://github.com/yuzibo/talks/blob/main/debian/2022-08-17-debian-fix-ftbfs-riscv64.pptx

说明，基于时效性，以上参考资料中的 URL 中带有 `*debian-ports/`可自动调整为 `debian/`.
