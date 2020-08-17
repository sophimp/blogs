---
title: shell script 学习
date: 2019-05-22 17:53:56
tags: 
- shell script
- linux
categories: 
- Linux
description: 以linux作为主力系统, shell script是必须得学习的，结合aosp的学习，确实感受到了shell script的威力。 要学习的东西太多了， 东一榔头，西一棒槌，都是半瓢水的水平，慢慢来吧。 
---

## bash

[Bash Reference Manual](https://tiswww.case.edu/php/chet/bash/bashref.html)


## linux shell script study

    脚本语言, 所见即所得, 所以环境更容易搭, 比较容易上手练习

    #! /bin/sh /bin/bash
    是告诉当前脚本要用哪个解释器来执行

    bash 的语法简单, 能力有限, 但是不用额外安装其他工具, 系统自代

    python, php, curl, go, gradle 等脚本语言, 都需要自带一个运行环境, 相对来说, 可以处理更复杂的事情. 

1. 命令

eval 将字符串当作表达式执行而返回一个结果的函数

新增一个shell命令最简单的方法, 在当前shell中运行脚本后, 脚本中所定义的方法即成了临时命令. 所以变量,函数的定义都是全局的, 除非使用local 显示定义的一个函数内的变量为局部的.

sed 命令配合正则, 使用得挺多


- 语法

1. local

    local一般用于函数内部, 用于局部变量声明.

    shell 定义的变量默认是global的, 函数内定义的变量默认也是global的, 如果同名, 函数定义的local变量会屏蔽脚本定义的global变量

2. $()

括号内可以调用函数或者命令

3. 括号
()

	括号里是用来执行shell命令的, 每个命令可用 ; 隔开, 另开一个shell来执行, 因此小括号中的变量余下脚本不可以使用.

(())

	内部用来作整数计算, 变量前不用$, 多个表达式可用; 隔开

[] 

	[] 相当于启用了test命令, 只能用于字符串比较 ==, !=, 整数比较使用 -gt, -eq, -lt
	正则表达式中, 表示范围
	arry 中, 可用来索引每个元素. 

[[]]

	是bash语言中的关键字, 比[]更加通用, 可以有效避免 &&, ||, < > 等操作符的报错. 
	[[]]中间不会发生文件名扩展和单词分割, 但是会发生参数扩展和命令替换
	支持字符串模式区配, 字符串比较时, 可以把右边的作为一个模式. 
	将表达式看作一个单独的元素. 

{}

	作扩展
	代码块, 相当于创建了一个匿名函数, 不会另开一个shell来执行
	每一条语句都要有分号, 最后一条也不例外
	第一个命令必须要和左括号有一个空格

	特殊的替换结构
	${var:-string}, ${var:=string}
		相当于 ?:, var为空时, ${} 的值为string, 反之为var值, ${var:=string}, 同时会将var 的值赋为string

	${var:+string}, 
		与${var:-string}逻辑相反

	${var:?string}
		若var不为空, 使用var的值, 为空则退出脚本, 将string输出到标准错误, 相当assert作用

	${variable%pattern}, variable是否以pattern结尾, 是则去掉variable右边最短的pattern匹配部分
	${variable%%pattern}, variable是否以pattern结尾, 是则去掉variable右边最长的pattern匹配部分
	${variable#pattern}, variable是否以pattern结尾, 是则去掉variable左边最短的pattern匹配部分
	${variable##pattern}, variable是否以pattern结尾, 是则去掉variable左边最长的pattern匹配部分
	这四种模式都不会改变variable的值


### 调试

[Shell 脚本调试技术](https://www.ibm.com/developerworks/cn/linux/l-cn-shell-debug/index.html)

1. trap 命令
2. tee 命令
3. 调试钩子
4. set 

	-n 只读取shell脚本，但不实际执行
	-x 进入跟踪方式，显示所执行的每一条命令
	-c "string" 从strings中读取命令
	$PS4 $LINENO $FUNCNAME
