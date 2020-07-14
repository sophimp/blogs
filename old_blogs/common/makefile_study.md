
## makefile 

- 显示规则, 隐式规则, 变量定义, 文件指示, 注释
    `makefile中的命令必须以tab开头`
    显示规则: 依赖关系
    隐式规则: 自动推导
    变量定义: 相当于c语言中的宏, 执行的时候原来替换
    文件指示: makefile的引用, 指定编译有效部分, 定义多行命令

    前面加-号, 表示遇错误不中断, 继续执行

    依赖规则:


- 默认按GNUmakefile, makefile, Makefile 顺序在当前文件夹下查找, 找到了便执行, 可以指定makefile, 使用-f 或 --file参数

- 引用其他的Makefile
    include 前面不能用tab, 可以有空格, include 文件 可以使用一个或多个空格隔开

-  依赖规则 

    target: prerequisites
        command

    规则顺序很重要, 只有一个最终目标, 放在第一个依赖规则中, 如果第一依赖规则有多个目标, 取第一个为最终目标

- 编译器用法
    * 这个也是要另学的, 之前感觉到迷, 那是因为没有去单独学习 gcc, cc
    * GNU 项目的都是牛人, 写的开源的工具, 真香

- 通配符

    `~` 相当于Unix下的~, ~/test 指$HOME, ~sophimp/test, 指sophimp的宿主目录下的test
    `*` 代替一系列文件
    `%` 在模式匹配中, 
    `?` 
    `[...]`

- 关键字
    * wildcard 扩展通配符 $(wildcard *.c ./sub/*.c) 扩展当前目录下的所有.c文件, 可以指定路径

- 特殊变量
    * VPATH, 多路径由冒号:分隔

        vpath <pattern> <directories>  // 为符合<pattern>的文件指定搜索目录
        vpath <pattern>                 // 消除符合 <pattern> 的文件的搜索目录
        vpath                           // 清除所有已被设置好的文件搜索目录

        pattern 中需要包含 % , 表示匹配所有零或若干字符

    * `$@` 所有目标集
    * `$<` 所有依赖目标集

- 伪目标
    * .PHONY 指定目标不是一个文件, 只是一个标签

    伪目标一般不需要依赖, 但是也可以有依赖, 伪目标总是会被执行的, 所以, 依赖的目标总是没有伪目标新, 就会被决议, 达到同时生成多个目标的目的.

- 静态模式规则
    `<target...>:<target-pattern>:<prereq-pattern>`
        `command`

- 书写命令
    * 必须是以Tab 开头, 与linux的shell命令是一样的, 按顺序一条一条执行
    * 使用@在命令行前, 此命令将不会被make显示出来
    * make -n, --just-print, 只打印命令, 不编译, 可用来调试
    * 当需要使用一条命令的结果应用在下一条命令上时, 必须写在一行, 用分号隔开

- 嵌套makefile

    subsystem:
        cd subdir && $(MAKE)

    export, unexport, -w, -C

- 定义命令包

    define
    endef

- 使用变量 
    * 变量相当于C语言中的宏, 代表一个文本字符串, 在make执行的时候会将其原模原样展开
    * $() 或 ${}
    * 变量可以使用在目标, 依赖,命令以及新的变量中
    * = 可以使用后面的变量, 不推荐使用, := 不可使用后面的变量, 推荐使用
    * MAKELEVEL 可以记录makefile嵌套层级
    * ?= 未定义,就赋值
    * 定义一个空格, 使用# 标明空变量的结束是一个好习惯
    * $(var:.o=.c) 将变量var 中.o换成.c, 另一种替换是静态模式 $(foo:%.o=%.c)
    * 变量的值可以再当成变量$($(var))
    * += 追加变量值
    * 设置make命令行参数可以使用override
    * 定义多行变量 define, endef结束, 命令包技术就是使用此命令字

- 环境变量 
    * makefile中定义了与系统环境变量同名, 那么会覆盖系统环境变量的值, 使用-e可以让系统环境变量覆盖makefile后定义的变量 
    * 系统环境变量可以充当全局变量的作用
    * makefile嵌套时, 上层的makefile可以传递到下层. 默认是通过命令行设置环境变量, 如果文件中的变量传递, 需要使用export关键字. 

- 目标变量 (规则型变量)
    * 自动化变量, 值依赖于规则的目标和依赖目标的定义
    * `target : <variable-assignment>`, `target: override <variable-assignment>` 

- 模式变量

    `<pattern>:<variable-assignment>`, `<pattern>: override <variable-assignment>`

- 条件判断
    * ifeq, ifneq, ifdef, ifndef , else, endif
    * ifeq(<arg1, arg2>), ifeq "arg1" "arg2", ifeq 'arg1' 'arg2', ifeq "arg1" 'arg2' , ifeq 'arg1' "arg2" 都是合法的
    * 最好不要将自动化变量放入条件表达式中, 因为自动化变量是在运行时才有的. 

- 函数
    * `$(<function> <args>) 或 ${<function> <args>} `args 以逗号分开
    * make 支持的函数: 

        $(subst <from>, <to>, <text>) 字符串替换
        $(patsubst, pattern, replacement, text) 模式替换, 功能相当于静态模式, 或变量替换
        $(strip <string>) 去开头和结尾空格
        $(findstr <find>, <in>) 在in 中查找find, 如果找到则返回find, 否则返回空
        $(filter <pattern...>, <text>) 保留text中符合 pattern 的所有字符串, 可以有多个模式
        $(filter-out <pattern...>,<text>)与上一个函数相反, 去符符合pattern的字符串
        $(sort <list>) 给list以单词升序排序
        $(word <n>,<text>) 取text中第n个单词, 从1开始
        $(wordlist <s>,<e>,<text>) 取text中 [s,n]区间的单词, 如果s大于单词个数, 返回空, 如果n在于单词个数, 取到结尾
        $(words <text>) 统计text 中的单词个数
        $(firstword <text>) 取text第一个单词

        $(dir <names...>) 从names中取出目录部分(最后一个/之前的部分), 如果没有/ 则返回./
        $(nodir <names...) 返回names非目录部分, 如果全是目录呢?
        $(suffix <names...>) 从names文件名序列中取各个文件名后缀序列, 如果没有后缀, 则返回空字符串
        $(basename <names...>) 取出各个文件名序列的前缀部分
        $(addsuffix <suffix>, <names...>) 将suffix 添加names 后面, 返回添加后的序列
        $(addprefix <prefix>, <names>) 将prefix 添加到 names前面
        $(join <list1>,<list2>) 将list2中对应的单词添加到list1的后面, 如果list1 多, 多出来的保持原样, 如果list2多, 将会复制到list1中, 返回list1

        $(foreach <var>, <list>, <text>) 将list中的值逐一取出放到var中, 然后执行text所包含的表达式, text每次会返回一个字符串, 当执行完循环时, 返回text所有的字符串, 以空格分开

        $(if <condition>, <then-part>) 或 $(if <condition>, <then-part>, <else-part>), 功能相当于make中的ifeq表达式

        $(call expression, param1, param2, ...) 唯一一个可创建新的参数化的函数, 使用$(1), $(2)...占位, 返回expression替换参数后的值

        $(origin <variable>) 不操作变量, 只告诉变量从哪里来, 不建议使用$, 返回值有undefine, default, environment, file, command line, override, automic

        $(shell command)  command 即为shell命令, 返回shell命令的输出 

        $(error <text...>)
        $(warning <text...>)

- 隐含规则
    * 编译c的隐含规则, 自动推导.o 的依赖文件为.c
    * 编译c++的隐含规则, 自动推导.o 的依赖文件为.c或.cc
    * 编译pascal的隐含规则, 自动推导.o 的依赖文件为.p
    * 编译fortran/Ratfor的隐含规则, 自动推导.o 的依赖文件为.f
    * 预处理fortran/Ratfor的隐含规则, 
    * 编译Modula-2程序的隐含规则, 自动推导<n>.sym 的依赖为<n>.def
    * 汇编和汇编预处理的隐含规则, 自动推导.o 依赖为 .s, 默认使用as编译器 , .s 的依赖为.S, 默认使用cpp预编译器
    * 链接object文件隐含规则, 如果没有源文件名字与目标名字相关联, 需要自定义生成规则, 否则隐含规则会报错
    * Yacc程序的隐含规则
    * LexC程序的隐含规则
    * LexRatfor程序的隐含规则

    隐含规则的命令中, 中基本上都使用一些预先设置的变量

    编译器, 编译和链接参数都有默认的(隐含的), (asm)as, (c/cpp)cc, (CXX)g++, ASFLAGS, CFLAGS, CXXFLAGS, CPPFLAGS

    * 隐含规则链

- 定义模式规则
    * 使用模式规则定义一个隐含规则, % 代表一个或多个字符

- 自动化变量
    * 自动化变量只出现在规则命令中
    * $@ 规则中的目标文件集
    * $% 仅当目标是函数库文件中, 表示规则中的目标成员名, 如果不是函数库文件, 则返回空
    * `$<` 依赖目标中第一个目标名字, 如果依赖目标是以模式定义的, 那么`$<`将是符合模式的一系列文件集
    * $? 所有比目标新的依赖目标集合, 以空格分开
    * $^ 所有依赖目标集合, 以空格分隔, 如果依赖中有重复的,会去重
    * $+ 所有依赖目标集合, 不会去重
    * $* 模式匹配或make可识别后缀之前的部分, GNUMake特性, 避免使用

- 旧式的后缀规则
    * 后缀规则不允许依赖文件
    * 后缀规则没有命令也是无意义的

## 练习

放在 OpenGL 的项目中练习

