
# Kotlin Coroutine: 异常处理

异常会导致闪退，严重影响用户体验，特别是在线上的异常捕获及处理, 因此异常处理(Exception Handling)是一个很重要的概念。

而Coroutine主要用于异步编程，异常处理只会更加复杂。

Coroutine异常传递有两种类型: 

    自动向上传递(launch, actor)
    把错误信息暴露给调用者(async 和 produce)

CoroutineExceptionHandler

    对于 launch, actor 创建的Coroutine，里面如果抛出异常需要通过 CoroutineExceptionHandler 来捕获。

    但是于对 async 函数的异常，需要在suspending point 的地方用 try-catch 来捕获这种异常。

CancellationException

    一个特殊的异常, launch 传参 handler
    当suspend 函数在等待其执行过程中被取消了，会抛出CancellationException 表示这个coroutine被取消了。这个异常是由Coroutine内部实现处理。

    Job.cancel 取消一个任务，不会影响父任务和其他子任务的执行

    如果Coroutine遇到的不是CancellationException, 则会使用这个异常来取消父Coroutine。 为了保证稳定的Coroutine层级关系（用来实现structured concrrency)，这种行为不能被修改。然后所有的子Coroutine 都终止后，父Coroutine 会收到原来抛出的异常信息。还是通过 CoroutineExceptionHandler来接收。


异常聚合

    如果多个子Coroutine都抛出了异常会出现什么情况？
    通用规则是 最先抛出的异常被暴露出来，但是这样会导致异常信息丢失。
    在JDK7+版本上可以支持同时显示后面的异常信息。

Supervisor

    在Coroutine层级结构中，取消行为是双向的。父或子任务取消都会导致整个Corouine 取消。

    SupervisorJob的取消行为是单向的，取消父任务可以同时取消所有子任务，而子任务的取消，不会导致父任务和其他子任务取消。

    coroutineScope() 和 supervisorScope的函数区别也是这样。

    由于supervisor 的子任务取消是单向的，所以子任务异常需要子任务单独处理，异常无法向上传递。即不能通过 CoroutineExceptionHandler 来捕获


    supervised coroutine 每个子coroutine 都应该通过异常处理器来处理自己的异常。因为 SupervisedCoroutine 中子job 的异常不会传递给父job, 所以需要自己处理。


    Coroutine 中异常处理和普通代码中的异常处理还是有很大区别。ThreadUncaughtHandler 也同样需要设置。

选择表达式

    同时收到数据的时候，选择第一个。
    在什么场景下会使用呢？ 

