---
title: aosp中repo的使用
category: aosp
layout: post
---
* content
{:toc}

# install repo
Android是一个特别大的软件项目，我们只有在git的管理基础上再进行一次封装。
在Ubuntu上安装repo一般有两种方案，一种是源码，不过这种方案我没有成功；第二种方案是直接通过命令`apt install repo`即可。
[link](https://blog.csdn.net/sunweizhong1024/article/details/8055372)
[link](https://blog.csdn.net/yasin_lee/article/details/5975068)
# 初始化一个库
在我的工作场景下是使用这么一个命令的。
## repo init
```bash
repo init -u ssh://yubo@10.12.130.5:29418/platform/manifest -b zhimo-mr1-dev  --repo-url=ssh://yubo@10.12.130.5:29418/tools/git-repo --reference=/home/local_mirror
```
这里有很多重点，需要简单地记录下。其实，一个简单的repo是这样的：
```bash
repo init -u https://aosp.tuna.tsinghua.edu.cn/platform/manifest
```
请不要在意URL，这玩意一通百通。如果需要某个特定的 Android 版本[列表](https://source.android.google.cn/setup/start/build-numbers#source-code-tags-and-builds):
```bash
repo init -u https://aosp.tuna.tsinghua.edu.cn/platform/manifest -b android-4.0.1_r1
```
因为我们的开发分支是xx,所以不太一样，这一点需要注意。
初始化成功的界面如下:
```bash
repo has been initialized in /home/user/src
```
在上面的第一条命令中，需要关注的就是`-b`和`--reference`选项，后者是指向了一个本地仓库，这样就能大大减轻服务器的压力，这个参数的作用还可以体现在下载内核源代码时。

和直接从Gerrit服务器下载相比优点如下：

	代码下载时间大大缩短，基本上就是直接checkout了。

	节省虚拟机磁盘空间，因为git相关的二进制文件都链接到镜像中了

	降低Gerrit负载

可以用 -m 参数来选择获取 repository 中的某一个特定的 manifest 文件，如果不具体指定，那么表示为默认的 namifest 文件 (default.xml)
```bash
repo init -u git://android.git.kernel.org/platform/manifest.git -m dalvik-plus.xml
```
假设，我的分支是别人已经更改过的，那么，我想使用原生的安卓源代码，怎么办？加个参数：

```bash
-m aosp_base/android-10.0.0_r20.xml
```

### 情景2；
这里有一个问题，比如我clone aosp代码时指定的是` -b r20`,但是，当在开发途中，突然告知要
切换到r25版本（这里的r25只是一个分支名字，实际中可以叫任何一个名字）。那么，我就删库从头下
吗？事实上是不必的，在aosp的root目录下，重新指定分支即可.
```c
repo init -u ssh://yubo@10.12.130.5:29418/platform/manifest -b zhimo-mr1-dev --reference=/home/local_mirror
```
这里是不会覆盖的，而且，在我的测试的时候，在一个分支上重新下载分支，同步时还会默认使用之前的标志，比如,自动更新：
```git
repo sync -cdj4 --no-tags
```
当所有的项目切换到新的分支上，这个`sync`就已经完成了.但是，如果你在本地的代码上有一些改动，则会提示：
```git
Fetching projects: 100% (747/747), done.
art/: discarding 1 commits
bionic/: discarding 1 commits
build/blueprint/: discarding 1 commits
build/make/: discarding 1 commits
build/soong/: discarding 3 commits
```
你肯定不希望自己辛辛苦苦修改的代码完全丢弃了啊，那么如何更新呢?


那么，如何完成代码的同步更新?

# 同步
一个标准的命令是:

```bash
repo sync
```
我们用的命令是：

```bash
repo sync -cdj4 --no-tags
```
这样就可以不必下载过多的tag

# git push commit
江湖救急，将`git push`这个命令放在这里以备不时之需。
```c
git push origin HEAD:refs/for/git-repo-branch
```
在aosp中，进入到每个repo中，前期的操作与正常的git操作是一模一样的，只是在提交
commit的时候,使用上面的命令，后面的repo branch要和相匹配的git repo branch相对应。

# 应用
使用命令:
```bash
du -h --max-depth=1
```
看一下这个工程的大小：
```bash
user@host037-ubuntu-1804:~/src$ du -h --max-depth=1
677M	./.repo
76M	./art
44M	./bionic
15M	./bootable
15M	./build
1.4G	./cts
26M	./dalvik
405M	./developers
132M	./development
1.8G	./device
7.7G	./external
1.9G	./frameworks
185M	./hardware
1.2M	./kernel
84M	./libcore
372K	./libnativehelper
773M	./packages
752K	./pdk
4.5M	./platform_testing
32G	./prebuilts
27M	./sdk
500M	./system
398M	./test
102M	./toolchain
1.7G	./tools
50G	.
```
一些版本控制的信息在`.repo`目录下。
需要重点关注下，`.repo/`目录下`manifest.xml`文档，它记录了整个项目的构成什么的。

# repo info
这个命令提供了一个全局的git库的概述，主要包括各个分支在某个仓库的情况，如下：

```bash
vimer@host:~/src/aosp_art/art$ repo info 
Manifest branch: zhimo-aosp
Manifest merge branch: refs/heads/zhimo-aosp-d_art
Manifest groups: all,-notdefault
----------------------------
Project: platform/art
Mount path: /home/vimer/src/aosp_art/art
Current revision: 9e22b01ffc829a3cdf9e66e07d6afd30eb1e3a7e
Local Branches: 5 [vimer_dev, run_test_yuzhen, run_test_0817, assembler_dev, fmv-s_dev]
```
# 目录分析
以art为例，与art有关的代码是：
1.art目录  2. libcore目录，包含 jdk相关源代码  3.libnativehelper目录，包含JNI相关代码
4. `frameworks/base/cmds/am、frameworks/base/core、frameworks/base/include`目录，包含Zygote相关的源代码。

