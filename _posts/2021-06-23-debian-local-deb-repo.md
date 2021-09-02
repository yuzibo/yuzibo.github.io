---
title: setup local deb packages repo
category:  debian
layout: post
---
* content
{:toc}

项目需要，要在本地的host上测试相关的deb更新的情况，下面是具体实现的脚本。

```bash
user@linux:~$ cat setup_deb_local_server.sh

#!/bin/bash
#1. mkdir <packagedir>
#2. dpkg-scanpackages packagedir | gzip > packagedir/Packages.gz
#3. user@linux:~$ cat /etc/apt/sources.list.d/test.list
#deb [trusted=yes] file:////home/user/ local_deb/

#4. apt-get update

# https://unix.stackexchange.com/questions/87130/how-to-quickly-create-a-local-apt-repository-for-random-packages-using-a-debian#

# https://www.cyberciti.biz/faq/sudo-append-data-text-to-file-on-linux-unix-macos/

DEB_DIR="/home/user/SX03.000_lite/l4e_deb_packages"
DEB_LOCAL_DIR="~/local_debs"

function mkdir_package(){
    if [ -d $DEB_LOCAL_DIR ]; then
        rm -rf $DEB_LOCAL_DIR
    else
        mkdir ~/local_debs
    fi
    cp $DEB_DIR/*.deb ~/local_debs
}

function reflash_deb(){
    echo "first make sure you move deb to dir"
    dpkg-scanpackages ~/local_debs | gzip > ~/local_debs/Packages.gz
}

function change_source_lists(){
    pushd /etc/apt/sources.list.d
    (sudo rm cuda-10-2-local-10.2.89.list  nvidia-l4t-apt-source.list visionworks-sfm-repo.list visionworks-repo.list  visionworks-tracking-repo.list)
    if [ -f eswin-apt-source.list ]; then
        (sudo mv eswin-apt-source.list eswin_deb.list.backup )
    else
      (sudo rm /etc/test_deb.list)
        #(sudo touch /etc/test_deb.list)

   fi
    (echo -e "deb [trusted=yes] file:/// /home/user/local_debs/" | sudo tee -a  /etc/apt/sources.list.d/test_deb.list)

    popd

    pushd /etc/apt
    (sudo mv sources.list sources.list.backup)
    popd
}

mkdir_package
reflash_deb
change_source_lists
```
这里直接使用一个脚本，把相关的debian包安装到对应的目录下，然后就可以执行`sudo apt update`

# debian 卸载/升级 软件的顺序

【http://jianjian.blog.51cto.com/35031/395468】

这些是软件包安装前后自动运行的可执行脚本. 统称为控制文件, 是 Deian 软件包的"控制"部分它们是：

preinst

Debian软件包(".deb")解压前执行的脚本, 为正在被升级的包停止相关服务,直到升级或安装完成。 (成功后执行 'postinst' 脚本)。

postinst

主要完成软件包(".deb")安装完成后所需的配置工作. 通常, postinst 脚本要求用户输入, 和/或警告用户如果接受默认值, 应该记得按要求返回重新配置这个软件。 一个软件包安装或升级完成后，postinst 脚本驱动命令, 启动或重起相应的服务。

prerm

停止一个软件包的相关进程, 要卸载软件包的相关文件前执行。

postrm

修改相关文件或连接, 和/或卸载软件包所创建的文件。
当前的所有配置文件都可在 /var/lib/dpkg/info 目录下找到, 与 foo 软件包相关的命名以 "foo" 开头,以 "preinst", "postinst", 等为扩展。这个目录下的 foo.list 文件列出了软件包安装的所有文件。Debian里用apt-get安装或卸载软件时，会常发生前处理或后处理的错误，这时只要删除 对应的脚本文件，重新执行安装或卸载即可

[https://blog.csdn.net/yingyingququ/article/details/108848019]

1. 首次安装某deb包时，执行dpkg -i test_v1.deb安装，DEBIAN下面控制脚本按如下顺序执行：

preinst->postinst

2. 若卸载deb，但保留配置档，执行dpkg -r test，DEBIAN下面控制脚本按如下顺序执行：

prerm->postrm

3. 若卸载不保留配置档，执行dpkg -P test，DEBIAN下面控制脚本按如下顺序执行：

prerm->postrm->postrm

4. 若升级安装,例如执行dpkg -i test_v2.deb，DEBIAN下面的控制脚本执行顺序如下：

prerm->preinst->postrm->postinst

这里，可以结合 官方手册来看这个问题：

https://www.debian.org/doc/debian-policy/ap-flowcharts.html
