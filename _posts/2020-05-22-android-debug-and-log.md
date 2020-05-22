---
title: Android 调试手段总结
category: aosp
layout: post
---
* content
{:toc}

# log
安卓有很多的log系统，以aosp为例，最基本的log定义恐怕是 `system\core\base\include\android-base\Logging.h`:
```c
//
// Google-style C++ logging.
//

// This header provides a C++ stream interface to logging.
//
// To log:
//
//   LOG(INFO) << "Some text; " << some_value;
//
// Replace `INFO` with any severity from `enum LogSeverity`.
//
// To log the result of a failed function and include the string
// representation of `errno` at the end:
//
```
那么对应的 log等级有:

```c
num LogSeverity {
  VERBOSE,
  DEBUG,
  INFO,
  WARNING,
  ERROR,
  FATAL_WITHOUT_ABORT,
  FATAL,
};
```
如果可以研究下将INFO改为FATAl（可以带有call stack）.

## 各个模块自己的log
借助这个log系统，aosp 中其他各个子模块可以实现自己的log系统，以art为例：`art\libartbase\base\logging.h`
```c
#include "android-base/logging.h"
#include "macros.h
```
请注意这个include文件，我自己并没有在该上层目录的Android.bp文件中找到相关头文件的引用，这块是怎么解决的这个问题，还需要研究。


# gdbserver
