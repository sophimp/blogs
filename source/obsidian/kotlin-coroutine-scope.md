
# Kotlin Coroutine: CoroutineScope

生命周期, 控件有生命周期

生命周期，是对从创建到销毁这一期间的抽象。 

生命周期函数, hook回调

# 常用的Coroutine.builder扩展函数

launch
produce
async
broadcast

```kotlin
fun <E> CoroutineScope.broadcast(
    context: CoroutineContext = EmptyCoroutineContext, 
	capacity: Int = 1, 
	start: CoroutineStart = CoroutineStart.LAZY, 
	onCompletion: CompletionHandler? = null, 
	block: suspend ProducerScope<E>.() -> Unit
): BroadcastChannel<E>	
```


# 总结

	为了保证Coroutine所占的资源能够及时回收, 需要从CoroutineScope启动其他的Coroutine, 以便在 scope.cancel的时候, 销毁所启动的子协程。当然子协程也可以保证不被销毁，这又是另外的技术。
