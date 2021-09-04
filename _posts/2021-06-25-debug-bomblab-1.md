---
title:  解密bomb phase_1
category: assembly
layout: post
---
* content
{:toc}

根据本系列的第一篇文章，我们现在来分析第一个bomb.

# gdb

其实这里主要是gdb的使用，根据以下的代码:

常用的命令有：

```bash
disas // 反汇编当前函数
disas sum // 反汇编函数sum

// ------调试------
// 若调用了其他函数，step/stepi会进入函数内部，而next/nexti不会
stepi // 执行下一条指令
step // 执行下一条语句
nexti // 执行下一条指令
next // 执行下一条语句

print 0x100 // 输出0x100的十进制表示
print /x 555 // 输出555的十六进制表示

print /d $rax // 以十进制输出寄存器%rax中的值
print /x $rax // 以十六进制输出寄存器%rax中的值
print /t $rax // 以二进制输出寄存器%rax中的值

x/s 0xbffff890 //检查地址0xbffff890中存储的字符串

```

# phase_1

```c
(gdb)
73          input = read_line();             /* Get input                   */
74          phase_1(input);                  /* Run the phase               */
75          phase_defused();                 /* Drat!  They figured it out!
76                                            * Let me know how they did it. */

# 打断点

(gdb) b 73
Breakpoint 1 at 0x400e32: file bomb.c, line 73.
(gdb) b 74
Breakpoint 2 at 0x400e37: file bomb.c, line 74.
(gdb) start # 开始
Temporary breakpoint 3 at 0x400da0: file bomb.c, line 37.
Starting program: /home/user/yubo_work/bomb/bomb

Temporary breakpoint 3, main (argc=1, argv=0x7fffffffe3d8) at bomb.c:37
37      {
(gdb) c
Continuing.
Welcome to my fiendish little bomb. You have 6 phases with
which to blow yourself up. Have a nice day!

Breakpoint 1, main (argc=<optimized out>, argv=<optimized out>) at bomb.c:73
73          input = read_line();             /* Get input                   */
(gdb) n # read_line 是读取字符串，到这里，gdb会停下来，期望我们输入, 下面我输入一个 "test"
test

Breakpoint 2, main (argc=<optimized out>, argv=<optimized out>) at bomb.c:74
74          phase_1(input);                  /* Run the phase               */

# ==
# 反汇编一下 phase_1
(gdb) disassemble phase_1
Dump of assembler code for function phase_1:
   0x0000000000400ee0 <+0>:     sub    $0x8,%rsp
   0x0000000000400ee4 <+4>:     mov    $0x402400,%esi // %esi用于存储第二个参数
   0x0000000000400ee9 <+9>:     callq  0x401338 <strings_not_equal>
   0x0000000000400eee <+14>:    test   %eax,%eax
   0x0000000000400ef0 <+16>:    je     0x400ef7 <phase_1+23>
   0x0000000000400ef2 <+18>:    callq  0x40143a <explode_bomb>
   0x0000000000400ef7 <+23>:    add    $0x8,%rsp
   0x0000000000400efb <+27>:    retq
End of assembler dump.

```

根据这篇文章， https://abcdxyzk.github.io/blog/2012/11/23/assembly-args/

+4处的%esi是一个参数寄存器 for phase_1这个函数， 根据这篇文章: https://www.jianshu.com/p/fd1cfed8a2d2
我们把一个数值给了esi寄存器，那么，这个数字到底是什么呢？

```c
(gdb) p (char*) 0x402400
$1 = 0x402400 "Border relations with Canada have never been better."
```
我是怎么也想不到 (char\*)这种类型。好，我们暂且输入的和这个字符串再一次传递给了
strings_not_equal函数，那么，该函数的返回值是通过eax返回，通过
https://stackoverflow.com/questions/13064809/the-point-of-test-eax-eax
这篇文章的解释，eax为0，则执行JE的内容，这与我们的经验相一致。


