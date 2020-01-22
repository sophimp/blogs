
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

函数sigsuspend
函数abort
函数system
函数sleep, nanosleep 和 clock_nanosleep
函数 sigqueue
作业控制信号
信号名和编号

### 总结

### 习题与问题
1. 删除图 10-2 程序中的for(;;) 语句, 结果会怎样? 为什么?

2. 实现10.22节中说明的sig2str函数

3. 画出运行图 10-9 程序时的栈帧情况

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


5. 仅使用一个定时器, (alarm 或较高精度的 setitimer), 构造一组函数, 使得进程在该单一定时器基础上可以设置任一数量的定时器. 

6. 编写一段程序测试图 10-24 中父进程和子进程的同步函数, 要求进程创建一个文件并向文件写一个整数0, 然后, 进程调用fork, 接着, 父进程和子进程交替增加文件中的计数器值, 每次计数器值增加1时, 打印是哪一个进程(子进程或父进程)进行了该增加1操作. 

7. 在图 10-25 中, 若调用者捕捉了 SIGABRT 并从该信号处理程序中返回, 为什么不是仅仅调用_exit, 而要恢复其默认设置并再次调用kill? 

8. 为什么在siginfo 结构(见10.14节)的si_uid字段中包括实际用户ID而非有效用户ID?

9. 重写图10-14中的函数, 要求它处理图10-1中的所有信号, 每次循环处理当前信号屏蔽字中的一个信号(并不是对每一个可能的信号都循环一次).

10. 编写一段程序, 要求在一个无限循环中调用sleep(6)函数, 每5分钟(即5次循环)取当前的日期各时间, 并打印tm_sec字段. 将程序执行的一晚上, 请解释其结果. 有些程序, 如cron 守护进程, 每分钟运行一次, 它时如何处理这类工作的?

11. 修改图 3-5 的程序, 要求: (a) 将 BUFFSIZE 改为100; (b) 用signal_intr 函数捕捉SIGXFSZ信号量并打印消息, 然后从信号处理程序中返回; (c) 如果没有写满请求的字节数, 则打印 write 的返回值. 将软资源限制 RLIMIT_FSIZE (见7.11节) 更改为 1024字节(在shell中设置软资源限制, 如果不行就直接在程序中调用setrlimit), 然后复制一个大于1024字节的文件, 在各种不同的系统上运行新程序, 其结果如何? 为什么?

12. 编写一段调用write的程序, 它使用一个较大的缓冲区(约1GB), 调用fwrite 前调用alarm 使得ls以后产生的信号. 在信号处理程序中打印捕捉到的信号, 然后返回. fwrite 可以完成吗? 结果如何? 
