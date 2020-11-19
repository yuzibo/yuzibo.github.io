---
title: docker 基本操作
category: docker
layout: post
---
* content
{:toc}

在大师的帮助下，初步有一个对docker的认识，

# 基本概念

## 镜像

镜像构建时，会一层层构建，前一层是后一层的基础。每一层构建完就不会再发生改变，后一层上的任何改变只发生在自己这一层。比如，删除前一层文件的操作，实际不是真的删除前一层的文件，而是仅在当前层标记为该文件已删除。在最终容器运行的时候，虽然不会看到这个文件，但是实际上该文件会一直跟随镜像。因此，在构建镜像的时候，需要额外小心，每一层尽量只包含该层需要添加的东西，任何额外的东西应该在该层构建结束前清理掉。

## 容器
镜像（Image）和容器（Container）的关系，就像是面向对象程序设计中的 类 和 实例 一样，镜像是静态的定义，容器是镜像运行时的实体。容器可以被创建、启动、停止、删除、暂停等。
容器的实质是进程，但与直接在宿主执行的进程不同，容器进程运行于属于自己的独立的 命名空间。因此容器可以拥有自己的 root 文件系统、自己的网络配置、自己的进程空间，甚至自己的用户 ID 空间。容器内的进程是运行在一个隔离的环境里，使用起来，就好像是在一个独立于宿主的系统下操作一样。这种特性使得容器封装的应用比直接在宿主运行更加安全。也因为这种隔离的特性，很多人初学 Docker 时常常会混淆容器和虚拟机。
前面讲过镜像使用的是分层存储，容器也是如此。每一个容器运行时，是以镜像为基础层，在其上创建一个当前容器的存储层，我们可以称这个为容器运行时读写而准备的存储层为 容器存储层。
容器存储层的生存周期和容器一样，容器消亡时，容器存储层也随之消亡。因此，任何保存于容器存储层的信息都会随容器删除而丢失。
按照 Docker 最佳实践的要求，容器不应该向其存储层内写入任何数据，容器存储层要保持无状态化。所有的文件写入操作，都应该使用 数据卷（Volume）、或者 绑定宿主目录，在这些位置的读写会跳过容器存储层，直接对宿主（或网络存储）发生读写，其性能和稳定性更高。
数据卷的生存周期独立于容器，容器消亡，数据卷不会消亡。因此，使用数据卷后，容器删除或者重新运行之后，数据却不会丢失。

以上概念太重要了， 摘抄自下面的文章:

https://yeasy.gitbook.io/docker_practice/basic_concept/image

# 获取镜像

docker pull [选项] [Docker Registry 地址[:端口号]/]仓库名[:标签]

一般Docker Registry 地址不指定，默认为官方的Docker Hub，标签不指定，默认为latest

例如：docker pull ubuntu:16.04

可以提前使用`docker docker search ubuntu`命令查看Docker Hub上的所有可利用的镜像。

# 查看镜像

## docker images ls 

## docker image ls

使用该命令查看下载的镜像

## docker image ls ubuntu

查看指定镜像

## docker image ls -q

查看镜像id

```c
vimer@host:~$ docker image ls ubuntu -q
d70eaf7277ea
```

# 删除镜像

docker image rm 镜像1 镜像2 ...

通常可用镜像id（前3位就行），镜像名，摘要删除

> 批量删除

docker image rm $(docker image ls -q ubuntu)

# 运行容器

> docker run -it --rm ubuntu bash

-it: -i 交互式操作 -t 终端

--rm: 容器退出时做清理工作

bash: 交互式shell

我们以这个镜像启动并运行一个容器，执行如下命令可以启动ubuntu里面的bash并进行交互操作.
具体操作就是:

```c
vimer@host:~$ docker  pull ubuntu
Using default tag: latest
latest: Pulling from library/ubuntu
6a5697faee43: Pull complete
ba13d3bc422b: Pull complete
a254829d9e55: Pull complete
Digest: sha256:fff16eea1a8ae92867721d90c59a75652ea66d29c05294e6e2f898704bdb8cf1
Status: Downloaded newer image for ubuntu:latest
docker.io/library/ubuntu:latest
vimer@host:~$ docker image ls
REPOSITORY                 TAG                 IMAGE ID            CREATED             SIZE
ubuntu                     latest              d70eaf7277ea        3 weeks ago         72.9MB
tinylab/linux-lab          next                d9b4a01fd5eb        3 months ago        3.55GB

vimer@host:~$ docker run -it --rm ubuntu bash // rm 清理容器退出时的资源
root@dc09804ce242:/# ls
bin   dev  home  lib32  libx32  mnt  proc  run   srv  tmp  var
boot  etc  lib   lib64  media   opt  root  sbin  sys  usr
# 注意这里：
root@dc09804ce242:/# uname -a
Linux dc09804ce242 5.3.0-42-generic #34~18.04.1-Ubuntu SMP Fri Feb 28 13:42:26 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux
root@dc09804ce242:/# exit
exit
vimer@host:~$ uname -a
Linux host 5.3.0-42-generic #34~18.04.1-Ubuntu SMP Fri Feb 28 13:42:26 UTC 2020 x86_64 x86_64 x86_64 GNU/L
```
看到没有，docker（容器里的Ubuntu其实就是用的）使用的kernel其实就是host的kernel，现在就有个疑问，docker的
这个交互是怎么做到的，好像用到了namespace和cgroup这两个特性。

## commit 理解镜像构成--慎用
docker commit最好用来保存现场，而不是制作镜像，定制镜像应该使用 Dockerfile 来完成。
基本的作用就是: 在一个容器中新改动了某个特性，并以此为镜像，以方便下次使用。这个命令就是干这个的，。

注意，我们还是 慎用 这个命令，看这里的。
https://yeasy.gitbook.io/docker_practice/image/commit

## Dockerfile定制镜像
https://yeasy.gitbook.io/docker_practice/image/build
大神写的非常完整，忍不住赞，这也是我之前没用docker考虑到的问题，这篇文章里基本上都有涉及。

总结几点就是：在构建docker镜像时尽量压缩层数，一般来说一个RUN指令完成一个事情，还有一个问题是，
要把不需要的东西不要加进存储层。

在 Shell 中，连续两行是同一个进程执行环境，因此前一个命令修改的内存状态，会直接影响后一个命令；而在 Dockerfile 中，这两行 RUN 命令的执行环境根本不同，是两个完全不同的容器。这就是对 Dockerfile 构建分层存储的概念不了解所导致的错误。


# 参考资料

https://zhuanlan.zhihu.com/p/41123740