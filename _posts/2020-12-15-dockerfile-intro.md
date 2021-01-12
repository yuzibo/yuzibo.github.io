---
title: docker之快速搭建环境-更换Ubuntu-python源
category: docker
layout: post
---
* content
{:toc}

# Dockerfile简介
Dockerfile就是指令docker镜像如何建立的一个文件，基本上只有动作，过程的东西基本不要放在里面。

# ubuntu 18.04
下面的这个Dockerfile就是快速搭建一个Ubuntu18.04的环境，当然，这个没什么可以值得记录的东西，关键是快速更换了国内的镜像源，包括python.

```bash
vimer@host:~/test/docker$ cat Dockerfile
FROM ubuntu:18.04

ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


ENV SOURCES_LIST=/etc/apt/sources.list

# It will fail without cert
#RUN apt update -y && apt install ca-certificates -y

# 更换国内源 @method 1: 但是没有替换全面
# RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list

# @method 2： Fill source.list with echo

RUN mv /etc/apt/sources.list /etc/apt/sources-bak.list \
        && echo "deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse" >> $SOURCES_LIST \
        && echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse" >> $SOURCES_LIST \
        && echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse" >> $SOURCES_LIST \
        && echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse" >> $SOURCES_LIST \
        && echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse" >> $SOURCES_LIST \
        && echo "deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse" >> $SOURCES_LIST \
        && echo "deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse" >> $SOURCES_LIST \
        && echo "deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse" >> $SOURCES_LIST \
        && echo "deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse" >> $SOURCES_LIST \
        && echo "deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse" >> $SOURCES_LIST

RUN ln -snf /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime

RUN apt update

RUN mkdir .pip && echo "[global]" >> .pip/pip.conf && echo "https://pypi.tuna.tsinghua.edu.cn/simple/" >> .pip/pip.conf
```

如果可以的话， 我打算把echo中的内容放在一个文件内，这样就可以快速更新source了。

最后执行 ：

```bash
docker build -t="demo-video" ./
# 或者
docker build -t "demo-video" -f Dockerfile ./ 
```
就可以创建镜像了，使用类似`docker run -it --rm image-name`就可以run它了。

不过需要注意的是，标签一定设置的正确，不然，你的应用可能用不上。

## docker编译软件
别的也不说了，还是具体看代码的例子吧。

```bash
vimer@host:~/git/videobench$ cat Dockerfile
FROM ubuntu:18.04

ENV SOURCES_LIST=/etc/apt/sources.list

RUN mv /etc/apt/sources.list /etc/apt/sources-bak.list \
        && echo "deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse" >> $SOURCES_LIST \
        && echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse" >> $SOURCES_LIST \
        && echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse" >> $SOURCES_LIST \
        && echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse" >> $SOURCES_LIST \
        && echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse" >> $SOURCES_LIST \
        && echo "deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse" >> $SOURCES_LIST \
        && echo "deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse" >> $SOURCES_LIST \
        && echo "deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse" >> $SOURCES_LIST \
        && echo "deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse" >> $SOURCES_LIST \
        && echo "deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse" >> $SOURCES_LIST

RUN ln -snf /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime

RUN apt update

RUN mkdir .pip && echo "[global]" >> .pip/pip.conf && echo "https://pypi.tuna.tsinghua.edu.cn/simple/" >> .pip/pip.conf

RUN \
        apt-get install -y build-essential git make \
          ninja-build \
          nasm \
          python3 \
          python3-dev \
          python3-pip \
          python3-setuptools \
          python3-tk \
    && pip3 install --upgrade pip \
    && pip install numpy scipy matplotlib notebook pandas sympy nose scikit-learn scikit-image h5py sureal meson cython \
        && mkdir /tmp/vmaf \
        && cd /tmp/vmaf \
        && git clone https://github.com/Netflix/vmaf.git . \
        && make \
        && make install \
        && mv model /usr/local/share \
    && rm -r /tmp/vmaf


RUN \
        apt-get install -y yasm pkg-config \
        && mkdir /tmp/ffmpeg \
        && cd /tmp/ffmpeg \
        && git clone https://git.ffmpeg.org/ffmpeg.git . \
        && ./configure --enable-libvmaf --enable-version3 --pkg-config-flags="--static" \
        && make -j 8 install \
        && rm -r /tmp/ffmpeg



RUN \
        mkdir -p /home/shared-vmaf

RUN \
        ldconfig
```

# 修改镜像
这一部分也是吊事Dockerfile的一部分，我们知道Dockerfile是是由一条条RUN指令构造的层，当Dockerfile执行到某一条命令时会
退出，这个时候我们可以进入倒数第二层:

```bash
runoob@runoob:~$ docker run -t -i [id] /bin/bash
```

在完成操作之后，输入 exit 命令来退出这个容器。

假设此时 ID 为 e218edb10161 的容器，是按我们的需求更改的容器。我们可以通过命令 docker commit 来提交容器副本。

```bash
vimer@host:~$ docker commit -m="has update" -a="runoob" e218edb10161 vimer/ubuntu:v2
```