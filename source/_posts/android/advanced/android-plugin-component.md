---
title: Android插件化与组件化
date: 2020-07-22 20:41:05
tags:
- 插件化
- 组件化
- Android
categories:
- Android
description: 插件化与组件化已经成为了Android 开发的标配技术, 

---

## 技术背景

### gradle

是什么，为什么，怎么做

gradle 是用来编译构建的工具， 支持多种语法。 编译构建这一行为， 也是一项工程, 有多种构建工具， 使用不同的语言， 提供不同的方式， 支持不同的工具。编译构建是生成可执行文件的前期工作。

### 组件式开发

组件式开发主要是为了解耦， 各模块可以独立编译，可以相互组合，相互通信。 


## AUC 项目分析

[AUC项目源码](https://github.com/Blankj/AndroidUtilCode)

原作者对此框架相关的文章:
[AucFrame 之简介](https://blankj.com/2019/07/22/auc-frame/)
[AucFrame 之让你的Gradle 更智能](https://blankj.com/2019/07/23/auc-frame-smart-gradle/)
[AucFrame 之统一管理Gradle](https://blankj.com/2019/07/24/auc-frame-manage-gradle/)
[比EventBus 更高效的事件总线](https://blankj.com/2019/07/22/busutils/)
[一学就会的模块间通信](https://blankj.com/2019/07/22/busutils/)

为何还是要再分析一下呢？ 
	主要原因是我看完上面几篇文章还是不能明白, 也无法顺利应用到AS4.1(Gradle6.1.1)版本. 
	我看不明白原因， 一是对gradle插件开发技能不熟悉， 二是根据作者画的框架图，以我现有的能力不能实现出来。
	因此，我希望提供一个新手用户的角度分析一下这个框架的视角, 提升自己, 同时希望能帮助后来人。

### 要解决什么问题

模块间通信
模块内通信

### 用什么技术实现

通过整个编译过程来分析, 为何要有构建工具来管理项目呢？ 

### 如何使用AUC及其优缺点

AUC主要还是一种思想， 可以完全按照其模板结构来搭建框架， 那样gradle脚本就不用大肆修改。
当然也可以自己定制，那么就需要更系统的学习gralde脚本开发技术。 


1. config.json 中的appConfig, pkgConfig, proConfig 都是用来干什么的

setting.gradle 中主要还是根据config.json 中的配置来include 工程, 同时更新Config.java中 `/*Never` 之间的的内容 

 config.json 中的 pkgConfig, 对应的配置是模块的业务层pkg
 config.json 中的 appConfig, 对应的配置是模块的启动调试入口app, 整个app真正的入口只有一个

appConfig 与 pkgConfig中的优先级大于 proConfig, 所以，打开与关闭哪些app与具体的业务是在这两个数组中配置
其他lib库是在proConfig中配置的

2. 各模块间的配置

根本编译的那套流程还是复用Android 本身的DSL脚本, 定制的逻辑在 buildApp.gradle 和 buildLib.gradle 中, 主要是针对dependencies 进行定制

各模块是否还需要依赖? 
	依赖就偶合了，那也没有必要进行组件式开发了， 但是共公lib库还是需要依赖的, 带有具体的业务逻辑的模块可以解耦

每个模块的export, pkg, app 都是什么角色？ 

可解耦模块间的通信是如何做到的?

	BusUtils 解决了数据的传递, 传递的bean对象是否还是需要抽取出公共模块依赖呢？ 

	ApiUtils 解决了不同模块间页面的跳转 

最后编译apk的时候不还是要将所有的模块都编译进来?
	这个环节在setting中就配置好了, 是将所有的模块都编译进来，只要对应的模块可以编译通过，那就是好的OK的

3. 

4. 优缺点
优点:
1. 做的很智能，只需配置config.json 即可完成组合
2. 相比于ARouter, WMRouter, 结构更加简洁, 对于个人项目，足够了。
3. 通用的功能还是挺多的，工具类，分享模块，登陆模块，用户信息管理模块等都是多个app可以共用的。

静态工具类确实很方便, 使用那么多静态方法好吗？ 

缺点:
1. Android Studio 中build.gradle相关的一些常用的插件功能不能正常使用
2. 还不支持androidx, 也不能使用android studio中迁移的androidx工具
3. 编译的时候慢了很多， 内存消耗了更多。 当然，相比于同时打开几个Android Studio 还是要消耗还是要小一些的。

[androidx 迁移库工件映射](https://developer.android.google.cn/jetpack/androidx/migrate/artifact-mappings)

4. 个人

就目前的了解来看，组件式开发， 相当于将多个app放在一个Project 下。由于多个app相关与不相关性，技术通用性, git管理等因素，因此涉及取舍问题:
持术通用性少的不相关app 要不要放在一个工程？ 模块独立git管理，是不是又要写一个工具，类似于aosp那样。
对每个模块的解耦能力要求更加高了

#### gradle插件开发

生命周期
[Gradle构建生命周期和Hook技术](https://juejin.im/post/6844903607679057934a)

特殊对象, 传参

应用场景与需求

groovy 语法的学习
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

2. DSL语法原理

[DSL语法原理与常用API介绍](https://www.jianshu.com/p/8250a5d2e109)

3. 定制的思想

版本统一管理

	插件，依赖库，编译工具版本，gradle 版本

签名

app 与 lib module 分开管理, 自由选择调试的包与模块

	库依赖是如何解决的呢？ 全部依赖好会好吗？ 

自动命名，签名功能

多渠道，多版本

#### 模块间通信

## 其他插件化框架

## 其他组件化框架

[美团开源WMRouter](https://github.com/meituan/WMRouter)
[美团外卖Android开源路由框架](https://tech.meituan.com/2018/08/23/meituan-waimai-android-open-source-routing-framework.html)

## 总结

