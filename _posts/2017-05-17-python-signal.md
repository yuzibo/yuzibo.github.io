---
title: "python signal处理"
category: python
layout: post
---

# Ctrl + c
Here is a task for tutorial_bcc_python_developer,how to deal with ``ctrl +c ``.From stackoverflow,the answer will be performaced:

```python

from bcc import BPF
import signal
import sys

def bpf():
    BPF(text='''
    int kprobe__sys_sync(void *ctx)
    { bpf_trace_printk("Hello, yubo\\n");
    return 0;}'''
    ).trace_print()

def signal_handler(signal, frame):
    print('You pressed Ctrl+c!')
    bpf()
    sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)
print('press Ctrl+c')
signal.pause()
```

Here, maybe some issue exist.But i thought, the model will be the same as c

