
# Kotlin Coroutine: Context, Dispatcher

## Context

CoroutineContext 包含了用户自定义的数据结合， 有两个重要的Element: Job, Dispatcher

CoroutineContext 定义了四个核心操作：

- 操作符(Operator) get 可以通过key 来获取 Element
- 函数fold 和 Collection.fold 类似， 提供获取当前CoroutineContext中的所有Element的能力
- 操作符plus 和 Set.plus 类似，返回一个新的context 对象，新的对象包含两个里面所有的element, 如果key重复, 用 + 号右边的Element替换左边的
- 函数 minusKey 返回删除一个 Element 的 context

context 组合使用，仅仅是为了代码简洁直观吗？ 还有没有其他作用
 

## Dispatcher

用来控制 CoroutineContext的执行线程

CoroutineDispatcher 是一个抽象类，标准库定义了几个常用的 实现

- Dispatcher.Default
	
	使用一个共享的后台线程池来运行里面的任务

- Dispatcher.IO

	用来执行阻塞IO操作，也是共享后台线程池。

- Dispatcher.Unconfined

	立即启动Coroutine并开始执行Coroutine 直到遇到第一个 suspension point
	一般而言不使用 Unconfined

- newSingleThreadContext 和 newFixedThreadPoolContext 可以创建在私有线程池运行的Dispatcher, 但是需要手动close
- asCoroutineDispatcher 扩展函数，可以将java Excecutor 转换为 Dispatcher 使用
- Dispatcher.Main 是指在Android 的UI线程执行

自定义Dispatcher

	实现比较复杂，标准库中的就够用了， 一般不用自定义
