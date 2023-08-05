---
title: Compose-SlotTable
date: 2023-07-28 06:31
uuid: 
status: draft
tags: Compose, SlotTable
categories: 编程，Android
description: 
---

# Compose 的实现原理

从@Composable 函数入手, 用函数来表达UI，
1. 如何实现的？
2. 有什么优劣
3. 如何选择

函数的特点：作用域，形参放栈内存

SlotTable

GapBuffer

Snapshot

	提供 registerGlobalWriteObserver, registerApplyObserver, 是用来触发重组的吗？

	GlobalSnapshotManager.ensureStarted()，实际上就是通过 Snapshot 状态改变通知 Composition 重组

NodeTree

LayoutNode

编译器支持, 添加了 $composer

	$composer.startRestartGroup
	$composer.endRestartGroup

幂等函数

	幂等函数和可重入函数并不完全相同。

	可重入函数是指在多线程或并发环境下，可以被安全地重复调用的函数。重复调用不会引发竞态条件或产生不正确的结果

	幂等函数是指一个操作无论执行多少次，结果都是一样的，而可重入函数是指一个函数可以被安全地重复调用。

	幂等函数可以被视为可重入函数的一种特殊情况，但可重入函数不一定是幂等函数。

remember, State

	composer#cache
	核心逻辑就是通过SlotReader 和 SlotWriter 操作 SlotTable 存储数据，而且这些数据是可以跨 Group 的

SideEffet, DisposableEffect, LaunchedEffect (React hook)

	SideEffect，实现方式比较简单，调用流程是 composer#recordSideEffect -> composer#record， 直接往 Composer 中 changes 插入 change，最终会在 Composition#applychanges 回调 effect 函数。
	DisposableEffectImpl 实现了 RememberObserver 接口，借助于 remember 存储在 SlotTable 中，并且 Composition 发生重组时会通过 RememberObserver#onForgotten 回调到 effect 的 onDispose 函数
	LaunchedEffect，与 DisposableEffect 的主要区别是内部开启了协程，用来异步计算的

Compose 函数内部调用流程是什么样的
Kotlin Compiler Plugin 在编译阶段帮助生成 $composer 参数的普通函数（有些场景还有带有 $change 等辅助参数），内部调用的 Compose 函数传递 $composer 参数
Compose 怎么构建生成 NodeTree，Node 节点信息怎么储存的
Kotlin Compiler Plugin 在 Compose 函数前后插入 startXXXGroup 和 endXXXGroup 构建树结构，内部通过 SlotTable 实现 Node 节点数据存储和 diff 更新，SlotTable 通过 groups 存储分组信息 和 slots 存储数据
Compose 如何监听 State 变化并实现高效 diff 更新的
MutableState 实现了 StateObject，内部借助 Snapshot 实现内部值更新逻辑，然后通过 remember 函数存储到 SlotTable 中，当 State 的值发生改变时，Snapshot 会通知到 Composition 进行重组
Compose 什么时候发生重组，重组过程中做了什么事情
当 State 状态值发生改变时，会借助 Snapshot 通知到 Composition 进行重组，而重组的最小单位是 RestartGroup（Compose 函数编译期插入的 $composer.startRestartGroup ），通过 Kotlin Compiler Plugin 编译后的代码我们发现，重组其实就是重新执行对应的 Compose 函数，通过 Group key 改变 SlotTable 内部结构，最终反映到 LayoutNode 重新展示到 UI 上
Snapshot 的作用是什么
Compose 重组借助了 Snapshot 实现并发执行，并且通过 Snapshot 读写确定下次重组范围

# 参考

[扒一扒 Jetpack Compose 实现原理](https://zhuanlan.zhihu.com/p/585400570)
[Understanding Jetpack Compose — part 1 of 2](https://medium.com/androiddevelopers/understanding-jetpack-compose-part-1-of-2-ca316fe39050)
[Understanding Jetpack Compose — part 2 of 2](https://medium.com/androiddevelopers/under-the-hood-of-jetpack-compose-part-2-of-2-37b2c20c6cdd)

