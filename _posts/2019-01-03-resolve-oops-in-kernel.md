---
title:  " First step on oops in kernel"
category: kernel
layout: post
---
* content
{:toc}

This is a note i refer to [the article](https://opensourceforu.com/2011/01/understanding-a-kernel-oops/)

So, i have to record it simply.

In fact, if you have interesting to learn  kernel programming, the oops is your better choice or tool.There is plenty of resources on Internet.And if you have some issues on that, i am grate happy to receive your email.

# The program can cause kernel oops

in oops.c

```c
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/init.h>

static void create_oops(void) {
	*(int *)0 = 0;
}

static int __init my_oops_init(void)
{
	pr_info("oops from the module\n");
	create_oops();
	return 0;
}
static void __exit my_oops_exit(void) {
	pr_info("Goodbye\n");
}
module_init(my_oops_init);
module_exit(my_oops_exit);

```

And you have to editor the Makefile file, like below:

```c
obj-m += oops.o
all:
		make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules
CFLAGS_task12-2.o := -DDEBUG

clean:
		make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
```
In the file, there is an entry may be different from other tutorial.Yes, CFLAGS, it is a flag how to compile the module.Why does we use the option? The answer is enable DEBUG for kernel module. In oops.c file, we can print some message with pr_info, but if we use pr_debug, it may be not display the information without -DDEBUG option.

So, then we:

```c
make && sudo insmod oops.ko
```

And the result:

```bash
yubo@debian:~/lit$ make
make -C /lib/modules/5.0.0-rc4/build M=/home/yubo/lit modules
make[1]: Entering directory '/usr/src/linux-headers-5.0.0-rc4'
CC [M]  /home/yubo/lit/oops.o
Building modules, stage 2.
MODPOST 1 modules
WARNING: modpost: missing MODULE_LICENSE() in /home/yubo/lit/oops.o
see include/linux/module.h for more information
CC      /home/yubo/lit/oops.mod.o
LD [M]  /home/yubo/lit/oops.ko
make[1]: Leaving directory '/usr/src/linux-headers-5.0.0-rc4'
```
Haha, it will kill the prograss after you insmod the module.

Let's cat dmesg:

```bash
[ 3341.170623] oops: loading out-of-tree module taints kernel.
[ 3341.170628] oops: module license 'unspecified' taints kernel.
[ 3341.170629] Disabling lock debugging due to kernel taint
[ 3341.170907] oops from the module
[ 3341.170913] BUG: unable to handle kernel NULL pointer dereference at 00000000
[ 3341.170917] #PF error: [WRITE]
[ 3341.170919] *pdpt = 0000000029111001 *pde = 0000000000000000
[ 3341.170924] Oops: 0002 [#1] SMP PTI
[ 3341.170928] CPU: 3 PID: 4066 Comm: insmod Tainted: P           O      5.0.0-rc4 #3
[ 3341.170932] Hardware name: Acer Aspire E1-471G/EA40_HC, BIOS V1.24 10/11/2012
[ 3341.170937] EIP: my_oops_init+0x12/0x1000 [oops]
[ 3341.170942] Code: Bad RIP value.
[ 3341.170945] EAX: 00000014 EBX: f86d1000 ECX: f6f755ac EDX: 00000007
[ 3341.170947] ESI: 00000001 EDI: f86d4000 EBP: e7ce7dec ESP: e7ce7de8
[ 3341.170950] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010246
[ 3341.170953] CR0: 80050033 CR2: f86d3fe8 CR3: 27c32000 CR4: 000406f0
[ 3341.170955] Call Trace:
[ 3341.170962]  do_one_initcall+0x42/0x1ae
[ 3341.170966]  ? _cond_resched+0x18/0x40
[ 3341.170972]  ? do_init_module+0x21/0x1dd
[ 3341.170975]  do_init_module+0x50/0x1dd
[ 3341.170978]  load_module+0x1d06/0x2540
[ 3341.170982]  ? kernel_read_file+0x222/0x250
[ 3341.170986]  sys_finit_module+0xa7/0xe0
[ 3341.170990]  do_fast_syscall_32+0x7f/0x1d0
[ 3341.170993]  entry_SYSENTER_32+0x6b/0xbe
[ 3341.170995] EIP: 0xb7f81851
[ 3341.170997] Code: 8b 98 58 cd ff ff 85 d2 89 c8 74 02 89 0a 5b 5d c3 8b 04 24 c3 8b 14 24 c3 8b 1c 24 c3 8b 3c 24 c3 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d 76 00 58 b8 77 00 00 00 cd 80 90 8d 76
[ 3341.170999] EAX: ffffffda EBX: 00000003 ECX: 004dc970 EDX: 00000000
[ 3341.171001] ESI: 01d19d90 EDI: 01d1a7a8 EBP: 004dae9c ESP: bfe2a18c
[ 3341.171003] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00000292

```
# Understanding the Oops dump
Let's have a closer look at the above dump, to understand some of the important bits of information.


[ 3341.170623] oops: loading out-of-tree module taints kernel.
[ 3341.170628] oops: module license 'unspecified' taints kernel.
[ 3341.170629] Disabling lock debugging due to kernel taint
[ 3341.170907] oops from the module

This is basic information to show the module.

[ 3341.170913] BUG: unable to handle kernel NULL pointer dereference at 00000000

It is obvious that to show the type of oops.

[ 3341.170919] *pdpt = 0000000029111001 *pde = 0000000000000000

May be this is relative to page table entry.If you have definited understanding about this, please tell me, thanks :)

[ 3341.170924] Oops: 0002 [#1] SMP PTI

This is the error code value in hex. Each bit has a significance of its own:

bit 0 == 0 means no page found, 1 means a protection fault
bit 1 == 0 means read, 1 means write
bit 2 == 0 means kernel, 1 means user-mode
[#1] — this value is the number of times the Oops occurred. Multiple Oops can be triggered as a cascading effect of the first one.

Refer to above the site.

[ 3341.170928] CPU: 3 PID: 4066 Comm: insmod Tainted: P           O      5.0.0-rc4 #3

This is your choice to have a look at kernel/panic.c:

```c

/*
 * TAINT_FORCED_RMMOD could be a per-module flag but the module
 * is being removed anyway.
 */
const struct taint_flag taint_flags[TAINT_FLAGS_COUNT] = {
	[ TAINT_PROPRIETARY_MODULE ]	= { 'P', 'G', true },
	[ TAINT_FORCED_MODULE ]		= { 'F', ' ', true },
	[ TAINT_CPU_OUT_OF_SPEC ]	= { 'S', ' ', false },
	[ TAINT_FORCED_RMMOD ]		= { 'R', ' ', false },
	[ TAINT_MACHINE_CHECK ]		= { 'M', ' ', false },
	[ TAINT_BAD_PAGE ]		= { 'B', ' ', false },
	[ TAINT_USER ]			= { 'U', ' ', false },
	[ TAINT_DIE ]			= { 'D', ' ', false },
	[ TAINT_OVERRIDDEN_ACPI_TABLE ]	= { 'A', ' ', false },
	[ TAINT_WARN ]			= { 'W', ' ', false },
	[ TAINT_CRAP ]			= { 'C', ' ', true },
	[ TAINT_FIRMWARE_WORKAROUND ]	= { 'I', ' ', false },
	[ TAINT_OOT_MODULE ]		= { 'O', ' ', true },
	[ TAINT_UNSIGNED_MODULE ]	= { 'E', ' ', true },
	[ TAINT_SOFTLOCKUP ]		= { 'L', ' ', false },
	[ TAINT_LIVEPATCH ]		= { 'K', ' ', true },
	[ TAINT_AUX ]			= { 'X', ' ', true },
	[ TAINT_RANDSTRUCT ]		= { 'T', ' ', true },
};

```
[ 3341.170937] EIP: my_oops_init+0x12/0x1000 [oops]
There is oop happened on the program. my_oops_init+0x12/0x21 is the <symbol> + the offset/length.

[ 3341.170942] Code: Bad RIP value.
Oh, Is it a bug? Should it be Bad EIP value?
Now， it will show the information about original code.RIP is the CPU register containing the address of the instruction that is getting executed.

[ 3341.170945] EAX: 00000014 EBX: f86d1000 ECX: f6f755ac EDX: 00000007
[ 3341.170947] ESI: 00000001 EDI: f86d4000 EBP: e7ce7dec ESP: e7ce7de8
[ 3341.170950] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010246
[ 3341.170953] CR0: 80050033 CR2: f86d3fe8 CR3: 27c32000 CR4: 000406f0

I do not know it.

[ 3341.170955] Call Trace:
[ 3341.170962]  do_one_initcall+0x42/0x1ae
[ 3341.170966]  ? _cond_resched+0x18/0x40
[ 3341.170972]  ? do_init_module+0x21/0x1dd
[ 3341.170975]  do_init_module+0x50/0x1dd
[ 3341.170978]  load_module+0x1d06/0x2540
[ 3341.170982]  ? kernel_read_file+0x222/0x250
[ 3341.170986]  sys_finit_module+0xa7/0xe0
[ 3341.170990]  do_fast_syscall_32+0x7f/0x1d0
[ 3341.170993]  entry_SYSENTER_32+0x6b/0xbe

Interesting...

[ 3341.170995] EIP: 0xb7f81851
[ 3341.170997] Code: 8b 98 58 cd ff ff 85 d2 89 c8 74 02 89 0a 5b 5d c3 8b 04 24 c3 8b 14 24 c3 8b 1c 24 c3 8b 3c 24 c3 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d 76 00 58 b8 77 00 00 00 cd 80 90 8d 76
[ 3341.170999] EAX: ffffffda EBX: 00000003 ECX: 004dc970 EDX: 00000000
[ 3341.171001] ESI: 01d19d90 EDI: 01d1a7a8 EBP: 004dae9c ESP: bfe2a18c
[ 3341.171003] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00000292

Ok

[ 3341.171005] Modules linked in: oops(PO+) ctr ...

Used module in linked list maybe.

[ 3341.171049] CR2: 0000000000000000
[ 3341.171052] ---[ end trace dd8bceded905e5e1 ]---
[ 3341.171054] EIP: my_oops_init+0x12/0x1000 [oops]
[ 3341.171057] Code: Bad RIP value.
[ 3341.171058] EAX: 00000014 EBX: f86d1000 ECX: f6f755ac EDX: 00000007
[ 3341.171060] ESI: 00000001 EDI: f86d4000 EBP: e7ce7dec ESP: c5a27ddc
[ 3341.171062] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010246
[ 3341.171064] CR0: 80050033 CR2: f86d3fe8 CR3: 27c32000 CR4: 000406f0

# Debugging an Oops dump
The first step is to load the  offending module into the GDB debugger, as follows:

yubo@debian:~/lit$ gdb oops.ko
GNU gdb (Debian 7.12-6) 7.12.0.20161007-git
Copyright (C) 2016 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "i686-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
<http://www.gnu.org/software/gdb/documentation/>.
For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from oops.ko...done.
(gdb)
(gdb) add-symbol-file oops.o 0xf86d4000
add symbol table from file "oops.o" at
.text_addr = 0xf86d4000
(y or n) y
Reading symbols from oops.o...done.

Next, add the symbol file to the debugger. The add-symbol-file command’s first argument is oops.o and the second argument is the address of the text section of the module. You can obtain this address from /sys/module/oops/sections/.init.text (where oops is the module name):

From the RIP instruction line, we can get the name of the offending function, and disassemble it.

(gdb) disassemble my_oops_init
Dump of assembler code for function my_oops_init:
0x00000024 <+0>:	call   0x25 <my_oops_init+1>
0x00000029 <+5>:	push   %ebp
0x0000002a <+6>:	mov    %esp,%ebp
0x0000002c <+8>:	push   $0x0
0x00000031 <+13>:	call   0x32 <my_oops_init+14>
0x00000036 <+18>:	movl   $0x0,0x0
0x00000040 <+28>:	xor    %eax,%eax
0x00000042 <+30>:	leave
0x00000043 <+31>:	ret
End of assembler dump.
(gdb)

Now, to pin point the actual line of offending code, we add the starting address and the offset. The offset is available in the same RIP instruction line. In our case, we are adding 0x00000024 + 0x12(which is came from    my_oops_init+0x12/0x1000 ) = 0x00000036.It points the 0x00000036 the instruction. It is a movl instruction.

(gdb) list *0x00000036
0x36 is in my_oops_init (/home/yubo/lit/oops.c:12).
7	#include <linux/kernel.h>
8	#include <linux/module.h>
9	#include <linux/init.h>
10
11	static void create_oops(void) {
12		*(int *)0 = 0;
13	}
14
15	static int __init my_oops_init(void)
16	{
(gdb)

So, we have found it.







