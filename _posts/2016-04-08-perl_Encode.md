---
title: "perl关于编码的问题"
layout: article
category: perl
---

# Encode
在程序里必须注意数据在获取和转移的过程中数据编码的问题。perl的模块Encode
的处理模块可以很好的处理这个问题。

### 两个方法

结果 = encode(编码方式a，要编码的字串)；

结果 = decode(编码方式b，要编码的字串)

encode是按编码方式a，decode是以编码方式b解码。
