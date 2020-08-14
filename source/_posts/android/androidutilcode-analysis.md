---
title: AndroidUtilCode 框架分析
date: 2020-07-22 20:41:05
tags: 
- 开源框架
categories: 
- Android
description: AndroidUtilCode 作者对其框架公开的有三篇介绍， 但是gradle版本更新比较快, 当前版本的gradle(6.1.1) 并不能无缝使用，且当前代码与example 也有些出入。此文主要记录将这个框架应用到个人项目， 移植到android 4.0.1 的过程。
---

## 项目理解

根据原作者的三篇文档介绍, 
[AucFrame 之简介](https://blankj.com/2019/07/22/auc-frame/)
[AucFrame 之让你的Gradle 更智能](https://blankj.com/2019/07/23/auc-frame-smart-gradle/)
[AucFrame 之统一管理Gradle](https://blankj.com/2019/07/24/auc-frame-manage-gradle/)
大概知道AucFrame 的架构原理, 然而这些应用到实际项目还是需要一定的学习的。 

AucFrame 的架构核心点在比较齐全的工具类， gradle 开发定制, BusUtil与ApiUtil两个插件。
gradle 更新较快， 我使用的版本说是支持到 gradle6.0， 然而在 gradle 6.1.1 上已经不能正常编译过, 某些接口已经发生了变化。 
因此，需要继续阅读源码，将其应用到个人项目中。 

计划分几个步骤来解析源码:

1. gradle 的定制
2. 如何应用到个人项目
2. BusUtils 分析
3. ApiUtil 的分析

### Gradle 定制

1. 如何使用gradle 进行插件开发?

gradle 开发相关的资料从哪里找？ 

	[Gradle Get Started](https://gradle.org/guides/#getting-started)
	[Gradle User Manual](https://docs.gradle.org/current/userguide/userguide.html)
	[Gradle 用户指南官方文档中文版](https://doc.yonyoucloud.com/doc/wiki/project/GradleUserGuide-Wiki/gradle_plugins/README.html)

利用gradle 构建的生命周期，预留出来的接口。

	buildSrc 模块是gradle 第一个执行的入口

计算机里通用的思想: 甭管什么框架， 什么系统， 都是先提供一个上下文环境， 而开发工作都是在这个环境中来工作，所以，既然是一个运行时环境，
那么就有环境里预质的变量和功能，扩展接口，二次开发也都是基于此来开发。

如何基于这个思想来学习框架呢？ 

找到入口函数， 生命周期，提供的环境变量，扩展的接口。 至于学习语言的语法，提供的api 有了业务思路以后, 都是可以现学现卖的。
至于语言以及其提供的基础库，也无外乎那几个套路，最本质的东西还是算法和数据结构。

计算机学习的套路
如何按照这个套路来学习新的框架技术
完全的新手如何去学，
	先用起来， 人的学习是多元化感知的，仅仅靠文字表述，还是缺少了很多信息，使用过程，视觉听觉, 综合性的信息，就会掌握一种知识， 这是一个小孩的成长，

有一定的基础的同学如何去学。

2. 定制的思想

版本统一管理

	插件，依赖库，编译工具版本，gradle 版本

签名

app 与 lib module 分开管理, 自由选择调试的包与模块

	库依赖是如何解决的呢？ 全部依赖好会好吗？ 

自动命名，签名功能

多渠道，多版本

### 应用到个人项目

那么多静态方法， 好吗？


## BusUtils 分析

## ApiUtil 的分析
