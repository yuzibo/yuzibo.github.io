---
title: shell 脚本 函数之参数传递
category: shell
layout: post
---
* content
{:toc}

# 传递参数

## 脚本和函数之间的传递

事情的缘由是这样的， 我在编写一个脚本，需要使用两个参数: 一个是java源代码，一个是相应的体系架构。
为了程序的健壮性， 我在调用功能函数之前首先调用检查函数以检查这两个参数的正确性, 下面是代码原型:

```bash
function check_args(){
    local T=$(gettop)    
    if [[ ${T} == '' ]]; then
        echo " You dont source build/envsetup.sh"
        usage_help
        return 1
    fi
    if [[ $# != 2 ]]; then # check num of args
        echo "Requies 2 args"
        usage_help
        return 1 # Can not use source any more
    fi
    case $2 in 
    ...
    *)
        echo "Not arch"
        usage_help
        return 1  
```

那么， 调用过程就是这样:

```bash
function run_cmd(){
    check_args "$@"
    if [[ $? != 0 ]]; then
        echo -e "Check failed\n"
        return 
    fi
}
run_cmd "$@" # here is exe cmd in shell script
```

我第一次写这个代码的时候， 结果一直不对，我也不知道为什么。 后面vscode给我提示了一下，是[foo references arguments, but none are ever passed](https://github.com/koalaman/shellcheck/wiki/SC2120)
我瞬间注意到了， 参数的整体应该是`$@`.

示例代码:

```bash
sayhello() {
  echo "Hello $1"
}
sayhello # ./myscript World
vimer@host:~/test$ ./myscript World
hello
#  corrent code:
sayhello() {
  echo "Hello $1"
}
sayhello "$@"
```

在一个函数中， "$1"是针对函数的参数，对于脚本的参数，则应该使用 "$@", 而且， 还也许需要双引号括起来的。

# 选项扩展--使用数组的形式

看代码:

```bash
options="-j 5 -B"
make $options file
```

这样是不行的， make在解析的时候会把第一个字符（也许）单独拎出来出来，这是不行的。 后面vscode给我提示了一下，是[这样](https://github.com/koalaman/shellcheck/wiki/SC2086#double-quote-to-prevent-globbing-and-word-splitting)
解决如下:

```bash
options=(-j 5 -B) # ksh: set -A options -- -j 5 -B
make "${options[@]}" file  # This is OK

make_with_flags() { make -j 5 -B "$@"; }
make_with_flags file # Function , ok
```


