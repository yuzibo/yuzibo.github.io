---
title: 从java到oat文件--android前期应用介绍
category: aosp
layout: post
---
* content
{:toc}

# java程序

```java
public class JavaToDex{
	public static void main(String[] args){
		System.out.println("How to make java to dex");
	}
}
```
保存文件需要注意，要以类名进行结尾，这是java语言编程的一个特色。

# javac
使用javac命名转化java程序转化为class文件。
```bash
javac JavaToDex.java ==> JavaToDex.class
java JavaToDex  ==> output sth
```

# dx
 注意，这个工具并在aosp下，其实想一想也是，dx是为了将java转化dex文件，那么，至少这个工作是由sdk提供的。一般来说，这个工具存放在build-tools下。

```bash
usage:
  dx --dex [--debug] [--verbose] [--positions=<style>] [--no-locals]
  [--no-optimize] [--statistics] [--[no-]optimize-list=<file>] [--no-strict]
  [--keep-classes] [--output=<file>] [--dump-to=<file>] [--dump-width=<n>]
  [--dump-method=<name>[*]] [--verbose-dump] [--no-files] [--core-library]
  [--num-threads=<n>] [--incremental] [--force-jumbo] [--no-warning]
  [--multi-dex [--main-dex-list=<file> [--minimal-main-dex]]
  [--input-list=<file>] [--min-sdk-version=<n>]
  [--allow-all-interface-method-invokes]
  [<file>.class | <file>.{zip,jar,apk} | <directory>] ...
    Convert a set of classfiles into a dex file, optionally embedded in a
    jar/zip. Output name must end with one of: .dex .jar .zip .apk or be a
    directory.
    Positions options: none, important, lines.
    --multi-dex: allows to generate several dex files if needed. This option is
    exclusive with --incremental, causes --num-threads to be ignored and only
    supports folder or archive output.
    --main-dex-list=<file>: <file> is a list of class file names, classes
    defined by those class files are put in classes.dex.
    --minimal-main-dex: only classes selected by --main-dex-list are to be put
    in the main dex.
    --input-list: <file> is a list of inputs.
    Each line in <file> must end with one of: .class .jar .zip .apk or be a
    directory.
    --min-sdk-version=<n>: Enable dex file features that require at least sdk
    version <n>.
  dx --annotool --annotation=<class> [--element=<element types>]
  [--print=<print types>]
  dx --dump [--debug] [--strict] [--bytes] [--optimize]
  [--basic-blocks | --rop-blocks | --ssa-blocks | --dot] [--ssa-step=<step>]
  [--width=<n>] [<file>.class | <file>.txt] ...
    Dump classfiles, or transformations thereof, in a human-oriented format.
  dx --find-usages <file.dex> <declaring type> <member>
    Find references and declarations to a field or method.
    <declaring type> is a class name in internal form, like Ljava/lang/Object;
    <member> is a field or method name, like hashCode.
  dx -J<option> ... <arguments, in one of the above forms>
    Pass VM-specific options to the virtual machine that runs dx.
  dx --version
    Print the version of this tool (1.16).
  dx --help
    Print this message.
```
上面的这个是帮助文档，值得需要注意下的。
Convert a set of classfiles into a dex file, optionally embedded in a
jar/zip. Output name must end with one of: .dex .jar .zip .apk or be a
directory.

由此看来，dx可以转化的文件格式还是很多的。
```bash
dx --dex --output=JavaToDex2.dex JavaToDex.class
```
就会由dex文件生成class文件。

好了， 生成dex文件只是万里长征的第一步，后面才是真正的旅途。

如果想查看dex文件的格式(如果有必要的话，这一步为了研究art的东西，一定需要研究这个文件)

有一个比较好的东西是dexdump,唉，这个工具又和dx不同了，dexdump 看样子在aosp中需要的很多，那么，这个文件会直接生成在out/host/linux-x86/bin下。
```bash
dexdump -h
dexdump: no file specified
Copyright (C) 2007 The Android Open Source Project

dexdump: [-c] [-d] [-f] [-h] [-i] [-l layout] [-m] [-t tempfile] dexfile...

 -c : verify checksum and exit
 -d : disassemble code sections
 -f : display summary information from file header
 -h : display file header details
 -i : ignore checksum failures
 -l : output layout, either 'plain' or 'xml'
 -m : dump register maps (and nothing else)
 -t : temp file name (defaults to /sdcard/dex-temp-*)
```
我们来看看上面那个文件的具体展示:

```bash
vimer@host:~/src/aosp/out/host/linux-x86/bin$ dexdump JavaToDex.dex
Processing 'JavaToDex.dex'...
Opened 'JavaToDex.dex', DEX version '035'
Class #0            -
  Class descriptor  : 'LJavaToDex;'
  Access flags      : 0x0001 (PUBLIC)
  Superclass        : 'Ljava/lang/Object;'
  Interfaces        -
  Static fields     -
  Instance fields   -
  Direct methods    -
    #0              : (in LJavaToDex;)
      name          : '<init>'
      type          : '()V'
      access        : 0x10001 (PUBLIC CONSTRUCTOR)
      code          -
      registers     : 1
      ins           : 1
      outs          : 1
      insns size    : 4 16-bit code units
      catches       : (none)
      positions     :
        0x0000 line=1
      locals        :
        0x0000 - 0x0004 reg=0 this LJavaToDex;
    #1              : (in LJavaToDex;)
      name          : 'main'
      type          : '([Ljava/lang/String;)V'
      access        : 0x0009 (PUBLIC STATIC)
      code          -
      registers     : 3
      ins           : 1
      outs          : 2
      insns size    : 8 16-bit code units
      catches       : (none)
      positions     :
        0x0000 line=3
        0x0007 line=4
      locals        :
  Virtual methods   -
  source_file_idx   : 2 (JavaToDex.java)
```
这个也是后续研究dex2oat的基础。
