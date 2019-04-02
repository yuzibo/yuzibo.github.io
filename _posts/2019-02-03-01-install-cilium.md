---
title: "安装cilium"
category: cilium
layout: post
---
* content
{:toc}

# 安装记录

## 安装Minikube
[turorial](https://cilium.readthedocs.io/en/latest/gettingstarted/minikube/)

1. install kubectl && minikube
```c
Use the Kubernetes command-line tool, kubectl, to deploy and manage applications on Kubernetes. Using kubectl, you can inspect cluster resources; create, delete, and update components; look at your new cluster; and bring up example apps.
```
kubectl[here](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl)很明显不能通过正常途径下载成功，只能使用github的二进制文件。
[github](https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG.md#client-binaries-1)选择**Current release**,点击进去选择**Dowdloads for v1.14.0**,
也就是你刚才看到的current release版本中的**Client Binaries**. [选择](https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG-1.14.md#client-binaries)对应的系统版本。然后就是解压，将"/bin"文件中的kubernets的kubectl可执行文件mv到/usr/local/bin文件夹下。　

```c
 kubectl version
Client Version: version.Info{Major:"1", Minor:"14", GitVersion:"v1.14.0", GitCommit:"641856db18352033a0d96dbc99153fa3b27298e5", GitTreeState:"clean", BuildDate:"2019-03-25T15:53:57Z", GoVersion:"go1.12.1", Compiler:"gc", Platform:"linux/amd64"}
The connection to the server localhost:8080 was refused - did you specify the right host or port?
```
这样就是ok的了。

## minikube
[here](https://kubernetes.io/docs/tasks/tools/install-minikube/),还是那个问题，现在应该切换到[github](https://github.com/kubernetes/minikube#other-ways-to-install)
我使用的是**.deb**包，这里你也可以使用

```c
yubo@debian:~/cilium$ minikube version
minikube version: v1.0.0
```
Goal of minikube: Our goal is to enable fast local development and to support all Kubernetes features that fit. We hope you enjoy it!
