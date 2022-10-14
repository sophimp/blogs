---
title: jectpack compose
date: 2021-09-09 17:28:33
tags:
- Compose
categories:
- Compose
description: 声明式UI的理念我很认可，kotlin 的编写体验也很爽，jvm的跨平台能力我也很挺认可，所以我希望Compose能发展起来，我也决定投入Compose的学习。
---

## 带着疑问

1. Declarative UI 与 Imperative UI
2. 不同于View架构体系，是如何渲染的呢?
3. 效率如何?
4. 算法实现, Composeer, SlotTable, GapBuffer
5. 跨平台的技术选择?

前端各种技术变更，关键还是思想的学习,jetpack 套件, LiveData, Lifecycle, ViewModel, Composed, 基于MVVM的思想，声明式UI。


MaterialTheme, Scaffold, 都是已经提供了的控件，我现在要做的就是学习这些控件的使用，至于后续再如何定制，那是使用起来的事情，使用官方的控件，肯定也能将应用做起来。


函数当参数这个特性可太灵活了，大部分都是 ()->Unit, 可以简写成{}, 实际还是kotlin的语法，但是像dsl的样子了。

现有了解:
响应式框架，底层仍旧是基于canvas渲染，再底层就是对接skia, skia提供的api就是canvas
skia 是一个2D引擎
会简单地使用，Row, Column, Modifer(控制布局属性), Text, Composable
基本的套路还不清楚: 合成规则, Button如何使用，列表如何使用， 如何看源码, Composable如何复用，布局如逻辑如何解耦
Flow, LifeCycle, ViewModel, kotlin, 协程，这些也都会影进度
动画如何使用, TextField 如何使用, 最基本的编辑器，在这上面会有如何改进

compoable 可以与 原有的渲染框架相互交互吗？ 还是说只能单向兼容

BaseText, BaseTextField, SelectionContainer
看上去，感觉更加强大？
如果能结合上 markdown 的开源框架，将展示与编辑合二为一，将有更多的可能啊

## 解决疑问

1. Declarative UI 与 Imperative UI

声明式 与 命令式

两者都是数据驱动UI, 区别在于： 
声明式UI 是根据状态，由框架来决定UI的显示与隐藏, 而命令式UI，需要自己根据状态，手动制定UI的显示与隐藏 
Jetpack Compose框架帮忙做了很多显示与隐藏的逻辑
我觉得这个减少了开发的心智负担，但是降低了渲染效率, 好比 cpp 与 java 的内存回收的比如一样。由JVM决定内存回收，必然对性能就是一个考验。
能否普及起来的标准是，compose算法与硬件算力的发展是否能和用户体验保持平衡。
用户体验不是需要极致的效率，如：24帧，用户就感知不到卡顿，所以，为了开发效率，compose是值得期待的。

2. 不同于View架构体系，是如何渲染的呢?
渲染同样是需要经历 measure, layout，canvas render
主要区别在于 measure前的准备工作与UI插入删除, 导致的measure 效率

3. 效率如何?

开发效率: compose要更高一些
渲染效率: 在加载 xml 文件这个IO环节，提升了效率，但是在 compose, recompose 决定measure layout 的环节要比View架构的效率低

4. 算法实现, Composeer, SlotTable, GapBuffer


5. 跨平台的技术选择?


### @Composable

标注Compose框架的基本编译单元，对象是 fun 或者 lamda, 不仅仅可以表示UI，也可以表示中间件

@Compoable 会改变被标注方法或lamda的属性，方法只能被 @Composable方法调用
带有隐示参数 composable context, 在同一个逻辑树中，context 可以用来传递信息

### 生命周期


### 管理状态

状态提升是一种将状态移至可组合的调用方法以使可组合项无状态的模式
那么长的一个篇幅下来，肯定有很多干货，状态用来干什么，数据的刷新，与恢复

remember 做了什么事情，如何处理生命周期
	
	Composables.kt 是扩展文件, 是对Composer接口的扩展
	通过SlotTable缓存状态信息

	* 
如何管理全局状态？必须要通过参数么

	现在想封状一个BaseActivity, 动态设置标题Icon, 发现就有些问题

### Modifier

如何使用Modifier, 嵌套布局Modifier 需不需要传递， 如何传递

## 附加效应(负面影响)

为什么负面影响叫作附国效应，名字取的我云里雾里，是我见识太少了， 还是我太笨了，领悟比较慢。

## 复盘总结

整体印象

	Compose

效率问题
	
	如何知道写的UI Compose会重组几次呢？ 
	重组会调用的生命周期
	
重组的核心原理
	
如何写系列文章？

	技术连贯性
	技术体系 -> 映射的是思维体系 -> 经验（记忆）
	开篇是最后才发表的

## 链接

[官方文档](https://developer.android.com/jetpack/compose/semantics?hl=zh-cn)

[Understanding Jetpack Compose](https://medium.com/androiddevelopers/understanding-jetpack-compose-part-1-of-2-ca316fe39050)
[Under the hook of Jetpack Compose](https://medium.com/androiddevelopers/under-the-hood-of-jetpack-compose-part-2-of-2-37b2c20c6cdd)
