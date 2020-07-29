---
title: Android app_process启动流程
category: aosp
layout: post
---
* content
{:toc}

之前留下了一个大坑，现在慢慢填上。

# AppRuntime::start()
app_process是安卓系统启动Java虚拟机的程序。首先来回忆下Zygote进程，按照邓凡平老师的书上说的，
java世界由Zygote进程创建，通过fork一个一个产生。那么， Zygote又是怎么来的呢？

我们知道，linux系统第一个进程就是init，安卓也不例外。在kernel层，init起来之后，安卓会通过一个脚本
激活Zygote进程。

init的具体实现位于 system/core/init 下， 如果详细介绍init的情况，这篇文章会偏离主旨的，会另外开一篇介绍
这个事情。以system/core/rootdir/init.zygote32.rc为例:
```bash
service zygote /system/bin/app_process -Xzygote /system/bin --zygote --start-system-server
    class main
    priority -20
    user root
    group root readproc reserved_disk
    socket zygote stream 660 root system
    socket usap_pool_primary stream 660 root system
    onrestart write /sys/android_power/request_state wake
    onrestart write /sys/power/state on
    onrestart restart audioserver
    onrestart restart cameraserver
    onrestart restart media
    onrestart restart netd
    onrestart restart wificond
    writepid /dev/cpuset/foreground/tasks
```
app_process会接受三类启动参数，分别代表不同的系统服务。在 frameworks/base/cmds/app_process/app_main.cpp文件中
```c
  if (zygote) {
        runtime.start("com.android.internal.os.ZygoteInit", args, zygote);
    } else if (className) {
        runtime.start("com.android.internal.os.RuntimeInit", args, zygote);
    } else {
        fprintf(stderr, "Error: no class name or --zygote supplied.\n");
        app_usage();
        LOG_ALWAYS_FATAL("app_process: no class name or --zygote supplied.");
    }
```
最终会以具体的形式调用runtime.
runtime实际上是AppRuntime的实例，而Appruntime是AndroidRuntime的派生类。AppRuntime也是定义在app_main.cpp中，
只是重写了setClassNameAndArgs、onVmCreated()、onStarted()、onZygoteInit()、onExit()这几个方法。

我们本文的重点函数AndroidRuntime是一个重点钉子户，涉及的东西比较多，源文件在 frameworks/base/core/jni/AndroidRuntime.cpp
。这个文件处理了很多jni注册的事情。

# AndroidRuntime::start()
```c++
/** Start the Android runtime,This invokes VM and calling the "static void main(String[], args)" method in the class named
  * by "className"
  */
void AndroidRuntime::start(const char* className, const Vector<String8>& options, bool zygote){
	...
	// 加载一些环境变量
	const char* rootDir = getenv("ANDROID_ROOT"); // getenv.c 在bionic/libc/upstream-openbsd/lib/libc/stdlib/getenv.c中定义
												// 这个文件理解起来还不是那么友好的
	const char* runtimeRootdir = getenv("ANDROID_RUNTIME_ROOT");
	const char* tzdataRootDir = getenv("ANDROID_TZDATA_ROOT");
	...
	JniInvocation jni_invocation; // 这两个是重中之重
	jni_invocation.Init(NULL);
}
```

## JniInvocation


