
## 第二章 Unix标准及实现

### 学习记录

对于标准, 一直都不是很重视, 太枯燥了. 实际过第一篇也确实如此, 几度都看睡着了. 

但是标准还是很有用处的. 至少对于开发可移植代码, 大家都遵守是有必要的. 

Unix 标准化

	有四种标准 
	ISO C 是最权威的, ANSI 标准, 有24个头文件. 所以, 只包含这几个头文件实现的程充, 是支持ISO C的
	IEEE POSIX 是最通用的, 由IEEE 协会制定, 已被很多计算机制造商所采用. Posix支持ISO C, 但是也有一些不同的地方. 如time.h 中的一部分. 
	SINGLE Unix Specification 是 POSIX 的超集, XSI(X/Open System Interface), 只有遵循XSI实现的才能称为UNIX系统
	FIPS, 已经淘汰为历史. 

	各标准的头文件, 有必要整体看一下, 分区思想, 所包含的内容. 
	
	接下来章节使用的到的 
	ISO
	errno.h, limits.h, setjmp.h, signal.h, stdio.h, time.h
	POSIX
	dirent.h(目录项), fcntl.h, grp.h, poll.h(投票函数), pthread.h, pwd.h, termios.h(终端I/O), sys/select.h, sys/socket.h, sys/stat.h, sys/times.h, sys/types.h, sys/un.h, sys/utsname.h, sys/wait.h, ftw.h(文件树漫游), syslog.h, sys/ipc.h, sys/msg.h, sys/resource.h, sys/sem.h, sys/shm.h, sys/uio.h, 
	

Unix 系统实现

	SVR4 最早的 BSD? 是AT&T实验室开发, 后来的4.4BSD 包含了 SVR4 专有源码, 是由加州伯克利分校开发的. 
	Free BSD 是开源的, 基于由Berkly 大学开发的4.4BSD-Lite版本生成的 FreeBSD项目. 
	Linux 是开源的, 最流形的类 Unix 系统
	Mac OS X (10.5的Intel部分)被证明是 Unix系统
	Solaris 不是很熟悉, 由Oracle 开发的Unix系统版本, 基于 SVR4, OpenSolaris 是基于Solaris大分部开源代码生成的项目, 试图建立围绕Solaris 的外部开发人员社区. 
	
标准和实现的关系

	四种Unix 系统在不同程度上都实现了POSIX.1 标准, Mac OS X 和 Solaris可以称为正统, 但是FreeBSD, 和 Linux也都提供了Unix编程环境. 

	本书只关注POSIX.1 标准所有要求的功能, 并指出四个系统之前的差别. 

限制

	大量标准化的工作, 找出了若干可移植的方法用以确定Unix系统中的魔数和特定技术的确定的常量. 

	限制的类型: 编译时限制, 运行时限制. 

	与文件或目录无关的运行时限制, 使用 sysconf 函数来查找检查
	与文件或目录有关的运行时限制, 使用 pathconf, fpathconf 函数查找检查. 

	ISO 限制 limits.h 
	POSIX限制 各个方面的一套标准. 
		数据类型的最大值, 最小值, 运行时可增加的什, 其他不变值, 文件名, 路径, 同时打开最大I/O数
	XSI 限制
		最小值, 运行时不变值. 

选项

	这个看完第一遍, 完全不知道讲了什么!

	所谓的选项就是指POSIX.1 XSI 所支持的功能(限制)选项.

	Posix 编译时限制定义在 unistd.h 中
	文件或目录无关运行时选选项使用sysconf来判断. 
	文件或目录有关运行时选选项使用pathconf, fpathconf 来判断. 
	每一种限制选项有3种平台可能支持的状态:
		1) 不支持, 符号常量没有定义或定义值为-1
		2) 支持, 符号常量定义值大于 0
		3) 符号常量定义值等于0, 需调用sysconf, pathconf, fpathconf来判断相应的选项是否支持. 

功能测试宏

	这个也不清楚讲了些什么

	POSIX_C_SOURCE, _XOPEN_SOURCE 就是功能测试宏.
	如果希望自定义的符号不与 POSIX.1 和 XSI定义的符号冲突, 只使用 POSIX.1 和 XSI 中的符号, 那么需要定义功能测试宏. 
	POSIX.1 使用功能测试宏来排除任何实现专有的定义. 
	XSI 中的功能测试宏_XOPEN_SOURCE通常定义为700
	POSIX.1 中的功能测试宏POSIX_C_SOURCE 通常定义为200809L


基本系统数据类型

	基本数据类型的范围, 浮点数的处理. 并不是我以为这样的! 

	在 sys/types.h 宝义了基本数据类型. 通常使用这些定义的基本数据类型, 不用考虑系统不同而变化的程序实现细节. 
	clock_t, comp_t, dev_t, fd_set, fpos_t, gid_t, ino_t, mode_t, nlink_t, off_t, pid_t, pthread_t, ptrdiff_t, rlim_t, sig_atomic_t, sigset_t, size_t, ssize_t, time_t, uid_t, wchar_t. 

标准之间的冲突

	如果 POSIX 与 ISO C 冲突了, 以ISO C 为准. 它们之间仍有差别. 

	如何只包含一次, 编译预处理的技巧. #ifndef #define #endif

### 总结

第一遍: 

	不同标准的实现, 是类unix 发行版的不同的根源. 
	BSD 是收费的, 在性能上可能要比linux更加优秀? 市面上经常以此为例子的是, 尽管linux是免费的, unix 依旧活到了现在, MAC OS X 的成功也经常被拿作例子. 
	不管如何, 目前主要的还是研究linux为主. 
	本书接下来章节主要是与 ISO, POSIX, USP 打交道
	我知道了这些标准, 短时间内也不考虑开发可移植性的程序, 当然还是根据标例来. 
	前两章的示例代码都没有敲. 接下来的章节, 代码就必须敲了. 但是api 不熟悉, 语法技巧不熟悉, 这个时候就中断, 去补C语言的知识了. 当初的计划本是如此. 
	
	还是宜采取流水线方式. 看完一遍, 先记录下来每一小节的印象, 然后, 再看一遍, 对着所写的, 查缺补漏, 再总自己的话, 将每一小节有一个交付. 

第二遍:

	本书分析的四个实现 FreeBSD, Linux, OpenSolaris 在某种意义上都是开源的. Mac OS X 是民用的.
	Unix编程环境标准化已取得了很大进展, 但是这些标准并不完美, 不能盲目地相信"权威"

### 习题与问题
1. 在2.8 节中提到的一些基本系统数据类型可以在多个头文件中定义. 例如, 在FreeBSD 8.0 中, size_t 在29个不同的头文件中都有定义. 由于一个程序可能包含这29个不同的头文件, 但是ISO C 却不允许对同一个名字进行多次typedef, 那么如何编写这些头文件呢? 

	头文件预编译处理 #ifndef #define #endif

2. 检查系统的头文件, 列出实现基本系统数据类型所用到的实际数据类型. 

	在基本数据类型小节中的, 大抵如此吧.
	clock_t, comp_t, dev_t, fd_set, fpos_t, gid_t, ino_t, mode_t, nlink_t, off_t, pid_t, pthread_t, ptrdiff_t, rlim_t, sig_atomic_t, sigset_t, size_t, ssize_t, time_t, uid_t, wchar_t. 

3. 改写图 2-17 中的程序, 使其在sysconf 为OPEN_MAX 限制返回LONG_MAX时, 避免进行不必要的处理. 

getrlinmit 运态得到每个进程最大打开文件描述符数, 因为可以修改对每个进程的限制. 

