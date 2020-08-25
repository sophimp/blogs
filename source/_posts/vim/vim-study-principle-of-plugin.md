---
title: vim 学习系列之(3) -- vim 插件系统
date: 2020-08-20 16:17:14
tags:
categories:
description:
---

### neovim插件原理

vim 与 neovim 插件的加载原理也是相同的。 

主要涉及这几个文件夹:

vimruntimepath --
|-- bundles
	|-- [plugins]
		|-- [start]
		|-- [after]
|-- vim
	|-- autoload
	|-- colors
	|-- ftplugin
	|-- syntax



