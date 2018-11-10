---
title: "oracle proc编程Makefile模板"
layout: post
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

# v0.3

爽，实在是爽，不但解决了makech的问题，还解决了Makefile自动生成
的文件放在相应的目录，只是简简单单的在将目标文件放在对应的目录
即可，当然，这里的目标文件不只是指gcc生成的目标文件，这里广义
的指你想操作的文件，比如：

```c
./
./Makefile
./src/*.c;*.h
./obj/*.o
./bin/<executable>
```
类似于一个工程，各种不同的文件放在不同的目录，各司其职。

```bash
.SUFFIXES: .pc .c .o

CC = gcc -o
PROC = proc

ORACLE_HOME = /opt/oracle/11g
BINDIR = /home/oracle/src/tools/dbsvr/bin

ORALIB = -lclntsh -lpthread

PROCSRCS = makech.pc
EXE	= makech

SRCS=$(PROCSRCS:.pc=.c)
OBJS=$(SRCS:.c=.o)

$(BINDIR)/$(EXE): $(SRCS)
	$(CC)   $@ -g $(SRCS)  -I$(ORACLE_HOME)/precomp/public -L$(ORACLE_HOME)/lib  $(ORALIB)

$(SRCS):
	$(PROC) INAME=$(PROCSRCS)  CODE=ANSI_C PARSE=NONE oname=$(SRCS)

clean:
	@echo "rm ..."
	@rm -f *.c
	@rm -f *.lis
	@rm -f *.o
```
看见没有，v3与v2的区别就在于新建了个BINDIR,然后使用$(BINDIR)/$(EXE)即可，
相应的，如果在源目录src中寻找相应的源文件，加入相应的路径名即可。
