---
title: vim 学习系列之(4) -- 开发环境的搭建
date: 2020-08-20 16:17:54
tags:
- Vim
- Neovim
categories:
- Vim
description:
---

### 明确目标

不管是有过IDE使用经验的人, 还是追求酷炫的情怀者, 基于何种缘由需要配置VIM开发环境, 首先要明确自己想要什么，而不是照着他人的教程有的没的一顿配置, 配置成功了，达到不自己的预期，配置不成功，都会严重影响持续折腾的积极性。

明确目标，是一项高级的能力。 我也是在折腾了很久才知道自己想要什么， 这里写下来， 也是想为后来者少踩一些坑。 关于学习踩坑更多的思考，请见{% post_link thought/thinking-about-programming 编程杂谈#踩坑 %}

vim开发环境搭建目标是为了高效率开发，方便代码跟踪阅读。

因此涉及以下特性待实现: 
	
	自动补全
	代码片段
	text object
	代码格式化

	函数调用栈查看
	字段, 语义跟踪函数调用位置
	成员变量, 函数列表
	跨依赖库的跟踪

### c/c++ 环境配置

[ 参考知乎韦易笑 c/c++环境配置](https://www.zhihu.com/question/47691414/answer/373700711), 其中补全主要还是YCM与deoplete 引, 这里我替换成coc尝试下效果, 毕竟 coc 在此教程发布的时间又发展了两年。 
	
1. tags 与 语义

	不管是代码补全，还是字段方法的引用查询，列表显示, 都涉及到tags 与 语义分析。

	tags的元素包含方法和可以定义成变量的符号, 如类，结构体, 枚举等语义定义。 基于tags的查询主要是根据字符串比对，因此可能会查询到很多同名但不相关的结果。
	语义, 是基于特定语言的语法分析，可以更加准确的查找方法，变量的引用调用，但需要对应应语言的编译器支持, 速度上相对于tags要慢一些。

	tags和语义插件并不是非此即彼，可以共存配置，达到最优体验。

	生成tags的工具有:
		[universal-tags](https://github.com/universal-ctags/ctags), 支持几十种语言, 现在人旧在维护。 
		[cscope](), 支持c/c++/java, 相比于ctags支持的语言少一些，但是功能比ctags更全一些，能够保存标签栈, 增量生成数据库, 查找被调用信息, 速度更快，正则查找。

	涉及到的vim插件有
		[gutentags](https://github.com/ludovicchabant/vim-gutentags)

	语义支持: 
		YCM, YouCompleteMe, 是一个庞然大物，功能强大，下载慢，安装较复杂, 还需要编译c++, 依赖python实现, 支持语义补全, 具体请参看期[Readme](https://github.com/ycm-core/YouCompleteMe)
		coc, conquer of completion, 首发neovim平台，现在同时支持的新一代补全工具，依赖nodejs实现，支持所有的LSP语言补全, 具体请参看[Readme](https://github.com/neoclide/coc.nvim)
	
	coc 相对于YCM要容易安装一些，nodejs 的源可以换成国内的源, 待玩一段时间coc, 有不足之处再玩YCM.

2. 自动补全

coc 支持LSP, LSP(Language Server Protocl) 是由微软团队牵头定义的的关于语言编辑器/IDE与特定语言编程特性服务之间的协议, 主要目的是为了各语言编辑器/IDE的实现与各编程语言支持的实现和发布相对独立。 例如像vscode和vim 一样， 遵循LSP 安装各种插件就可以良好支持某一编程语言的开发， 而不用像visual studio 和jetbrans全家桶一样，一个IDE与特定的一个或几个语言支持绑定。 

	LSP的server 主要提供自动补全，定义导航，命名重构 等功能，编辑工具/IDE只需要保持通信, 可以保证一款编辑器或IDE很快的就能深度支持一种语言，解决了 m-times-n的问题。

那么通过coc, 就可以专注于配置每一种语言的server, coc 相当于client, 这个插件平台主要是用来管理各语言的LSP client/server 插件。

coc 插件, 是一个插件平台，这一点与vim-plug又有何不同呢？ 

	vim-plug 主要用来管理插件的安装，卸载，状态查询。所以下载下来的插件都是插件开发者对vim/neovim开发好的。
	而coc不仅可以管理插件， 采用typescritp可以使用很小的代价就可以移植vscode插件， typescript 的社区比较活跃, 还支持LSP的client/server插件，但是其他的插件要利用coc特性, 需要基于coc api再重新开发或适配。目前coc支持所有的lsp语言，支持部分非LSP插件.

通过`:CocInstall <plug-name>` 来安装插件。

在[register-custom-language-server](https://github.com/neoclide/coc.nvim/wiki/Language-servers#register-custom-language-servers)中查看支持LSP的各种语言配置.

LSP的server大都是编译引擎或者各语言的命令行程序/库
LSP的client是coc插件, 与 server 是通过 jsonRPC协议进程间通信
coc统一提供了server和client的配置，不用分开配置.

大型项目还是不能使用LSP的查找定义或者引用, 内存爆炸, 而且默认是以.git为一个项目模块来分析，这样各模块间必须解耦, 模块间的通信或者进程间的通信代码跟踪还是需要全局的tags来定位。 coc与ctags并不冲突，可以相互补充。

c/c++

	server: clangd, llvm, ccls, cquery, ccls是基于cquery来做的
	这里我同时安装了clangd 和 ccls, 会不会冲突呢？
	
	client: coc-clangd

	ccls 被遗弃了？ 
	可以补全了，如何修改popwindow的背景色

python 
	server: jedi
	client: coc-python

lua
	lua-lsp 目前只支持到lua5.1-5.3
	
java
	server: 
	client: coc-java

3. 代码搜索

在 coc 的LSP插件中已经包含了单个项目间的定义与搜索

4. 文件搜索

coc-explorer, 文件窗口管理器, 以.git, .root, .project

fzf,

LeaderF

5. 代码高亮

coc-highlight

6. 文件树

coc-explorer

7. snippet

coc-snippets, 

8. 代码格式化

coc-prettier

> coc插件可以从其github的readme中找到 coc-settins.json中的参数配置选项和说明, 安装coc-json, 可以在配置文件中自动提示
> 或者什么都不输入， 直接调用自动补全，会显示当前插件允许的所有配置

9. gutentags插件的学习

10. 自动添加tag, 添加其他的tag, 系统层源码

11. 内嵌终端
[skywind3000/vim-terminal-help](https://github.com/skywind3000/vim-terminal-help)
`alt + '=' ` 打开/隐藏终端
`alt + 'q'` 终端退出到 Normal模式
`alt + shift + 'h/j/k/l'` 窗口跳转

drop 命令安装， 可以默认使用vim打开一个文件

### 总结

coc 基本上可以满足目前的开发需求，但是插件还是不能安装多了， 不懂的就不要安装，有需求再安装。 插件安装多了，内存直接爆掉了

开发环境就这样配置好了？ 显然还不够，更多的配置在后续持续学习补充吧, 现在时间并不允许耗在这个环境上面。。。

