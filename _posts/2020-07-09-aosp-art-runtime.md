---
title: aosp art runtime的记录
category: aosp
layout: post
---
* content
{:toc}

# runtime
这个 runtime 的核心功能文件存放在 art/runtime/ 下，我们可以看一下common\_runtime\_test.cc这个文件

CommonRuntimeTestImpl这是一个基类，其中的析构函数确保删除dex文件。
std::string CommonRuntimeTestImpl::GetAndroidTargetToolsDir(InstructionSet isa)
return GetAndroidToolsDIr(), 需要三个参数：体系目录、参数2、参数3.

SetUp() 建立最小的runtime 环境：
1. std::string min_heap_string : "-Xms%zdm"
2. std::string max_heap_string : "-Xmx%zdm"
3. std::string boot_class_path_string : "-Xbootclasspath"
4. std::string boot_class_path_locations_string :

PreRuntimeCreate()

runtime\_.reset(Runtime::Current());
class_linker\_ = runtime\_->GetClassLinker();

从SetUp()可以看出来，runtime这块需要处理的是Dex文件。
往下走: FinalizeSetUp()
runtime\_->GetHeap()->CreateThreadPool(); // 创建heap thread pool so that GC runs in parallel.正常情况下thread pool是由runtime创建的

runtime\_->GetHead()->VerifyHeap(); // 在使用之前先要检查Heap的正确性

TearDown():
这个函数在 art  test 的代码中非常常见，这么说吧，这就是一个Gtest的一个前期环境搭建，
只要一运行这个函数也就说明gtest也在运行了
```c++
void CommonRuntimeTestImpl::TearDown() {
  CommonArtTestImpl::TearDown();
  if (runtime_ != nullptr) {
    runtime_->GetHeap()->VerifyHeap();  // Check for heap corruption after the test
  }
}
```


