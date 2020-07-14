
## netty 框架

Bootstrap

	负现初始化启动线程, 打开socket.

EvengLoopGroup

	将EventLoop 归为一组, 可以共享资源, 如线程等 

EventLoop
	
	用来持续查找新消息, 然后交给对应的handle 处理. 

SocketChannel
	
	一个SocketChannel, 代表着一个 tcp 连接, 那么相应的数据, 应该也是SocketChannel 持有. 
	EventLoop 管理SocketChannel. 在同一个线程里. 

ChannelInitializer

	用来初始化SocketChannel, 是ChannelPipeline 中一个特殊的ChannelHandler, 在创建SocketChannel时添加到Pipeline中, 在初始化完SocketChannel后, 会自己从 Pipeline 中移除. 

ChannelPipeline

	一系列的 ChannelHandler, 当前新消息或者发送数据时, 触发handler, 执行为一个handler, 自动触发去执行下一个handler. 
	这样就形成了流水线

ChannelHandler

	用来处理SocketHandler接收到的数据. 或用来发送数据到SocketChannel. 

## ChannelPipeline 

ChannelInboundHandler, 

	接收数据后, 所经过的流水线

ChannelOutboundHandler, 
	发送数据所经过的流水线


## Codec

Encoder
	用来将 raw bytes 转换成 javaObject, 如 http, WebSockets, SSH/TLS 等

Decoder
	可将上述的java对象转换成 raw bytes


