
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
看完好像搞懂了， 但是又说不出个所以然
实现 Provider接口，
ContentProvider
我还是需要先将chatGPT的内容copy下来，靠我自己去记录，没有必要

### compose, composer, composition, composable

有多次composition, 每个composition 有一个composer
remember 向 Composition 插入一个 State 
一个@Composable 对应一个 Group 吗？纠结这样的细节有用吗？ 只需要知道 remember 向 Composition 中插入一个值，可以缓存的值不就行了？

毫无疑问， compose与Android View 的体系关联不大，源码对于我来说，都是全新, 但是view的经验也有一定的指导意义。

### Surface
干嘛用的, 为什么页面的外面要套一层Surface
如果不用MaterialDesign，是不是不是就不用Surface了？
Compose 又是如何剪裁的, 写一篇blog不是轻松的事，特别是在自己还不会的情况下，
Surface 的作用：
Clipping, Borders, Background, Content Color
每一个 组件都能套一个Surface么

为什么要用contract包一下 

NodeChain, Modifier.Node

还是很有激情的， 大佬走在前面，我也只能按我的节奏来，跟着大佬的脚步走。

边做边写，肯定是效率最高的，通过我这几十年的经历来看，为什么呢？ 这个效率是针对整体效率，而不是开发效率。
一个产品，开发只占1/3，或许还不到，最终要的是变现，营销，哪怕是不变现，想图个名，也得营销。
所以，大部分人的综合能力，还是有短板的，人之常情，精力有限，兴趣有偏向，做起事来，肯定是反人类的居多。
不能卖惨，因为后面还得凹人设，还想走科技的路线。

### 绘制原理
compose 用路由这一套，放在一个Activity 中， 随着加载的层级越多， 会不会影响到计算效率。
Navigation 会不会隔离, 测量的时候，会不会所有的LayoutNode 都会测量呢？
多个Activity 会不会效率更高一些呢？

## kotlin

设计需要什么样的情况呢？

函数式编程，我都忘记要怎么去写代码了，top函数是都翻译成静态函数了吗？ top变量也成了静态变量，top变量过多会不会导致内存泄露呢？ 
java是以类的方式带组合代码，习惯是文件名与类名相对应，但是kotlin 是以文件的形式来组织代码
top函数/变量，扩展函数， data数据结构，大都是放同一个文件中。

新的架构模式，mvi 是怎么操作的
这里面涉及到的flow, state, LocalProvider 都是新概念，且都是前置条件，无形中提升了门槛

## MaterialTheme

遵循这套机制，换纯色的肤是方便的

## 环境搭建

版本匹配：android 这一块，升级的时候，比较烦人的便是版本问题，不同版本，兼容不好，那真是一个灾难
[AGP 与 gradle 版本匹配](https://developer.android.com/studio/releases/gradle-plugin?hl=zh-cn)

## FAQ

1. `EXCEPTION_ACCESS_VIOLATION (0xc0000005) at pc=0x00007ff8b5ec28be`

换了机器, 装得是官方系统, 一直报这个错误，最后发现是设置了 WindowsStyle 出了问题，
期间尝试手段： 补装了VC++Redist各种库, CPU的各种配置也都打开了，GPU 是AMD的RX580 2480SP, 下载各版本的jdk

