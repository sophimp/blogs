---
title: vim 学习系列之(5) -- vim 脚本
date: 2020-08-26 14:36:41
tags:
- vim
- neovim
categories:
- vim
description:
---

### vim 脚本

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
	

