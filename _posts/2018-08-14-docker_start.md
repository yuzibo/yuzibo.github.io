---
title: docker基础
category: docker
layout: post
---
* content
{:toc}

# 安装
docker安装的话请参考这篇文章[article](https://www.howtoing.com/how-to-install-and-use-docker-on-debian-9/)

Docker binds a Unix socket, but it need **root**user also.If you do not want use **root**, there is the best way to do it with creating **docker**user group add user into it.When the Docker daemon starts, it create a Unix socket accessible by members of the **docker** group.

[refer to it](https://docs.docker.com/install/linux/linux-postinstall/)

After installing the Docker, you can verfy it with below:

```c
yubo@debian:~/git/yuzibo.github.io/_posts$ sudo docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
1b930d010525: Already exists
Digest: sha256:5f179596a7335398b805f036f7e8561b6f0e32cd30a32f5e19d17a3cda6cc33d
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/

```

# create docker group

1. Create the **docker** group
```c
sudo groupadd docker
```

2. Add your user to the **docker** group
```c
sudo usermod -aG docker $USER
```

3. 你得退出当前的登录界面才可以，再次重新登录。

4. Verify that you can run **docker** commands without **sudo**
```c
docker run hello-world
```

# Configure Docker to start on boot

Enable it with **systemd**:
```c
sudo systectl enable docker
```
