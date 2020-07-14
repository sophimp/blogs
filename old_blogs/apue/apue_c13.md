
## 第十三章 守护进程

### 学习记录

Intruduction

	随着系统的生命周期运行的进程， 用来做监护系统的状态之类的日常事务的工作。 

Daemon Characteristics

Coding Rules

Error Logging

Single-Instance Daemons

Daemon Conventions

Client-Server Model


### 总结

	目前貌似只需了解到， 守护进程， 没有控制终端,但是可以通过命令控制, SIGHUB信号可以触发处理, 一般是用来处理系统的日常事务（定时任务， 系统日志等) 即可， 前期开发应该用不到守护进程。 

	大多数Unix系统中, 守护进程是一直运行的。 
	cron 守护进程, 可做一些定时任务。 

### 习题与问题
13.1 As we might guess from Figure 13.2, Whe the syslog facility is initialized, either by calling openlog directly or on the first call to syslog, the special device file for the UNIX domain datagram socket, /dev/log, has to be opened. What happens if the user process (the daemon) calls chroot before calling openlog?

13.2 Recall the sample as ps output from section 13.2. The only user-level daemon that isn't a session leader is the rsyslogd process. Explain why the syslogd daemon isn't a session leader.

13.3 List all the daemons active on your system, and identify the function of each one.

13.4 Write a program that calls the daemonize function in Figure 13.1. After calling this function, call getlogin(Section 8.15) to see whether the process has a login name now that it has become a daemon. Print the result to a file.
