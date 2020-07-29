---
title: aosp中非标准文件的用法
category: aosp
layout: post
---
* content
{:toc}

所谓的非标准头文件就是指那些在aosp外不曾见过的文件或者一些库的用法。
# string8
这个在aosp中尤其常见，例如:
```c++
 String8 argv_String;
      for (int i = 0; i < argc; ++i) {
        argv_String.append("\"");
        argv_String.append(argv[i]);
        argv_String.append("\" ");
      }
      ALOGV("app_process main with argv: %s", argv_String.string());
```
String8 的定义在 system/core/libutils/include/utils/String8.h 中，为什么不用std呢？从我看代码的了解中
看到String8照顾了UTF-8的特性， 而且其UTF-8的值不能超过0x10FFFFF,

### 处理路径
```c
    /*
     * Set the filename field to a specific value.
     *
     * Normalizes the filename, removing a trailing '/' if present.
     */
    void setPathName(const char* name);
    void setPathName(const char* name, size_t numChars);
 /*
     * Remove the last (file name) component, leaving just the directory
     * name.
     *
     * "/tmp/foo/bar.c" --> "/tmp/foo"
     * "/tmp" --> "" // ????? shouldn't this be "/" ???? XXX
     * "bar.c" --> ""
     */
    String8 getPathDir(void) const;

    /*
     * Return the filename extension.  This is the last '.' and any number
     * of characters that follow it.  The '.' is included in case we
     * decide to expand our definition of what constitutes an extension.
     *
     * "/tmp/foo/bar.c" --> ".c"
     * "/tmp" --> ""
     * "/tmp/foo.bar/baz" --> ""
     * "foo.jpeg" --> ".jpeg"
     * "foo." --> ""
     */
    String8 getPathExtension(void) const;

    /*
     * Return the path without the extension.  Rules for what constitutes
     * an extension are described in the comment for getPathExtension().
     *
     * "/tmp/foo/bar.c" --> "/tmp/foo/bar"
     */
    String8 getBasePath(void) const
...
```
简单摘抄了一点了，可以看出，aosp自己实现了一些有助于操作的函数，尤其对于一个涉及路径文件的字符串操作。

