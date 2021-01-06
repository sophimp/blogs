---
title: Android Gradle 学习
date: 2021-01-04 21:19:24
tags:
- Android
- Gradle
categories:
- Android
description: 随着项目越来越大，参与的人数越来越多，在项目构建，自动化集成, 打包, 测试这一块，少不了要深入Android的学习，这里就记录Android Gradle 项目构建相关知识。 
---

### 疑问

build.gradle 脚本中的那些DSL语言从哪里学习?
有一个[博客](https://www.cnblogs.com/dasusu/p/6650782.html)解答了我的疑问, 但是该博客是解决了查看源码的问题。系统的学习还是得去看gradle文档。 

[gradle dsl document](https://docs.gradle.org/6.7.1/dsl/)

gradle 与 groovy

	gradle是使用groovy编写的， groovy 是脚本语言， 兼容java, 可以直接使用jdk的类。 
	groovy 也是很秀, 如何做到兼容java, 直接使用java的库应该是解释器是运行在jvm中的? 定义语言的那些人， 着实厉害。
	不过我更想做菜就是了。 

Android 的组件化，插件化，编译期代码注入, 都得深入gralde编程

gradle 版本更新比较快， api更新也比较快，学习也最好捡最新Android Studio 匹配的版本学习。 

直接从缓存的gralde src 中打一个jar包放到缓存路径下还不行，会导致Android studio 都启动不了。 删除disabled_plugins.txt 

gralde 与 Android Studio的对应关系

	classpath 'com.android.tools.build:gradle:4.1.1' 后面的版本号与AndroidStudio的版本号对应。 
	grade文件夹会自动生成最新版本的gradle配置。

	理论上， 直接配置gradle/wrapper/gradle-wrapper.properties中的gradle版本， 也可以下载。但是不能确定

### 定制gradle脚本
gradle 构建流程

### 奇怪的坑点

win10 的热点wifi也会影响AndroidStudio 4.1.1版本的编译错误： 中断一个已有的连接。 必须关掉wifi热点，然后invalidate cache and restart 才能再次编译通过

compiler Command-line Options, 设置 --encoding utf-8 不识别
