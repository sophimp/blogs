---
title: 组件化开发
date: 2021-08-12 11:06:00
tags:
- 组件化
- Gradle插件
categories:
- 组件化
description: 一直在积累自己的App, 但是一直纠结困惑于框架的搭建, 随着Android的发展，到如今组件化是我比较认可的架构和方式，借着再次起航博客之机，就以组件化的学习来开始尝试新一轮的博客写作方式。
---

### 组件化和插件化

插件化和组件化这两个概念困惑了我许久。

现如今的理解：
插件化发展是受`免发版，热修复, 热更新`的需求而兴起的一门技术，主要思路是利用dex的 class 加载机制, 但是受限于Android系统和应用市场的限制, 日渐势微，但是其技术确实有黑科技的味道，有借鉴意义。

组件化发展是应用演进的趋势, 随着各行各业的龙头APP稳定下来，APP的形式必然会有共通的地方，遵循`高内聚，低耦合`的原则，这些共通的地方便逐渐演进成组件。同时，拆分成组件后，也能加快大项目的编译速度。

### 我想要的组件化

已造出的轮子，尽可能地复用。
各组件随意组合，尽可能少地做重复工作。
各组件间，最小程度耦合。

### 从哪里入手

[YummyLau/ComponentCornerstone](https://github.com/YummyLau/ComponentCornerstone)

此控件满足描述基本满足我想要的组件化,
不足的是组件化仍旧需要从业务和技术上双重保证, 硬件的解耦如果全部采用

### 具体的实施步骤
1. 用起来
- 单独调试每个库

	targetModuleName 调试模块入口
	targetDebugName 调试资源文件目录
	@AutoInjectImpl(sdk = [])
	@AutoInjectComponent(impl = [])
	component.gradle 中的include, exclude 与 setting 中在多层级创建的时候也不完全保持一致

- 拆分sdk

面向接口编程

- 调用sdk

implement component

- 资源库隔离

sourceSets

2. 特性疑问
- :: 这样的语法支持吗？

得看源码了
	
- pins 何用

### 总结