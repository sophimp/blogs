
--- 
title: Kotlin Coroutine: CoroutineScope
date: 2023-01-05 17:05
tags: 
categories: 
description: 
---

# Kotlin Coroutine:  基本概念

多线程编程，对我来说，一直卡在门口徘徊，平常项目里遇到的多线程bug大概就是ConcurrentModificationException
进程，线程，协程
进程，线程根系统比较挂钩的，协程是基于线程的。

协程是通用理念吗？ c++/go中的协程理念是不是一样？

就是为了提供更好的异步编程体验, 编译器支持，语言层面支持

异常的捕获

	await, async 不是关键字， suspend 比 Future, promise 提供了更多的异常信息

为什么我学习coroutine就感觉那么难？

学习 RxJava, graphQL, ROOM, Dagger, Hilt, 都感觉很难，问题在哪？
跟现实相关性不大，更加抽象的概念，我理解的比较慢. 这也在于，我知道的太少了。
话说回来，那些大牛知道，也是他们花费了精力去学习了。
所以，我的知识储备是落后于同龄人的。

盲目追求看的速度，一目十行，一周看一本书，最后就是量子波动式读书。

一目十行也是熟能生巧，我还是生瓜蛋子，熟什么呢？

看一篇技术文章，看完下来， 没有收获，需要反复看，那就反复看呗。
在没有发现其他技巧的时候，也只能靠死办法攻破

1. CoroutineScope

CoroutineScope是如何控制生命周期的呢？

CoroutineScope 只是提供一个接口，使用者需要根据实际情况，自行管理生命周期
CoroutineScope 提供了几个扩展函数，便于创建与消毁
使用的Activity, Fragment 的Scope 不过是有人已经针对封装好了

ScopeBuilder
runBlocing: 阻塞
coroutineScope; suspended

提供了几种 CoroutineScope

避免不了要从代码入手, 看源码，编译后的代码。

socpe 继承 job, 也与job绑定，job有更细的控制api

CoroutineContext operator plus

2. EffectSize

3. Flow

operator

	intermediate
		transform:	map, filter, transform(定制，emit any value)
		size-limiting : take
		context: flowOn(changeContext)
	terminal
		collect, first, toSet, toList, single, reduce, fold
	buffering
		buffer
	conflation
		confilate, collectionLatest
	composing multiple flows
		zip, combine
	flattening flows
		flatMapConcat, flatMapMerge, flatMapLatest
	exception
		catch
	completion
		imperative: finally
		declarative: onCompletion

sequential

exception

	try/catch, 只能放在 block code 里try, 放在coroutine 外部 try, 捕获不到协程的异常
	transparency, 

	由内向外传递

4. Channel

Channel, Deffered,	传递值, 协程内外 scope 传值, 避免回调

5. Structured Concurrency

什么是结构并发，

解决问题引入的概念？
高效，避免内存泄漏，所有子协程执行完，才结束，内部的异常错误不丢失。

6. ExceptionHandler

CoroutineExceptionHandler 类似于 Thread.uncaughtExceptionHandler


