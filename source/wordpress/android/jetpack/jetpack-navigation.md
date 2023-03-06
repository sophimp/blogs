---
title: Jetpack Navigation
uuid: 208
status: publish
date: 2021-01-26 19:36:42
tags: Jetpack, Navigation
categories: Android
description: Navigation 可以代替Arouter吗？
---

### 是什么
[官方文档](https://developer.android.com/guide/navigation)

开始为了解决Fragment导航困难的问题， 现在也加上了Activity的导航， 看完Navigation, 还是得再看一看Arouter。

Navigation不仅仅是解决跳转困难的问题， 而是与Toolbar, DrawerLayout, BottomDrawerLayout 结合起来，朝图形化设计方向行进。类似xcode的StroyBoard

所以，这些控件并不是高高在上，只是实现了某个场景下的功能，然后被官方采用了而已。 其他的代码不都是这样

### 为什么
为跨各种应用，不同屏幕之间提供一致的导航体验。

处理Fragment事务
默认情况下，正确处理往返操作
为动画和转换提供标准化资源
实现和处理深层链接
包括导航界面模式(抽屉式导航栏和底部导航)，用户只需要完成极少的额外工作。
Safe Args, 是一个gradle插件，可以目标之间导航和传递数据时保证类型安全
ViewModel支持， 可以将ViewModel的范围限定为导航图，以在图表的目标之间共享与界面相关的数据。
Android Studio 提供了Navigation Editor 查看和编辑导航图。

### 架构

导航图
	在<navigation>标签内部
	用来显示跳转流程视图。 
NavHost
	管理应用导航对象
NavController
	每一个NavHost都有相应的NavController, View, Fragment, Activity都提供了findNavController方法
NavDestination

如何配置跳转
	使用代码跳转 NavController.navigate
	使用NavigateUI进行跳转
	
看源码的难度就在这里， 一层套一层的封装， 有些确实没必要的，封装的越厉害，使用的场景就越加局限。
所以， 核心看什么呢？ 实现最原始功能的控件。使用Toolbar的局限性也比较大， 因此会定制TitleBar, 使用已有的控件， 继承自AppCompatActivity, 可以保证在以前的系统上UI的兼容。
如何导航， 
	NavController
		使用id,
		createNavigateOnClickListener
		顶部Toolbar和底部导航栏结合NavigationUI来更新组件
		NavAction导航
		DeepLinkRequest
		navigateUP, popBackStack方法分别入栈出栈
如何维护Fragment栈
如何传参
绑定了NavigationUI， 如何传参？ 

### 原则

确保用户在各应用之间切换时能够使用相同的启发法和模式进行导航。

固定起始目的地
导航状态表示目的地堆栈
向上按钮绝对不会使用户退出您的应用。
	深层链接跳转到应用, 向上按钮也不会退出应用，返回按钮才会退出返回到深层链接的应用。

深层链接可模拟手动导航
	合成返回堆栈必须是真实的, 会被替换成目标页面的起始导航堆栈。 
