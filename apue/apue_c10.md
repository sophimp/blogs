
## 第十章 信号

### 学习记录

信号, 看过很多次了, 最初的印象还是在学习OC的时候, 哦, 又想起了在华为外包的日子. 

	先将自己提升起来吧, 我现在的能力, 自己都管不好, 如何还想着去拯救别人? 没有谁是在等着我去拯救的, 除了我自己. 
	学习是急不来的, 那么找找状态, 就得换另一个状态, 下一次再找的感觉, 当然也得适应. 

关键就是看书是在被动接受, 投入不进去. 所以, 总是进入不了状态, 一天一天, 时间在消逝, 我还是卡在这里. 我能做什么呢? csapp 的 lab做起来? 那么apue 又该怎么办, Unix网络编程又该怎么办呢? 现在了解到, 确实, posix的api我得学习, 现在基础的编程就是要学习这些api, 不仅如此, 主要还是设计的思想. 犯什么迷和懒呢? 

信号概念

	信号就有些类似于中断的概念? 还是说, 中断也只是信号的一种. 
	信号就是软件中断.
	linux支持31种信号, 每个系统支持的不一样, posix 实时扩展.  
	每个信号都有一个名字, 以SIG开头
	说细介绍了产生这些信号的场景
	其中 kill 函数 可以号将状态码传给要终止的进程

函数signal
	
	用来捕捉信号并处理的函数, 推荐使用 sigaction 函数, 因为signal 函数的语义与实现有关

不可靠信号
	
	历史原因, 系统对信号处理不可靠, 有的进程感知不到, 有的想处理却被永远阻塞. 

	不可靠信号指的是, 信号可能会丢失; 一个信号发生了, 但是进程却可能一直不知道这一点.  同时, 进程对信号的控制能力也很差. 

中断的系统调用
	
	信号中断的调用是内核中执行的系统调用

可重入函数

	调用标准I/O函数, 使用静态数据结构, 调用了malloc,free的函数, 都是不可重入函数. 
	在信号处理中调用不可重入函数, 结果是未知的. 
	
SIGCLD语义

	子进程状态变化时, 会发出此信号, 父进程需调用wait族函数用以捕捉

	对于SIGCLD 信号, 不同系统的处理不同, 对于SIGCHLD 信号, 子进程状态发生改变时会发
	如果SIGCHLD 信号被忽略, 则会产生僵死进程. 

可靠信号术语和语义

	信号屏蔽字
	信号产生, 信号递送, 未决的

函数 kill 和 raise

	kill 函数将信号发送给进程或进程组
	raise 函数允许进程向自身发送信号

函数alarm 和 pause

	alarm 函数可以设置一个定时器, 将来的某个时刻, 定时器会超时, 超时的时候会产生 SIGALRM 信号

	pause 函数休眠当前进程, 直到接收到一个信号. 

	alarm 和 pause 结合起来, 可以实现 sleep 函数的效果. 

	alarm 多次会相互影响, 与第一次alarm的状态比较. 

信号集

	表示多个信号的数据类型

	int sigemptyset(sigset_t *set);
	int sigfillset(sigset_t *set);
	int sigaddset(sigset_t *set, int signo);
	int sigdelset(sigset_t *set, int signo);
	int sigismember(const sigset_t *set, int signo);
	
函数sigprocmask

	信号屏蔽字, 规定了当前阻塞而不能递送给该进程的信号集. 
	int sigprocmask(int how, const sigset_t *restrict set, sigset_t *restrict oset);
	SIG_BLOCK		该进程新的信号屏蔽字是其当前信号屏蔽字和set指向信号集的并集. set包含了希望阻塞的附加信号. 
	SIG_UNBLOCK		该进程新的信号屏蔽字是其当前信号屏蔽字和set指向信号集补集的交集. set包含了希望解除阻塞的信号. 
	SIG_SETMASK		该进程新的信号屏蔽是set指向的值. 
	不能阻塞 SIGKILL 和 SIGSTOP 信号

	sigprocmask 函数可以检测或更改, 或同时进行检测或更改进程的信号屏蔽字. 

函数sigpending

	int sigpending(sigset_t *set);

	通过set 参数返回信号集, 其中的信号是阻塞不能递送的, 因而也一定是当前未决的. 
	信号没有被排队, 重复产生的信号, 后面的会覆盖前面的. 

函数sigaction

	int sigaction(int signo, const struct sigaction *restrict act, struct sigaction *restrict oact);
	检查或(/并)修改与指定信号相关联的处理动作. 
```c
	struct sigaction{
		voic (*sa_handler)(int); /* addr of signal handler, or SIG_IGN, or SIG_DFL*/
		sigset_t sa_mask;		 /* additional signals to block */
		int		sa_flags;		 /* signal options, Figure 10.16 */
		void	(*sa_sigaction)(int, siginfo_t *, void *); /* alternate handler */
	 };
	struct siginfo{
		int si_signo;	/* signal number */
		int	si_errno;	/* if nonzero, errono value from <errno.h> */
		int si_code;	/* additional info (depends on signal) */
		pid_t si_pid;	/* sending process ID */
		uid_t si_uid;	/* sending process real user ID */
		void *si_addr;  /* address that caused the fault  */
		int si_status;	/* exit value or signal number */
		union sigval si_value; /* application-specifica value */
		/* possibly other fields also */
	}
	union sigval{
		int sival_int;
		void *sival_ptr;
	}
```

函数sigsetjmp和siglongjmp

	#include <setjmp.h>
	int sigsetjmp(sigjmp_buf env, int savemask);
	void siglongjmp(sigjmp_buf env, int val);

	setjmp 和 longjmp, 非局部转移的函数, 在信号处理程序中经常调用longjmp函数以返回到程序的主循环中, 而不是从该处理程序返回. 

	sigsetjmp 多了一个savemask 参数, 非零表示,在env中保存进程的当前信号屏蔽字. 

	sigsetjmp, siglongjmp 只管一次, 且不能跨进程, 只是跨函数

函数sigsuspend

	修改进程的信号屏蔽字, 可以阻塞或解除对它们的阻塞. 这种技术可以保护不希望由信号中断的代码临界区. 
	如果在信号阻塞时, 产生了信号, 那么该信号的传递就被推迟直到它解除了阻塞. 

	int sigsuspend(const sigset_t *sigmask);

	在早期的不可靠信号机制中会产生一个问题, 如果在解除阻塞时刻和pause之间确实发生了信号, 因为可能不会再见到该信号, 所以从这种意义上讲, 在此时间窗口中发生的信号丢失了, 这样就使得pause永远阻塞. 
	纠正此问题, 需要在一个原子操作中先恢复信号屏蔽字, 然后使进程休眠. 这种功能是sigsuspend函数实现的. 

	
函数abort

	调用abort将向主机环境递送一个未成功终止的通知, 其方法是调用raise(SIGABRT)函数

函数system

	打开一个shell进程, 执行 cmd 命令. 处理相关的信号, 调用system函数, 一定要正确地解释其返回值. 
	这个函数, 同样也没有深入理解, 待用到时再钻吧. 第一遍就是知其然. 

函数sleep, nanosleep 和 clock_nanosleep

	从名字上看, 精度不同, 秒, 纳秒, 时钟纳秒.

```c
	#include <unistd.h>
	unsigned int sleep(unsigned int seconds);

	#include <time.h>
	int nanosleep(const struct timespec *reqtp, struct timespec *remtp);

	int clock_nanosleep(clockid_t clock_id, int flags, const struct timespec *reqtp, sturct timespec *remtp);
```

	sleep与alarm函数, 更具体的应用, 还是到应用中再发现吧. 现在看了一遍, 印象不深. 
	还有某些具体的函数类型, 都得搞明折, siginfo, sigaction

函数 sigqueue

```c
	#include <signal.h>
	int sigqueue(pid_t pid, int signo, const union sigval value);
```

	在POSIX.1 增加信号排队的扩展支持, 在SUSv4中, 排队信号功能已从实时扩展中移至基础说明部分. 
	sigqueue 函数只能把信号发送给单个进程, 可以使用value 参数向信号处理程序传递整数和指针值. 除此之外, sigqueue 与 kill 功能类似. 
作业控制信号

	SIGCHLD 子进程已停止或终止. 
	SIGCONT 如果进程已停止, 则使其继续运行.
	SIGSTOP 停止信号(不能被捕捉或忽略)
	SIGTSTP 交互式停止信号
	SIGTTIN 后台进程组成员读控制终端
	SIGTTOU 后台进程组成员写控制终端

	除了sigchld 信号,大多数应用并不处理这些信号, 交互式shell则通常会处理这些信号的所有工作. 

信号名和编号

```c
	extern char *sys_siglist[];

	#include <signal.h>
	void psignal(int signo, const char *msg);

	#include <signal.h>
	int sig2str(int signo, char *str);
	int str2sig(const char *str, int *signop);
```

### 总结

学习信号处理, 主要还是这一套机制的原理, 每一步,都对应一个状态. 每个函数的功能, 才能配合好使用信号.

不同平台, 不同语言, api肯定不一样, 但是原理操作基本上是一样的. 

为何要有pending状态? suspend 又是何许人也? 

信号制的阻塞与解除, 为了解决什么问题? 保护不希望由信号中断的代码临界区. 

信号用于大多数复杂的应用程序中. 

本单介绍了可靠信号概念以及所有相关函数, 在此基础上提供abort, system, sleep 函数的 POSIX.1实现, 最后以观察分析作业控制信号以及信号名和信号编号之间的转换结束. 

信号编程思想: 

	处理信号屏蔽字 sigprocmask
	监听信号	signal
	发送信号	kill, raise, sigqueue
	非局部跳转  sigsetjmp, siglongjmp, 只能在同一进程内跳转, 不可以跨进
	结合 fork 函数, 多进程编程, 也是并发编程的一种. 

	注册信号监听, 将信号屏蔽, 然后放开, 给另一个进程发送信号, 进程由sigsuspend函数挂起, 进入下一个循环. 另一个进程同理
	
### 习题与问题
1. 删除图 10-2 程序中的for(;;) 语句, 结果会怎样? 为什么?

	在第一次捕捉到信号, 进程就终止了, 因为一捕捉到信号, pause就会返回

2. 实现10.22节中说明的sig2str函数

	这个没啥难度, 就是将信号名翻译成字符串, 实现跟pr_mask是一样的. 调用sigismember函数判断信号

3. 画出运行图 10-9 程序时的栈帧情况

	看了答案的栈帧, 很清晰, 还是英文版的pdf清晰. 

4. 图 10-11 程序中利用 setjmp 和 longjmp 设置 I/O 操作的超时, 下面的代码也常见于此种目的:
```c
signal(SIGALRM, sig_alrm);
alarm(60);
if (setjmp(env_alrm) != 0){
	/* handle timeout */
	...
}
```
这段代码有什么错误? 
	
	在第一次调用alarm 和 setejmp之间又有一次竞争条件, 如果进程在调用alarm和setjmp之间被内核阻塞了, alarm超时后就调用信号处理程序, 然后调用longjmp, 但是由于没有调用过setjmp, 所以没有设置env_alrm缓冲区. 此时说明longjmp的操作是未定义的. 

5. 仅使用一个定时器, (alarm 或较高精度的 setitimer), 构造一组函数, 使得进程在该单一定时器基础上可以设置任一数量的定时器. 

	硬核题, 还得看论文实现

6. 编写一段程序测试图 10-24 中父进程和子进程的同步函数, 要求进程创建一个文件并向文件写一个整数0, 然后, 进程调用fork, 接着, 父进程和子进程交替增加文件中的计数器值, 每次计数器值增加1时, 打印是哪一个进程(子进程或父进程)进行了该增加1操作. 

	看练习题, 这个也是面试的经典题型了. 这个是要用waitpid来做, 还是要用信号来做? 

7. 在图 10-25 中, 若调用者捕捉了 SIGABRT 并从该信号处理程序中返回, 为什么不是仅仅调用_exit, 而要恢复其默认设置并再次调用kill? 

	如是仅仅调用_exit, 进程终止状态不能表示该进程是由于 SIGABRT 信号而终止的
	
8. 为什么在siginfo 结构(见10.14节)的si_uid字段中包括实际用户ID而非有效用户ID?

	如果信号是由其他进程发出的, 进程必须设置用户ID为root或者是接收进程的所有者, 否则kill不能执行. 所以实际用户ID为信号的接收者提 供了更多的信息. 

9. 重写图10-14中的函数, 要求它处理图10-1中的所有信号, 每次循环处理当前信号屏蔽字中的一个信号(并不是对每一个可能的信号都循环一次).

	还没有理解题义, 每次循环处理当前信号屏蔽字中的一个信号是什么意思.

10. 编写一段程序, 要求在一个无限循环中调用sleep(6)函数, 每5分钟(即5次循环)取当前的日期各时间, 并打印tm_sec字段. 将程序执行的一晚上, 请解释其结果. 有些程序, 如cron 守护进程, 每分钟运行一次, 它时如何处理这类工作的?

	每60~90分钟增国一秒. 
	每次调用sleep都需要调度一次将来的时间事件, 而这是由cpu调度的, 有时并没有发生在事件发生时立即被唤醒. 
	其次进程开始运行和再次调用sleep都需要一定量的时间. 

	cron守护进程每分钟都要获取当前时间, 首先设置一个休眠周期, 然后在下一分钟开始时唤醒. 将当前时间转换成本地时间并查看tm_sec值. 这样就可以补偿上面两种情况的误差, 大多数是调用sleep(60), 偶尔有一个sleep(59), 但是若在进程中花费了许多时间执行命令或者系统的负载重, 调度慢, 这时休眠值可能远小于60. 

11. 修改图 3-5 的程序, 要求: (a) 将 BUFFSIZE 改为100; (b) 用signal_intr 函数捕捉SIGXFSZ信号量并打印消息, 然后从信号处理程序中返回; (c) 如果没有写满请求的字节数, 则打印 write 的返回值. 将软资源限制 RLIMIT_FSIZE (见7.11节) 更改为 1024字节(在shell中设置软资源限制, 如果不行就直接在程序中调用setrlimit), 然后复制一个大于1024字节的文件, 在各种不同的系统上运行新程序, 其结果如何? 为什么?

	也是硬核题, 还得搞4种系统, SIGXFSZ, 超过文件长度限制

12. 编写一段调用write的程序, 它使用一个较大的缓冲区(约1GB), 调用fwrite 前调用alarm 使得 1s 以后产生的信号. 在信号处理程序中打印捕捉到的信号, 然后返回. fwrite 可以完成吗? 结果如何? 

	fwrite, write

