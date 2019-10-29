
## 第三章 文件I/O

### 学习记录

文件描述符

	是一个非负整数, 从0开始, 0,1,2 分别代表 STDIN_FILENO, STDOUT_FILENO, STDERR_FILENO
	每一个进程都一个文件描述符表, 有最大打开文件数. 

	在unix系统里, 一切皆文件, 文件描述符就是一个高度的抽象. 
	
	文件描述符表: 文件起始地址, 结束地址, 读文件指针, 文件描述符. 

open 和 openat

	#include <fcntl.h>
	int open(const char *path, int oflag, .../* mode_t mode */);
	int openat(int fd, const char *path, int oflag, ... /* mode_t mode */);

	其中 oflag 值:
		必选常量: O_RDONLY, O_WRONLY, O_RDWR, O_EXEC, O_SEARCH
		可选常量: O_APPEND, O_CLOEXEC, O_CREAT, O_DIRECTORY, O_EXCL, O_NOCTTY, O_NOFOLLOW, O_NOBLOCK, O_SYNC, O_TRUNC, O_TTY_INIT, O_SYNC, O_RSYNC. 

	openat 函数解决了以相对路径打开文件.  如果是绝对路径, 与open函数一样. 两个函数的反回值都是最小未用描述符数值. 

	TOCTTOU (time-of-check-to-time-of-use): 两个基于文件的函数调用, 其中第二个函数依赖于第一个调用的结果, 那么程序是脆弱的. 

creat

	#include <fcntl.h>
	int creat(const char *path, mode_t mode);

	等效于 open(path, O_WRONLY | O_CREAT | O_TRUNC, mode);
	creat 的一个不足之处是: 它以只写的方式打开所创建的文件. 

	创建一个临时文件:
		create 方式, create, close, open
		open 方式, open(path, O_RDWR | O_CREAT | O_TRUNC, mode);

close

	#include <unistd.h>
	init close(int fd);

	关闭一个文件还会释放该进程加在该文件上的锁. 
	当一个进程终止时, 内核自动关闭它所有的打开文件. 

lseek

	#include <unistd.h>
	off_t lseek(int fd, off_t offset, int whence);

	whence值:
		SEEK_SET: 将该文件偏移量设置为距文件开始处的 offset 个字节
		SEEK_CUR: 将该文件偏移量设置为当前值加上offset, offset 可正可负
		SEEK_END: 将该文件偏移量设置为文件长度加offset, offset可正可负. 

	执行成功返回新的文件偏移量. 如果文件描述符指向的是一个管道, FIFO 或网络套接字, 则反回 -1, 并将 errno 设置为 ESPIPE.

	lseek 的offset 大于文件大小, 会形成空洞文件. 

	示例见 apue/chapter03.c  中 create_hole_file()

read, write

	#include <unistd.h>
	ssize_t read(int fd, void *buf, size_t nbytes);
	
	read 成功, 返回读到的字节数, 读到文件末尾, 返回0 
	nbytes > sizeof(buf), 返回 buf size, 下一次读时返回0 
	从终端设备读时, 通常一次只能读一行
	从管道或FIFO设备读时, read 将只返回实际读取数
	从面向记录的设备(如磁带)读时, 一次最多返回一个记录. 
	读取时,有信号中断, 有的系统会处理成失败, 有的会处理成成功, 返回已读字节数. 
	void* 表示通用指针
	
	#include <unistd.h>
	ssize_t write(int fd, void *buf, size_t nbytes);
	write成功, 返回已写字节数, write失败, 返回-1. 
	与read函数类同

I/O的效率

	与磁盘 block 大小有关, 超过磁盘块大小, 对效率的影响就微乎其微

文件的共享
	
	进程表项, 记录指向文件描述符表项的指针
	文件表项, 记录指向 v 节点表项的指针, 是一个虚拟的文件操作, 同样也有文件的读写记录, 与虚拟内存思想(类似于二级指针?)类同. 
	v 节点表项, 真正的与碰盘操作的信息表. v节点表项, i 节点信息, 各是什么? 

	v 节点结构的目的是对在一个计算机系统上多文件系统类型提供支持. 把与文件系统无关的i节点部分称为v节点. 那么i节点部分就是不同文件系统的特征?
	linux系统采用了一个与文件系统相关的i节点和一个文件系统无关的i节点. 

	v节点表项, i节点, 与文件系统有关, 无关, 这个暂可先理解成 v节点表项的责任就是与磁盘实际物理读取相关的数据结构. 
	至于如何实现, 待review 源码. 

原子操作

	将几个操作合为一个不可被打断的操作, 要么都执行, 要么都不执行. 

	#include <unistd.h>
	ssize_t pread(int fd, void *buf, size_t nbytes, off_t offset);
	ssize_t pwrite(int fd, void *buf, size_t nbytes, off_t offset);
	都是原子操作. 相当于先 lseek, 再进行read, write操作. 

dup 和 dup2

	#include <unistd.h>
	int dup(int fd);
	int dup2(int fd, int fd2);

	是复制函数, dup 返回当前进程未使用的最小文件描述符,  dup2 可以指定新描述符的值, 如果fd2已经打开, 可以先将其关闭, FD_CLOEXEC 文件描述符标志将被清除. 如果 fd == fd2, 则dup2 返回fd2, 不关闭它. 

	dup2 是一个原子操作. 

sync, fsync, fdatasync

	磁盘I/O都通过缓冲区进行, 延时写, 但传统unix实现在内核中并没有设置缓冲区高速缓存或高速缓存. 
	为了保证磁盘上实际文件系统与缓冲区中的内容一致性, unix提供了 sync, fsync, fdatasync 三个函数. 
	#include <unistd.h>
	int fsync(int fd); // 指定一个文件起作用, 并等待写磁盘操作结束才返回. 
	int fdatasync(int fd); // 类似于fsync, 但只影响数据部分, 不会更新文件属性.
	int sync(void); // 只是将修改过的块缓冲区排入写队列, 然后就返回, 它并不等待实际写磁盘操作结束. 

fcntl

	#include <fcntl.h>
	int fcntl(int fd, int cmd, ... /* int arg */);

	file control? 
	a) 复制一个已有的描述符 (cmd=F_DUPFD 或 F_DUPFD_CLOEXEC).
	b) 获取/设置文件描述符标志 (cmd=F_GETFD 或 F_SETFD).
	c) 获取/设置文件状态标志 (cmd=F_GETFL 或 F_SETFL).
	d) 获取/设置异步I/O所有权 (cmd=F_GETOWN 或 F_SETOWN).
	e) 获取/设置记录锁 (cmd=F_SETLK , F_SETLKW, F_GETLK).

	示例见 apue/chapter03.c  中 fcntl_test()
	./c03 0 < /dev/tty	关于重定向符这些代表什么参数, 不清楚
	解决: 重定向符不是c03 接收的参数, 供 shell解析. 所以这条命令的意思是将 /dev/tty 重定向到0, 然后使用 fcntl 读取文件属性

ioctl

	io control, 这个函数的出境率也挺高, 但是看完没有啥印象. 
	io 操作的杂物箱.

	#include <unistd.h> /* System V */
	#include <sys/ioctl.h> /* BSD and linux */
	int ioctl(int fd, int request, ...);

	第18章再继续. 

/dev/fd

	在/dev/fd 目录下有 0, 1, 2等文件, 可以通过打开这些文件来复制描述符n. 

	fd = open("/dev/fd/0", mode"); 等效于 fd = dup(0);

### 总结

	read, write 都是在内核中执行的函数, 没有做缓存, 通过观察不同的I/O bufferSize 长度对读取文件所需时间的影响
	但是在sync, fsync, fdatasync这些函数中介绍, 后续的unix都还是做了缓存.

	read, write 的bufSize 并不是内核的缓存

	多个进程操作同一文件, 原子操作
	ioctl, fcntl 函数抛出了一个引子. 

### 习题与问题

1. 当读/写磁盘文件时, 本章中描述的函数确实是不带缓冲机制的吗? 请说明原因.

	read, write 不带缓冲机制, 这个缓冲指的是内核的三缓缓存技术吗? 方法参数中的bufSize 与题中所描述的缓冲机制不是一个概念? 
	原因: 在内核中调用的函数, 这是不是原因呢? 这句话的意思是不是所有在内核中调用的函数都不带缓冲? 

	答案: 所有的I/O都要经过内核的块缓存区(就是cpu的三级缓存), 唯一的例外是对原始磁盘设备的I/O, 但不考虑这种情况, 即然read 和 write的数据都要经过内核缓冲, 那么"不带缓冲的I/O" 指的是在用户的进程中对这两个函数不会自动缓冲, 每次read 或 write 就要进行一次系统调用. 
	术语 不带缓冲的I/O 指的是用户进程对函数的缓存. 每次都是一次系统调用, 那不就是应该的么? 

2. 编写一个与 3.12 节中 dup2 功能相同的函数, 要求不调用 fcntl 函数, 并且要有正确的出错处理.

	使用dup 功能? dup2 是原子操作, 且可指定新 fd 描述符

	示例见 apue/chapter03.c 中 

3. 假设一个进程执行下面3个函数调用:
	
	fd1 = open(path, oflags);
	fd2 = dup(fd1);
	fd3 = open(path, oflags);

画出类似于图3-9的结果图. 对于fcntl 作用于fd1 来说, F_SETFD 命令会影响哪一个文件描述符? F_SETFL 呢? 

	open 一次会打开一个文件表项, open 同一个文件, 会打开创建两个文件表项, 但是共享同一个v节点. 所以, fd1, fd2 共享同一个文件表项, 它们三个共享同一个v节点. 

	F_SETFD 只会作用于 fd1 , F_SETFL 是设置文件标志的, 会作用于 fd1, fd2

4. 许多过程中都包含下面一段代码:

	dup2(fd, 0);
	dup2(fd, 1);
	dup2(fd, 2);
	if(fd > 2)
		close(fd);
为了说明if语名的必要性, 假设fd是1, 画出每次调用dup2 时3个描述符项及相应的文件表项的变化情况. 然后再画出fd为3的情况.

	0, 1, 2分别是标准输入, 输出, 错误信息, 
	fd = 1 时, 
		dup2(fd, 0) 先关闭 0, 再将 0 -> 1
		dup2(fd, 1) 不打开也不关闭 1
		dup2(fd, 2) 先关闭 2, 再将 2 -> 1
		最终结果是0, 2 -> 1

	fd = 3 时,
		dup2(fd, 0) 先关闭0, 再将 0 -> 3
		dup2(fd, 1) 先关闭1, 再将 1 -> 3
		dup2(fd, 2) 先关闭2, 再将 2 -> 3

	为何要判断 fd > 2 呢? fd=3 时并没有看到其他问题. 
	
	答案: fd=1, 执行 dup2(fd, 1) 返回1, 没有关闭描述符1, 调用3次dup2后, 3个描述符指向相同的文件表项, 所以不需要关闭描述符
	fd=3, 调用3次dup2后, 有4个描述符指指向相同的文件表项, 这种情况下就需要关闭描述符3. 

	为何4个描述符指向同一个描述符, 就要关闭掉一个呢? 

5. 在Boune shell, Bourne-again shell 和 Korn shell中, digit1>&digit2 表示要将描述符digit1重定向至描述符digit2的同一文件. 请说明下面两条命令的区别. (shell命令是从左向右解析的)

	./a.out > outfile 2>&1 
	./a.out 2>&1 > outfile

	这两条命令还真解析不出来, 第一条命令outfile 2 会当成一个文件吗? 否则a.out的结果输出到 outfile 接下来如何连接后面的命令
	第二条命令 a.out 2 算是一个命令? 但是如果命令返回的不是文件描述符呢? 还会重定向到 &1 吗? 然后再将内容输出到 outfile? 
	
	看完答案推测, 所有的可执行程序默认都是输出到标准输出描述符1(大多数情况下都是终端)的, 
	所以 第一条命令中 ./a.out > outfile 的作用是将 1 重定向到 outfile,  接下来 2>&1 是调用dup2(1,2) 将2重定向到1, 即将1的输出复制到2. 最终, 2也指向outfile
	按这样解析, 是两个并列的命令, 怎么不需要管道连接或者分号隔开呢? 

	第二条命令是先将 2 -> 1(即终端), 然后再将./a.out 的终端输出1 -> outfile, 最终, 2 -> 原有的终端输出, 1 -> outfile
	
	文件描述符重定向操作即是改变其中v节点指针操作, 疑惑的是这样的并行命令是允许存在的?! 确是可以执行的, 要在哪里找相关资料. 

6. 如果使用追加标志打开一个文件以便读,写, 能否仍用lseek在任一位置开始读? 能否用lseek 更新文件中任一部分的数据? 请编写一段程序验证.

	可以任意读, 不可以任意写, 
	添加了append标志, 使每次写都是一个原子操作, 原子操作里讲了, 同样有原子操作的函数有pwrite()

	验证程序见 apue/chapter03.c 中 append_verfiy_lseek()
