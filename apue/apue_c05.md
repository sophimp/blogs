
## 第五章 标准I/O库

### 学习记录

标准I/O, 除了对第3章一些补充, 如文件I/O带缓存, 还多了一些什么呢? 

即使标准的I/O库, 也是不推荐的, 一是因为效率问题, 二是因为安全问题, 那么, 为何标准I/O库不更新呢? 

不更新是有历史原因, 很多程序都是基于标准I/O来写的, 再说, 标准I/O也不尽是缺点, 只是个别函数有缺陷而已, 有替代库

但是仍然觉得历史问题导致I/O库不能替换不够说服力. 

3, 4, 5章, 大多还都是stdio, 内核函数, 文件I/O函数的说明, 看起来实在枯燥, 效率太低下, 没必要细看, 先了解一个大概, 历史背景, 足矣. 

后续等用到了, 细细研究吧. 所以, 这样一种看书方式, 并不是一个好方法, 每一章都达到一样的标准, 并不是明智的做法. 

流的概念在这里都有了, 只不过是当初的理解能力太差, 没有坚持下来, C语言从大一下学期开始学, 整个大学都荒废过来了.  理解了流的概念, 编程里的各种抽象, 在现实中都有原型, 经常感叹, 这些人的聪明才智, 是真得牛X. 

```c
#include <stdio.h>
#include <wchar.h>

int fwide(FILE *fp, int mode);


void setbuf(FILE *restrict fp, char *restrict buf);
void setvbuf(FILE *restrict fp, char *restrict buf, int mode, size_t size);

int fflush(FILE *fp);

FILE *fopen(const char *restrict pathname, const char *restrict type);
FILE *fropen(const char *restrict pathname, const char *restrict type, FILE *restrict fp);
FILE *fdopen(int fd, const char *type);

int getc(FILE *fp);
int fgetc(FILE *fp);
int getchar(void);

int ferror(FILE *fp);
int feof(FILE *fp);

void clearerr(FILE *fp);

int ungetc(int c, FILE *fp);

int putc(int c, FILE *fp);
int fputc(int c, FILE *fp);
int putchar(int c);

// 读一行
char *fgets(char *restrict buf, int n, FILE *restrict fp);
char *gets(char *buf);

// 写一行
int fputs(const char *restrict str, FILE *restrict fp);
int puts(const char *str);

// 二进制I/O
size_t fread(void *restrict ptr, size_t size, size_t nobj, FILE *restrict fp);
size_t fwrite(void *restrict ptr, size_t size, size_t nobj, FILE *restrict fp);

// 定位流
long ftell(FILE *fp);
int fseek(FILE *fp, long offset, int whence);
void rewind(FILE *fp);

off_t ftello(FILE *fp);
int fseeko(FILE *fp, off_t ofset, int whence);

int fgetpos(FILE *restrict fp, fpos_t *restrict pos);
int fsetpos(FILE *restrict fp, const fpos_t *pos);

// 格式化 I/O
int printf(const char *restrict format, ...);
int fprintf(FILE *restrict fp, const char *restrict format, ...);
int dprintf(int fd, const char *restrict format, ...);

int sprintf(char *restrict buf, const char *restrict format, ...);
int snprintf(char *restrict buf, const char *restrict format, ...);

int scanf(const char *restrict format, ...);
int fscanf(FILE *restrict fp, const char *restrict format, ...);
int sscanf(const char *restrict buf, const char *restrict format, ...);

char *tmpnam(char *ptr);
FILE *tmpfile(void);

#include <stdlib.h>
char mkdtemp(char *templete);
int mkstemp(char *templete);

#include <stdio.h>

FILE *fmemopen(void *restrict buf, size_t size, const char *restrict type);
```


### 总结

标准I/O是基于内核I/O函数的, 多增加了缓存, 也正是加了缓存, 导致问题增多, 虽然方便, 但是有些函数存在隐患, 效率问题, 针对隐患, 标准库并未选择修复, 既而有新的库替代. 为何没有修复, 除了历史代码原因, 也想不到其他原因, 但是历史代码原因说服力又不够. 

### 习题与问题
1. 用setvbuf 实现setbuf

```c
void setbuf(FILE *restrict fp, char *restrict buf);

int setvbuf(FILE *restrict fp, char *restrict buf, int mode, size_t size);
```
	设置缓冲区类型(全缓冲, 行缓冲, 不带缓冲)

	setbuf 可以打开或关闭缓冲, buf为NULL则关闭缓冲区, buf不为null, 或fp指向终端设备, 则有些系统可默认设置成行缓冲, 指向非终端设备,默认是全缓冲的.  

	setvbuf可以更精准地说明缓冲类型. buf 为NULL, 忽略size 则为关闭缓冲, 其他情况, 指明mode参数, _IOFBF, _IOLBF, _IONBF 可达到setbuf的效果. 

2. 图5-5的程序利用每次一行I/O(fgets  和 fputs 函数)复制文件. 若将程序中的MAXLINE 改为4, 当复制的行超过最大值时会出现什么情况? 对此进行解释. 

	fgets 读入数据时, 直至缓冲区满(会留一个字节存放终止null字节). 同样, fputs 只负责将缓冲区的内容输出直到遇到一个null字节, 并不考虑缓冲区中是否包含换行符. 所以, 如果将MAXLINE 设得很小, 这两个函数仍会正常工作, 只不过在缓冲区较大时, 函数被执行的次数要多于MAXLINE设置得较大的时候. 

	如果这些函数删除或添加换行符, 则必须保证对于最长的行, 缓冲区也足够大 

3. printf 返回0 表示什么? 

	没有输出任何字符, 如空字符串. 

4. 下面的代码在一些机器上运行正确, 而在另外一些机器上运行时出错, 解释问题所在. 

```c
#include <stdio.h>
int main(void){
	char c;
	while((c = getchar()) != EOF)
		putchar(c);
}
```
	getchar 返回值是int类型, 而char 在有的系统上是无符号保存的, 此时, 程序会陷入死循环, 在本书的四种系统中 Mac OS X, Linux, FreeBSD, Solaris 都是使用char有符号数, 所以可以正常工作. 

5. 对标准I/O流如何使用fsync函数(见3.13节)?

	先使用fflush, 再使用fsync, 否则无作用. 

6. 在图1-7和图1-10程序中, 打印的提示信息没有包含换行符, 程序也没有调用fflush函数, 请解释输出提示信息的原因是什么?
	
	程序在交互运行时, 标准输入和标准输出为行缓冲模式. 每次调用fgets时, 标准输出设备将自动fflush.

7. 基于 BSD 的系统提供了funopen 的函数调用使我们可以拦截读,写,定位以及关闭一个流的调用. 使用这个函数为FreeBSD和Mac OSX 实现fmemopen.



