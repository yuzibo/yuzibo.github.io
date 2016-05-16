---
title: "Makefile中后缀规则"
layout: article
category: make
---

# make中的通配符原则

```bash
EXE=test
OBJ=test.o

$(EXE): $(OBJ)
	gcc -o $@ $<

%.o: %.c
	gcc -c -o $@ $<
```
这里的意思很明显：可执行文件依赖于对象文件，对象文件又需要一条统配规则：
所有.c的文件会生成.o的文件，下面是规则。

```bash
EXE=test
OBJ=test.o

$(EXE): $(OBJ)
	gcc -o $@ $<

.SUFFIXES: .c .o

.c.o:
	gcc -g $@ $<
```
与上面实现了同样的功能，但是有一点注意，这条默认规则不产生输出，上面的Makefile会输出。

