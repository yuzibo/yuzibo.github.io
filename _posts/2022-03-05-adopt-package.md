---
title: Adopting a package from Debian
category: debian-riscv
layout: post
---
* content
{:toc}

主要根据 https://unix.stackexchange.com/questions/650225/step-by-step-instructions-to-abandon-a-debian-package-and-no-longer-be-its-maint 
反向操作即可。


https://arnaudr.io/2016/10/01/publishing-a-debian-package-mentors-sponsorship/

这也是一个好的文章。

#  注意事项

1. 因为是ITA，需要更改version。 NMU此版本就行了。
2. Adopting a package is not enough...Update the lastest version from upstream and fix lintian warnings.
