
# Kotlin Coroutine: Job, Deffered

Job 具有生命周期且可以取消, 还有层级关系。

父Job取消，所有的子Job取消。子Job被取消或出现异常后，父Job也会取消
具有多个子Job的的父Job会等所有的子Job完成或取消后，自己才会执行完成。

# Job接口常用函数

start 
cancel

	Coroutine是否取消，还看具体实现，该方法只是将状态设置为cancel, 并不会主动去取消Coroutine

invokeOnCompletion

	可以给Job设置一个完成通知
	
join


withTimeout 和 withTimeoutOrNull

Nocancelable

	context的单例对象，设置任务不可取消

SupervisorJob

	里面的子Job互不影响，但是父Job取消，还是会取消所有子Job


# Deferred 接口

Deferred 继承自 Job, Job的方法Differd 一样适用

额外三个方法：

await
getCompleted
getCompletionExceptionOrNull


# 总结

Job 接口可以查询Coroutine 状态
Deferred 接口可以获取Coroutine 结果

