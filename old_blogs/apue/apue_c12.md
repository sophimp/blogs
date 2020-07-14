
## 第十二章 线程控制

### 学习记录

	线程控制, 也是硬核的一章. 后面就是网络编程的应用. 
	网络编程, 清楚了tcp/ip的握手挥手流程, 线就在那里定着了. 剩下 ip protocl, 多线程, io编程

	就是这么几个api, 翻来覆去, 还是弄不明白. 

	the details of controlling thread behavior

	How threads can keep data private from other threads in the same process. 

	thread attributes and synchronization primitive attributes

	How some process-based system calls interact with threads.

Thread Limits

	sysconf, 没有限制的, 不能获取的不代表不存在, 只是不能通过sysconf来获取罢了. 

Thread Attributes

	thread attributes 都有共同的形式. 
	一个attribute object, 关联一种对象, 
	一个attribute object  可以是多个attibutes 的集合,
	attribute 对应用是不可见的, 使用函数来访问和设置
	每个attribute 都有初始化函数设置默认值, 销毁函数释放资源
	attribute 是通过值来传递的

```c
	#include <pthread.h>
	int pthread_attr_init(pthread_attr_t *attr);
	int pthread_attr_destroy(pthread_attr_t *attr);

	int pthread_attr_getdetachstate(const pthread_attr_t *restrict attr, int *detachstate);
	int pthread_attr_setdetachstate(const pthread_attr_t *restrict attr, int *detachstate);
	
	int pthread_attr_getstack(const pthread_attr_t *restrict attr, 
							void **restrict stacaddr,
							size_t *restrict stacksize);
	int pthread_attr_setstack(pthread_attr_t *attr, 
							void *stacaddr,
							size_t stacksize);

	int pthread_attr_getstacksize(const pthread_attr_t *restrict attr,
									size_t *restrict stacksize);
	int pthread_attr_setstacksize(pthread_attr_t *attr,
									size_t *stacksize);

	int pthread_attr_getguardsize(const pthread_attr_t *restrict attr,
									size_t *restrict guardsize);
	int pthread_attr_setguardsize(pthread_attr_t *attr,
									size_t *guardsize);
```

	detach thread, 在这个状态的线程有何特点, 执行的线程已经不再与线程对象相关联, 因此线程对象的join函数不可以再使用, 线程还可以继续执行, 线程对象可以被销毁, 此时再操作线程, 需要其他的机制. 不想再知道线程终止的状态. 系统负责回收, 调用pthread_detach
	thread stack,  thread stack 也可以操作, 进程的stack理论上也是可以设置的, 只是要内核级, 当然, 设置的所有线程stack不能超过实际的内存大小. 
	guardsize, 在thread stack 最后的一个扩展区, 保护stack 不会 overflow, 修改会被操作系统四舍五入设置为 pagesize 的整数倍, 

Synchronization Attributes

	先初步浏览, 操作都是 init, destroy, get, set, 着重看每种attribute 都有什么作用. 

	Mutex Attributes

		process-shared mutex attribute, 多进程共享同一个mutex, PTHREAD_PROCESS_PRIVATE 更高效
		robust attribute, 多个进程共享一个mutex, 持有的进程异常终止了, 需解决mutex status recovery问题
		type attribute, 控制mutex锁的特性, PTHREAD_MUTEX_NORMAL, PTHREAD_MUTEX_ERRORCHECK, PTHREAD_MUTEX_RECURSIVE, PTHREAD_MUTEX_DEFAULT, 
```c
	#include <pthread.h>
	int pthread_mutexattr_init(pthread_mutexattr_t *attr);
	int pthread_mutexattr_destroy(pthread_mutexattr_t *attr);
	int pthread_mutexattr_getpshared(const pthread_mutexattr_t * restrict attr, int *restrict pshared);
	int pthread_mutexattr_setpshared(pthread_mutexattr_t * attr, int pshared);
	int pthread_mutexattr_getrobust(const pthread_mutexattr_t * restrict attr, int *restrict robust);
	int pthread_mutexattr_setrobust(pthread_mutexattr_t * attr, int robust);
	int pthrad_mutex_consistent(pthread_mutex_t *mutex);

	int pthread_mutexattr_gettype(const pthread_mutexattr_t * restrict attr, int *restrict type);
	int pthread_mutexattr_settype(pthread_mutexattr_t * attr, int type);
```

	Reader-Writer Lock Attributes

		只支持 process-shared 属性

```c
	#include <pthread.h>
	int pthread_rwlockattr_init(pthread_rwlockattr_t *attr);
	int pthread_rwlockattr_destroy(pthread_rwlockattr_t *attr);

	int pthread_rwlockattr_getpshared(const pthread_rwlockattr_t *restrict attr, int *restrict pshared);
	int pthread_rwlockattr_setpshared(pthread_rwlockattr_t *attr, int pshared);

```

	Condition Variable Attributes
	
	支持两种: process-shared attribute, clock attribtue

```c
	#include <pthread.h>
	int pthread_condattr_init(pthread_condattr_t *attr);
	int pthread_condattr_destroy(pthread_condattr_t *attr);

	int pthread_condattr_getpshared(const pthread_condattr_t *restrict attr, int *restrict pshared);
	int pthread_condattr_setpshared(pthread_condattr_t *attr, clock_t pshared);

	int pthread_condattr_getclock(const pthread_condattr_t *restrict attr, int *restrict clock_id);
	int pthread_condattr_setclock(pthread_condattr_t *attr, clock_t clock_id);
```

	Barrier Attributes

		支持 process-shared attribute
		PTHREAD_PROCESS_SHARED: 多进程可访问
		PTHREAD_PROCESS_PRIVATE: 只能初始化 barrier attribute 的线程可以访问

```c
	#include <pthread.h>
	int pthread_barrierattr_init(pthread_barrierattr_t *attr);
	int pthread_barrierattr_destroy(pthread_barrierattr_t *attr);

	int pthread_barrierattr_getpshared(const pthread_barrierattr_t *restrict attr, int *restrict pshared);
	int pthread_barrierattr_setpshared(pthread_barrierattr_t *attr, clock_t pshared);
```

Reentrancy

	可重入, 
	thread-safe, 可以通过调用synconf(_POSIX_THREAD_SAFE_FUNCTIONS); 得到线程安全的函数. 
```c
	#include <stdio.h>
	int ftrylockfile(FILE *fp);
	void flockfile(FILE *fp);
	void funlockfile(FILE *fp);

	int getchar_unlocked(void);
	int getc_unlocked(FILE *fp);

	int putchar_unlocked(int c);
	int putc_unlocked(int c, FILE *fp);

```
	pthread 不能保证异步信号处理函数的同步.
	recursive mutex 递归互斥量, 允许忆经获取mutex lock的线程继续获取锁, 内部计数+1, 但是必须有相同的释放, 计数为0时, 其他线程才可能获取锁. 

Thread-specific Data

	also known as thread-private data. 
	为何要有线程的私有数据:
		1. 需要维护每个线程各自的数据, 不污染其他线程的数据, 如线程id
		2. 适应基于进程的多线程环境.  errno例子

```c
	#include <pthread.h>

	// 创建一个key与thread-specific data 绑定,以便访问
	// 绑定的destructor 函数 在调用cancel的时候会调用, 如果调用 abort, exit, _exit, _Exit等函数时不会被调用.
	// thread-specific data 要用malloc来分配, 需要在destructor中free, 否则会造成内存泄漏
	// 一个线程可以分配多个key, 每个key都可以绑定一个destructor
	int pthread_key_create(pthread_key_t *keyp, void (*destructor)(void *)); 

	// 解除key与thread-specific的绑定
	// 调用此函数不会调用与key绑定的destructor
	int pthread_key_delete(pthread_key_t *key);

	// 保证执行一次初始化
	// initflag 必须是全局变量
	int pthread_once(pthread_once_t *initflag, void (initfn)(void));

	void *pthread_getspecific(pthread_key_t key);
	int pthread_setspecific(pthread_key_t key, const void *value);
```

	什么是c语言的全局变量? 这个全局变量是相对于文件的还是相对于整个应用运行环境的. 

	相对于文里的全局变量, 对于文件里的线程来说是全局变量. 动态分配的变量也是全局变量

Cancel Options

	cancelability state, cancelability type, 这两个属性不包括在 pthread_attr_t 中
	cancelability state, 可设置 PTHREAD_CANCEL_ENABLE, PTHREAD_CANCEL_DISABLE 
	cancelability type, 
```c
	#include <pthread.h>
	int pthread_setcancelstate(int state, int *oldstate);

	// 添加自己的 线程 cancellation point
	void pthread_testcancel(void);

	int pthread_setcanceltype(int type, int *oldtype);
```

	pthread_cancel 不会等待线程终止, 线程会继续执行, 直到到达cancellation point
	cancellation point 线程检测是否已经被取消的点, 如果已经取消, 执行请求. 

	那些图表中的函数, 就是一个线程的cancellation point 吗?  每调用那些函数, 就会检查一次cancel state? 
	是在刚开始调用的时候, 还是在调用完成呢? 

	cancellation type: deferred canncellation, PTHREAD_CANCEL_DEFERRED, PTHREAD_CANCEL_ASYNCHRONOUS

	cancellation point 是根据 cancellation type 来执行的, PTHREAD_CANCEL_DEFERRED 是延时执行(默认方式), 
	PTHREAD_CANCEL_ASYNCHRONOUS 是随时可以取消, 在带有 cancellation point 的函数中, 会将 PTHREAD_CANCEL_ASYNCHRONOUS, 改成enable,然后会wait, 等待信号或广播唤醒, 唤醒后再改成disable,  在等待唤醒这段时间都是 canncellation point, 
	cancellation point 是为了防止线程异常终止没有释放资源, 那么这段时间又是怎么释放资源的呢? 线程又是如何终止的呢? 直接由kernel来执行吗? 
	man pthread_cancel 得知
	When a cancellation request is acted on, the following steps occur for thread(in this order):
	1. Cancellation clearn-up handler are popped and called.
	2. Thread-specific data structors are called, in an unspecified order.
	3. The thread is terminated.

	是不是可以继续理解为, 当canncellation type 被设置成 pthread_cancel_asynchronous, 就会通知内核, 这个线程可以被安全终止, 内核会检测一下线程状态是否可以被取消, 如果是enable, 就会去执行上面三个步骤. 带有cancellation point的函数内部都有pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS) 的调用. 

Thread and Signals

```c
	#include <signal.h>
	// 线程里没有 sigprocmask 函数, 使用如下函数替代.  sigprocmask 是在进程中使用的, 失败更新 errno, 返回-1
	// 而 pthread_sigmask 失败返回 错误码, 不更新errno.
	int pthread_sigmask(int how, const sigset_t *restrict set,
						sigset_t *restrict oset);

	int sigwait(const sigset_t *restrict set, int *restrict signop);

	int pthread_kill(pthread_t thread, int signo);
```

	sigwait, block 与 mask的作用不一样,  block 是阻止信号暂时接收, 但是unblock后, 还会继续处理, mask是屏蔽接收信号, 不再处理. 
	sigwait 前要先block, 否则会打开一个时间窗, 在这个时间窗里, sigwait 还未调用完, 就已经有信号发送过来了, 造成信号丢失. 
	sigwait 一旦接收到信号, 继续处理下面的代码还是在线程环境, 不用担心函数是否安全, 这跟进程的信号接收还不一样, 那是在中断处理函数中调用的. 

	如果进程和线程同时等待同一个信号, 看具体实现怎么传递, 要么线程返回, 要么调用进程的信号中断处理函数. 不会同时都执行. 
	多个线程都等待同一个信号而阻塞, 在有一个信号递到时, 只有一个线程会返回, 队首的(假如有队列的话)?
	
	可以用0值的信号来检测线程是否存在, 如果默认的信号是终止进程, 发送一个信号到线程, 一样可以终止进程. 

	alarm timers 是进程资源, 线程共享的, 如何多线程互不干扰的使用 alarm timers, 这在练习题12.6里有, 记得之前10.5也是同样的实现, 还发表了论文. 

Thread and Fork

	在线程里调用fork, 同样会copy整个进程, 因此子线程已经和原来的进程是不同的进程. 除了拷贝了地址空间，也同样从父进程中继承了 mutex, reader-writer lock, condition variable， 因此， 问题就来了， 子进程继承了所有的锁， 但是在子进程中, 并不会复制持有锁的线程， 所以， 子进程就不清楚，哪些线程持有了锁以及如何释放锁。

```c
	#include <pthread.h>
	int pthread_atfork(void (*prepare)(void), void (*parent)(void), void(*child)(void));
```

	嵌套加锁， 先加锁的后解锁， 后加锁的程序， 

Thread and I/O

	pread, pwrite, lseek

	进程中所有线程共享相同的文件描述符

### 总结

	线程提供了分解并发任务的另一种模型。 
	如何调整线程和它们的同步原语
	线程的可重入性
	线程如何与其他面向进程的系统调用进行交互。  

### 习题与问题
1. Run the program in Figure 12.17 on the linux system, but redirect the output into a file.

	

2. Implement putenv_r, a reentrant version of putevn. Make sure that your implementation is async-signal safe as well as thread-safe.

3. Can you make the getenv function shown in Figure 12.13 async-signal safe by blocking signals at the beginning of the function and restoring the previous signal mask before returning? Explain. 

4. Write a program to exercise the version of getenv from Figure 12.13. Compile and run the program on FreeBSD. What happens? Explain. 

5. Given that you can create multiple threads to perform different tasks within a program, explain why you might still need to use fork.

6. Reimplement the program in Figure 10.29 to make it thread-safe without using nanosleep or clock_nanosleep. 

7. After calling fork, could we safely reinitialize a condition variable in the child process by first destroying the condition variable with pthread_con_destroy and then initializing it with pthread_cond_init?

8. The timeout function in Figure 12.8 can be simplified substantially. Explain how. 
