---
title: 在字符串里写shell
category: shell
layout: post
---
* content
{:toc}

近日，有一点需求是关于 先文本化shell脚本，然后在脚本中调用相关的语句把
这些命令写入另一个可执行的shell脚本中，以下是具体的两种方式。

# cat EOF

我个人是比较喜欢这种方式的:

```bash
cat >${PACKAGE_DIR}/DEBIAN/control<<EOF
Source: eswin ms bsp
Section: unknown
Priority: optional
Maintainer: Eswin
Build-Depends: debhelper (>= 10)
Standards-VERSION: 4.1.2
Homepage: http://eswin.com/
Package: eswin-ms-bsp-replace-logo
Pre-Depends: dpkg (>= 1.16.1)
Depends: locales (>= 2.3.6)
VERSION: ${VERSION}
Architecture: ${ARCH}
Description: ESWIN® BSP replace logo
EOF
```
这样，${PACKAGE_DIR}/DEBIAN/control 这个文本连创建都不用了，直接可以使用。

# echo -e ${VAR}

```bash
POSTINST_CONT="#!/bin/bash\n
#1. copy login logo\n
cp $INSTALL_DIR_1/$LOGIN_LOGO /usr/share/backgrounds/\n
sed "s/NVIDIA_Login_Logo.png/${LOGIN_LOGO}/g" /etc/skel/.xsessionrc
\n
#2. Copy wallpaper logo\n
cp ${INSTALL_DIR_1}/${WALLPAPER_LOGO} /usr/share/backgrounds\n
sed "s/NVIDIA_Wallpaper.jpg/${WALLPAPER_LOGO}/g" /etc/xdg/autostart/nvbackground.sh\n
"
```
把这个内容输出到文本中：

```bash
$(echo -e ${POSTINST_CONT} > ${PACKAGE_DIR}/DEBIAN/postinst)
```
注意，这里的shell文本必须使用双引号，单引号是不行的。






