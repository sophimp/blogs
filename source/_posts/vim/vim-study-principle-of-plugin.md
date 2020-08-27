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

```txt
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
```

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

| 插件名称 | 作用说明 |
| :--:     | :--:     |
| [junegunn/plug.vim](https://github.com/junegunn/vim-plug)                                             | 插件管理器, 支持异步操作，主流使用的插件管理器，于我而言是够用了                                                                                                                                                            |
| [easymotion/vim-easymotion](https://github.com/easymotion/vim-easymotion)                             | 强化搜索功能的插件，vim中有单行搜索，全局搜索, 提供了2字符搜索功能，将搜索结果高亮，而其他内容加一个遮罩变暗, 快速跳转到搜索结果, 强化了dot重复上一步操作等功能, 更详细功能可通过 :help easymotion.txt 查看, 很强大，可以用 |
| [Raimondi/delimitMate](https://github.com/Raimondi/delimitMate)                                       | 用来自动补全括号, 引号等需要成对出现的闭合区间, 详细文档通过 :help delimitMate.txt 查看                                                                                                                                     |
| [justinmk/vim-dirvish](https://github.com/justinmk/vim-dirvish)                                       | 可以从当前文件夹内快速导航的插件, 使用 -/enter 分别跳转上一级文件夹/进入文件夹, 比netrw更快, 只复责导航，不负责创建更改删除,  详细文档通过 :help dirvish.txt 查看                                                           |
| [justinmk/vim-sneak](https://github.com/justinmk/vim-sneak)                                           | 强化了单行查找的命令, 使用两个字符全局搜索, 使用逗号(,)分号(;)分别跳转上一个/下一个匹配项, 大部分时候可以替代(/)的全局搜索功能                                                                                              |
| [tpope/vim-fugitive](https://github.com/tpope/vim-fugitive)                                           | 可以在vim 命令行中使用任何git命令的插件，结果分屏显示, 然而没有高亮，使用:Git 或 :G 代替 :!git, 详细文档通过 :help fugitive 查看                                                                                            |
| [tpope/vim-unimpaired](https://github.com/tpope/vim-unimpaired)                                       | 将vim内置的常用的20个命令使用[] 开头分别映成对的快捷键, 这20个命令到目前来我用得挺少, 具体哪些命令通过 :help unimpaired.txt 查看                                                                                            |
| [godlygeek/tabular](https://github.com/godlygeek/tabular)                                             | 文本格式化工具, 通过正则表达式来格式化文本, 详细文档通过 :help tabular.txt 查看                                                                                                                                             |
| [bootleq/vim-cycle](https://github.com/bootleq/vim-cycle)                                             | 定义一个变化表链，可以快速变化, 如 flase => true => false, 就可以通过 :CycleNext :CyclePrev 快速变换， 当然还可以绑定快捷键, 这对于反义词组，或者日常枚举单词做成一个循环链表达到快速变化的目的                             |
| [tpope/vim-surround](https://github.com/tpope/vim-surround)                                           | 方便修改成对的符号如"", '', [], {}, xml中的标签等, 支持text-obj, normal 模式下对应的命令有 cs, ys, ds; visual模式下命令为S, 将光标移动到符号包裹的区域中，使用命令替换即可
| [tpope/vim-rhubarb](https://github.com/tpope/vim-rhubarb)                                             | 加强tpope/vim-fugitive 的:Gbrowse命令, 将Git命令使用 hub来替代, hub是对git命令的封装和强化，git命令封装的工具还有lazygit
| [mhinz/vim-startify](https://github.com/mhinz/vim-startify)                                           | vim启动首页的定制，可定制标题，页脚，显示最新打开的标签页和永久的会话, 可以通过菜单直接打开, 通过 :h startify 来查看文档                                                                                                    |
| [flazz/vim-colorschemes](https://github.com/flazz/vim-colorschemes)                                   | vim主题的管理，提供了已配置好的scheme,通过 :colorscheme 切换， 或者在vimrc 中使用colorscheme 来设置                                                                                                                         |
| [xolox/vim-misc](https://github.com/xolox/vim-misc)                                                   | 多样化自动加载脚本, 实现异步加载？vim8和neovim都已经支持异步了， 且这个库已经5年+没有更新了, 与编写vim脚本相关性较高, 暂不研究，后续再看                                                                                    |
| [terryma/vim-expand-region](https://github.com/terryma/vim-expand-region)                             | 在visual模式下，使用+,- 自动识别(根据syntax-region)扩展或缩减选中区域                                                                                                                                                       |
| [pprovost/vim-ps1](https://github.com/pprovost/vim-ps1)                                               | 支持windows下的powershell 的脚本语法高亮, 暂时用不上                                                                                                                                                                        |
| [tbastos/vim-lua](https://github.com/tbastos/vim-lua)                                                 | 加强 lua 语法的高亮显示                                                                                                                                                                                                     |
| [octol/vim-cpp-enhanced-highlight](https://github.com/octol/vim-cpp-enhanced-highlight)               | 加强 cpp 语法高亮显示                                                                                                                                                                                                       |
| [vim-python/python-syntax](https://github.com/vim-python/python-syntax)                               | 加强 python 语法高亮显示                                                                                                                                                                                                    |
| [pboettch/vim-cmake-syntax](https://github.com/pboettch/vim-cmake-syntax)                             | 加强 cmake 语法高亮显示                                                                                                                                                                                                     |
| [beyondmarc/hlsl.vim](https://github.com/beyondmarc/hlsl.vim)                                         | 加强 hlsl 语法高亮显示                                                                                                                                                                                                      |
| [tpope/vim-eunuch](https://github.com/tpope/vim-eunuch)                                               | 对shell命令的封装, 有 delete, unlink, move, rename, chmod, mkdir, cfind, clocate, Lfind/, Wall(write all), SudoWrite, SudoEdit, 这个功能也确实挺好用的，不用切换终端可以干一些常做事情了                                   |
| [dag/vim-fish](https://github.com/dag/vim-fish)                                                       | 为编写fish脚本提升体验的插件，支持fish脚本语法高亮等，我暂时使用的是zsh, 先弃之                                                                                                                                             |
| [skywind3000/vim-dict](https://github.com/skywind3000/vim-dict)                                       | 为各文件/语言定制补全的常用字库, 根据打开的文件类型自动添加到tags中, 在看配置写markdown 会加载text.dict，目前并没有触发方法, 可能是当前使用的补全的插件不一样吧, 待调试。
| [Yggdroot/LeaderF](https://github.com/Yggdroot/LeaderF)                                               | 文件搜索插件，支持模糊搜索, 正则表达式, 包括当前路径下递归搜索，最近打开使用搜索, buffers搜索，gtags搜索                                                                                                                    |
| [tamago324/LeaderF-filer](https://github.com/tamago324/LeaderF-filer)                                 | 基于LeaderF 进行文件目录导航, 改变文件系统(创建，删除等)                                                                                                                                                                    |
| [vim-scripts/L9](https://github.com/vim-scripts/L9)                                                   | 一个vim script的lib库，好久没有维护了啊                                                                                                                                                                                     |
| [honza/vim-snippets](https://github.com/honza/vim-snippets)                                           | 收集了snipMate 和 UltiSnipets 的各语言常用的snippets，snipMate 是vimL开发的，UltiSnipets 需要python支持                                                                                                                     |
| [MarcWeber/vim-addon-mw-utils](https://github.com/MarcWeber/vim-addon-mw-utils)                       | 项目介绍: 按功能解释文件并自动缓存，也是为了写vimL脚本的一个插件,  待写vimL再研究                                                                                                                                           |
| [tomtom/tlib_vim](https://github.com/tomtom/tlib_vim)                                                 | 也是为vim脚本编写提供的工具库                                                                                                                                                                                               |
| [garbas/vim-snipmate](https://github.com/garbas/vim-snipmate)                                         | snippets 解释引擎, 使用vimL开发                                                                                                                                                                                             |
| [xolox/vim-notes](https://github.com/xolox/vim-notes)                                                 | 记笔记的插件，暂时用不上，直接写markdown 也能满足, 这个note可以方便写vim文档的格式                                                                                                                                          |
| [skywind3000/vimoutliner](https://github.com/skywind3000/vimoutliner)                                 | 用于制作目录大纲, 暂无必要研究                                                                                                                                                                                              |
| [mattn/webapi-vim](https://github.com/mattn/webapi-vim)                                               | vimL 的Web api库,  具体功能请看readme                                                                                                                                                                                       |
| [mattn/gist-vim](https://github.com/mattn/gist-vim)                                                   | 用于创建gists的插件, gist是和git结合的类似于记笔记的软件， 可用于分享，搜索，下载，嵌入到网页, 是github的一个服务，当然也可以有云功能, 暂时也用不到，自建一个仓库替代了                                                     |
| [lambdalisue/vim-gista](https://github.com/lambdalisue/vim-gista)                                     | 用于管理gist, gist相当于云笔记功能，其实是挺有用处的， 但是国类的网太慢了，影响体验                                                                                                                                         |
| [lifepillar/vim-cheat40](https://github.com/lifepillar/vim-cheat40)                                   | vim 命令速查表, 使用<leader>? 调出                                                                                                                                                                                          |
| [kshenoy/vim-signature](https://github.com/kshenoy/vim-signature)                                     | 将vim marker 显示在侧边状态栏, 按字母顺序跳转 marker, 可以使用特殊符号作为marker并显示                                                                                                                                      |
| [mhinz/vim-signify](https://github.com/mhinz/vim-signify)                                             | 在侧边状态栏显示svn, git等cvs管理的文件的状态                                                                                                                                                                               |
| [t9md/vim-choosewin](https://github.com/t9md/vim-choosewin)                                           | 将已打开的vim窗口编号，便于快速跳转，暂没必要使用, 使用skywind3000定制的 <tab>h/j/k/l 就足以快速跳转了                                                                                                                      |
| [francoiscabrol/ranger.vim](https://github.com/francoiscabrol/ranger.vim)                             | 将终端的ranger集成到vim使用，ranger是一个终端的文件导航工具, vim操作, 也是一神器                                                                                                                                            |
| [kana/vim-textobj-user](https://github.com/kana/vim-textobj-user)                                     | 自定义text-objects,  text-object 也是一个很好用的特性                                                                                                                                                                       |
| [kana/vim-textobj-syntax](https://github.com/kana/vim-textobj-syntax)                                 | 支持text-objects 高亮显示, 详细文档通过 :h textobj-syntax.txt                                                                                                                                                               |
| [kana/vim-textobj-function](https://github.com/kana/vim-textobj-function)                             | 定义了函数体为一个text-objects, 表示为af, 支持c/java/vimL                                                                                                                                                                   |
| [sgur/vim-textobj-parameter](https://github.com/sgur/vim-textobj-parameter)                           | 结合kana/vim-textobj-user, 将函数参数定义为一个text-object, i 不包括逗号， a包括逗号                                                                                                                                        |
| [bps/vim-textobj-python](https://github.com/bps/vim-textobj-python)                                   | 定义python 的函数与类为text object, 分别为 af, if, ac, ic,  提供函数间跳转 `[pf / ]pf ` 和类间跳转 `[pc / ]pc`                                                                                                              |
| [jceb/vim-textobj-uri](https://github.com/jceb/vim-textobj-uri)                                       | 定义uri为text object, 需要与pathogen.vim , vim-textobj-user 一起安装， 光标移动到uri 上，键入 go 可以使用默认浏览器打开链接                                                                                                 |
| [junegunn/fzf](https://github.com/junegunn/fzf)                                                       | fzf是shell下的文件搜索工具，也支持模糊查找, 可以针对不同的文件类型查找，与vim的buffer, tags, mark配合也很好， 功能很强大, 留着后续学习使用                                                                                  |
| [junegunn/fzf.vim](https://github.com/junegunn/fzf.vim)                                               | 将shell下的fzf集成到vim中，现在使用LeaderF, 感觉够用, 暂时可以不用这个,先留着吧                                                                                                                                             |
| [mhartington/oceanic-next](https://github.com/mhartington/oceanic-next)                               | neovim 的一个主题                                                                                                                                                                                                           |
| [jceb/vim-orgmode](https://github.com/jceb/vim-orgmode)                                               | 将Emacs 的 Org-Mode 移植到vim， 文本式的大纲和任务管理, 看来这个任务管理工具是大家都需要的                                                                                                                                  |
| [soft-aesthetic/soft-era-vim](https://github.com/soft-aesthetic/soft-era-vim)                         | 一款vim的主题                                                                                                                                                                                                               |
| [dyng/ctrlsf.vim](https://github.com/dyng/ctrlsf.vim)                                                 | 代码搜索和查看工具, ack/ag/pt/rg, 这几个是什么工具，没有查出来                                                                                                                                                              |
| [itchyny/calendar.vim](https://github.com/itchyny/calendar.vim)                                       | 日历插件, 功能很强大， 还可以做日程安排                                                                                                                                                                                     |
| [tpope/vim-speeddating](https://github.com/tpope/vim-speeddating)                                     | 快速加减数字的插件, ctrl+A 增加，ctrl+X减少，可以识别日期，时间格式, 按照对应的规则加减                                                                                                                                     |
| [chiel92/vim-autoformat](https://github.com/chiel92/vim-autoformat)                                   | 根据定制的代码格式化模板自动格式化, 模板在readme有                                                                                                                                                                          |
| [voldikss/vim-translator](https://github.com/voldikss/vim-translator)                                 | vim下的翻译器，也挺好用的，可以直接将翻译的文本替换, 或复制到剪贴板, 翻译引擎支持bing, iciba, google, youdao, trans, sdcv, 默认iciba, youdao, 需要网络，是在线的                                                           |
| [benmills/vimux](https://github.com/benmills/vimux)                                                   | 与tmux终端数据交互, tmux是一个终端复用软件，可以让会话与窗口解绑                                                                                                                                                            |
| [skywind3000/vim-gutentags](https://github.com/skywind3000/vim-gutentags)                             | skywind 对[ludovicchabant/vim-gutentags](https://github.com/ludovicchabant/vim-gutentags) 做了一些提升, 不用提前进行搜索，自动切换到cscope数据库, 依赖于cscope, universal-ctags工具                                        |
| [Shougo/deoplete.nvim](https://github.com/Shougo/deoplete.nvim)                                       | 补全工具, 对deoplete-jedi基于vim8/neovim 异步特性的扩展，根源还是基于jedi 插件, 需要vim/neovim 支持python, 在neovim 下coc 是个趋势，还有一个ycm 老大哥，优先学coc,和ycm, deoplete 暂弃之，                                  |
| [roxma/nvim-yarp](https://github.com/roxma/nvim-yarp)                                                 | 为neovim写远程插件的框架，暂不研究                                                                                                                                                                                          |
| [roxma/vim-hug-neovim-rpc](https://github.com/roxma/vim-hug-neovim-rpc)                               | 在vim8上建一个neovim rpc 客户端的兼容层, 暂不研究                                                                                                                                                                           |
| [zchee/deoplete-jedi](https://github.com/zchee/deoplete-jedi)                                         | deoplete.nvim 的python补全源, 暂时不用deoplete补全                                                                                                                                                                          |
| [vimwiki/vimwiki](https://github.com/vimwiki/vimwiki)                                                 | 制作wiki的插件，并不是vim使用手册的wiki, 类似于markdown的语法，暂时没有必要，其功能可以用 hexo + markdown 来替代                                                                                                            |
| [vim-airline/vim-airline](https://github.com/vim-airline/vim-airline)                                 | 强化底部的状态栏, 类似插件有 lightline, powerline                                                                                                                                                                           |
| [vim-airline/vim-airline-themes](https://github.com/vim-airline/vim-airline-themes)                   | 底部状态的主题                                                                                                                                                                                                              |
| [itchyny/lightline.vim](https://github.com/itchyny/lightline.vim)                                     | clone 的 powerline, 比airline更轻量级                                                                                                                                                                                       |
| [neoclide/coc.nvim](https://github.com/neoclide/coc.nvim)                                             | neovim 下当前新流行的补全插件, conuqer of code completion，deoplete可以不用了YCM暂时也可以放一边了                                                                                                                          |
| [kkoomen/vim-doge](https://github.com/kkoomen/vim-doge)                                               | 文档生成插件,支持15+语言                                                                                                                                                                                                    |
| [scrooloose/nerdtree](https://github.com/scrooloose/nerdtree)                                         | 文件列表导航， 有了ranger, leaderF, dirvish, nerdtree 显得无关紧要了,  但放在那里，偶尔用到看一眼，也不会影响多少性能                                                                                                       |
| [tiagofumo/vim-nerdtree-syntax-highlight](https://github.com/tiagofumo/vim-nerdtree-syntax-highlight) | nerdtree 文件图标支持                                                                                                                                                                                                       |
| [rhysd/vim-grammarous](https://github.com/rhysd/vim-grammarous)                                       | 语法检查工具, 有助于英语写作                                                                                                                                                                                                |
| [neomake/neomake](https://github.com/neomake/neomake)                                                 | 语法检查，编译框架，类似的有ale                                                                                                                                                                                             |
| [liuchengxu/vista.vim](https://github.com/liuchengxu/vista.vim)                                       | 查看，搜索 LSP symbols, tags 类似于ctrlsf插件，查以方便查看函数，变量列表                                                                                                                                                   |
| [liuchengxu/vim-clap](https://github.com/liuchengxu/vim-clap)                                         | 添加了浮动窗口特性,  快速查找文件, 文件的搜索是一件高频的日常任务，对此行为优化的插件很多                                                                                                                                   |
| [sbdchd/neoformat](https://github.com/sbdchd/neoformat)                                               | neovim 下的自动格式化代码工具，类似的插件有 vim-autoformat                                                                                                                                                                  |
| [Shougo/neocomplete.vim](https://github.com/Shougo/neocomplete.vim)                                   | 为了在vim下兼容neovim下的deoplete插件，                                                                                                                                                                                     |
| [vim-scripts/OmniCppComplete](https://github.com/vim-scripts/OmniCppComplete)                         | 基于ctags数据库的c/cpp补全引擎, 对其他补全插件有一个补充吧, ctags生成也支持多种语言，因此也可以支持其他语言的ctags补全                                                                                                      |
| [shawncplus/phpcomplete.vim](https://github.com/shawncplus/phpcomplete.vim)                           | 基于OmniCppComplete补全引擎的 php补全支持                                                                                                                                                                                   |
| [othree/html5.vim](https://github.com/othree/html5.vim)                                               | 基于OmniCppComplete补全引擎的 html5 补全支持                                                                                                                                                                                |
| [autozimu/LanguageClient-neovim](https://github.com/autozimu/LanguageClient-neovim)                   | 使(neo)vim支持LSP，已集成了deoplete, ncm2, MUcomplete 补全引擎, 这是对deoplete一类补全引擎的续命，新一代coc已全面支持LSP                                                                                                    |
| [skywind3000/vim-keysound](https://github.com/skywind3000/vim-keysound)                               | 用于模拟打字机的声音, 然而使用青轴的机械键盘，也有此效果, 这里作为趣味项目，看个人选择                                                                                                                                      |
| [istepura/vim-toolbar-icons-silk](https://github.com/istepura/vim-toolbar-icons-silk)                 | gvim工具条的图标 silk 主题                                                                                                                                                                                                  |
| [voldikss/vim-floaterm](https://github.com/voldikss/vim-floaterm)                                     | (neo)vim的在终端下的浮动窗口特性库                                                                                                                                                                                          |

### 关于插件学习的思考总结

1. 何为插件?

插件，主要目的是对原有软件的扩展，不管是vscode, 或者是chrome, 或者是 IDE, 游戏引擎，提供的插件系统学习成本大都不会太高，是锦上添花的功能。 插件与原软件的关系就好比应用与操作系统的关系一样。
很多优秀的插件功能也会被集成到后续的新版本软件过程，一个优秀的插件系统有助于软件生态的建立， 也有助于软件本身的良性发展。
插件并不神奇，但确实很有用, 使用的流程更简单，下载插件，重启软件，就可以用起来了。 

vim 本身的多模式哲学，和优秀的插件架构，造就了神级编辑器。

2. 插件的学习成本

插件一股脑都安装了，除了可能会导至加载会慢， 使用并不会产生冲突, 因为大多数插件都提供的是命令方式，插件开发者会刻意避开比较流行的插件的命令的命名, 将命令映射成快捷键是用户的事情，而少部分插件会默认一些快捷键可能会引起冲突，但那也仅仅是不触发而已。 

插件提供的是命令式的如 `:PluginInstall`, 使用频率较高的命令， 一般都是要定制(映射)快捷键，慢慢形成自己的操作习惯。

因此，看到一款插件，可以放心大胆的引用进来，用一用，合适就加入插件库， 不合适就移出去，学习的成本很低, 不必顾虑太多。

学会了vim的基本操作，后续建立自己高效的工作流基本都是找插件或者定制插件。

插件的学习成本主要还在于各个领域的专业知识， 如各语言的代码组织，编译系统。像YCM插件就是典型的复杂的插件， 需要额外安装各语言的编译工具链。

3. 插件系统的丰富性

丰富的插件可以将vim打造成神级编辑器，然而陈年的老插件也加重了vim学习的负担。当然这里还有一个主要的原因, 没有一个好的系列教程，大多数的vim教程都只是写一些vim的tricks, 或者某个插件的使用，这就导致学习具有盲目性与时效性。

