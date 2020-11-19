---
title: docker之容器概念
category: docker
layout: post
---
* content
{:toc}

# 基本概念

主要参考这篇文章做的笔记， [here](https://yeasy.gitbook.io/docker_practice/container/run)

简单的说，容器是独立运行的一个或一组应用，以及它们的运行态环境。对应的，虚拟机可以理解为模拟运行的一整套操作系统（提供了运行态环境和其他系统环境）和跑在上面的应用。

# 启动

启动容器有两种方式，一种是基于镜像新建一个容器并启动，另外一个是将在终止状态（stopped）的容器重新启动。
因为 Docker 的容器实在太轻量级了，很多时候用户都是随时删除和新创建容器。

cmd: docker run 

只运行一个程序:

> vimer@host:~$ docker run ubuntu /bin/echo "Hello, vimer"
> Hello, vimer

当利用 docker run 来创建容器时，Docker 在后台运行的标准操作包括：
> 检查本地是否存在指定的镜像，不存在就从公有仓库下载
> 利用镜像创建并启动一个容器
> 分配一个文件系统，并在只读的镜像层外面挂载一层可读写层
> 从宿主主机配置的网桥接口中桥接一个虚拟接口到容器中去
> 从地址池配置一个 ip 地址给容器
> 执行用户指定的应用程序
> 执行完毕后容器被终止

# 守护态运行

通过 `-d`参数来指定docker后天运行。

```c
vimer@host:~/src/trustedStorage$ docker run  ubuntu /bin/sh -c "while true; do echo hello,world; sleep 1; done"
hello,world
hello,world
hello,world
hello,world
...
```
使用容器无限执行，在伪终端输出以上内容。

```c
vimer@host:~/src/trustedStorage$ docker run  -d ubuntu /bin/sh -c "while true; do echo hello,world; sleep 1; done"
544a5eb8567694e882474064ec081869f8df3aefce9e3ad3619755a72bb04899
```
加了`-d`参数，所以docker把容器放在后台运行了。使用 -d 参数启动后会返回一个唯一的 id，也可以通过 docker container ls 命令来查看容器信息。

### docker container ls

```c
vimer@host:~/src/trustedStorage$ docker container ls
CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS               NAMES
544a5eb85676        ubuntu              "/bin/sh -c 'while t…"   About a minute ago   Up About a minute                       heuristic_euclid
```

### docker container logs id

```c
vimer@host:~/src/trustedStorage$ docker container logs 544a5
hello,world
hello,world
...
```
可以查看正在运行的container跑的是什么内容（假设有打印输出的话）。

### docker container stop id

```c
vimer@host:~/src/trustedStorage$ docker container ls
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
544a5eb85676        ubuntu              "/bin/sh -c 'while t…"   7 minutes ago       Up 7 minutes                            heuristic_euclid
vimer@host:~/src/trustedStorage$ docker container stop 544a5
544a5
vimer@host:~/src/trustedStorage$ docker container ls -a
//所有的image都在这里面， 包括已经终止的container
```

### docker container start id

可以将一个终止的container重新激活。restart是首先关闭docker，然后再打开docker。

# 进入容器

在使用 -d 参数时，容器启动后会进入后台。
某些时候需要进入容器进行操作，包括使用 docker attach 命令或 docker exec 命令，推荐大家使用 docker exec 命令，原因会在下面说明。

### docker attach id

```c
vimer@host:~/src/trustedStorage$ docker container start 544a5
544a5
vimer@host:~/src/trustedStorage$ docker attach 544a5
hello,world
hello,world
^Zhello,world
hello,world
hello,world
^Cvimer@host:~/src/trustedStorage$
```
也就是这样，使用attach的方式，可以在伪终端下使用 `Ctrl + C`的方式关掉container。

### docker exec -it ID bash

docker exec 后边可以跟多个参数，这里主要说明 -i -t 参数。

```c
vimer@host:~/src/trustedStorage$ docker run  -dit ubuntu
05e1d23b8876d24fae0a324681652fa54145e2baf17edc994b12d91da7f8b43d
```

-i 只是交互，但是输出呢，是那种原来一行一行的。 -t 是模拟出来一个终端。

```c
vimer@host:~/src/trustedStorage$ docker exec -i 05e1d bash
ls
bin
boot
dev
etc
home
lib
lib32
lib64
libx32
media
mnt
opt
proc
root
run
sbin
srv
sys
tmp
usr
var
exit
```
这里你就可以放心使用exit退出容器，但是原容器还是存在的。
加上 -t 的参数后:

```c
root@05e1d23b8876:/# ls
bin   dev  home  lib32  libx32  mnt  proc  run   srv  tmp  var
boot  etc  lib   lib64  media   opt  root  sbin  sys  usr
```

# 导出容器: export

我们首先将上面的container stop。然后使用export命令导出:

```c
vimer@host:~/src/trustedStorage$ docker export 05e1d23b8876 > test_ubuntu.tar
vimer@host:~/src/trustedStorage$ ls
test_ubuntu.tar
vimer@host:~/src/trustedStorage$ du  test_ubuntu.tar -h
72M     test_ubuntu.tar
```

# 导入容器: import

```c
vimer@host:~$ cat test_ubuntu.tar | docker import - test/ubuntu:v1.0
sha256:02b96a5671af165755c27b9690edbd4836338425a0147ecd8f986572cc632386
```
这个时候，你使用`container ls`是看不到该container的，首先得激活才有可能看到，类似实例化吧。
这块还有一点问题，后面再补充吧。

import可以直接在URL上导入过来，而且在这个过程中可以继续打tags info。

# rm container

`docker container rm ID`
该命令必须删除终止状态的容器。如果是运行中的，则添加`-f`参数。
>  docker container prune
则会清除所有的已终止的container，慎用。

```c
vimer@host:~$ docker container prune
WARNING! This will remove all stopped containers.
Are you sure you want to continue? [y/N] y
Deleted Containers:
d31e1b77c7798c12d63742d7ec5210dd625ea89754d91e1022b6ef3f368eaf3b
d8f8aa5613744b77960d5459ffbd087c329b17506bca45b7cd6927d0acb1495d
11ba0ac4d76afe40da5b077a53c725c536b6d0687eaa2404730591df9a1f1015
e5530c2e24488944ffdb89a341c8fd649d8b0df55c1ffe1ec8cdd62318908086
f3548a71e9f896897b03dea2bc55ab3075015db46c0735e14a6997f2ead773ec
f4439eba7ee40eafa711019eb00d2a8c119bc17047a9771c0fb74a41fdb2ac17
013060b7e65dacffa181390c7977f3caa1e98838baef1b74e937f6b314e0509d

Total reclaimed space: 4.504MB
```
通过最下面的提示，我们可以发现， container占用的资源的真的很少的，至少在占用物理空间这个层面来说。

# 容器的改动

```c
docker diff container_name
```

