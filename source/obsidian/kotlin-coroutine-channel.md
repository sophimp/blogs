
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
produce() 封装了一个工厂方法

