---
title: "ebpf基础知识"
category: bpf
layout: post
---

* content
{:toc}

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


