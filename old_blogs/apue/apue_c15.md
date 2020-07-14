
## 第十五章 进程间通信

Interprocess Communication, 这个在android 中引入了binder 机制， 也是一个很重要的技术话题。 

在 linux 中，之前的理解, 进程间异步编程靠的是信号机制

### 学习记录

Introduction

Pipes

	管道， 在终端下的使用， 就已经感觉到了强大， 管道确实牛逼，多个程序联合起来执行。 想法很geek

popens and pclose Functions 

	打开或关闭管道的函数？ 

Coprocesses  

	协同进程, 一直被协程这个概念包围， 确没能静下心来去好好学习一下， 是因为， 连进程和线程都还没有摸透， 所以下意识有些排斥协程的学习。 

	这里的协程与 c#, kotlin里的概念是一样的吗？ 或者思想是一样的吗？ 

FIFOS

	先进先出队列? 在这里的应用是什么， 也是一种通信方式？ 还是用于进程间通信所使用的数据结构. 

XSI IPC

	XSI 与 POSIX 是两个标准，XSI 是对 POSIX 的扩展吗？ 系统的实现，基本是都支持POSIX 的， 但是不一定全支持 XSI, 而且某些接口的实现标准也有出入。
	所以这些涉及到跨平台

	Identifiers and Keys
	Permission Structure
	Configuration Limits
	Advantage and Disadvantages

Message Queues

	消息队列， 是相对于进程间共享的消息队列吗？ 那也得做好同步工作。 消息队列， 不仅公是进程间， 线程间， 模块间， 都适用。 系统与子系统间通信的一个比较好的方式。 

Semaphores

	信号量, 第一次接触这个还是学习 OC 编程的时候， 信号量与 signal 又是什么关系？ 看完了这些章节， 现在还是不清楚。 信号量的实现也是使用了信号中断机制

Shared Memory

	共享内存， 这与高级I/O里的 Memory-Mapper I/O 是什么关系？ 面对不同元素, 不同层级的抽象？ 

POSIX Semaphores

	为何要单独介绍一下 POSIX  的 信号量？ 

Client-Server Properties

	客户端-服务端 属性， 为何在这里成了属性了,  以进程为单位考虑, 确实是分开的进程，当然同一个进程里， 也可以有客户端与服务端， 这个时候，就是一个思想了吧。 

### 总结

### 习题与问题
