---
title: 快速了解 Gradle 插件开发
date: 2021-08-06 17:52:49
tags: 
- Android
- Gradle Plugin
categories:
- Gradle
description: 随着开发的资历越来越深， 所要求的技术栈同样也越来越广(深)，于今越来越多的开源库都涉及到Gradle插件的开发，各种黑科技，生产力工具都离不开Gralde。
---

## gralde 插件开发
1. 如何入手
先看视频或blog, 站在前人的肩膀上，将会走得更远。
上来就看文档的效率还是比较低下的，作为开拓者，那是没办法。
但是最后肯定还是以官方文档和代码为主

2. 什么是脚本插件

构建过程，提供hook方法用于影响构建过程, hook脚本即为插件。

有两种形式:
I. 直接在build.gradle中编写

通过apply from 来引用

II. 对象插件

通过插件全路径类名或id引用，主要有三种形式
- 在当前构建脚本下直接编写
- 在buildSrc 目录下编写
	
默认插件目录, 会在构建时自动打包编译，添加到classpath中, 不需要任何额外的配置就可以被其他模块中的gradle脚本使用, 同样可以发布。

buildSrc执行时机早于setting.gradle, 
setting.gralde中无需配置buildSrc，否则会当成子项目，执行两遍

- 在完全独立的项目/模块中编写

setting.gralde 中声明子模块

3. 架构

生命周期: 初始化，配置,  执行

setting.gralde 初始化脚本

project, 每一个build.gralde解析的对象

task: 每一个task都会经历 初始化，配置，执行生命周期, task 可被执行多次


4.  依赖库
apt, annotation process tools
AspectJ, 
asm, 
字节码

5. 调试方法

如何代码跟踪，debug调试

6. ComponentCornerstone 插件 
虽然知道是实现与sdk分离， 但是如何做到调试多个应用呢？ Demo如何跑起来呢？

7. groovy
闭包， lamda表达式，底层的表示可推测成是一个可别名的函数
基础变量，字符串，控制语句
数据结构
方法，类，metaClass
文件，json, xml解析

8. gradle 小结

连续看gradle文章，大脑有些麻木了， 跟不上思路，需要主动思考总结一下。

JsonChao产出效率很高, 关键是质量也不错, 真得是牛逼，就是我在看的时候，心态就比较急功近利，也思考不出一个比较好的练习项目，学习这玩意，先搭个大体的框架，知道从哪里查，从哪里学，把握整体的架构，不能太离谱。然后再找一个项目实战，哪里不会查哪里。

真正开发起插件，大概跟xposed差不多了，有些实现是很原始，hook每一次的遍历, 然后再注入修改，修改字节码也有现成的框架可以使用, 所以，关键体现实力的反而是一些小工具上

整体的构建流程

web, python, gradle, cmake, 任何一种语言，都有Runtime Environment

为何他能写出这么好的博客？
已经有了这些优秀的博客了，我需要怎么写，才能将我所学习的过程给呈现出来呢？

以问答的形式呈现, 没有目标，无差别地看blog, 效率是比较低的。

以ComponentCornerstone 源码，来看文档。

ExtensionContainer: 为一个对象添加DSL语法支持

## 资源
1. [深入探索编译插桩技术（三、解密 JVM 字节码）](https://juejin.cn/post/6844904116603486222)
2. [深度探索 Gradle 自动化构建技术（四、自定义 Gradle 插件）](https://juejin.cn/post/6844904135314128903)
3. [如何读懂晦涩的Class文件](https://yummylau.com/2020/07/27/%E5%A6%82%E4%BD%95%E8%AF%BB%E6%87%82%E6%99%A6%E6%B6%A9%E7%9A%84%20Class%20%E6%96%87%E4%BB%B6%EF%BD%9C%E8%BF%9B%E9%98%B6%E5%BF%85%E5%A4%87/)
4. [深度探索 Gradle 自动化构建技术](https://juejin.cn/post/6844904132092903437)
5. [【灵魂七问】深度探索 Gradle 自动化构建技术](https://juejin.cn/post/6844904142725447687#heading-4)
