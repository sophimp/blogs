---
title: netconf协议
date: 2021-01-06 10:02:19
tags:
- nms
- netconf
categories:
- nms
description: 公司项目需要做一个nms(Net Management System)网管系统, 需要使用netconf, yang 通信。虽然专业相关性不强，但本着学习协议设计的思想，那就验证我所认为的编程的相通性吧。
---

### 是什么, 为什么, 怎么做, 为什么
[rfc 6241 netconf](https://tools.ietf.org/html/rfc6241#section-10.3) 
netconf定义了一套机制, 用来安装，操作，删除网络设备的配置。使用xml来承载协议信息。netconf协议操作通过远程调用实现。
[rfc 6020 yang model](https://tools.ietf.org/html/rfc6020)
yang model是一种数据模型语言，被netconf, netconf远程通信(rpc, remote procedure calls), netconfig 通知(notifications)用作配置和状态数据操作建模。
ssh
ssl

[netconf call home介绍](https://tonydeng.github.io/2017/11/28/netconf-call-home/)


为什么netconf是xml的，yang model要重新定义语言模型。
yang model 是承载于neconf吗？ 

### 开源库
先将netopeer2编译跑起来，看一看是什么工具

需要依赖的库很多libssh, libnetconf2, libyang, libsysrepo, 选择直接安装，又出现了版本不匹配问题, libssh, libnetconf2, libyang, 这些库直接编译， 也会有依赖库缺失问题。

cmake 工程， 可以生成visual studio。

libssh安装最新的ppa

```sh
sudo add-apt-repository ppa:kedazo/libssh-0.7.x
sudo apt-get update
```
编译安装依赖库 
```sh
# 换清华或阿里源
sudo apt install zlib1g zlib1g-dev libssh-gcrypt-dev build-essential cmake libssh-dev
```

[netopeer2使用](https://blog.csdn.net/qq_27923047/article/details/108001624)
```sh
netopeer2-server -d -v 2 
```

[netconf配置](https://support.huawei.com/enterprise/zh/doc/EDOC1000178403/258c27a0)

libnetconf2 如何使用, 看来主要是移植这个库就行了。 

运行错误 
`[ERR]: NP: Module "ietf-netconf" feature "writable-running" not enabled in sysrepo.`
[解决办法](https://github.com/CESNET/netopeer2/issues/652)

`[ERR]: SR: mkfifo() failed (Operation not permitted)`
[解决办法](https://github.com/microsoft/WSL/issues/3195)
[improved wsl](https://devblogs.microsoft.com/commandline/chmod-chown-wsl-improvements/)
```sh
# 将所有的/mnt 下的windws盘都重新挂载一下， 就可以正常启动了。
sudo umount /mnt/c sudo mount -t drvfs C: /mnt/c -o metadata
```
`nc ERROR: Unable to connect to localhost:830 (Connection refused).
cmd_connect: Connecting to the localhost:830 as user "root" failed.`
[解决办法](https://github.com/CESNET/netopeer2/issues/579)
登陆失败， 检查服务端是不是因为登陆失败产生segmentation fault 挂掉了。
这里并不是用户认证的问题， 而是服务端挂掉了， 导致ssh 通道关闭，如何拿到server端的具体的日志？

`Failed to open "/sr_ietf-netconf-acm.running" (Permission denied).`

### 资料文档
[github-libnetconf2](https://github.com/CESNET/libnetconf2)
[github-libyang](https://github.com/CESNET/libyang)
[github-libNetpeer2](https://github.com/CESNET/Netopeer2)
[github-sysrepo](https://github.com/sysrepo/sysrepo)
[libssh](http://git.libssh.org/projects/libssh.git)
[netopeer2 笔记](https://miaopei.github.io/2020/09/22/Netconf/sysrepo-netconf-node/)
