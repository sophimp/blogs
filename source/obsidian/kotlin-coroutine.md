
## 协程

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

ScopeBuilder
runBlocing: 阻塞
coroutineScope; suspended

提供了几种 CoroutineScope

避免不了要从代码入手, 看源码，编译后的代码。

socpe 继承 job, 也与job绑定，job有更细的控制api

2. EffectSize

3. Flow

4. Channel

Channel, Deffered,	传递值, 协程内外 scope 传值, 避免回调

5. Structured Concurrency

什么是结构并发，

解决问题引入的概念？
高效，避免内存泄漏，所有子协程执行完，才结束，内部的异常错误不丢失。
