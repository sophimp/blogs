
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
    * wildcard

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

## 练习

放在 OpenGL 的项目中练习

