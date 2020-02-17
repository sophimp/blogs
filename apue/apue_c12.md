
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

	Condition Variable Attributes

	Barrier Attributes

Reentrancy

Thread-specific Data

Cancel Options

Thread and Signals

Thread and Fork

Thread and I/O

### 总结

### 习题与问题
1. Run the program in Figure 12.17 on the linux system, but redirect the output into a file.

2. Implement putenv_r, a reentrant version of putevn. Make sure that your implementation is async-signal safe as well as thread-safe.

3. Can you make the getenv function shown in Figure 12.13 async-signal safe by blocking signals at the beginning of the function and restoring the previous signal mask before returning? Explain. 

4. Write a program to exercise the version of getenv from Figure 12.13. Compile and run the program on FreeBSD. What happens? Explain. 

5. Given that you can create multiple threads to perform different tasks within a program, explain why you might still need to use fork.

6. Reimplement the program in Figure 10.29 to make it thread-safe without using nanosleep or clock_nanosleep. 

7. After calling fork, could we safely reinitialize a condition variable in the child process by first destroying the condition variable with pthread_con_destroy and then initializing it with pthread_cond_init?

8. The timeout function in Figure 12.8 can be simplified substantially. Explain how. 
