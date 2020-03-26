
## 第十七章 高级进程间通信

进程间通信， 在之前有几种形式: pipe, FIFOs, 消息队列，信号量，共享内存，协同进程

### 学习记录

Introduction

	高级进程间通信， 越高级抽象， 意味着限制越多，耦合越多， 使用的场景越局限。当然，这不防碍是常用技术。 

Unix Domain Sockets

	Domain Socket, 又是个付么玩意， domain 在 系统网络配置里见到过， 作为一个域， 在这里是指网络间的IPC?

Unique Connections

	唯一连接， 这个又是干什么的, 举一些特例？ client-server的专有连接， 就像daemon 进程一样？ 

Passing File Descriptors

	传送文件描述符， linux 里一切都是文件， 这个文件并不只限于经常理解的文档文件， 而是对一块存储（内存，磁盘)区域的抽象。 可以将存储区域的读写统一起来. 

An Open Server, version 1

	应该是一个示例了。 

An Open Server, version 2


### 总结

### 习题与问题
