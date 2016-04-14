---
title: "oracle proc编程Makefile模板"
layout: article
category: oracle
---

# V 0.1

这个版本的Makefile，是把命令行输入的东西放到Makefile中而已，或者说只是测试
怎样使用proc编程。

<em> 注意，自己要将oracle的目录及库文件位置写正确 </em>

### 使用方法
首先把下面的文件换成你要测试的文件，比如makech.pc,你应该或者或多或少的了解
makefile的原理。最开始的就是你的最终目标。我这里就是

>makech <--- makech.c <---makech.pc

也就是说你要替换4个单词，直接make就可以了。

```c



.SUFFIXES: .pc .c .o


CC = gcc -o
PROC = proc


ORACLE_HOME = /opt/oracle/11g

ORALIB = -lclntsh -lpthread

makech: makech.c
	$(CC)   $@ -g $<  -I$(ORACLE_HOME)/precomp/public -L$(ORACLE_HOME)/lib  $(ORALIB)
makech.c: makech.pc
	$(PROC) INAME=$*.pc  CODE=ANSI_C PARSE=NONE oname=$*.c

clean:
	@echo "rm ..."
	@rm -f *.c
	@rm -f *.lis

```

# v.2
这一版本比上次有所提高，主要是打字少，还可以实现个性化。

将PROCSRCS 的值换为你想编辑的.pc文件，EXE为你的目标文件即可。

```c
.SUFFIXES: .pc .c .o

CC = gcc -o
PROC = proc

ORACLE_HOME = /opt/oracle/11g

ORALIB = -lclntsh -lpthread

PROCSRCS = test_stu.pc
EXE	= 123

SRCS=$(PROCSRCS:.pc=.c)
OBJS=$(SRCS:.c=.o)

$(EXE): $(SRCS)
	$(CC)   $@ -g $(SRCS)  -I$(ORACLE_HOME)/precomp/public -L$(ORACLE_HOME)/lib  $(ORALIB)

$(SRCS):
	$(PROC) INAME=$(PROCSRCS)  CODE=ANSI_C PARSE=NONE oname=$(SRCS)

clean:
	@echo "rm ..."
	@rm -f *.c
	@rm -f *.lis
	@rm -f *.o
```

