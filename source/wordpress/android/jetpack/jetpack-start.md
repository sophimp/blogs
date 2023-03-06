---
title: Android Jetpack框架
uuid: 199
status: publish
date: 2021-01-04 14:12:28
tags: Android, Jetpack
categories: Android
description: Android Jetpack, 多个库组成的套件, 可以理解为重构后的 support 库
---

### 介绍

[官方文档](https://developer.android.com/jetpack?hl=zh-cn)

开源的好处就是可以衍生出很多“项目官方”精力之外的优秀框架，而一些优秀框架就反哺官方团队再次集成优化。 Jetpack就是官方吸收一些优秀的框架的思想, 然后集成到官方版本并再次优化， 继而试图统一规范？ 
刚好我个人的项目还在初期， 所以， 使用Jetpack 来继续接下来的开发，是一举多得。

### 架构

![](https://upload-images.jianshu.io/upload_images/8718569-0eba2b011f653e1c.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

jetpack 目前(2021/1/4)为止共有85个控件， 有以前的，有新增的, 分为了Architecture, Foundation, Behavior, UI 四个方向

Architecture
	架构相关组件
	Lifecycles, 管理Activity和Fragment生命周期
	LiveData, 在底层数据库更改时通知视图， 具备生命周期感知能力的数据订阅、分发组件。
	ViewModel, 数据存储组件，通常和DataBinding配合使用，我感觉将数据绑定放在xml视图是一个不好的架构，我认为不好的， 我可以不使用。
	Room, 轻量级 orm 数据库， GreenDao也是过时的项目了。
	DataBinding, view和data之间双向绑定的工具
	Paging, 列表分页组件, 可完成一次加载和显示一小块数据。
	Navigation, 端内统一路由组件
	WorkManager, 管理Android后台作业。

Foundation
	基础组件, 提供横向功能： 向后兼容性，测试，安全，Kotlin语言支持
	Android KTX, 优化了Kotlin使用Jetpack和Android平台的API
	AppCompat, 较低版本系统兼容
	Auto, 提供了车辆标准化界面和用户交互
	检测, 从AndroidStudio中快速检测基于Kotlin或Java的代码
	安全, 安全读写加密文件和共享偏好设置
	测试，用于单元和运行时界面测试的Android测试框架
	TV, 构建可让用户在大屏幕上体验沉浸式内容的应用的库
	Wear OS: 可穿戴设备应用的组件


Behavior
	通知，权限，分享
	CameraX
	DownloadManger
	媒体和播放
	通知
	权限
	偏好设置
	分享
	切片, UI模板
UI
	动画和过渡
	表情符号
	Fragment
	layout
	platte

### jetpack库版本查询

[jetpack releases](https://developer.android.com/jetpack/androidx/releases)

在上面的库上查询， 到目前为止， 一直保持更新。

### 学习计划

1. 避开眼高手低的误区

上来就给原理搞清楚，学完原理就完成一篇博客。 这个误区叫做眼高手低。
先学会用，记录关键信息， 然后再深究原理, 整理成博客。

2. 取舍
废弃掉基于[blankj设计的AUC框架](https://github.com/Blankj/AndroidUtilCode)搭建的工程，至少对于我个人项目来说, 有些过渡设计。且新版本的AndroidStudio 4.1.1 + gradle 6.5， 需要做一些适配，而我对gradle不熟，暂时对于个人项目来说也没有这个需求。 

Android 4.1.1 已经支持了创建模块使用 `:` 语法多路径创建，这个特性够个人项目的规划使用了。

3. 从头开始
基于Android Studio 4.1.1, gradle6.5, kotlin 1.4.21, jetpack, UI风格完全使用MaterialDesign。
学习jetpack库，积累技术，造轮子，分享开源。

4. 后续计划
做一个视频sdk, 基于每一个比较大的Android发行版，持续维护, 保持技术学习。

### 总结

Jetpack 是google基于各大优秀的开源框架的思想及百家争鸣的现状， 试图统一开发规范而将Android sdk 和 support库整理，删减，新增，优化， 统一重构到andoridx.*库包下, 
整个Jetpack库贯穿整个应用开发, 可以从四大块方便学习记忆， Architecture, UI, Fundation, Behavior, 相当于新的support 库套件。

