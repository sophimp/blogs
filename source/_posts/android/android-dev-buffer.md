---
title: Android开发琐碎
date: 2021-01-23 11:37:01
tags:
- Android
categories:
- Android
description: 这两年主要玩Android系统与网络，对于应用层的开发有些陌生。然而现在终究是要靠应用技术吃饭，因此，借着重新学习Jetpack，做自己项目的机会，将Android应用层开发技术学习的过程记录下来, 后续再归纳整理成可读性更高的blog。
---

### 背景

这两年主要玩Android系统与网络，对于应用层的开发有些陌生。然而现在终究是要靠应用技术吃饭，因此，借着重新学习Jetpack，做自己项目的机会，将Android应用层开发技术学习的过程记录下来, 后续再归纳整理成可读性更高的blog。

主要方针是，首要先学会如何使用, 初步理解原理，阶段性的整理成blog。

### 积累
-  AppCompatActivity

使用ActionBar, 包括action items, navigation 节点, 更多的ToolBar设置的api
内置 Dark 和 Light 主题
集成DrawerLayout

继随自AppCompatActivity的Activity必须设置Theme.AppCompat 下的主题。

-  ActionBar, Toolbar

Toolbar 是ActionBar的类属， ActionBar是主要的具体实现，用来显示标题，Application级别的一致性的导航，和交互的条目。

Toolbar 包含的元素，导航按钮，品牌logo, 标题与副标题，一个或多个自定义view, 行为菜单

ActionBar 是针对整个应用的？ 若将ActionBar 当作Activity专有的，需要设计NoActionBar主题。
setLogo 用来替换默认的主页导航图标

- Window
抽象类，提供标准的UI策略, 如背景，标题区域，默认的按键事件处理。只有一个实现类 PhoneWinodw。

作为最顶级的View视图，添加到WinodwManager中。

- CoordinateLayout, AppBarLayout, CollapsingToolbarLayout, NestedScrollView, 

CooridinatorLayout, 加强版的FrameLayout, 用于两个场景:
	1. 作为顶层级的Application装饰或chrome布局
	2. 作为专有的与一个或多个子view交互的容器。
	交互的方式由Behavior定义
	每个子view有一个anchor, anchor所通信的id是Coordinatorlayout中的任一子view, 但不能是自己或者自己的子view, 这可以放置浮动的view相对于其他任意的内容。
	dodge InsetEdge 可以在重叠的时候适当移动而避免重叠。

AppBarLayout
	是一个垂直的LineageLayout, 实现了matirial design app bar 概念的特性，即滚动手势。
	子view通过setScrollFlags(int)和xml的属性app:layout_scrollFlags来提供滑动的特性。

CollapsingToolbarlayout
	用来包装 Toolbar, 实现折叠效果。被设计成直接用作AppBarLayout的子view

NestedScrollView
	默认支持嵌套手势的ScrollView

CoordinatorLayout这一套是沉浸式布局的实现， 提供了固定的几种效果。我前期倒是用不上。 后绪再研究吧。

- AppBarConfiguration, NavigationUI, NavUtils

- ViewBinding
```gradle
android{
	// android 4.0.-
	viewBinding {
		enabled = true
	}
	// android 4.0.+ 
	buildFeatures{
		viewBinding = true
	}
}
[viewbinding inclue](https://juejin.cn/post/6844904065655111693)
```

- T extend Object, ? super Object

extend 只能读取子类, super 只能写子类。 根本思想是只能向上转型。

