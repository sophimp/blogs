
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

		hash bucket

	pthread_mutext_timelock Function
		
		bound the time that a thread blocks

```c
	#include <pthread.h>
	#include <time.h>
	int pthread_mutex_timedlock(pthread_mutex_t *restrict mutex, const struct timespec *restrict tsptr);
```
	阻塞的时间可能会因为几种原因有所不同: 
		1. 开始的时间在某秒的中间位置 
		2. 系统时钟的精度可能不足以精确支持我们指定的超时时间
		3. 在程序继续运行前, 调度延迟

	Reader-Writer Locks

		互斥量有两种状态: locked, unlocked, 读写锁有三种状态 locked in read mode, locked in write mode, unlocked

		写锁只能同时被一个线程获取, 读锁可以被多个线程获取, 在写锁获取时, 不可以获取读锁, 获取写锁前, 所有线程的读锁都得释放. 

```c
	#include <pthread.h>
	int pthread_rwlock_init(pthread_rwlock_t *restrict rwlock, const pthread_rwlockattr_t *restrict attr);
	int pthread_rwlock_destroy(pthread_rwlock_t *rwlock);

	int pthread_rwlock_rdlock(pthread_rwlock_t *rwlock);
	int pthread_rwlock_wrlock(pthread_rwlock_t *rwlock);
	int pthread_rwlock_unlock(pthread_rwlock_t *rwlock);

	int pthread_rwlock_tryrdlock(pthread_rwlock_t *rwlock);
	int pthread_rwlock_trywrlock(pthread_rwlock_t *rwlock);
```
		读写锁, 就是上面两个锁的具体实例, 外加一个特性, 读锁可以多个. 

	Reader-Writer Locking with Timeouts

```c
	#include <pthread.h>
	int pthread_rwlock_timedrdlock(pthread_rwlock_t *restrict rwlock, const struct timespec *restrict tsptr);
	int pthread_rwlock_timedwrlock(pthread_rwlock_t *restrict rwlock, const struct timespec *restrict tsptr);
```
		tsptr 限定了获取锁时block的时间, 指定的是绝对时间, 不是相对时间

	Condition Variables
```c
	#include <pthread.h>
	int pthread_cond_init(pthread_cond_t *restrict cond, const pthread_condattr_t *restrict attr);
	int pthread_cond_destroy(pthread_cond_t *cond);

	int pthread_cond_wait(pthread_cond_t *restrict cond, pthread_mutex_t *restrict mutex);
	int pthread_cond_timedwait(pthread_cond_t *restrict cond, 
								pthread_mutex_t *restrict mutex,
								const struct timespec *restrict tsptr);

	int pthread_cond_signal(pthread_cond_t *cond);
	int pthread_cond_broadcast(pthread_cond_t *cond);
```

		condition 与 mutext 是什么关系, 有什么区别, condition 需要mutex来保护, 那为何又要一个condition? 
			是为了防止condition信号丢失, 所谓的condition, 是要发送等待和发送的条件
		condition 的机制倒是与 java的 wait, notify机制类似. 
		condition是队列的状态. 是否为空, 空的话使用condition_wait等待. 条件是否可以理解为 mutex 与 signal的结合

	Spin Locks
		
		自旋锁是忙等, 减小sleep, wake 等在线程调试上所花费的时间, 
		自旋锁不能等太长时间, 随着处理器的速度越来越快, 
		自旋锁的使用场景只在特定场景有用(非抢占式内核开发,中断处理程序不能被中断)
		所谓忙等, 就是采用一个循环计数, 达到某个值, 再尝试获取锁. 

```c
	#include <pthread.h>
	int pthread_spin_init(pthread_spinlock_t *lock, int pshared);
	int pthread_spin_destory(pthread_spinlock_t *lock); // c的编程风格, 返回0为成功, 非零为失败. 

	init pthread_spin_lock(pthread_spinlock_t *lock);
	init pthread_spin_trylock(pthread_spinlock_t *lock);
	init pthread_spin_unlock(pthread_spinlock_t *lock);
```

	Barriers

		屏障, 可以将所有的线程阻挡在一个点, 然后继续执行, pthread_join就是一个例子

```c
	#include <pthread.h>
	int pthread_barrier_init(pthread_barrier_t *restrict barrier, 
							const pthread_barrierattr_t *restrict attr, 
							unsigned int count);

	int pthread_barrier_destroy(pthread_barrier_t *barrier);
	int pthread_barrier_wait(pthread_barrier_t *barrier);
	一个线程达到点, 调用pthread_barrier_wait(0)等待, 直到最后一个线程等待达到 barrier count, 所以线程都被唤醒, 继续执行. 
```

### 总结

要首先摸清作者思路, 这点确实很重要, 看了也好几本书了, 每个人写作思路总是有那么一点的. 

	想想也是, 自己是如何构建思维树的: 先方泛阅读, 积累零散的知识点, 再将零散的知识点总结, 抽象出来共有的特征节点. 由根到叶, 思维树就慢慢成了. 但是写作的时候时候, 就是从根到枝, 再到叶, 更具体的叙述. 相当于是总分/总分总结构. 大部分书都是采用这种结构的. 

	我总是想起杂文, 散文, 什么形散意不散的影响. 总分, 总分总就是最有用的套路. 

	这个时候, 这个想法, 启发了我对散文的套路的认识: 所谓的散文, 形散意不散, 就是举一些看似不相干的例子, 小故事, 寓言, 道理, 但是仔细一想, 又是有共通的地方. 看似不相干, 就是形散, 共通的地方就是意不散. 

	还有叙述文, 议论文. 
	叙述文, 的套路, 一般是按时间线, 感情线, 倒叙, 插叙, 蒙太奇之类的手法, 所以结构讲究的是行云流水. 并不强求总分结构. 
	议论文也是总分, 总分总结构, 所以, 总分/总结构, 是写blog, 写技术书, 写议论文的比较普遍的套路. 

因此, 摸清作者的写作思路, 对看起书来确实有很大的帮助. 同时, 对于自己的写作, 也不必再毫无头脑, 一头雾水, 瞎子乱撞了. 老老实实按总分结构. 只不过这个总分结构, 同时也得考虑思维的递进(层层递进/交替递进), 由易到难, 更加容易接收. 

还有文章的结构, 为何要这样划分, 当初肯定是有一个原因的. 

apue 书的套路:

	介绍概念 -> 与概念相关的api -> api的功能, 特点, 不同系统上的实现差异, 应用场景 -> 程序示例(需求, 解释)

	概念需要理解记
	api先初略了解其功能特点. 暂时先不管各系统上的差异, 只管linux上的实现
	程序要先搞清需求, 再直看程序, 进一步搞明白api的使用. 对程序的解释, 留着针对疑问的参考. 

就从这里, 开始尽量看英文版本书吧, 英文版看不明白, 中文版是一样看不进去. 中文版大都是拍照的, 看得也闹心. 
无聊了, 看些书, 磨磨脑子, 现在不是玩游戏的时候. 况且有那么多事情要做. 真正投入到做事情中, 也并没有说就多么累, 反而是身心愉悦的. 

condition 是signal与mutex的结合, 所以取了一个新名字 condition吗? 

spin locks 使用的场景越来越小, 但是得知道忙等的概念. spin lock是既然是占用cpu, 是不是意味着必须得多核cpu才能用? 单核cpu被占着, 还有空去做其他事情吗? 

线程的创建 销毁 同步 都是 thread control primitive functions 

做练习题, 很多时候题意都搞不懂, 非得看答案才知道是在说什么, 读不懂题意, 心态就炸了, 题都读不懂, 何谈做出来...

### 习题与问题
1. Modify the example code shown in Figure 11.14 to pass the structure between the threads property.
	
	将structure 动态分配内存即可, 使用join可以传递参数, 按说全局变量也是可以的. 

2. In the example code shown in Figure 11.14, what additional synchronization (if any) is necessary to allow the master thread to change the thread ID associated with a pending job? How would this affect the job_remove function?

	需要在job中加入引用计数和互斥锁, 在job_find中增加count, destroy 时减少. 在write中判断, 必须引用计数为0时才可修改

3. Apply the techniques show in Figure 11.15 to the worker thread example( Figure 11.1 and 11.14) to implement the worker thread function. Don't forget to update the queue_init function to initialize the condition variable and change the job_insert and job_append functions to signal the worker threads. What difficulties arise?

	惊群效应: 当唤醒了许多线程但又没有工作可做, 导致cpu资源的浪费, 增加了锁有争夺. 
	thundering herd problem: 
	所以, 不同的场合有不同的同步选择, 这也是为何这有么多同步机制的来源, 就是为了适应不同的场景. 

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

	每种情况都可能是正确的, 但每种方法都有不足之处. 

5. What synchronization primitives would you need to implement a barrier? Provide an implementation of the pthread_barrier_wait function.

	第一想法是signal, 
	源码实现看不懂, 网上搜索到了一个timer的实现版本. 
	signal 就不能实现吗? signal实现不能阻塞. 
	

