---
title: "ebpf基础知识"
category: bpf
layout: post
---

* content
{:toc}

# bpftool
目前，本人的理解的就是系统带来的库工具，目前都放在内核的`tools`目录下。
例如，这个`bpftools`工具就可以提供一个调试、探视内核中由`eBPF`产生的map.

## 编译
```bash
 cd ~/git/linux/tools/bpf/bpftool/
 sudo make
 sudo make install
```
具体的用法可以在后面具体展示。

# 如何正事自己系统的eBPF是否满足
```bash
$ cd tools/testing/selftests/bpf/
$ make
$ sudo ./test_verifier
```
如果有问题，说明需要检查kernel config文件是否完全适配

# libbpf
位于`tools/lib/bpf`.这个库很明显就是为了加载eBPF程序，当然，FB工程师也维护了一个[github](https://github.com/libbpf/libbpf)


# Main features
If you want to learn what type of  ebpf program is supported, you can use:

	git grep -W 'bpf_prog_type {' include/uapi/linux/bpf.h

in kernel tree source code.

# Maps

	git grep -W 'bpf_map_type {' include/uapi/linux/bpf.h

"-W" is matching the substring in the text.

# XDP
Listing the drivers the XDP supported:

	git grep -l XDP_SETUP_PROG drivers/


# helper

	 git grep 'FN(' include/uapi/linux/bpf.h


