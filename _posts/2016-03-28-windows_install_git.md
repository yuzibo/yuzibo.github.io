---
layout: post
title: "windows上安装git"
category: tools
---

哈哈，把linux下的编程习惯带到windows上来

# 错误

### 错误1:

$ git clone xx
Cloning into foo-private...
Password:
error: error setting certificate verify locations:
  CAfile: /bin/curl-ca-bundle.crt
  CApath: none

### 解决方法

将curl-ca-bundle.crt 使用git --config  命令添加进去，注意，这个文件的位置不固定，你必须先确定在哪里，然后使用:

```bash 
git config --system http.sslcainfo "C:\Program Files (x86)\git\bin\curl-ca-bundle.crt"
```

这里的目录，注意把"/"修改为上面的"\",退出即可
