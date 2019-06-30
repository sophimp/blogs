
## vim 配置c++环境

[参考韦易笑教程](https://www.zhihu.com/question/47691414/answer/373700711)

改变一下策略, 直接拿其配置, 简单学会一下怎么使用, 更多的使用方法, 后续慢慢研究

有好多的插件, 一下午的时间, 看看源码, 简单了解了一下相关的操作, 从keymap.vim 中, 可以尝试很多快捷键的作用
在bundle.vim 中也可以看到各插件的常用快捷键操作

quickfix窗口可以有很多操作啊, 快速搜索, 代码搜索这些功能确实很好用

直接clone 代码, 在.vimrc 中添加 加载的bundle, 然后就可以直接利用能力了, unix 下直接使用 vimrc.unix即可 

vim 哲学, emacs 工具, 更加强大, 可以制作一个操作系统, 暂时没有精力去折腾, 先搞定vim, vim 已经可以满足我的需求了

	直接clone 配置到~/.vim/ 下 git clone 
	配置 .vimrc 
		so ~/.vim/vim/vimrc.unix
		let g:bundle_group = ['要加载的模块', '可以从 bundle.vim' 中查看有哪些模块可选]
		so ~/.vim/vim/bundle.vim
	然后查看 bundle.vim 下各插件的快捷键配置, asc/keymap.vim, 通用快捷键, 操作一下, 看看效果, 理解个大概, 这一过程先操作熟练了, 养成操作习惯( 这里以前还有点中二的想法, 非得配置一下属于自己的操作习惯, 其实呢, 自己也并没有什么操作习惯, 仅仅是想以不一样来标榜是属于自己的,这里韦易笑前辈, 作为几十年的使用习惯, 绝大部分都是可取, 高效的, 当然, 肯定也有部分并不合适自己的习惯, 用着别扭, 那个时候, 再改一下, 也就是两三天就可以纠正过来了. 纠正习惯并不是一件多么难, 且可怕的事. 以前的经历, 大多是想一上来就想总结出自己的习惯, 然后, 在零的基础上, 怎么可能瞬间建成大厦? 于是在重压下, 从入门到放弃了) , 先活下来, 再想提高效率的事情.  
	上一步骤, 花个一周的时间, 快捷键熟悉完后, 再研究那些一眼看不出来的操作, 再逐步提高效率. 

	
plug.vim
--------

	插件管理 

	按照github 上的readme 配置， 插件管理， 暂时就先学一个 PlugInstall 命令， 插件安装的依赖， 也先按教程来搞，先学其他插件的使用

'junegunn/vim-easy-align'
----------

	代码格式化
    简单使用, 使用nmap, xmap gaip *=
    vim 有四种模式, visual, normal, insert, 还有一个interactive mode

'skywind3000/quickmenu.vim'
--------
    
	快捷菜单
    安装上了, 但是还没有真正得明白什么用, 用来帮助快速查看快捷键命令? 要怎么配置? 

'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
------

	文件目录树
    怎么将文件树放在左边呢? 放在右边也挺好
    延时加载, 打开vim 会变得更快一点
    
    采用了韦易笑的配置, 按模块加载, bundle, 这些思想也都是共通的

w0rp/ale
------------

	代码动态检查
	
	暂时是直接安装插件配置, 已可满足基本需求, 待有错误时再研究

Raimondi/delimitMate: 
------

	用来自动补全括号, 引号等需要成对出现的闭合区间
	看了文档, 配置是默认开启的? 目前看到的效果是还需要手打, 但是会自动对齐, 自动对齐功能还不清楚是不是此插件的

terryma/vim-expand-region: 
------

	在visual模式下, 用来快速选择text-object 区域的内容, + 扩大选择范围, - 减小选择范围, 可以自行配置text-object, 此脚本里的配置貌似也没怎么起作用, {}, () 这里面的内容都不能识别 

mattn/webapi-vim: 
------

	提供解析xml, html, json, Base64, Sha1, HMAC 的库
	支持协议有 BasicHttp, OAuth, SOAP, Autopub, XMLRPC
	用来提供给vim 脚本使用

PProvost/vim-ps1: 
------

	用来支持powershell, 这个暂时可以先不用, 也是按需加载的, 所以不用感知 

LeaderF: 
------
	 是一个python 库脚本, 需要vim 支持python/python3, 适用于大型项目
	 功能: 异步模糊查找, 快速定位文件, buffers, mrus, tags 等等
	 mrus 是vim 的最近缓存功能, 还是别的插件的?

	 使用起来得费一番功夫, 很多选项和功能

	 在deepin 上的映射ctrl+p 键有冲突


fzf: 
------
vim-snippets: 
------
vim-cycle: 
------
rust.vim: 
------
echodoc.vim: 
------
vim-fugitive: 
------
vim-notes: 
------
vim-nerdtree-syntax-highlight: 
------
calendar.vim: 
------
OmniCppComplete: 
------
ctrlsf.vim: 
------
vim-syntax-extra: 
------
vim-cpp-enhanced-highlight: 
------
vim-eunuch: 
------
tlib_vim: 
------
vim-snipmate: 
------
vim-orgmode: 
------
oceanic-next: 
------
vim-sneak: 
------
nerdtree: 
------
vim-dict: 
------
vim-colorschemes: 
------
vim-lua: 
------
vim-gista: 
------
vim-unimpaired: 
------
gist-vim: 
------
vim-dirvish: 
------
vim-misc: 
------
tabular: 
------
soft-era-vim: 
------
vim-speeddating: 
------
vim-easymotion: 
------
phpcomplete.vim: 
------
vimoutliner: 
------
vim-startify: 
------
ale: 
------
python-syntax: 
------
html5.vim: 
------
L9: 
------
FuzzyFinder: 
------
vim-abolish: 
------
vim-gutentags: 
------
vim-surround: 
------
vim-fish: 
------
vim-addon-mw-utils: 
------
