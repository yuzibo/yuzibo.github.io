---
layout: article
category: shell
title: "ss连接的命令"
---
```bash
#!/bin/bash
#ss.sh
sslocal -s ip -p portnum -k password -t 600 -m aes-256-cfb
```