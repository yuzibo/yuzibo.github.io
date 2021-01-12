---
title: shell根据ps kill
category:  shell
layout: post
---
* content
{:toc}

# 在普通用户模式下

一定要限定在普通用户下，或者一定确保你自己执行`ps`命令不会引出别的进程，不然会引出大麻烦，杀掉系统服务进程或者杀掉别人的进程。

```bash

#########################################################################
# File Name: kill_python.sh
# Author: Bo Yu
# mail: tsu.yubo@gmail.com
# Created Time: 2020年12月25日 星期五 18时57分02秒
##########################################################################
#!/bin/bash

function grep_python(){

        tmp_line="ps_txt"

        if [ -e $tmp_line ];then
                `rm $tmp_line`
        else
                `touch $tmp_line`
        fi

        `ps > $tmp_line`

        #cat $tmp_line

        cat $tmp_line |  \
        awk '{
                for(i=1; i<=NF;i++){
                        if($i ~ /python/){
                                cmd="echo "$1"  "$4
                                system(cmd)
                                cmd="kill -9 "$1
                                system(cmd)
                        }
                }
        }'
}

grep_python

```
