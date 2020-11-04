---
title: 为文件中的每一行添加特定字符串
category: shell
layout: post
---
* content
{:toc}

这个需求应该很容易的使用python实现，但是如果什么东西都用python去完成， 未免大材小用了(其实是真菜)

```bash
# cat IR_lists.txt
HAbove
HAboveOrEqual
HLessThan
HLessThanOrEqual
```

现在的需求是， 在每一条IR的前面添加`HInstruction::`, 最后形成比如`HInstruction::HAbove`的形式。
由于这个IR_lists.txt文件是不断变化的， 所以直接写死不太灵活。

# awk

现在先用这个命令， 之前用的都忘记了。

```bash
awk '{print "HInstruction::"$0}' IR_lists.txt
HInstruction::HAbove
HInstruction::HAboveOrEqual
HInstruction::HLessThan
HInstruction::HLessThanOrEqual
```

# sed

sed的分隔符有很多种， 大家只要统一风格就行。 

```bash
sed 's#^#HInstruction::#' IR_lists.txt
# or
sed 's/^/HInstruction::/' IR_lists.txt
HInstruction::HAbove
HInstruction::HAboveOrEqual
HInstruction::HLessThan
HInstruction::HLessThanOrEqual
```
