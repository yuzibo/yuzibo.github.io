---
title: ebpf学习路线
category: bpf
layout: post
---
* content
{:toc}

# 先看第一个提交commit
这也是我最近才发现的一个技巧，就是如果一个问题特别复杂，我们就应该从最简单的东西入手，那么，对于，
对于ebpf有什么简单的呢？

答案就是在第一个commit.[commit](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=99c55f7d47c0dc6fc64729f37bf435abf43f4c60)

跟着这个commit,你就能抛开一些繁琐的东西，这是最本质的东西，我在想能不能将这些程序自己重新跑一遍看看。

# 关注两个项目
[项目1](https://github.com/libbpf/libbpf)  [项目2](https://suricata.readthedocs.io/en/latest/capture-hardware/ebpf-xdp.html)

通过这两个项目你就可以建立libbpf，就可以测试一些自己改动了，根据自己的需要。

# 很好的总结
[serial post](https://ferrisellis.com/posts/ebpf_syscall_and_maps/)

# 最全的积累
[github](https://github.com/zoidbergwill/awesome-ebpf)

# 相关资料
https://blog.cloudflare.com/tag/ebpf/

https://blogs.oracle.com/linux/notes-on-bpf-1




