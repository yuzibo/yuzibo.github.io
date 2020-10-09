---
title: aosp中art的一些简单记录
category: aosp
layout: post
---
* content
{:toc}

嗨 这篇文章没有太多干货，主要是简单记录下art中的一些术语， 当然是在看邓书的时候记下来的。

# IR

## 优化方式-HDeoptimize-解释执行

aosp 7中据说拥有13种IR优化的方法， HDeoptimize(反优化)或者说以interpreter方式来执行。

## LocationSummary

这个大类声明在art/compiler/optimizing/locations.h文件中，它包含了方方面面的任务。
比如IR对象的输入输出操作数来自寄存器还是内存栈、以何种方式进行解析、目标平台等等如此多的作用
都可以被LocationSummary进行封装。当然它需要被 code_generation.cc[并不一定是这个文件类似的]文件消费。

下面我们摘取几处代码进行剖析:

```c
// locations.h ::
class LocationSummary : public ArenaObject<kArenaAllocLocationSummary> {
 public:
  enum CallKind { // CallKind 描述了一个Hinstruction是否涉及函数调用
    kNoCall, // 该Hinstructon不涉及函数调用，即不与HInvoke相关
    kCallOnMainAndSlowPath,
    kCallOnSlowPath, // 有些java代码需要不优化的方式运行，除0抛异常等
    kCallOnMainOnly // 函数调用
  };

  explicit LocationSummary(HInstruction* instruction,
                           CallKind call_kind = kNoCall,
                           bool intrinsified = false);

  void SetInAt(uint32_t at, Location location) { // 指定IR的入口， Location对象后面会进行介绍
    inputs_[at] = location;
  }

  Location InAt(uint32_t at) const {
    return inputs_[at];
  }

  size_t GetInputCount() const {
    return inputs_.size();
  }
  void SetOut(Location location, Location::OutputOverlap overlaps = Location::kOutputOverlap)
  // ... 比较特殊，需要判断输出是否对输入寄存器进行了覆盖
  void UpdateOut();
  void AddTemp();
  void AddRegisterTemps();
  // ...
```

我们在上面的代码中看到了这里大量使用了Location这个对象， 我们简单来看一下这个数据结构。同样， 该结构也是定义在相同的头文件中。

```c
/**
 * A Location is an abstraction over the potential location
 * of an instruction. It could be in register or stack.
 */
class Location : public ValueObject {
 public:
  enum OutputOverlap {
    // The liveness of the output overlaps the liveness of one or
    // several input(s); the register allocator cannot reuse an
    // input's location for the output's location.
    kOutputOverlap,
    // The liveness of the output does not overlap the liveness of any
    // input; the register allocator is allowed to reuse an input's
    // location for the output's location.
    kNoOutputOverlap
  };

  enum Kind {
    kInvalid = 0,
    kConstant = 1,
    kStackSlot = 2,  // 32bit stack slot.
    kDoubleStackSlot = 3,  // 64bit stack slot.

    kRegister = 4,  // Core register.

    // We do not use the value 5 because it conflicts with kLocationConstantMask.
    kDoNotUse5 = 5,

    kFpuRegister = 6,  // Float register.

    kRegisterPair = 7,  // Long register.

    kFpuRegisterPair = 8,  // Double register.

    // We do not use the value 9 because it conflicts with kLocationConstantMask.
    kDoNotUse9 = 9,

    kSIMDStackSlot = 10,  // 128bit stack slot. TODO: generalize with encoded #bytes?

    // Unallocated location represents a location that is not fixed and can be
    // allocated by a register allocator.  Each unallocated location has
    // a policy that specifies what kind of location is suitable. Payload
    // contains register allocation policy.
    kUnallocated = 11,
  };
// 后面还有很多成员方法
```

从注释中我们也可以看出来， Locations的作用对象既可以是寄存器，也可以是stack.

# code_generations.cc

这不是一个文件，各个不同的arch有不同的code_generations的生成文件。我们先练看一下这个文件中的几个有意思的数据结构。

## LocationsBuilderMIPS64
我们以MIPS64为例（art/compiler/optimizing/code_generator_mips64.h），可以由LocationsBuildMIPS64派生出很多与arch相关的IR，这些IR是从dex到assembler的中间件。结合前面的知识， 我们看一下这个东西的大概:

```c
class LocationsBuilderMIPS64 : public HGraphVisitor {
 public:
  LocationsBuilderMIPS64(HGraph* graph, CodeGeneratorMIPS64* codegen)
      : HGraphVisitor(graph), codegen_(codegen) {}

#define DECLARE_VISIT_INSTRUCTION(name, super)     \
  void Visit##name(H##name* instr) override;

  FOR_EACH_CONCRETE_INSTRUCTION_COMMON(DECLARE_VISIT_INSTRUCTION)
  FOR_EACH_CONCRETE_INSTRUCTION_MIPS64(DECLARE_VISIT_INSTRUCTION)

#undef DECLARE_VISIT_INSTRUCTION

  void VisitInstruction(HInstruction* instruction) override {
    LOG(FATAL) << "Unreachable instruction " << instruction->DebugName()
               << " (id " << instruction->GetId() << ")";
  }

 private:
  void HandleInvoke(HInvoke* invoke);
  void HandleBinaryOp(HBinaryOperation* operation);
  void HandleCondition(HCondition* instruction);
  void HandleShift(HBinaryOperation* operation);
  void HandleFieldSet(HInstruction* instruction, const FieldInfo& field_info);
  void HandleFieldGet(HInstruction* instruction, const FieldInfo& field_info);
  Location RegisterOrZeroConstant(HInstruction* instruction);
  Location FpuRegisterOrConstantForStore(HInstruction* instruction);

  InvokeDexCallingConventionVisitorMIPS64 parameter_visitor_;

  CodeGeneratorMIPS64* const codegen_;

  DISALLOW_COPY_AND_ASSIGN(LocationsBuilderMIPS64);
};
```
很明显的是，LocationsBuilderxx是遍历CFG的IR并为他们生成合适的LocationsSummary 的对象。

我们以MIPS64的visitadd函数为例，具体看一下上面两个数据结构的用法。

```c
void LocationsBuilderMIPS64::VisitAdd(HAdd* instruction) {
  HandleBinaryOp(instruction);
}

void InstructionCodeGeneratorMIPS64::VisitAdd(HAdd* instruction) {
  HandleBinaryOp(instruction);
}
//
void LocationsBuilderMIPS64::HandleBinaryOp(HBinaryOperation* instruction) {
  DCHECK_EQ(instruction->InputCount(), 2U);
  LocationSummary* locations = new (GetGraph()->GetAllocator()) LocationSummary(instruction);
  DataType::Type type = instruction->GetResultType();
  switch (type) {
    case DataType::Type::kInt32:
    case DataType::Type::kInt64: {
      locations->SetInAt(0, Location::RequiresRegister()); // 期望第二个操作数为寄存器
      HInstruction* right = instruction->InputAt(1);
      bool can_use_imm = false;
      if (right->IsConstant()) {
        int64_t imm = CodeGenerator::GetInt64ValueOf(right->AsConstant());
        if (instruction->IsAnd() || instruction->IsOr() || instruction->IsXor()) {
          can_use_imm = IsUint<16>(imm);
        } else {
          DCHECK(instruction->IsAdd() || instruction->IsSub());
          bool single_use = right->GetUses().HasExactlyOneElement();
          if (instruction->IsSub()) {
            if (!(type == DataType::Type::kInt32 && imm == INT32_MIN)) {
              imm = -imm;
            }
          }
          if (type == DataType::Type::kInt32) {
            can_use_imm = IsInt<16>(imm) || (Low16Bits(imm) == 0) || single_use;
          } else {
            can_use_imm = IsInt<16>(imm) || (IsInt<32>(imm) && (Low16Bits(imm) == 0)) || single_use;
          }
        }
      }
      if (can_use_imm)
        locations->SetInAt(1, Location::ConstantLocation(right->AsConstant()));
      else
        locations->SetInAt(1, Location::RequiresRegister());
      locations->SetOut(Location::RequiresRegister(), Location::kNoOutputOverlap);
      }
      break;

    case DataType::Type::kFloat32:
    case DataType::Type::kFloat64:
      locations->SetInAt(0, Location::RequiresFpuRegister());
      locations->SetInAt(1, Location::RequiresFpuRegister());
      locations->SetOut(Location::RequiresFpuRegister(), Location::kNoOutputOverlap);
      break;

    default:
      LOG(FATAL) << "Unexpected " << instruction->DebugName() << " type " << type;
  }
}

```

