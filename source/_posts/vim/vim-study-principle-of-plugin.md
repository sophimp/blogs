---
title: vim 学习系列之(3) -- vim 插件系统
date: 2020-08-20 16:17:14
tags:
- vim
- neovim
categories:
- vim
description:
---

### neovim插件原理

vim 与 neovim 插件的加载原理也是相同的。 

主要涉及这几个文件夹:

|-- <vimruntimepath> --
	|-- bundles
		|-- [plugins]
			|-- [start]
			|-- [after]
	|-- vim
		|-- autoload
		|-- colors
		|-- ftplugin
		|-- plugin
			|-- [start]
			|-- [after]
		|-- syntax
	|-- pack
	|-- compiler

* vimruntimepath
	通过 `:help runtimepath` 可以查看详细内容, runtimepath可以更改， neovim 共用vim的配置就是通过修改runtimepath, 这种思想类似于 chroot命令。

* bundles
	vim-plug 插件安装的文件夹，下面每一个文件夹代表一个插件
	每个插件内部的文件结构与 |-- vim 下的类似, 可以有autoload, start, after 生命周期文件夹， 也有 ftplugin, syntax等每个插件加载时检索的文件夹。 
	

* vim 下的 文件夹

	plugin
		“全局插件", 会自动加载的vim 脚本文件夹。 这个文夹件可以放置自己p定制的插件，如何仅仅是使用github上的插件，还是直接使用插件管理器依赖更好一些。 

		start 文件夹是脚本加载

	autoload
		(与plugin 不一样) 此文件夹下的脚本只有在调用的时候才会加载, 通过# 来调用, # 相当于路径一样使用
		[示例](https://www.w3cschool.cn/vim/xenarozt.html)

	ftdetect
		可以自定义识别文件类型, 具体查看 :help ftdetect

	ftplugin
		编辑已知文件类型时执行的脚本, 如添加smali语言的语法高亮支持，就需要同时在 ftplugin, syntax 下添加smali.vim 脚本

	syntax
		定制每个语言的高亮显示

	color
		主题文件夹，可以定制不同的配色

* compiler
	默认的时候不会创建, 定义如何运行各种编译工具或格式化工具，以及如何解析其输出。 可以在多个ftplugins间共享。且不会自动执行，必须通过 `:compiler`调用

* pack
	Vim8 原生软件包目录， 采用了 "Pathogen" 格式的包管理。 

pack 原生包管理个人觉得没必要使用， vim-plugin 就很好用, 但是了解一下有必要， 主要是学习其他大神的配置文件时， 知道有这么一回事就行。

### vim 的启动流程

[vim配置层次结构与插件加载方式(一)](https://blog.csdn.net/qq_27825451/article/details/100518128)
[vim8原生内置(naive)插件安装（二）](https://blog.csdn.net/qq_27825451/article/details/100557133)

`:scriptnames` 可以查看加载了哪些脚本， 通过脚本的路径可以查看到vim 会加载哪些路径下的脚本，
`:set runtimepath` 也可以查看运行时加载路径，以逗号分隔。
使用 `vim -V` 可以查看vim 启动信息, 

`:help initialization` 查看初始化文档

	1. 设置 shell 和 term 选项, 'term' 选项是在第8步用来改变GUI的 
	2. 处理参数， `-V` 参数可以显示日志信息和下一步动作, 方便用来调试启动初始化流程。
	3. 从环境变量或文件中加载可执行命令并执行。`Ex commands`, 是 `exec` 将字符串当作 shell 命令执行
	4. 加载脚本文件
	5. 设置 shellpipe 和 shellredir, shell管道和输出重定向。
	6. 如果带有` -n ` 参数, 将 updatecount 设置为0
	7. 如果带有` -b ` 参数，设置 binary options, 
	8. 执行GUI初始化 (仅作用于gvim启动)
	9. 读 viminfo 文件
	10. 读 quickfix 文件
	11. 打开所有窗口
	12. 如果带有` -c 和 +cmd ` 参数，执行启动命令

	生命周期还涉及 start, after 目录，针对每个插件加载过程


### 插件介绍

这里就[韦易笑vim配置](https://github.com/skywind3000/vim) 中涉及到插件进行分析学习, 
更多的插件学习，请查看[github 上vim 话题](https://github.com/topics/vim)， 这下面的话题，依然可以查看到当前很活跃的插件。

|插件名称|作用说明|
|:--:|:--:|
| [junegunn/plug.vim](https://github.com/junegunn/vim-plug)                               | 插件管理器, 支持异步操作，主流使用的插件管理器，于我而言是够用了                                                                                                                                                            |
| [easymotion/vim-easymotion](https://github.com/easymotion/vim-easymotion)               | 强化搜索功能的插件，vim中有单行搜索，全局搜索, 提供了2字符搜索功能，将搜索结果高亮，而其他内容加一个遮罩变暗, 快速跳转到搜索结果, 强化了dot重复上一步操作等功能, 更详细功能可通过 :help easymotion.txt 查看, 很强大，可以用 |
| [Raimondi/delimitMate](https://github.com/Raimondi/delimitMate)                         | 用来自动补全括号, 引号等需要成对出现的闭合区间, 详细文档通过 :help delimitMate.txt 查看                                                                                                                                     |
| [justinmk/vim-dirvish](https://github.com/justinmk/vim-dirvish)                         | 可以从当前文件夹内快速导航的插件, 使用 -/enter 分别跳转上一级文件夹/进入文件夹, 比netrw更快, 只复责导航，不负责创建更改删除,  详细文档通过 :help dirvish.txt 查看                                                           |
| [justinmk/vim-sneak](https://github.com/justinmk/vim-sneak)                             | 强化了单行查找的命令, 使用两个字符全局搜索, 使用逗号(,)分号(;)分别跳转上一个/下一个匹配项, 大部分时候可以替代(/)的全局搜索功能                                                                                              |
| [tpope/vim-fugitive](https://github.com/tpope/vim-fugitive)                             | 可以在vim 命令行中使用任何git命令的插件，结果分屏显示, 然而没有高亮，使用:Git 或 :G 代替 :!git, 详细文档通过 :help fugitive 查看                                                                                            |
| [tpope/vim-unimpaired](https://github.com/tpope/vim-unimpaired)                         | 将vim内置的常用的20个命令使用[] 开头分别映成对的快捷键, 这20个命令到目前来我用得挺少, 具体哪些命令通过 :help unimpaired.txt 查看                                                                                            |
| [godlygeek/tabular](https://github.com/godlygeek/tabular)                               | 文本格式化工具, 通过正则表达式来格式化文本, 详细文档通过 :help tabular.txt 查看                                                                                                                                             |
| [bootleq/vim-cycle](https://github.com/bootleq/vim-cycle)                               | 定义一个变化表链，可以快速变化, 如 flase => true => false, 就可以通过 :CycleNext :CyclePrev 快速变换， 当然还可以绑定快捷键, 这对于反义词组，或者日常枚举单词做成一个循环链表达到快速变化的目的                             |
| [tpope/vim-surround](https://github.com/tpope/vim-surround)                             | 方便修改成对的符号如"", '', [], {}, xml中的标签等, 支持text-obj, normal 模式下对应的命令有 cs, ys, ds; visual模式下命令为S, 将光标移动到符号包裹的区域中，使用命令替换即可
| [tpope/vim-rhubarb](https://github.com/tpope/vim-rhubarb)                               | 加强tpope/vim-fugitive 的:Gbrowse命令, 将Git命令使用 hub来替代, hub是对git命令的封装和强化，git命令封装的工具还有lazygit
| [mhinz/vim-startify](https://github.com/mhinz/vim-startify)                             | vim启动首页的定制，可定制标题，页脚，显示最新打开的标签页和永久的会话, 可以通过菜单直接打开, 通过 :h startify 来查看文档                                                                                                    |
| [flazz/vim-colorschemes](https://github.com/flazz/vim-colorschemes)                     | vim主题的管理，提供了已配置好的scheme,通过 :colorscheme 切换， 或者在vimrc 中使用colorscheme 来设置                                                                                                                         |
| [xolox/vim-misc](https://github.com/xolox/vim-misc)                                     | 多样化自动加载脚本, 实现异步加载？vim8和neovim都已经支持异步了， 且这个库已经5年+没有更新了, 与编写vim脚本相关性较高, 暂不研究，后续再看                                                                                    |
| [terryma/vim-expand-region](https://github.com/terryma/vim-expand-region)               | 在visual模式下，使用+,- 自动识别(根据syntax-region)扩展或缩减选中区域                                                                                                                                                       |
| [pprovost/vim-ps1](https://github.com/pprovost/vim-ps1)                                 | 支持windows下的powershell 的脚本语法高亮, 暂时用不上                                                                                                                                                                        |
| [tbastos/vim-lua](https://github.com/tbastos/vim-lua)                                   | 加强 lua 语法的高亮显示                                                                                                                                                                                                     |
| [octol/vim-cpp-enhanced-highlight](https://github.com/octol/vim-cpp-enhanced-highlight) | 加强 cpp 语法高亮显示                                                                                                                                                                                                       |
| [vim-python/python-syntax](https://github.com/vim-python/python-syntax)                 | 加强 python 语法高亮显示                                                                                                                                                                                                    |
| [pboettch/vim-cmake-syntax](https://github.com/pboettch/vim-cmake-syntax)               | 加强 cmake 语法高亮显示                                                                                                                                                                                                     |
| [beyondmarc/hlsl.vim](https://github.com/beyondmarc/hlsl.vim)                           | 加强 hlsl 语法高亮显示                                                                                                                                                                                                      |
| [tpope/vim-eunuch](https://github.com/tpope/vim-eunuch)                                 | 对shell命令的封装, 有 delete, unlink, move, rename, chmod, mkdir, cfind, clocate, Lfind/, Wall(write all), SudoWrite, SudoEdit, 这个功能也确实挺好用的，不用切换终端可以干一些常做事情了                                   |
| [dag/vim-fish](https://github.com/dag/vim-fish)                                         | 为编写fish脚本提升体验的插件，支持fish脚本语法高亮等，我暂时使用的是zsh, 先弃之                                                                                                                                             |
| [skywind3000/vim-dict](https://github.com/skywind3000/vim-dict)                         | 词典补全的数据库, 目前还没找到触发方法, 配置信息也还没摸懂                                                                             |
| [tamago324/LeaderF-filer](https://github.com/tamago324/LeaderF-filer)                                 | <++>                                                                                                                                                                                                                        |
| [Yggdroot/LeaderF](https://github.com/Yggdroot/LeaderF)                                               | <++>                                                                                                                                                                                                                        |
| [vim-scripts/L9](https://github.com/vim-scripts/L9)                                                   | <++>                                                                                                                                                                                                                        |
| [honza/vim-snippets](https://github.com/honza/vim-snippets)                                           | <++>                                                                                                                                                                                                                        |
| [MarcWeber/vim-addon-mw-utils](https://github.com/MarcWeber/vim-addon-mw-utils)                       | <++>                                                                                                                                                                                                                        |
| [tomtom/tlib_vim](https://github.com/tomtom/tlib_vim)                                                 | <++>                                                                                                                                                                                                                        |
| [garbas/vim-snipmate](https://github.com/garbas/vim-snipmate)                                         | <++>                                                                                                                                                                                                                        |
| [xolox/vim-notes](https://github.com/xolox/vim-notes)                                                 | <++>                                                                                                                                                                                                                        |
| [skywind3000/vimoutliner](https://github.com/skywind3000/vimoutliner)                                 | <++>                                                                                                                                                                                                                        |
| [mattn/webapi-vim](https://github.com/mattn/webapi-vim)                                               | <++>                                                                                                                                                                                                                        |
| [mattn/gist-vim](https://github.com/mattn/gist-vim)                                                   | <++>                                                                                                                                                                                                                        |
| [lambdalisue/vim-gista](https://github.com/lambdalisue/vim-gista)                                     | <++>                                                                                                                                                                                                                        |
| [lifepillar/vim-cheat40](https://github.com/lifepillar/vim-cheat40)                                   | <++>                                                                                                                                                                                                                        |
| [kshenoy/vim-signature](https://github.com/kshenoy/vim-signature)                                     | <++>                                                                                                                                                                                                                        |
| [mhinz/vim-signify](https://github.com/mhinz/vim-signify)                                             | <++>                                                                                                                                                                                                                        |
| [t9md/vim-choosewin](https://github.com/t9md/vim-choosewin)                                           | <++>                                                                                                                                                                                                                        |
| [francoiscabrol/ranger.vim](https://github.com/francoiscabrol/ranger.vim)                             | <++>                                                                                                                                                                                                                        |
| [kana/vim-textobj-user](https://github.com/kana/vim-textobj-user)                                     | <++>                                                                                                                                                                                                                        |
| [kana/vim-textobj-syntax](https://github.com/kana/vim-textobj-syntax)                                 | <++>                                                                                                                                                                                                                        |
| [kana/vim-textobj-function](https://github.com/kana/vim-textobj-function)                             | <++>                                                                                                                                                                                                                        |
| [sgur/vim-textobj-parameter](https://github.com/sgur/vim-textobj-parameter)                           | <++>                                                                                                                                                                                                                        |
| [bps/vim-textobj-python](https://github.com/bps/vim-textobj-python)                                   | <++>                                                                                                                                                                                                                        |
| [jceb/vim-textobj-uri](https://github.com/jceb/vim-textobj-uri)                                       | <++>                                                                                                                                                                                                                        |
| [junegunn/fzf](https://github.com/junegunn/fzf)                                                       | <++>                                                                                                                                                                                                                        |
| [junegunn/fzf.vim](https://github.com/junegunn/fzf.vim)                                               | <++>                                                                                                                                                                                                                        |
| [mhartington/oceanic-next](https://github.com/mhartington/oceanic-next)                               | <++>                                                                                                                                                                                                                        |
| [jceb/vim-orgmode](https://github.com/jceb/vim-orgmode)                                               | <++>                                                                                                                                                                                                                        |
| [soft-aesthetic/soft-era-vim](https://github.com/soft-aesthetic/soft-era-vim)                         | <++>                                                                                                                                                                                                                        |
| [dyng/ctrlsf.vim](https://github.com/dyng/ctrlsf.vim)                                                 | <++>                                                                                                                                                                                                                        |
| [itchyny/calendar.vim](https://github.com/itchyny/calendar.vim)                                       | <++>                                                                                                                                                                                                                        |
| [tpope/vim-speeddating](https://github.com/tpope/vim-speeddating)                                     | <++>                                                                                                                                                                                                                        |
| [chiel92/vim-autoformat](https://github.com/chiel92/vim-autoformat)                                   | <++>                                                                                                                                                                                                                        |
| [voldikss/vim-translator](https://github.com/voldikss/vim-translator)                                 | <++>                                                                                                                                                                                                                        |
| [benmills/vimux](https://github.com/benmills/vimux)                                                   | <++>                                                                                                                                                                                                                        |
| [skywind3000/vim-gutentags](https://github.com/skywind3000/vim-gutentags)                             | skywind 对[ludovicchabant/vim-gutentags](https://github.com/ludovicchabant/vim-gutentags) 做了一些提升, 不用提前进行搜索，自动切换到cscope数据库, 依赖于cscope, universal-ctags工具                                        |
| [Shougo/deoplete.nvim](https://github.com/Shougo/deoplete.nvim)                                       | 补全工具, 对deoplete-jedi基于vim8/neovim 异步特性的扩展，根源还是基于jedi 插件, 需要vim/neovim 支持python, 在neovim 下coc 是个趋势，还有一个ycm 老大哥，优先学coc,和ycm, deoplete 暂弃之，                                  |
| [roxma/nvim-yarp](https://github.com/roxma/nvim-yarp)                                                 | <++>                                                                                                                                                                                                                        |
| [roxma/vim-hug-neovim-rpc](https://github.com/roxma/vim-hug-neovim-rpc)                               | <++>                                                                                                                                                                                                                        |
| [zchee/deoplete-jedi](https://github.com/zchee/deoplete-jedi)                                         | deoplete 的python补全源                                                                                                                                                                                                     |
| [vimwiki/vimwiki](https://github.com/vimwiki/vimwiki)                                                 | 制作wiki的插件，并不是vim使用手册的wiki, 类似于markdown的语法，暂时没有必要，其功能可以用 hexo + markdown 来替代                                                                                                            |
| [vim-airline/vim-airline](https://github.com/vim-airline/vim-airline)                                 | <++>                                                                                                                                                                                                                        |
| [vim-airline/vim-airline-themes](https://github.com/vim-airline/vim-airline-themes)                   | <++>                                                                                                                                                                                                                        |
| [itchyny/lightline.vim](https://github.com/itchyny/lightline.vim)                                     | <++>                                                                                                                                                                                                                        |
| [neoclide/coc.nvim](https://github.com/neoclide/coc.nvim)                                             | <++>                                                                                                                                                                                                                        |
| [kkoomen/vim-doge](https://github.com/kkoomen/vim-doge)                                               | <++>                                                                                                                                                                                                                        |
| [scrooloose/nerdtree](https://github.com/scrooloose/nerdtree)                                         | <++>                                                                                                                                                                                                                        |
| [tiagofumo/vim-nerdtree-syntax-highlight](https://github.com/tiagofumo/vim-nerdtree-syntax-highlight) | <++>                                                                                                                                                                                                                        |
| [rhysd/vim-grammarous](https://github.com/rhysd/vim-grammarous)                                       | <++>                                                                                                                                                                                                                        |
| [neomake/neomake](https://github.com/neomake/neomake)                                                 | <++>                                                                                                                                                                                                                        |
| [liuchengxu/vista.vim](https://github.com/liuchengxu/vista.vim)                                       | <++>                                                                                                                                                                                                                        |
| [liuchengxu/vim-clap](https://github.com/liuchengxu/vim-clap)                                         | <++>                                                                                                                                                                                                                        |
| [sbdchd/neoformat](https://github.com/sbdchd/neoformat)                                               | <++>                                                                                                                                                                                                                        |
| [Shougo/neocomplete.vim](https://github.com/Shougo/neocomplete.vim)                                   | <++>                                                                                                                                                                                                                        |
| [vim-scripts/OmniCppComplete](https://github.com/vim-scripts/OmniCppComplete)                         | <++>                                                                                                                                                                                                                        |
| [shawncplus/phpcomplete.vim](https://github.com/shawncplus/phpcomplete.vim)                           | <++>                                                                                                                                                                                                                        |
| [othree/html5.vim](https://github.com/othree/html5.vim)                                               | <++>                                                                                                                                                                                                                        |
| [autozimu/LanguageClient-neovim](https://github.com/autozimu/LanguageClient-neovim)                   | <++>                                                                                                                                                                                                                        |
| [skywind3000/vim-keysound](https://github.com/skywind3000/vim-keysound)                               | 用于模拟打字机的声音, 然而使用青轴的机械键盘，也有此效果, 这里作为趣味项目，看个人选择                                                                                                                                      |
| [istepura/vim-toolbar-icons-silk](https://github.com/istepura/vim-toolbar-icons-silk)                 | <++>                                                                                                                                                                                                                        |
| [voldikss/vim-floaterm](https://github.com/voldikss/vim-floaterm)                                     | <++>                                                                                                                                                                                                                        |
| <++>                                                                                                  | <++>                                                                                                                                                                                                                        |

### 关于插件学习的思考总结

何为插件?

	插件，主要目的是对原有软件的扩展，不管是vscode, 或者是chrome, 或者是 IDE, 游戏引擎，提供的插件系统学习成本大都不会太高，是锦上添花的功能。 插件与原软件的关系就好比应用与操作系统的关系一样。
	很多优秀的插件功能也会被集成到后续的新版本软件过程，一个优秀的插件系统有助于软件生态的建立， 也有助于软件本身的良性发展。
	插件并不神奇，但确实很有用, 使用的流程更简单，下载插件，重启软件，就可以用起来了。 

	vim 本身的多模式哲学，和优秀的插件架构，造就了神级编辑器。

插件的学习成本

	插件一股脑都安装了，除了可能会导至加载会慢， 使用并不会产生冲突, 因为大多数插件都提供的是命令方式，插件开发者会刻意避开比较流行的插件的命令的命名, 将命令映射成快捷键是用户的事情，而少部分插件会默认一些快捷键可能会引起冲突，但那也仅仅是不触发而已。 

	插件提供的是命令式的如 `:PluginInstall`, 使用频率较高的命令， 一般都是要定制(映射)快捷键，慢慢形成自己的操作习惯。

	因此，看到一款插件，可以放心大胆的引用进来，用一用，合适就加入插件库， 不合适就移出去，学习的成本很低, 不必顾虑太多。

	学会了vim的基本操作，后续建立自己高效的工作流基本都是找插件或者定制插件。

	插件的学习成本主要还在于各个领域的专业知识， 如各语言的代码组织，编译系统。像YCM插件就是典型的复杂的插件， 需要额外安装各语言的编译工具链。

