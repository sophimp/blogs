
## 第一章 Unix基础知识

### 学习记录

### 总结

### 习题与问题

1. 当读/写磁盘文件时, 本章中描述的函数确实是不带缓冲机制的吗? 请说明原因.

2. 编写一个与 3.12 节中 dup2 功能相同的函数, 要求不调用 fcntl 函数, 并且要有正确的出错处理.

3. 假设一个进程执行下面3个函数调用:
	
	fd1 = open(path, oflags);
	fd2 = dup(fd1);
	fd3 = open(path, oflags);

画出类似于图3-9的结果图. 对于fcntl 作用于fd1 来说, F_SETFD 命令会影响哪一个文件描述符? F_SETFL 呢? 

4. 许多过程中都包含下面一段代码:

	dup2(fd, 0);
	dup2(fd, 1);
	dup2(fd, 2);
	if(fd > 2)
		close(fd);
为了说明if语名的必要性, 假设fd是1, 画出每次调用dup2 时3个描述符项及相应的文件表项的变化情况. 然后再画出fd为3的情况.

5. 在Boune shell, Bourne-again shell 和 Korn shell中, digit1>&digit2 表示要将描述符digit1重定向至描述符digit2的同一文件. 请说明下面两条命令的区别. 

	./a.out > outfile 2>&1
	./a.out 2>&1 > outfile

6. 如果使用追加标志打开一个文件以便读,写, 能否仍用lseek在任一位置开始读? 能否用lseek 更新文件中任一部分的数据? 请编写一段程序验证.
