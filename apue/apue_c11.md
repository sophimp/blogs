
## 第十一章 线程

### 学习记录

Thread Concepts

	响应时间, 吞吐量, 线程id, 共享进程中的数据(可执行的程序代码, 全局内存和堆内存, 栈以及文件描述符等), 线程信息(寄存器值, 堆,栈, 调度优先级和策略, 信号屏蔽字, errno 变量)

Thread Identification

	线程id 只相对于所属进程上下文中才有意义, 进程id是在整个系统中保持唯一. 

```c
	#include <pthread.h>
	int pthread_equal(pthread_t tid1, pthread_t tid2);
	pthread_t pthread_self(void);
```

Thread Creation

```c
	#include <pthread.h>
	int pthread_create(pthread_t *restrict tidp, pthread_t restrict attr, void *(*start_rtn)(void *), void *restrict arg);
```
	新创建的线程可以访问进程地址空间, 并且继承调用线程的浮点环境和信号屏蔽字, 但是该线程的挂起信号集会被清除. 

	cc 就是gcc编译器吗? 为何使用 -lpthread不行, 使用 -pthread就行, 看man cc 显示的是gcc的doc

Thread Termination

```c
	#include <pthread.h>
	void pthread_exit(void *rval_ptr);
	int pthread_join(pthread_t thread, void **rval_ptr);
	int pthread_cancel(pthread tid);

	void pthread_cleanup_push(void (*rtn)(void *), void *arg);
	void pthread_cleanup_pop(int execute);
```

	rval_ptr 必须是全局变量或堆变量, 不能是局部变量
	pthread_cancel 用来取消进程中的其他线程, 相当于调用了参数为 PTHREAD_CANNEL的pthread_exit函数. pthread_cannel 并不等于终止线程, 仅仅是提出请求. 

	线程分离, 何为分离状态?
	pthread_join, pthread_detach, 可以分离线程, pthread_create 也可以创建一个分离的线程. 

Thread Synchronization

	Mutexes

		每个线程都得遵守互斥加锁的机制, 同步才有作用
		往往是将共同操作的部分抽取成一个方法, 每个线程都调用此方法, 但是如果每个线程操作数据的方式不一样, 还是要分开加锁. 

```c
	#include <pthread.h>
	int pthread_mutex_init(pthread_mutex_t *restrict mutex, const pthread_mutexattr_t *restrict attr);
	int pthread_mutex_destory(pthread_mutex_t *mutex);

	int pthread_mutex_lock(pthread_mutex_t *mutex);
	int pthread_mutex_trylock(pthread_mutex_t *mutex);
	int pthread_mutex_unlock(pthread_mutex_t *mutex);
```

	Deadlock Avoidance

	pthread_mutext_timelock Function

	Reader-Writer Locks

	Reader-Writer Locking with Timeouts

	Condition Variables

	Spin Locks

	Barriers

### 总结

### 习题与问题
1. Modify the example code shown in Figure 11.14 to pass the structure between the threads property.

2. In the example code shown in Figure 11.14, what additional synchronization (if any) is necessary to allow the master thread to change the thread ID associated with a pending job? How would this affect the job_remove function?

3. Apply the techniques show in Figure 11.15 to the worker thread example( Figure 11.1 and 11.14) to implement the worker thread function. Don't forget to update the queue_init function to initialize the condition variable and change the job_insert and job_append functions to signal the worker threads. What difficulties arise?

4. Which sequence of steps is correct?
	1. Look a mutex(pthread_mutex_lock).
	2. Change the condition protected by the mutex.
	3. Signal threads waiting on the condition (pthread_cond_broadcast).
	4. Unlock the mutex(pthread_mutex_unlock).
	or
	1. Look a mutex(pthread_mutex_lock).
	2. Change the condition protected by the mutex.
	3. Unlock the mutex(pthread_mutex_unlock).
	4. Signal threads waiting on the condition (pthread_cond_broadcast).

	第二个对. 

5. What synchronization primitives would you need to implement a barrier? Provide an implementation of the pthread_barrier_wait function.

