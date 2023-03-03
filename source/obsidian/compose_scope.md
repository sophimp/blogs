
## Compose 作用域 与生命周期

Coroutine, Compose, ViewModel 都是如何来实现作用域的呢？

生命周期的本质是内存的创建与回收, 是依据引用技术来决定的。

切面编程的思想。

写作就是要保证冷静的思考，耐心一点，事情不可能是一蹴而就的。

SideEffect 可用来感知Compose的生命周期

## SideEffect

触发一次性事件， 满足特定状态条件时进入另一个屏幕

从能感知可组合项生命周期的受控环境中调用

Effect Api 也是 Composable 函数, 在Composition完成时会调用，但是不会发送到UI

- LaunchedEffect

	在Composable function 中运行一个 suspend 函数

	当进入组合(Composition)时，会启动一个coroutine 调用参数中的block code, 离开组合时，会cancel掉coroutine
	LaunchedEffect 发生重组时，关联不同的key, 会cancel掉之前开启的coroutine, 再重新开启一个新的Coroutine

	Composition 相当于显示中dom树

- rememberCoroutineScope

	获得一个组合感知的CoroutineScope State, 以便可以在Composable 之外启动协程, 退出组合后自动取消。

	相当于Composable的lifecycleScope
	
- rememberUpdatedState

	关联一个value, value变化，不会重启composable，但是关联的值会正常更新，获取的是最新的值。
	
- DisposableEffect

	一般在做扫尾工作。在关联的key变化或离开了Composition时调用
	必须在最后实现 onDispose(), 否则ide会报错
	register 和 unregister LifecyclerObserver

- SideEffect
	
	publish Compose State to non-compose code

	每次重组时，自动更新，Composable 的传参到 非Composable的变量中

- produceState 
	
	将非Compose state 转换成 Compose State, 一般赋值给返回值State, 可供其他Composable调用
	返回的值相同，不会触发重组。

	也可以用来监听 非挂起数据， 使用 awaitDispose 来移除监听

- derivedStateOf

	将一个或多个 state 合并成另一个 state
	多个状态中的任一一个发生变化时，才触计算, 不会在每次重组的时候都执行一次计算

- snapshotFlow

	将Compose state 转成 Flow
	类拟于Flow.distinctUntilChanged

- restarting effects

- 常量true, Unit 作key
	
	可以跟随call site的生命周期

