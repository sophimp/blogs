---
title: compose-Navigation
date: 2022-09-09 17:00 
tags:
- Compose
- Navigation
categories:
- Compose

description: 导航库, 也是路由库，跨平台, 不能使用官方的库
---
## 带着问题学技术

不想想那么多，就是干，路由库也有很多了，各大厂百花争艳, 最先接触的还是ARouter, 然而现在已经放弃了维护。
再然后就是 Navigation, 当然简单地以为就是针对Fragment的，看官方的英文的文档, 
然后就是货拉拉的TheRouter

是我太菜逼了，路由的概念理解的少。
路由框架，本质上是借鉴路由器的概念, 路由器是负责将数据包传递到目标服务。
uri, url有什么区别？这两个概念说起来当初也是困扰了我很久
定义的一种数据形式。url 是广泛被熟知的一种URI实现
协议，主机名，端口，路径，查询字符串，片段标识符

scheme 是uri的一部分，协议+冒号

就是根据路径，跳转到不同的页面。

1. compose 中 navigation 是如何工作的?

如何去维护状态跳转，如果全部缓存的话，会不会内存泄露呢？

使用Stack, 缓存状态， 根据动作，改变Navigator 触发重组

push, pop 的实现看不到, knm是反编译生成的代码, 想看源码，需要关闭java bytecode decompiler

2. deeplink是什么意思

用于通过链接直接打开某个页面或执行特定的操作，而不用从头开始一级级打开某个页面

3. 传参如何实现

路由的核心能力：
解耦UI跳转，降低系统依赖

## Navigation

路由功能，与底部导航功能还是有所区别

Router 需求：
	
	状态保存
	栈操作
	过场动画

底部导航需求：

	选中突出
	动态布局
	切换过渡动画
	信息Badge

技术选择

	放弃Decompose, 使用PreCompose, Moelcule 更合口味

	ViewModel 是如何保证作用域的？ 绑定作用域？


2023-08-25 17:47
突然将 Navigation 的源码看明白了
NavHost, 

用于提供root composable

NavGraphBuilder, 构建所有的 composable 函数, 保存在一个list中

改变 NavController 的 currentDestination 来触发重组, 选择不同的 composable, navigate 与 popBackStack 本质上就是模拟 Stack 入栈出栈操作

可以做到更兼容的方式, 需要人来写的. 使用百分比的方式, 更方便一些? 

SaveableStateHolder


## 使用

Compose 如何动态布局

LiveData 里如何使用@Composable

添加 runtime-livedata 库

compose-compiler, 配置 composeOptions

编译报错:

1. void org.jetbrains.kotlin.gradle.dsl.KotlinJvmOptions.setUseIR(boolean)
版本不匹配, AS, gradle-plugin, compose, compose-compiler, kotlin 都更新到当前稳定版本

```kotlin
composeOptions {
	kotlinCompilerExtensionVersion = "1.3.0"
}
kapt("")
```



