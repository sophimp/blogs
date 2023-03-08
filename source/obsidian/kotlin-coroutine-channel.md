
--- 
title: kotlin Coroutine: Channel
date: 2023-02-15 10:23
tags: 
categories: 
description: 
---

# Kotlin Coroutine: Channel

Channel 类似于 BlockQueue

用来跨协程, 跨线程通信

同时实现了两个接口 SendChannel 和 ReceiveChannel

创建 Channel 通过 Channel(capacity)

Channel.Rendezvous - RendezvousChannel 无缓存, 会阻塞
Channel.Conflate - ConflateChannel 只缓存最新, 不阻塞
Channel.UNLIMITED - LinkedListChannel 缓存无限制，受系统资源限制，不阻塞
0 - UNLIMITED 之间, 就缓存传入的数量

close() 关闭通道

produce() 封装了一个生产者
```kotlin
public fun <E> CoroutineScope.produce(
    context: CoroutineContext = EmptyCoroutineContext,
    capacity: Int = 0,
    block: suspend ProducerScope<E>.() -> Unit
): ReceiveChannel<E> 

```

返回一个Channel, 代码块是ProducerScope的扩展，这个套路很方便, 源码里到处都是这样的用法

PipeLines

管道是生产数据流的一种模式，数据流可能是无限的

通过CoroutineScope的扩展函数，继承同一个Scope 可以用 structure concurrency 特性来实现并行计算, 而不用引入GlobalScope

- TickerChannels

ticker() 创建 TickerChannels. 可以设置一个初始的延时和间隔，类似于 Timer的使用 
主要用来创建复杂的基于时间的pipelines, 和其他基于时间窗口的操作符函数以及基于时间的事件处理机制。

随着大家对基础概念的理解，其他内容查看相关api文档，应该就不难理解了。



