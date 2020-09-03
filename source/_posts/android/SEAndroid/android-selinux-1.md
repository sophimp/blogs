---
title: Android SELinux 系列(一)
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

### 术语

DAC:	Discretionary Access Control, 自主访问控制
MAC:	Mandatory Access Control, 强制访问控制
TE:		Type

