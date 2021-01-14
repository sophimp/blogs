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
netconf定义了一套机制, 用来安装，操作，删除网络设备的配置。使用xml来承载协议信息，为分层内容提供了灵活但完全指定的编码机制。
[rfc 6241 netconf中文翻译](https://tonydeng.github.io/rfc6241-zh/)
[rfc 6020 yang model](https://tools.ietf.org/html/rfc6020)
yang model是一种数据模型语言，被用来为netconf, netconf远程调用(rpc, remote procedure calls), Notifications操作的配置和状态数据进行建模。
yang 包含了netconf 的xml rpc 的协议, 可以使用工具转换成相应的xml形式。 
ssh
ssl

[netconf call home介绍](https://tonydeng.github.io/2017/11/28/netconf-call-home/)

sysreop 一套存储yang文件的数据库框架
netopeer 模拟的服务端， 客户端实验环境

netconf 从概念上分为四层
	content, 不在文本范转之内，被期望用于分别开展标准化netconf数据模型的工作。
	operations, 定义了一套基本协议操作, 作为带有xml编码参数的RPC方法调用。
	messages, 为编码RPC和Notifications提供一个简单的， 与传输无关的帧机制
	secure transport, 提供客户端与服务端的通信路径。

	yang 是为指定netconf数据模型和协议操作而开发的，涵盖了operations 和 content层。

基于netconf的通信流程是什么？ 
	先建立tcp连接， 再建立ssh连接，再建立netconf session, 然后发送`<hello>`信息，交换能力。

netconf是xml的，为什么yang model要重新定义语言模型。
yang model 是承载于neconf吗？ 
netconf是如何基于ssh 通信的?
需要移植哪几个库？
放到ctms端，是使用文件数据库，还是使用数据库。 

xml 与 model对应转换的库

model 与 数据库对应转换的库

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

出错误的核心思想是看日志， 找不到啥库就下载。

### rpc model
`<rpc>` 用于封装从客户端发到服务端的netconf请求。 有一个强制属性 message-id
```xml
<rpc message-id="101"
     xmlns="urn:ietf:params:xml:ns:netconf:base:1.0">
  <my-own-method xmlns="http://example.net/me/my-own/1.0">
    <my-first-parameter>14</my-first-parameter>
    <another-parameter>fred</another-parameter>
  </my-own-method>
</rpc>
```

`<rpc-reply>` 响应`<rpc>`操作, 有一个强制属性 message-id, 还必须包含`<rpc>`中一切额外的属性。
```xml
<rpc message-id="101"
     xmlns="urn:ietf:params:xml:ns:netconf:base:1.0"
     xmlns:ex="http://example.net/content/1.0"
     ex:user-id="fred">
  <get/>
</rpc>

<rpc-reply message-id="101"
     xmlns="urn:ietf:params:xml:ns:netconf:base:1.0"
     xmlns:ex="http://example.net/content/1.0"
     ex:user-id="fred">
  <data>
    <!-- contents here... -->
  </data>
</rpc-reply>
```

`<rpc-error>` 放在 `<rpc-reply>`中发送

`<ok>` 处理 `<rpc>`请求期间没有发生错误或警告, `<ok>` 元素将放在 `<rpc-reply>` 消息中发送。

受管的设备必须按照请求的顺序发送响应。

### 子树过滤

子树过滤器
	* 名字空间选择
	* 属性匹配表达式
	* 包含节点
	* 选择节点
	* 内容匹配节点

### 能力

`<hello>`信息中携带能力信息。 

### 总结

netconf 是使用xml 进行交互的可配置语言，提供了一些默认的操作，get-config, edit-config, replace-config, delete-config等等。 
netconf 是一种协议标准，这种标准形式寄托于xml语言实现。 主要用于实现社备间的远程通信。 

子树过滤， 能力， 选择器这些，是针对NMS系统与服务设备间通信业务必要性，可扩展性设计的。

### 资料文档
[github-libnetconf2](https://github.com/CESNET/libnetconf2)
[github-libyang](https://github.com/CESNET/libyang)
[github-libNetpeer2](https://github.com/CESNET/Netopeer2)
[github-sysrepo](https://github.com/sysrepo/sysrepo)
[libssh](http://git.libssh.org/projects/libssh.git)
[netopeer2 笔记](https://miaopei.github.io/2020/09/22/Netconf/sysrepo-netconf-node/)
