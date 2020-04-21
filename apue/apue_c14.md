
## 第十四章 高级I/O

这一章必须得下点心思， 干货很多。 后面 进程间通信， 网络IPC:套接字， 高级进程间通信， 终端I/O， 数据库函数库都会用到此章知识。 

后面章节: 伪终端， 与网络打印机的通信， 就可以选择性了解一下，看看总结， 知道是什么回事就行。 

高级I/O， 进程间通信， 网络通信， 数据库， 都是硬核知识， 加油突破一下， 对于后面看ffmpeg, opencv, okio, okhttp, 这几个库都是有好处的。 

分两遍读， 第一遍先分别了解讲得大概是什么

在这一章, 看到章节标题， 还是对 Nonblocking I/O, Record Locking, I/O Multiplexing, select, poll, Asyncrhonous I/O, Memory-Mapped I/O 这几章比较感兴趣. 

### 学习记录

Nonblokcing I/O
	
	常见，java 中也有的nio, 如何做到无阻塞的？ 
	什么是阻塞， 一个线程, 一直等待结果返回, 一直占用着cpu资源， 这便是阻塞。 
	那么非阻塞， 就是在等待的过程， cpu还可以做其他事情。
	阻塞最怕的就是被永远阻塞了， 这就相当于并发死锁了。 
	导致永远阻塞的系统调用有哪些:

Record Locking

	记录锁， 第一次见， 又是做什么？ 

I/O Multiplexing

	I/O 多路复用， 与 select , poll 又是什么关系？ 

select and pselect Functions

	与poll 一样， epoll, 多次在知乎上的讨论中看到过。 好像是很通用的技术。 

poll Function

	只看这些函数， 能学到什么？ 这个函数是做什么的， 在什么样的应用场景下工作，有哪些限制， 配置参数的设定通常也是根据实际的开发场景来提供的。 

Asynchronous I/O

	异步I/O, 上面这些讲得不都是异步I/O么， 在这里是作一个总结， 顺便引起后面多平台的I/O介绍？ 并不是， I/O 可以异步， 也可以同步， 有的支持异步， 有的需要额外再作一些工作。 异步的场景就是多进程或多线程。 

System V Asynchronous I/O

	各种系统下的 异步I/O， 暂不考虑跨平台的话， 是不是意味着也只是先了解一下？ 

BSD Asynchronous I/O

POSIX Asychronous I/O
	
	POSIX 下的协议， 还有一个XSI 对POSIX 的扩展协议

readv and writev Functions

	这又是什么函数？ 已经有好几个write, read 函数了，线程安全和线程不安全的， 内核级别的， 可重入的

readn and writen Functions

	想想，I/O 不就是靠 read, write函数么， 所以， 了解这些函数也是有必要的。 

Memory-Mapped I/O

	内存印射， 这就是虚拟内存技术的应用吧。 免一次的内存拷贝？ 基础打好后， 相信再看那些框架， 确实不再会一愁莫展了。 

### 总结

### 习题与问题
