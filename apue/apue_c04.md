
## 第四章 文件和目录

### 学习记录

本章的"枯燥" 程度就有些高了, 看了两周, 都看不下去. 信息量也有些大. 但大多都是熟悉的, 看得时候不上心. 

还是解决不了枯燥的本质, 本章是讲文件权限管理相关的函数. 同时也是工具使用. 代码里可用, 脚本中也可用. 

没有必要一直在这上面耗着

文件类型
	
	普通文件		S_ISREG()
	目录			S_ISDIR()
	块特殊文件		S_ISBLK()
	字符特殊文件	S_ISCHR()
	FIFO			S_ISFIFO()
	套接字			S_ISSOCK()
	符号链接		S_ISLINK()

相关函数原型, 与shell命令工具的参数还是有所差别, 但是功能是一样的

```c
#include <sys/stat.h>

// restrict 关键字么? 确实是c99中的关键字, 被修饰的指针变量所指的内存区域只能通过该指针来修改, 其他指针都是无效的. 
int stat(const char *restrict pathname, struct stat *restrict buf);
int fstat(int fd, struct stat *buf);
int lstat(const char *restrict pathname, struct stat *restrict buf);
int fstatat(int fd, const char *restrict pathname, struct stat *restrict buf, int flag);

#include <unistd.h>
int access(const char *pathname, int mode);
int faccessat(int fd, const char *pathname, int mode, int flag);

#include <sys/stat.h>
mode_t umask(mode_t cmask);

#include <sys/stat.h>
int chmod(const char *pathname, mode_t mode);
int fchmod(int fd, mode_t mode);
int fchmodat(int fd, const char *pathname, mode_t mode, int flag);

#include <unistd.h>
int chown(const char *pathname, uid_t owner, gid_t group);
int fchown(int fd, uid_t owner, gid_t group);
int fchownat(int fd, const char *pathname, uid_t owner, gid_t group, int flag);
int lchown(const char *pathname, uid_t owner, gid_t group);

#include <unistd.h>
int truncate(const char *pathname, off_t length);
int ftruncate(int fd, offt_t length);

#include <unistd.h>
int link(const char *existingpath, const char *newpath);
int linkat(int fd, const char *existingpath, const char *newpath, int flag);
int unlink(const char *pathname);
int unlinkat(int fd, const char *pathname, int flag);

#include <stdio.h>
int remove(const char *pathname);
int rename(const char *pathname, const char *newname);
int renameat(int oldfd, const char *pathname, int newfd, const char *newname);

// 创建符号链接不要求actualpath已经存在
#include <unistd.h>
int symlink(const char *actualpath, const char *sympath);
int symlinkat(const char *actualpath, int fd, const char *sympath);
ssize_t readlink(const char* restrict pathname, char *restrict buf, size_t bufsize);
ssize_t readlinkat(int fd, const char* restrict pathname, char *restrict buf, size_t bufsize);

#include <sys/time.h>
int utimes(const char *pathname, const struct timeval times[2]);

#include <sys/stat.h>
int mkdir(const char *pathname, mode_t mode);
int mkdirat(int fd, const char *pathname, mode_t mode);

#include <unistd.h>
int rmdir(const char *pathname);

#include <dirent.h>
DIR *opendir(const char *pathname);
DIR *fdopendir(int fd);
struct dirent *readdir(DIR *dp);
void rewinddir(DIR *dp);
int closedir(DIR *dp);
long telldir(DIR *dp);
int seekdir(DIR *dp, long loc);

#include <unistd.h>
int chdir(const char *pathname);
int fchdir(int fd);
char *getcwd(char *buf, size_t size);
```
S_IRWXU = S_IRUSR | S_IWUSR | S_IXUSR
S_IRWXG = S_IRGRP | S_IWGRP | S_IXGRP
S_IRWXO = S_IROTH | S_IWOTH | S_IXOTH


### 总结

本章围绕stat 函数, 介绍了stat 结构中的每一个成员. 

```c
struct stat{
	mode_t			st_mode;	/* 文件类型 & 模式(权限) */
	ino_t			st_ino;		/* i-node number (序列号) */
	dev_t			st_dev;		/* 设备号(文件系统) */
	dev_t			st_rdev;	/* 特殊文件设备号 */
	nlink_t			st_nlink;	/* 链接数 */
	uid_t			st_uid;		/* 用户id */
	gid_t			st_gid;		/* 用户组id */
	off_t			st_size;	/* 普通文件字节数 */
	struct timespec st_atim;	/* 最后访问时间 */
	struct timespec st_mtim;	/* 最后修改时间 */
	struct timespec st_ctim;	/* 最后状态更新时间 */
	blksize_t		st_blksize;	/* 最大的 i/o 块大小 */
	blkcnt_t		st_blocks;	/* 磁盘块分配大小 */
};
```

本章实在是看得没什么头绪, 函数的使用目的性缺失, 知道是操作文件相关的, 待后续有需求的时候, 再回过头来看. 

### 习题与问题

1. 用stat函数替换图4-3程序中的lstat函数, 如若命令行参数之一是符号链接, 会发生什么变化? 

	stat 函数是跟随符号链接, 返回的是符号指向的文件信息
	lstat 不跟随符号链接, 返回的是符号本身信息

2. 如果文件模式创建屏蔽字是777(八进制), 结果会怎样? 用shell的umask命令验证该结果. 

	该文件除了root用户可以删除, 任何人不得访问

3. 关闭一个你所拥有的用户读权限, 将导致拒绝访问自己的文件, 对此进行验证.

	chmod 0333 

4. 创建文件foo和bar后, 运行图4-9的程序, 将发生什么情况?

	foo 文件会被所有用户可读可写
	bar 文件会被非root用户可读可写

5. 4.12节中讲到一个普通文件的大小可以为0, 同时我们又知道st_size 字段是为目录或符号链接定义的, 那么目录和符号链接长度是否可以为0? 

	目录长度不可能为零, 每个目录下都有默认文件 . 和 ..
	符号链接长度

6. 编写一个类似cp(1)的程序, 它复制包含空洞的文件, 但不将字节0写到输出文件中去. 

7. 在4.12号ls命令的输出中, core 和 core.copy 的访问权限不同, 如果创建两个文件时umask没有变, 说明为什么会发生这种差别. 

	创连core文件, 使用内核的默认权限 rw-r--r--
	创建core.zopyu 时, 使用是shell环境的权限 rw-rw-rw-

8. 在运行图 4-16 的程序时, 使用了df(1)命令来检查空闲的磁盘空间. 为什么不使用du(1)命令? 

	du需要文件名, 且不会计算tempfiles, df 可以查看实际的磁盘空间

9. 图 4-20 中显示unlink函数会修改文件状态更改时间, 这是怎样发生的? 

	unlink 如果文件的链接数大于1, 则不会删除文件, 只修改最后访问时间, 如果链接数等于1, 则物理删除文件. 这时会释放i节点, 对应的文件状态信息也都删除了. 

10. 4.22 节中, 系统对可以打开文件数的限制对myftw函数会产生怎样的影响? 

	深度不超过1000, 超过1000, 文件名过长, 有些系统就会getcwd失败

11. 在4.22节中的myftw 从不改变其目录, 对这种处理方法进行改动: 每次遇到一个目录就用其调用chdir, 这样每次调用lstat时就可以使用文件名而非路径名, 处理完所有的目录项后执行 chdir(".."). 比较这种版本的程序和书中程序的运行时间. 

12. 每个进程都有一个根目录用于解析绝对路径名, 可以通过chroot函数改变根目录. 在手册中查询此函数. 说明这个函数什么时候可调用?

	根目录用于解析绝对路径. 
	chroot 改变根目录. 在当前帐户, 不注销, 安装别一个帐户的环境时, 可以使用chroot. 
	chroot 只能超级用户使用, 一旦使用了, 原进程及后续进程都不可能再恢复原根目录. 
	可用于隔离ftp服务, 匿名登陆

13. 如何只设置两个时间值中的一个来使用 utimes 函数. 

	先使用stat 获取到文件的3个时间值, 再调用utimes设置时间, 将不改变的设置为stat读到地值. 

14. 有些版本的finger(1)命令输出"New mail received.." 和 "unread since..", 其中..表示相应的日期和时间. 程序是如何决定这些日期和时间的? 

15. 用cpio(1) 和 tar(1)命令检查档案文件的格式(请参阅<Unix程序员手册>第55部分中的说明). 3个可𩢺的时间值中哪几个是为每一个文件保存的? 你认为文件复原时, 文件的访问时间是什么? 为什么?

	cpio 和 tar 只归档文件的修改时间(st_mtim). 

16. Unix 系统对目录树的深度有限制吗? 编写一个程序循环, 在每次循环中, 创建目录, 并将该目录更改为工作目录. 确保叶节点的绝对路径长度大于系统的 PATH_MAX 限制. 可以调用getcwd 得到目录的路径名吗? 标准unix 系统工具是如何处理长度路径名的? 对目录可以使用tar 或 cpio命令归档吗? 
	
	超过PATH_MAX, Mac OS X 调用getcwd 会出错, 文件名太长了. 在FreeBSD, Linux, Solaris中可以获得文件名, 但是需要多次调用realloc得到一个足够大的缓冲区.
	cpio 不可以归档此目录, tar 可以归档. 

17. 3.16 节中描述的 /dev/fd 特征. 如果每个用户都可以访问这些文件, 则其访问权限必须为rw-rw-rw-. 有些程序创建输出文件时,先删除该文件以确保该文件名不存在, 忽略返回码. 
```
	unlink(path);
	if ((fd = creat(path, FILE_MODE))<0)
		err_sys(...);
```
如果path是/dev/fd/1, 会出现什么情况? 

	/dev 目录关闭了一般用户的写访问权限, 以防止普通用户删除目录中的文件名. 这就意味着 unlink 失败. 

18. 文件的属性, 操作命令

	stat, file, 
