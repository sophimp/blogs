
---
title: Android 11+ 存储权限适配
date: 2022-10-10 11:13
tags:
- Android
categories:
- Android
description: Android 11+ 权限适配, 是时候适配一波权限了，不能读取其他应用的数据
---

## 可访问的目录获取

## 限制访问的目录

数据库访问

targetSdkVersion 

	告诉系统使用什么版本, 所运行的系统低于此版本，就会走系统的兼容代码？
	那么不升级targetSdkVersion, 对于强制升级的功能就没法用，对于有兼容代码的功能，则不影响正常功能使用，关键在于，兼容代码也是会砍掉的。过旧的兼容代码会增加系统的复杂性，且没有意义

什么时候才有余力去学习官方文档的技术呢？
前期还是看开源代码，效率更高些，有一定积累，有闲了，再系统研究官方文档，开发新技术的应用

## 参考资料

[targetSdkVersion](https://developer.android.com/guide/topics/manifest/uses-sdk-element)

[管理存储设备上的所有文件](https://developer.android.com/training/data-storage/manage-all-files)
