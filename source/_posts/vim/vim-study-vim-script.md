---
title: vim 学习系列之(5) -- vim 脚本
date: 2020-08-26 14:36:41
tags:
- Vim
- Neovim
categories:
- Vim
description:
---
### 关键字，命令
- autocmd	

autocmd! BufRead,BufNewFile `*.sophimp` setfile

- augroup

- finish

vim 命令，可以终止此命令后的vim脚本执行

- did_load_filetypes

`did_load_filetypes` 并不是vim内置的函数，而是在全局的 filetype.vim 中设置的一个变量，可以通过 `:e $VIMRUNTIME/filetype.vim` 查看，在加载一次后被置 1

- getline(1)

读取第一行

- did_filetype()

内置函数, 如果一个file type相关的事件触发了至少一次，返回true, 可以用作guard, 防止重复触发 file type 事件

- silent
	
### Buffers, Windows, Tabs
set hidden 禁止提示
```vim
:buffers
:buffer + n 
:buffer + <tab>
:bdelete + n/<tab>
```

window 是buffer的显示区域
tab 代表window的layout, 不代表一个文件，关闭tab只是关闭了window layout, 并没有关闭buffer, 一个buffer代表一个文件 

```vim
// 多个tab打开文件
vim - p file1 file2 file3
```



### 语法

### 技巧点 

[Google Vimscript Style Guide](https://google.github.io/styleguide/vimscriptguide.xml)

`:help usr_41` 命令

如何让vim 与 nvim 使用同一个配置？ 

	将nvim 的执行环境修改成vim 的, 类似于chroot的原理。

	打开nvim, 输入 `:help nvim-from-vim` 有帮助文档

	1. 创建`~/.config/nvim/init.vim` 文件
	2. 添加下例内容到 init.vim
```vimrc

	# ^= 将~/.vim 添加到runtimepath之前，after 是用来覆盖缺省值或增加设置(很少用到)，这里实际是没有用到, 对应的还有start 生命周期
	set runtimepath^=~/.vim runtimepath+=~/.vim/after

	# &是取选项值，packpath 是vim 默认插件存放位置, 所有 pack/*/opt/{name}/plugin/**/*.vim 文件都被执行, 这样可以允许"plugin"使用子目录，像 `runtimepath` 里的插件一样。
	let &packpath = &runtimepath

	source ~/.vimrc
```
	3. 重启nvim, 就会加载vim 配置了
		

- vim buffer, register

	buffer 管理文件, `:buffers` 可查看所有缓冲区
	register 管理 复制，剪切，删除等命令的内容, `:registers` 可以查看所有寄存器。
	
- runtimepath

runtimepath下的脚本会执行几次？
给的示例script.vim, 只有在加载不认识类型的文件时会执行。

- 红色高亮
红色高亮一般是错误，可以使用下面的函数查看报错信息
```viml
:echo synIDattr(synID(line("."),col("."),0),"name")
```
然后再根据报错信息，全局搜索, 定位到报错脚本。

场景: 在md文件中，下划线一直红色高亮, 使用上述方法输出`markdownError`, `grep -r "markdownError" . ` 找到是theme_color中有报错，最后安装一个`plasticboy/vim-markdown`插件解决

