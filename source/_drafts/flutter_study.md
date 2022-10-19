---
title: flutter
date: 2022-09-19 18:38 
tags:
- Flutter
categories:
- Flutter
description: flutter 学习
---

## flutter

选型flutter，我觉得并不明智，但是给时间学一学倒也无所谓，对比这学习

标题栏，优先使用官方库, 官方库不满足再考虑定制

Stateful, Stateless Widget主要区别是什么
	
> The State is the information that can be read sycnchrously when the widget is built and might change during the life time of the widget.
> In other words, the state of the widgets is the datas of the objects that its properproties(parameters) are sustaining at the time of its creation(when the widgets is painted on the screen).

	StatefulWidget 和 StatelessWidget 都是不可变的
	StatefulWidget 可变的是重写createState, State 中 提供 setState() 方法主动刷新, build方法会调用多次
	StatelessWidget build 方法只会调用一次, 刷新只能靠外部的重刷

virtualDOM 原理是什么，实现相关类有哪些
	从dom这一点看，跟web端思路相近
	React 中是 virtualDOM, Flutter 中也有吗？

渲染流程，自定义控件原理

## dart

构造函数的参数需要`{}`包起来，而且可以当做成员变量

	这个语法糖与kotlin的想法是一致的，语法表现形式不一致

aync, await 

	异步操作

Stream

	java 中也有Stream, kotlin中有Flow
	Stream的出发点是什么？不会爆内存，但是也会有缓存, 并发

构造函数

	有语法糖，可以手动赋值，可以结合final, this.field

lambda

	可以带 `=>` 也可以不带

## 环境配置

直接打开flutter 工程，android 的相关应用都找不到，另外开一个窗口，直接打开Android工程即可

## 控件

1. 权限
2. 图片选择
3. 弹窗
