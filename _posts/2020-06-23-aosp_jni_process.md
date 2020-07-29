---
title: aosp中之jni调用过程
category: aosp
layout: post
---
* content
{:toc}

aosp 中使用了大量的jni，现在我们进行一个简单的总结，对aosp中的jni有一个大概的了解。

frameworks中存在大量的上层服务，也就是aosp中上层的服务。我也不理解为什么这块如此过量的使用java，今天这个例子的目录在:
frameworks/base/media/java/android/media/MediaScanner.java. 稍微统计了一下，就这个`media`目录中，存在了168个
文件，可见aosp中存在大量的java代码。

从java代码入手。

# MediaScanner

```java
public class MediaScanner implements AutoCloseable {
    static {
        System.loadLibrary("media_jni");
        native_init();
    }

    private final static String TAG = "MediaScanner";
    ...
     private native void processDirectory(String path, MediaScannerClient client);
    private native boolean processFile(String path, String mimeType, MediaScannerClient client);
    private static native final void native_init();
    private native final void native_setup();
    private native final void native_finalize();
    ...
```
file: frameworks/base/media/java/android/media/MediaScanner.java.
按照邓凡平老师的书上说，`media_jni`会自动加载为libmedia_jni.so(显而易见，这是由C++代码写的，也就是native代码).
native关键字表示调用native代码。

这上面的代码有两点值得注意，一个是动态加载JNI动态库，一个就是调用native函数。由下面的`loadLibrary`我们可知，aosp中
可能是在运行时加载JNI库，后面native下面再总结。

loadLibrary:
```java
...
 @CallerSensitive
    public static void loadLibrary(String libname) {
        Runtime.getRuntime().loadLibrary0(Reflection.getCallerClass(), libname);
    }
...
```
[file: ??]奇怪，没找到这个文件定义在哪块。

`native_init()`是后面要解决的问题。

# JNI层函数
所谓的JNI层函数就是说，不使用JNI动态库，java调用c++代码（或者反过来说也是一样的），由java的关键词`native`修饰的函数
就是调用JNI层的函数。

对应上面java代码的JNI层的文件在：frameworks/base/media/jni/android_media_MediaScanner.cpp，我们把两个文件的位置对比下:
```bash
frameworks/base/media/jni/android_media_MediaScanner.cpp
frameworks/base/media/java/android/media/MediaScanner.java
```
看到没有，这样就很容易识别，总结一句话就是，frameworks/base下的服务，绝大多说存在java和jni目录，也就是说，java相应的JNI文件
就离自己不远，这就是为什么frameworks中大量使用java做业务开发的原因吧，需要效率或者系统操作的动作时，则使用c/c++去完成。
现在来看一下android_media_MediaScanner.cpp文件中的主要内容.

```c
...
// This function gets a field ID, which in turn causes class initialization.
// It is called from a static block in MediaScanner, which won't run until the
// first time an instance of this class is used.
static void
android_media_MediaScanner_native_init(JNIEnv *env)
{
    ALOGV("native_init");
    jclass clazz = env->FindClass(kClassMediaScanner);
    if (clazz == NULL) {
        return;
    }

    fields.context = env->GetFieldID(clazz, "mNativeContext", "J");
    if (fields.context == NULL) {
        return;
    }
}
...
static jboolean
android_media_MediaScanner_processFile(
        JNIEnv *env, jobject thiz, jstring path,
        jstring mimeType, jobject client)
{

    // Lock already hold by processDirectory
    MediaScanner *mp = getNativeScanner_l(env, thiz);
    if (mp == NULL) {
        jniThrowException(env, kRunTimeException, "No scanner available");
        return false;
    }

    const char *mimeTypeStr =
        (mimeType ? env->GetStringUTFChars(mimeType, NULL) : NULL);
    if (mimeType && mimeTypeStr == NULL) {  // Out of memory
        // ReleaseStringUTFChars can be called with an exception pending.
        env->ReleaseStringUTFChars(path, pathStr);
        return false;
    }

    MyMediaScannerClient myClient(env, client);
    MediaScanResult result = mp->processFile(pathStr, mimeTypeStr, myClient);
    if (result == MEDIA_SCAN_RESULT_ERROR) {
        ALOGE("An error occurred while scanning file '%s'.", pathStr);
    }
    env->ReleaseStringUTFChars(path, pathStr);
    if (mimeType) {
        env->ReleaseStringUTFChars(mimeType, mimeTypeStr);
    }
    return result != MEDIA_SCAN_RESULT_ERROR;
}
```
如果，这里弄不明白二者之间的联系，很好，说明这个问题很关键，提醒一下，我们要注意下cpp文件中的头文件，那里有我们
想要的答案。

# 二者之间的联系
来看一下JNI层函数的命名:
`android_media_MediaScanner_native_init`这里面有什么玄机吗？是的，目前看出来的就是，这个命名规格与java的相应方法的
全路径是一模一样的。我们注意,在`frameworks/base/media/java/android/media/MediaScanner.java`文件中，开头就是

```java
package android.media; # MediaScanner.java的打包
...
public class MediaScanner implements AutoCloseable {
    static {
        System.loadLibrary("media_jni");
        native_init();
    }
    ...
    private native boolean processFile(String path, String mimeType, MediaScannerClient client);
    private static native final void native_init();
   ...
```
MediaScanner作为一个大类，其方法由native_init,如果我们把这个方法的全路径补全，不就是:
`android.media.MediaScanner.native_init`吗，除了最后一个下划线，其他的把下划线换成点就可以将二者联系起来，这
里面一定有相关的方法是解决这个问题的。

我们上面说的就是java世界中的JNI注册的问题。

# JNI注册

## 静态注册
这个简单说下就是利用java的编译工具生成一个带有签名的头文件。后面会写一篇文章做一些记录的。

## 动态静态


```c
//#define LOG_NDEBUG 0
#define LOG_TAG "MediaScannerJNI"
#include <utils/Log.h>
#include <utils/threads.h>
#include <media/mediascanner.h>
#include <media/stagefright/StagefrightMediaScanner.h>
#include <private/media/VideoFrame.h>

#include "jni.h"
#include <nativehelper/JNIHelp.h>
#include "android_runtime/AndroidRuntime.h"
#include "android_runtime/Log.h"
#include <android-base/macros.h>
```



