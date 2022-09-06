---
title: compose material design
date: Tue 06 Sep 2022 06:00:39 PM CST Tuesday
tags:
- Material Design
- Compose
categories:
- Compose
description: Material Design, 一种设计风格与标准，不管是View体系还是Compose体系，官方SDK都提供了这套标准下的组件，便于UI的开发
---

## 前言

以前我一直忽略了 Material Design, 工作的环境大都是公司请了自己的UI来设计界面，所以，Material Design 的组件应用反而少了。

如今有了一定的开发经验, 明白了Android开发大概是怎么回事，基础知识与自学能力都有一定的积累，有信心与想法去从头学一学Android开发。

Jetpack Compose, Kotlin, Android开发，优化，学习的过程中，一直不知道该去怎么写blog, 那就从 Compose Material Design Component的学习开始吧。

Blog还是需要写的，写作能力很重要，需要刻意练习。我改如何突破写作技巧，多看多练多思考, 要耐心

Compose 也仅仅实现了比较常用的组件(控件)效果, 不追求花里胡哨的效果，也够组装一个应用了，剩下的效果，需要自定义

## Surface 与 Scaffold 的区别

Surface 责任:

	剪裁: Clipping
	阴影: elevation
	轮廓边界: Border
	背景: background
	内容颜色: contentColor 给Text, Icon提供默认颜色

Surface 可以用与任何组件的父布局, 不限于页面的根布局使用

Scaffold
	类似于 CooridinateLayou的角色，用于 Child Component的协作
	如 TopAppBar, FloatingActionButton
	


