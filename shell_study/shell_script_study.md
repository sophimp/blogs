
## shell script 语法

0. #! 

    告诉系统其后所指定的程序即时解释此脚本的Shell程序

    /bin/sh 或 /bin/bash 是同一个程序的不同版本, bash 更新一些

- 常用命令 

    echo 向命令窗口输出, echo 在csapp中的例子是一个C/S架构
    printf 模拟C语言的printf 函数
    readonly 标记为只读变量 
    unset 删除变量, 删除后变量不可再用, 不能删除只读变量

- 变量 
    * 字母,数字,下划线
    * 等号不能有空格
    * 局部变量 

        shell内部定义的变量
    * 环境变量 

        相当于全局变量, 跨shell脚本可访问
    * shell变量 

        shell程序设定的特殊变量, 一部分是环境, 一部分是局部, 脚本语言基本上都有上下文提供的变量
    * 字符串

        单引号, 双引号, 跟所有脚本语言中的限制一样, 双引号中可引用变量, 可转义
        获取字符串长度 ${#str}
        提取字符串 ${str:1:4}
        查找字符串 `expr index "$str" o`
    * 数组

        定义 arr_name=(val1, val2, ...), 
        数组没有范围, 下标没有限制, 只支持一维数据
        读取数组${arr_name[n]}
        获取数组长度 ${#arr_name[@]} 或 ${#arr_name[*]}
        获取单个数组元素长度 ${#arr_name[n]}

- 注释

    `
    # 单行注释

    :<<EOF
        多行注释
    EOF

    EOF 可以使用其他符号替换
    `
- 脚本传递参数

    $0 为执行脚本的文件包, $n 分别为空格分出来的参数

    $# 传递到脚本的参数个数
    $* 以一个字符串显示向脚本传递的所有参数
    $$ 脚本运行的当前进程ID号 
    $! 后台运行的最后一个进程ID号
    $@ 将每个参数分别以字符串形式显示出来
    $? 显示最后命令的退出状态, 0表示无错误, 其他任何值都表示有错误

    $* 与 $@ 都是引用所有参数, 但是在引号中使用有区别, "$*" 等价于将所有参数作为一个参数传递, "$@" 是将所有参数分开传递

- 运算符
    * 算数

        expr 和 awk
        val = `expr 1 + 1` 运算符两边都必须有空格
        `+ - * / % = == !=` 其中 * 需要转义
        在mac 中 expr 的表达式为 $((表达式)), * 不需要加转义
    * 关系
        
        -eq -ne -gt -lt -ge le
        关系运算符两边只支持数字
    * 布尔

        ! -o -a 
    * 逻辑运算 

        || && 示例上 布尔与逻辑的效果一样了?
    * 字符串

        != = -z -n $ 只能用在 if 判断语句中

    * 文件测试

        -b file 是否是块设备
        -c file 是否是字符设备文件
        -d file 是否是目录
        -f file 是否是普通文件(既不是设备文件, 也不是目录)
        -g file 是否设置了SGID(set group id)位 
        -u file 是否设置了SUID(set user id)位
        -k file 是否设置了粘着位(Sticky Bit)
        -p file 是否是有名管道 
        -r file 是否是可读文件
        -w file 是否是可写文件
        -x file 是否是可执行文件
        -s file 检测文件是否为空
        -e file 检测文件是否存在
        -S file 是否为socket文件
        -L file 检测文件是否存在并且是否是一个链接符号

- 流程控制

    if 语句

        if condition
        then 
            command1
            command2
            ...
            commandN
        elif
        then
            comman1
            ...
            commanN
        else
            command1
            ...
            commandN
        fi
    写成一行要加分号隔开

    for 循环

        for var in item1 ... itemN
        do
            command1
            ...
            commandN
        done

        for(( ; ;  ))
    写成一行要加分号隔开

    while 循环

        while condition
        do
            command1 
            ...
            commandN
        done

    无限循环

        while :
        do
            command
        done

        while true
        do
            command
        done

        for(( ; ; ))

    until 循环

        until condition
        do
            command
        done

    case 语句

        case 值 in
        模式1)
            command
            ...
        ;;
        模式2)
            command
            ...
        ;;
        *)
            command
            ...
        ;;
        esac

    跳出循环

        break continue

- 函数

    [ function ] funname [()]
    {
        action;
        return int(0-255); 
    }

    如果不加 返回值, 将以最后一条命令的结果作为返回值

    函数返回值在运行之后通过 $? 来获取

    函数参数跟脚本参数是一样的, 通过 $n 来获取, 当n>10时需要通过 ${n} 来获取

    函数是先定义再使用的

- 重定向

        command > file
        command >> file
        command < file
        n > file 将文件描述符为n 的文件重定向到 file
        n >> file
        n >& m 将输出文件 n, m 合并
        n <& m 将输入文件 民,m 合并
        << tag 将开始标记tag 和结束标记tag之间的内容作为输入

    Here Document

        command << delimiter
            document
        delimiter
    将delimiter之间的内容作为参数传递给command
    结尾的delimiter 一定要顶格写
    开始的delimiter 前后的空格会被忽略掉

    /dev/null 写入到它的内容都会被丢弃

- Shell 文件包含 

        . filename 
        source filename
        注意中间有空格


## 练习

[练习脚本](exercise_for_shell.sh)
