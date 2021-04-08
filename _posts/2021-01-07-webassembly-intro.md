---
title: WebAssembly 简介
category: WebAssembly
layout: post
---
* content
{:toc}

这篇文章缩减了不少内容。

# 非Web环境

## Emscripten
Emscripten toolchain是WebAssembly的第一个工具,它模拟了一个特别的OS 系统在web 接口,也可以允许开发者使用libc。Emscripten Compiler Frontend（EMCC）可以直接看成类似gcc的工具。emcc可以使用Clang或者LLVM编译成wasm或者asm.js文件。

## LLVM
这个不用说了，就是一个标准的编译器集合。

## Node.js
JavaScript文件镶嵌在HTML中，当然也需要借助浏览器进行查看。那么，如果不用浏览器怎么运行呢？这个时候就需要借助JS的runtime （Node.js）去跑了。


## WebAssembly Runtime

### WebAssembly Micro Runtime(WAMR)
该Runtime内部包含一个WebAssembly VMcore（iwasm）.

### wasmer
Wasmer是一个非浏览器的、支持WASI和Emscription

### wasmtime


# links
https://liux120.github.io/ECE202_WASM/
