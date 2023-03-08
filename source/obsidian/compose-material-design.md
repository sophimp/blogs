---
title: compose material design
date: 2022-09-06 18:00 
tags:
- Material Design
- Compose
categories:
- Compose
description: Material Design, 一种设计风格与标准，不管是View体系还是Compose体系，官方SDK都提供了这套标准下的组件，便于UI的开发
---

## 前言

如今有了一定的开发经验, 明白了Android开发大概是怎么回事，基础知识与自学能力都有一定的积累，有想法与信心去从头学一学Android开发。

Blog还是需要写的，写作能力很重要，需要刻意练习。我改如何突破写作技巧，多看多练多思考, 要耐心

写程序，写blog, 写小说，是真的需要考虑多个方面的，作为新手，

Compose 也仅仅实现了比较常用的组件(控件)效果, 不追求花里胡哨的效果，也够组装一个应用了，剩下的效果，需要自定义

分工合作的时候对Material Design 还没有什么感觉，工作的环境大都是公司请了自己的UI来设计界面，如今想实现自己的UI的时候，才发现Material Design确实能在保证UI质量的前提下，节省不少时间的

遵守Material的空间，换肤也是非常容易

## Surface 与 Scaffold 的区别

Surface 责任:

	剪裁: Clipping
	阴影: elevation
	轮廓边界: Border
	背景: background
	内容颜色: contentColor 给Text, Icon提供默认颜色

Surface 可以用与任何组件的父布局, 不限于页面的根布局使用, 相当于CardView的作用

Scaffold
	类似于 CooridinateLayou的角色，用于 Child Component的协作
	如 TopAppBar, FloatingActionButton
	其他场景的 BackdropScaffold, BottomScaffold

## Material Theme

也是一个Composable, 

直接套在组件外面? 
可以单独套组件, 子组件不设置的话，默认使用父组件theme

## 使用
	
就使用原生的，不使用 Dagger 和 Hilt, 后面再考虑自定义或者第三方库



