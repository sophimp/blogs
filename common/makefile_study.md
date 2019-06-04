
## makefile 
- 显示规则, 隐式规则, 变量定义, 文件指示, 注释
    `makefile中的命令必须以tab开头`
    显示规则: 依赖关系
    隐式规则: 自动推导
    变量定义: 相当于c语言中的宏, 执行的时候原来替换
    文件指示: makefile的引用, 指定编译有效部分, 定义多行命令

    前面加-号, 表示遇错误不中断, 继续执行

- 默认按GNUmakefile, makefile, Makefile 顺序在当前文件夹下查找, 找到了便执行, 可以指定makefile, 使用-f 或 --file参数
- 引用其他的Makefile
    include 前面不能用tab, 可以有空格, include 文件 可以使用一个或多个空格隔开


## 练习

放在 OpenGL 的项目中练习

