---
title: jectpack-compose.md
date: 2021-09-09 17:28:33
tags:
categories:
description: 声明式UI，命令式UI，重组，幂等，各种新名词，完全重做了一套UI框架，不同以之前的View,ViewGroup架构。
---

# Compose

前端各种技术变更，关键还是思想的学习, jetpack 套件, LiveData, Lifecycle, ViewModel, Composed, 基于MVVM的思想，声明式UI。

MaterialTheme, Scaffold, 都是已经提供了的控件，我现在要做的就是学习这些控件的使用，至于后续再如何定制，那是使用起来的事情，使用官方的控件，肯定也能将应用做起来。

不同于View架构体系， 那是如何渲染的呢？ 

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

## @Composable

标注Compose框架的基本编译单元，对象是 fun 或者 lamda, 不仅仅可以表示UI，也可以表示中间件

@Compoable 会改变被标注方法或lamda的属性，方法只能被 @Composable方法调用
带有隐示参数 composable context, 在同一个逻辑树中，context 可以用来传递信息

## 管理状态

状态提升是一种将状态移至可组合的调用方法以使可组合项无状态的模式
那么长的一个篇幅下来，肯定有很多干货，状态用来干什么，数据的刷新，与恢复

remember 做了什么事情，如何处理生命周期
	
	Composables.kt 是扩展文件, 是对Composer接口的扩展
	通过SlotTable缓存状态信息


## Modifier

如何使用Modifier, 嵌套布局Modifier 需不需要传递， 如何传递

## 附加效应(负面影响)

为什么负面影响叫作附国效应，名字取的我云里雾里，是我见识太少了， 还是我太笨了，领悟比较慢。

## 链接

[官方文档](https://developer.android.com/jetpack/compose/semantics?hl=zh-cn)
