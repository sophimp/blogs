---
title: Gradle 插件开发
date: 2021-08-06 17:52:49
tags: 
- Android
- Gradle Plugin
categories:
- Gradle
description: Gradle 插件开发记录
---

## gralde 插件开发
1. 脚本插件

直接在build.gradle中编写，通过apply from 来引用
2. 对象插件

通过插件全路径类名或id引用，主要有三种形式
- 在当前构建脚本下直接编写
- 在buildSrc 目录下编写
	
默认插件目录, 会在构建时自动打包编译，添加到classpath中, 不需要任何额外的配置就可以被其他模块中的gradle脚本使用, 同样可以发布。

buildSrc执行时机早于setting.gradle, 
setting.gralde中无需配置buildSrc，否则会当成子项目，执行两遍

- 在完全独立的项目/模块中编写

setting.gralde 中声明子模块

3. 架构

生命周期函数, 

4.  依赖库
apt, annotation process tools
AspectJ, 
asm, 
字节码

5. 调试方法

如何代码跟踪，debug调试

6. ComponentCornerstone 插件 
虽然知道是实现与sdk分离， 但是如何做到调试多个应用呢？ Demo如何跑起来呢？

## 资源
1. [深入探索编译插桩技术（三、解密 JVM 字节码）](https://juejin.cn/post/6844904116603486222)
2. [深度探索 Gradle 自动化构建技术（四、自定义 Gradle 插件）](https://juejin.cn/post/6844904135314128903)
3. [如何读懂晦涩的Class文件](https://yummylau.com/2020/07/27/%E5%A6%82%E4%BD%95%E8%AF%BB%E6%87%82%E6%99%A6%E6%B6%A9%E7%9A%84%20Class%20%E6%96%87%E4%BB%B6%EF%BD%9C%E8%BF%9B%E9%98%B6%E5%BF%85%E5%A4%87/)
