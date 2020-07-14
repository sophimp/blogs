
## 第六章 系统数据文件和信息

本章的内容也较少, 主要介绍了 /etc/passwd, /etc/group

其他常用的 /etc/serivces, /etc/hosts, /etc/networks, /etc/shadow, /etc/protocols

登录信息 utmp

系统标识 uname

系统时间 

	UTC, Coordinated Universal Time, 协调世界时
	time, date, strftime, 
	时区 EST/CST

### 学习记录

口令文件
阴影文件
附属组ID
实现区别
其他数据文件
登陆帐户记录
系统标识
时间和日其例程
	strftime 各格式化参数

### 总结

本章的内容, 也是增加对系统信息的也解, 文件的权限机制, 是由 /etc/passwd, /etc/shadow 和 /etc/group 来校验的
系统相关信息的获取, 时间和日期的转换
这些知识, 后续编程用到时再查, 一般也就是在日志系统中用到. 便于远程调试, 信息统计. 

对于日常使用来说, uname, host, hostname, date, time, group, passwd, 这些命令基本上对应本章知识. 

### 习题与问题

1. 如果系统使用阴影文件, 那么如何取得加密口令?

	有专门的函数, getspnam, getspent, setspent, enspent

2. 假设你有超级用户权限, 并且系统使用了阴影口令, 重新考虑一道习题.

	可以直接查看 /etc/shadow

3. 编写一程序, 它调用uname 并输出 utsname 结构中的所有字段, 将该输出与uname(1)命令的输出结果进行比较. 
```c
struct utsname{
	char sysmname[]; /* name of the opearting system */
	char nodename[]; /* name of node */
	char release[];  /* current release of the opearting system */
	char version[];  /* current version of the release */
	char machine[];  /* name of hardware type */
}
```

4. 计算可由time_t数据类型表示的最近时间. 如果超出了这一时间会如何呢? 

	时间出现混乱, 难不成世界末日?  time_t 是long型的, 在32位系统上是4字节

5. 编写一程序, 获取当前时间, 并使用strftime将输出结果转换为类似于date(1)命令的默认输出. 将环境变量TZ设置为不同值, 观察输出结果. 

6. 什么是系统自举
	
	应该叫作计算机自举, 自己激活各个元器件, 以便完成加载操作系统这一目的, 再由操作系统完成更复杂的任务. 
	自己加电自检, 磁盘引导.
