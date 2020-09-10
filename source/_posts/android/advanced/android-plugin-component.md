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
	因此，我希望提供一个新手用户的角度分析一下这个框架的视角, 提升自己的同时希望能帮助后来人。

### 要解决什么问题

达到组件化开发, 必须模块解耦, 因此得解决模块间通信, 模块间页面跳转问题。
所谓组件式开发, 是将各模块可实现最小功能(不可再拆分)，可以灵活快速组合成一个功能不同的应用。此时各最小功能的模块便是组件, 可以单独作为一个应用测试。

### 用什么技术实现

grrovy语言开发
gradle插件开发

### 如何使用AUC

AUC主要还是一种思想， 可以完全按照其模板结构来搭建框架， 那样gradle脚本就不用大肆修改。
当然也可以自己定制，那么就需要更系统的学习gralde脚本开发技术。 


1. config.json 中的appConfig, pkgConfig, proConfig 都是用来干什么的

setting.gradle 中主要还是根据config.json 中的配置来include 工程, 同时更新Config.java中 `/*Never` 之间的的内容, 用于builLib.gradle 中依赖的配置

 config.json 中的 pkgConfig, 对应的配置是模块的业务层pkg
 config.json 中的 appConfig, 对应的配置是模块的启动调试入口app, 整个app真正的入口只有一个

appConfig 与 pkgConfig中的优先级大于 proConfig, 
打开与关闭哪些app与具体的业务是在 appConfig 与 pkgConfig 这两个数组中配置, 为空，默认所有的pkg 与 app模块都不编译。 多人合作的话，务必将这两个数组保持为空， 各人配置自己的模块开发。
其他库模块是在proConfig中配置的, proConfig 是全配置，export，pkg, app, lib 都需在时面配置好， appConfig 与 pkgConfig 也必须是proConfig中有的。

2. 各模块间的配置

根本编译的那套流程还是复用Android 本身的DSL脚本, 定制的逻辑在 buildApp.gradle 和 buildLib.gradle 中, 主要是针对dependencies 进行定制

各模块是否还需要依赖? 
	依赖就偶合了，那也没有必要进行组件式开发了， 
	但是共公lib库还是需要依赖的, 带有具体的业务逻辑的模块可以解耦

每个模块的export, pkg, app 都是什么角色？ 

	通用lib库是通过依赖顺序是 common -> base -> subutil -> utilcode
	其他业务库
		export模块 都依赖 通用lib库 common
		pkg 和 mock 模块都依赖 config.json 中配置的 apply=true 的 export模块
	
	这里重复依赖的问题由gralde 解决，会使编译的速度变慢, 
	全面依赖肯定会有多余的类，会使编译速度变慢，但是多余的类和多余的方法会在混淆时由proguard优化掉
	export库是各模块间的通信耦合暴露引用对象, 可以通过BusUtil来依赖注入

	app模块依赖
		跟据Config.pkgConfig 来依赖所有的pkg模块

最终编译， 所有的模块还是需要依赖且放在一起的
	app模块 --(依赖)--> pkg模块 --(依赖)--> export模块 --(依赖)--> common模块
但是每个模块又可以分开测试, 框架复用了 lib 和 app库的gradle, 将配置工作集中在了 config.json 中
因此模块间的通信也是有必要的，就像EventBus 避免了接口回调地狱, 也将各模块间的耦合性降低了。
	每个模块必须有一个export, 否则就不能依赖 common lib库

遵循单一原则，开放封闭原则，依赖倒置原则, 里氏替换原则，接口隔离原则，最少感知原则

可解耦模块间的通信是如何做到的?

	BusUtils 解决了数据的传递, 传递的bean对象是否还是需要抽取出公共模块依赖呢？ 

	ApiUtils 解决了不同模块间页面的跳转 

最后编译apk的时候不还是要将所有的模块都编译进来?
	这个环节在setting中就配置好了, 是将所有的模块都编译进来，只要对应的模块可以编译通过，那就是好的OK的

3. debug模式下, applicationIdSuffix 与 resValue问题

> APT: error: attribute 'package' in <manifest> tag is not a valid Android package name: 'com.sophimp.android.cook-studio.debug'
	
	`applicationIdSuffix ".debug"`, 
		在原有的applicationId 加一个后缀, 可以针对不同的flavor, 不同的 buildType, 让多代理商，调试版本与发布版本共存
	`resValue "string", "app_name", Config.appName + suffix` 
		用于传参, 第一个表示类型，第二个是参数名称，第三个是参数值
	
	上面的错误与这两个属性设置没关系，是包名中不能有中划线

4. 静态工具类确实很方便, 使用那么多静态方法好吗？ 

	静态方法与静态变量在程序初始化的时候就会加载到内存, 如果有很多方法后续没有被使用，会加大内存负担与程序运行负担(现在大内存的情况下，这个影响并不是很严重，且添加混淆后，也会去除没有引用的静态方法)
	静态变量在多线程或多处修改时，安全性不能保证。
	静态方法也只适合工具类，适合实现可重入的方法，
	静态方法是面向过程的，意味着面向对象的特性就没法使用了。
	静态方法不会被回收，所以容易引起内存泄漏。
	所以， 必要的工具类，对整个项目性能的影响可忽略。

5. AUC的使用感受

 移植到项目中后，创建模块更加灵活，因为build.gralde可以复用，所以只需要创建特定名字的文件夹, 在config.json中配置即可。
 使用到了插件开发的buildSrc模块，可以将build.gradle的书写达到提示效果。
 相比于ARouter, WMRouter, 结构更加简洁, 便于学习，对于个人项目使用, 足够了。
 原项目暂时还不支持androidx, 暂时没用上AndroidStudio自带的迁移工具(可能是我不会用吧), 纯手工移植过来的。

 [androidx 迁移库工件映射](https://developer.android.google.cn/jetpack/androidx/migrate/artifact-mappings)

 编译的时候慢了很多， 内存消耗了更多。 当然，相比于同时打开几个Android Studio 还是要消耗还是要小一些的。
 mock层为每个组件提供了测试模拟环境
 pkg用来装载组件的业务功能
 export库是各模块间的通信耦合共享引用的对象
 app用来作为测试入口

 对于多个项目，还是分开放在多个工程里， 多个项目中功能相同的模块，采用独立git维护，然后每个项目再写一个脚本工具，类似于aosp的repo来管理是最好的。
 没必要将不同的项目放在同一个工程里，那样维护起来也麻烦。这里面主要的问题就是共用模块的问题。

#### gradle插件开发

1. groovy 学习

gradle 开发相关的资料

[Gradle Get Started](https://gradle.org/guides/#getting-started)
[Gradle User Manual](https://docs.gradle.org/current/userguide/userguide.html)
[Gradle 用户指南官方文档中文版](https://doc.yonyoucloud.com/doc/wiki/project/GradleUserGuide-Wiki/gradle_plugins/README.html)
[Developing Custom Gradle Plugins](https://docs.gradle.org/current/userguide/custom_plugins.html)

生命周期
[Gradle构建生命周期和Hook技术](https://juejin.im/post/6844903607679057934a)

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
	先用起来， 人的学习是多元化感知的，仅仅靠文字表述，还是缺少了很多信息，在 用过程，会增视觉听觉感觉等综合性的信息，下意识就会全面掌握一种知识。

2. DSL语法原理

[DSL语法原理与常用API介绍](https://www.jianshu.com/p/8250a5d2e109)

3. 定制的思想

build.gradle复用，
dependency的智能填充
多渠道，多版本实现
自动打包命名，签名功能

#### 模块间通信

## 其他插件化框架

## 其他组件化框架

[美团开源WMRouter](https://github.com/meituan/WMRouter)
[美团外卖Android开源路由框架](https://tech.meituan.com/2018/08/23/meituan-waimai-android-open-source-routing-framework.html)

## 总结

