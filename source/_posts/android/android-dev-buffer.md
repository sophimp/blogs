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

- widget, launcher, Activity的关系

manifest文件由PM描述，然后在aws中注册，通过launcher是跳转到入口Activity, 但是通过widget, notification, 可以跳转到app中任何一个Activity。
aws是如何找到对应的Activity呢？直接按路径加载, 这样启动的Activity会不会开启进程, 走不走zygote

- 依赖与关联，聚合与组合

依赖与关联，是从代码角度，根据变量生命周期 划分

聚合与组合，从业务角度，根据现实从属关系 划分, 从代码角度，封装性不同,

依赖、关联、聚合、组合， 耦合度依次增加, 代码表现形式上都是关联的表现形式，作为局部变量或成员变量

- classpath, apply 与 dependencies
classpath 用来加载插件, apply 使用插件
denpendencies 用来加载库

- enum的使用

enum最好不要使用其构造函数，可以使用一个Builder或者Impl来实现业务，这样在使用enum的时候，跟踪代码就比较方便。空间的增加可以忽略。
不推荐使用枚举的源头是《阿里巴巴java开发手册》，强制，枚举可用于参数，不可以用于返回值，在于版本升级，返回值会产生序例化错误。
我还是认同，这是反序例化库的问题，并不是java枚举的问题。枚举还是很好用的.

- qmui

theme 观念， 产品观念

- 音视频

学习哪门技术，都得下心思，解决一个算一个
不管理应用开发，还是音视频，都是庞大的知识体系。还是得有所决择
深入音视频，更有前景一些，因此UI上的细节不必过于追究



