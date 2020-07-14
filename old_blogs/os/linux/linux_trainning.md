
## linux 内核

    内核做了哪些事情? 

        I/O, 驱动, 文件系统, 内存管理, 进程/线程调度

    只有内核, 一个系统也可以跑起来

    宏内核: 所有的操作都在内核态
    微内核: 文件操作放在了用户态

- 操作系统构成
        任务调度,  渲染模块, 驱动开发

## linux 启动流程
    操作系统 -> /boot 加载内核img -> 创建 init 进程 -> 按运行级别启动应用 -> /etc/init.d(启动脚本存放) -> 用户登陆 -> login shell

## linux 目录结构
    |-/
      |- /root
        root用户目录
      |- /bin
        系统命令存放位置
      |- /sbin
        super user 命令存放位置
      |- /boot
        系统启动加载的一些核心文件
      |- /dev
        设备管理
      |- /etc
        所有应用配置文件, 一般都放在此文件下
      |- /home
        用户主目录, 一般以用户名命名
      |- /var
        习惯将经常修改的目录放在这里, 各种日志文件, mail 的预设置
      |- /lib
        链接库存放位置
      |- /usr
        应用程序安装默认放在该目录下
      |- /media
        系统识别的硬件挂载到该目录下
      |- /mnt
        可作临时挂载目录
      |- /opt
      |- /proc
        虚拟目录, 系统内存映射, 可以直接访问该目录获取系统信息
      |- /tmp
        存放一些临时文件, 关机自动清除
      |- /sys
        sysfs 文件系统, 是内核设备的一个直观反应, 集成了 proc, jdefs, devpts 文件系统 
      |- /

## 进程管理
    - yum, rpm 安装
        陷入了死循环, 最根本的安装, 编译源码, make install, 然后源码编译不过
        是版本不对, 还是环境没装好, 就算copy了一份好的, 然而 rpm 的命令都过不去
    - 查看进程, 杀死进程
        ps -l       
        ps -ef 查询正在运行的进程
        ps -ajx 完整格式
        pstree
        ps -o pid, ppid, comm
        kill -9 pid
        pgrep -l <pname> 可以模糊查询进程
        lsof -i:<port> 查看端口占用
        lsof -u <username> 查看username 进程所打开的文件
    - 监控进程
        top
    - 进程:
        一个进程的内存空间: 常量区, 静态区, 栈, 堆, 程序代码区
        fork, exec
        pmap 输出进程内存状况
    - 查看前后台进程
        jobs -l
    - 前后台转换
        fg %<工作号>
        bg %jobnummber 开始后台工作, 状态变成运行中
    - 查看内存
        sar -r 1 2
        vmstat 1 3

## 磁盘管理
    - df
        对整个根级的文件目录信息查看
    - du
        对目录下的文件和目录磁盘的使用空间
    - fdisk
        fdisk -l 查看物理盘信息
        也可做分盘操作, 格式化操作
    - mount/umount
        磁盘的挂载和卸载操作

## 文本处理
cat, touch, xargs

## 网络工具

## shell编程

[linux shell script study](linux_shell_script.md)

