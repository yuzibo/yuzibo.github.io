---
title: "linux 编译错误"
layout: post
category: kernel
---

# linux-next

 ### hits:

/arch/x86/include/asm/pgtable-3level.h:128:20: error: redefinition of ‘native_pud_clear’
./arch/x86/include/asm/pgtable-3level.h:124:20: note: previous definition of ‘native_pud_clear’ was here

这里：

http://lkml.iu.edu/hypermail/linux/kernel/1602.0/03087.html

on x86_64:

when CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD is enabled
and CONFIG_TRANSPARENT_HUGEPAGE is not enabled:

../fs/proc/task_mmu.c: In function 'smaps_pud_range':
../fs/proc/task_mmu.c:596:2: error: implicit declaration of function 'is_huge_zero_pud' [-Werror=implicit-function-declaration]
if (is_huge_zero_pud(*pud))
^
