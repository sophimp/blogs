---
title: vim 学习系列之(4) -- c/cpp 环境的搭建
date: 2020-08-20 16:17:54
tags:
- vim
- neovim
categories:
- vim
description:
---

### c/c++ 环境配置

[ 参考知乎韦易笑 ](https://www.zhihu.com/question/47691414/answer/373700711)

代码跟踪
	调用栈
	语义跟踪
	字段跟踪
	函数列表
	成员函数列表
	跨依赖库的跟踪

	有两种方式: 基于tags, 基于语义

	tags 原理是按字符串来比较，所以可能会有一些不相干逻辑但命名相同的定义和调用会被搜出来
	基于语义要准备一些， 但速度相对tags要慢一些， 因为要实时分析。 

	小孩子才选择， 成年人我都要!

	tags: 
		ctags, 使用[universal-ctags](https://ctags.io/) 来生成, gutentags 需要提前安装生成ctags的工具
		cscope, 双ctags更强大的工具，可以查看函数调用的地方，
	语义: 
		YCM, 
		coc, 

自动补全

snippet

文件搜索

代码高亮

文件树

编译

