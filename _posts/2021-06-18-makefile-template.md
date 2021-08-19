---
title: makefile 模板
category: make
layout: post
---
* content
{:toc}

Refer to https://makefiletutorial.com/

```bash
# Thanks to Job Vranish (https://spin.atomicobject.com/2016/08/26/makefile-c-projects/)
TARGET_EXEC := EswinE2r

BUILD_DIR := ./build
SRC_DIRS := ./src
INC_DIRS := ./include


CC	:= ../../../../../tools/gcc/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-gcc
CXX := ../../../../../tools/gcc/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-g++
AR	:= ../../../../../tools/gcc/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-ar
STRIP := ../../../../../tools/gcc/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-strip


# Find all the C and C++ files we want to compile
SRCS := $(shell find $(SRC_DIRS) -name *.cpp -or -name *.c)

# String substitution for every C/C++ file.
# As an example, hello.cpp turns into ./build/hello.cpp.o
OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)

# String substitution (suffix version without %).
# As an example, ./build/hello.cpp.o turns into ./build/hello.cpp.d
DEPS := $(OBJS:.o=.d)

# Every folder in ./src will need to be passed to GCC so that it can find header files
INC_DIRS := $(shell find $(INC_DIRS) -type d)
# Add a prefix to INC_DIRS. So moduleA would become -ImoduleA. GCC understands this -I flag
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

# The -MMD and -MP flags together generate Makefiles for us!
# These files will have .d instead of .o as the output.
CPPFLAGS := $(INC_FLAGS) -MMD -MP

# The final build step.
$(BUILD_DIR)/$(TARGET_EXEC): $(OBJS)
	$(CC) $(OBJS) -o $@ $(LDFLAGS)

# Build step for C source
$(BUILD_DIR)/%.c.o: %.c
	mkdir -p $(dir $@)
	$(CC)  $(CFLAGS) $(INC_FLAGS) -c $< -o $@

# Build step for C++ source
#$(BUILD_DIR)/%.cpp.o: %.cpp
#	mkdir -p $(dir $@)
#	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@

.PHONY: clean
clean:
	rm -r $(BUILD_DIR)

# Include the .d makefiles. The - at the front suppresses the errors of missing
# Makefiles. Initially, all the .d files will be missing, and we don't want those
# errors to show up.
-include $(DEPS)
```

还有一种模板，但是我不太清楚里面的用法，先看下代码:

```bash
#include ../../common.mk

EXECUTABLE = test
OBJ_BASE_DIR    := objs

HOST_ARCH       := $(shell uname -m)
TARGET_ARCH     := $(HOST_ARCH)
OBJDIR          := $(OBJ_BASE_DIR)/$(TARGET_ARCH)/release

SOURCEDIR  := src
SRCS       := $(wildcard $(SOURCEDIR)/*.c)
OBJS       := $(patsubst $(SOURCEDIR)/%c, $(OBJDIR)/%o, $(SRCS))

INCPATH         := -Iinclude

ifeq ($(HOST_ARCH), x86_64)
        ifeq ($(ARCH), )
        else ifneq ($(findstring $(ARCH), aarch64 arm64),)
                TARGET_ARCH := aarch64
                CROSS_CC    := 1
                CC          := ../../../tools/gcc/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-gcc
                CXX         := ../../../tools/gcc/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-g++
                AR          := ../../../tools/gcc/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-ar
                STRIP       := ../../../tools/gcc/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-strip
        else ifneq ($(ARCH), $(HOST_ARCH))
$(error $(ARCH) is not supported on $(HOST_ARCH) )
        endif
else
        ifeq ($(ARCH), )
        else ifneq ($(ARCH), $(HOST_ARCH))
                ifneq ($(ARCH)_$(HOST_ARCH), arm64_aarch64)
$(error $(ARCH) is not supported on $(HOST_ARCH) )
                endif
        endif
endif

.PHONY : all dir
all: dir $(EXECUTABLE)

dir:
        @mkdir -p $(OBJDIR)

$(EXECUTABLE): $(OBJS)
        $(CC) $^ -o $@
        @echo ++++++ $(EXECUTABLE) is generated successfully!!! ++++++

$(OBJS): $(OBJDIR)/%.o: $(SOURCEDIR)/%.c
        $(CC) $(CFLAGS) -o $@ -c $< $(INCPATH)

$(OBJDIR)/%.d : %.c
        @set -e; rm -rf $@; mkdir -p $(OBJDIR); \
        $(CC) -MM $(CFLAGS) $(INCPATH) $< > $@.$$$$; \
        sed 's,\($*\)\.o[ :]*,\$(OBJDIR)\/\1.o $@ : ,g' < $@.$$$$ > $@; \
        rm -f $@.$$$$

-include $(OBJS:.o=.d)

.PHONY : clean
clean:
        $(RM) $(OBJ_BASE_DIR)
        $(RM) $(EXECUTABLE)
```
其中，我不太明白的是 `$(OBJDIR)/%.d: %.c`这句话是什么意思。还有一点是，我们的连接的有文件 `-Iinclude`或者
`-Llibxx`，这个连接标志一般是放在定义的位置，我们不在规则里去显性的使用这个标志，，，一般情况下。
