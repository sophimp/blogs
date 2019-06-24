
## vim 配置c++环境

[参考韦易笑教程](https://www.zhihu.com/question/47691414/answer/373700711)

改变一下策略, 直接拿其配置, 简单学会一下怎么使用, 更多的使用方法, 后续慢慢研究

有好多的插件, 一下午的时间, 看看源码, 简单了解了一下相关的操作, 从keymap.vim 中, 可以尝试很多快捷键的作用
在bundle.vim 中也可以看到各插件的常用快捷键操作

quickfix窗口可以有很多操作啊, 快速搜索, 代码搜索这些功能确实很好用

直接clone 代码, 在.vimrc 中添加 加载的bundle, 然后就可以直接利用能力了, unix 下直接使用 vimrc.unix即可 

vim 哲学, emacs 工具, 更加强大, 可以制作一个操作系统, 暂时没有精力去折腾, 先搞定vim, vim 已经可以满足我的需求了

插件管理 
--------

plug.vim

按照github 上的readme 配置， 插件管理， 暂时就先学一个 PlugInstall 命令， 插件安装的依赖， 也先按教程来搞，先学其他插件的使用

代码格式化
----------

    'junegunn/vim-easy-align'
    
    简单使用, 使用nmap, xmap gaip *=
    vim 有四种模式, visual, normal, insert, 还有一个interactive mode

快捷菜单
--------

    'skywind3000/quickmenu.vim'
    安装上了, 但是还没有真正得明白什么用, 用来帮助快速查看快捷键命令? 要怎么配置? 暂时用处不大? 

文件树
------

    'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

    怎么将文件树放在左边呢? 放在右边也挺好
    延时加载, 打开vim 会变得更快一点
    
    采用了韦易笑的配置, 按模块加载, bundle, 这些思想也都是共通的


'tpope/vim-fireplace', { 'for': 'clojure' }

'rdnetto/YCM-Generator', { 'branch': 'stable' }

'fatih/vim-go', { 'tag': '*' }

'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

'iamcco/mathjax-support-for-mkdp'
'iamcco/markdown-preview.vim'

'udalov/kotlin-vim'


