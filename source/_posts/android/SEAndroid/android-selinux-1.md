---
title: Android SELinux 系列(一) 背景，作用，原理
date: 2020-07-31 17:03:08
tags:
- SELinux
- Android
categories:
- Android
description: 在ROM移植过程中, 卡在启动流程里，是最难受的事， 没有串口调试，拿不到相关的日志，只能靠猜，SELinux 的配置，是否会导致启动不起来呢？ 最后的结果是，靠猜并没有解决启动问题，因为可能出问题的环节太多了，此次研究raw socket 调用同样也遇到SEAndroid 的问题, 但借此机会，系统的学习一上SEAndroid, SELinux 是有必要的。
---

## Android SELinux 

[android seolicy 官方文档](https://source.android.com/security/selinux/customize)

sepolicy.te 文件使用的是[M4语言](https://www.gnu.org/savannah-checkouts/gnu/m4/manual/m4-1.4.18/index.html)

[SELinux 简析与修改](https://www.cnblogs.com/blogs-of-lxl/p/7515023.html)

### 是什么

### 为什么

### 怎么做

### 相关术语

DAC:			Discretionary Access Control, 自主访问控制
MAC:			Mandatory Access Control, 强制访问控制
TE文件:			安全策略配置文件, Type Enforcement Access Control
LSM:			Linux Security Module, linux安全模块
audit2allow:	查看有哪些地方违返权限的地方

### 安全策略配置文件

安全策略配置文件 是通过m4, checkpolicy等工具来编译的

file_context:	记载了不同目录初始化的SContext， 和object_r有关
seapp_context:	和应用程序打标签有关
property_contexts:	和属性服务(property_service)有关, 为不同的属性打标签 

编译流程是怎么样的，为何要打标签?

作用范围 

	文件操作，接口调用， 功能特性
