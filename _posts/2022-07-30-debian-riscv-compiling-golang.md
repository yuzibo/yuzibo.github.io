---
title: debian riscv 源码编译golang及proxy使用 
category: riscv
layout: post
---
* content
{:toc}

出于验证一个测试程序的目的，需要在riscv64的板子上源码安装golang，原本很简单的事情，但是操作之后才发现不是这回事，故这里简单记录下，以便后面需要时用到。

以下操作是在mengzhuo老师的指导下完成。

首先知道的一点是，源码编译go， [here](https://go.dev/doc/install/source),另外golang目前(2022/08/01)还没有riscv64的二进制包，需要更需要从源码编译。从源码编译，需要有一个自举的过程，但是[Bootstrap toolchain from C source code](https://go.dev/doc/install/source) 1.4 版本还不支持rv，所以，这里就麻烦一些了。

# 步骤
首先安装 golang-go - Go programming language compiler, linker, compiled stdlib. 在目前的debian系统上，已经默认安装支持golang-go，一定要使用这个，不要使用gccgo，后者的问题非常多。

```bash
apt install golang-go
```
然后  `go version`就可以看到相应的输出了。在相同的terminal下，然后下载 golang  的source code,我下载的是 go version go1.18.4.解压，然后执行`./make.bash`即可。

这个时候或者编译完成后，如果go version提示说找不到相关命令，大概率是由于 goroot gopath的相关路径不对。

# 环境变量

## GOROOT
```bash
GOROOT=/home/vimer/go/go/
```
这里其实就是指向的你的go源码的位置:
```bash
vimer@unmatched:~/go/go$ ls
AUTHORS          CONTRIBUTORS  PATENTS    SECURITY.md  api  codereview.cfg  lib   pkg  test
CONTRIBUTING.md  LICENSE       README.md  VERSION      bin  doc             misc  src
```
紧接着，要把 go的可执行程序加入$PATH中：
```bash
export PATH=$PATH:$GOROOT/bin
```

## GOPATH
还有一个是GOPATH:
```bash
GOPATH="/home/vimer/go/proj"
```
这个是用来存储相关go的生成物的。

## GOPROXY
因为go是google开发的嘛，有些东西timeout是不可避免的，所以遇到这种问题时，需要使用:
```bash
GOPROXY="https://proxy.golang.com.cn"
```