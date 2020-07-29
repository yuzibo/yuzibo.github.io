---
title: aosp中art compiler简单记录
category: aosp
layout: post
---
* content
{:toc}

对，这又是一个简单的记录notes,因为我都不知道这背后是什么逻辑，或者说，是什么东西都不知道。

# optimizing
这个目录就是所谓的"优化"吧，具体是什么输入以及产生什么输出目前还有待确定。
整个文件在art/compiler/目录下，其中一个重要的结构体是 _HGraph_.

optimizing_unit_test.h:

```c
// Create a control-flow graph from dex instructions
HGraph* CreateCFG(const std::vector<uint16_t>& data,
					DataType::Type return_type = DataType::Type::kInt32) {
	HGraph× graph = CreateGraph(); // 创建CFG的环境
	// Align 4 bytes
}
```

