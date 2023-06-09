
---
title: compose 积累
date: 2023-03-08 12:18
tags: 
categories: 
description: 
---

# compose 学习 临时积累

## Compose 数据流动

函数的数据流入有两种形式: 
1. 访问类的成员变量
2. 以参数的形式传递

流出也有两种形式
1. 更改Scope类的变量
2. 以返回值的形式返回

而Composable是一个特殊的函数，可以承载页面，组件

真正学进去了，哪里不会学哪里，只要开始学，总有学完的那一天。

ComposeLocalProvider
composeLocalOf

compose 是函数，而作为一个函数，数据的流动

### compose 如何与 skia 结合起来的

ComposableAndroidView

View draw 方法
	canvasHolder.draw() -> LayoutNode.draw

### SlotTable 是全局只有一个吗

本来就是Composable 传参， 所以应该是一个应用只有一个

### State, Scope是怎么处理的

State 的值写入触发重组, ParcelableSnapshotMutableState

Snapshot, 维护一堆state, 初始值都是一样的
Snapshot获取, currentSnapshot, 优先返回线程，线程没有，返回全局的
管理State的

大部分都直接写在文件里的变量，怎么保障Scope的？

compose的渲染, 看完了原理，还是不晓得怎么去开发, 最终都是调用canvas画，底层当然可以用其他引擎画。

Scope, Layer, 都是一种抽象，DrawScope, 将画绘制区域的上下文抽取出来

看原理还是有点犯困， 怎么去解决这个问题。

函数式编程： 
	闭包，作用效果记录了一个方法的入口，这个方法可以调用函数作用域里的变量，然后计算出结果, 共享作用域里的变量
	
	还是有些不适应函数式编程

在Composable 函数里，传参的时候就会构建渲染树，Layer, LayoutNode, 最终的动画实现还是依靠于动画函数，改变canvas上的内容。一秒画60+次

> 明确耗时操作，不耗时操作，耗时操作放在任务线程里去, 主线程只负责刷新UI, 一直存在一个误区，总怕计算机算不了那么快, 对这一块没有明确地概念

知道这些原理，我接下来该怎么走？SqlDelight还是要继续，PreCompose框架还是要搞明白

composition state

### composeLocalOf
看完一遍，又忘记这个是干什么的了

### compose, composer, composition, composable

有多次composition, 每个composition 有一个composer
remember 向 Composition 插入一个 State 
一个@Composable 对应一个 Group 吗？纠结这样的细节有用吗？ 只需要知道 remember 向 Composition 中插入一个值，可以缓存的值不就行了？

毫无疑问， compose与Android View 的体系关联不大，源码对于我来说，都是全新, 但是view的经验也有一定的指导意义。

## kotlin

设计需要什么样的情况呢？

## MaterialTheme

遵循这套机制，换纯色的肤是方便的

## 环境搭建

版本匹配：android 这一块，升级的时候，比较烦人的便是版本问题，不同版本，兼容不好，那真是一个灾难
[AGP 与 gradle 版本匹配](https://developer.android.com/studio/releases/gradle-plugin?hl=zh-cn)

## FAQ

1. `EXCEPTION_ACCESS_VIOLATION (0xc0000005) at pc=0x00007ff8b5ec28be`

换了机器, 装得是官方系统, 一直报这个错误，最后发现是设置了 WindowsStyle 出了问题，
期间尝试手段： 补装了VC++Redist各种库, CPU的各种配置也都打开了，GPU 是AMD的RX580 2480SP, 下载各版本的jdk

