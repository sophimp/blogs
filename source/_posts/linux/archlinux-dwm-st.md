---
title: Archlinux- dwm, st, tmux
tags:
- 终端
- 窗口管理器
categories:
- Linux
description: 在Linux下工作， 终端是最常用的工具了。 桌面环境配置的终端， 会有快捷键冲突， 特别是alt键，这个原因导致在vim中使用alt键很受限，且很难找到在哪里去修改配置，因此，使用最原简单的工具， 可定制性更高。 虽然学习曲线更加陡峭, 但生命就在于折腾，折腾出一款符合自己习惯， 且可完全定制的UI是非常有必要的， 也借此学习了解操作系统。本文记录折腾dwm 和 st 的过程。 
---

## suckless

[suckless.org](https://suckless.org/) 是一个开源组织。 
其软件标准是: 高质量， 简单， 清晰，极俭。 
其哲学思想是: 保持事物简单，最小且可用。

dwm, st 都是出自这里。

### dwm 

动态窗口管理器，小而精， 可定制性强。
fork 了 [theniceboy/dwm](https://github.com/theniceboy/dwm) 的代码，已经打了patcheds里的补丁
[相关脚本](https://github.com/theniceboy/scripts)

开机启动

快速启动一个应用

其他工具(如网络管理工具, 文件夹查看工具)

### st

同样fork 了[theniceboy/st](https://github.com/theniceboy/st) 的代码, 已经打了patches 里的补丁

安装字体
```sh
yay -S otf-nerd-fonts-fira-code
```
	这里下载github 使用 curl 会遇到 :443端口禁止访问的问题， 这是由于墙的原因，DNS污染了
	请看[这里](https://github.com/hawtim/blog/issues/10)
	替换一下hosts即可解决
```hosts
	199.232.68.133 raw.githubusercontent.com
	199.232.68.133 user-images.githubusercontent.com
	199.232.68.133 avatars2.githubusercontent.com
	199.232.68.133 avatars1.githubusercontent.com
```

编译安装
```sh
sudo make clean install
```

st-copyout 使用

内窜滚动

### tmux
[tmux是什么](https://www.ruanyifeng.com/blog/2019/10/tmux.html)

tmux是会话与窗口实现解绑的工具，需要运行在终端里, 因此也必须先有窗口管理器。 tmux与dwm分离窗口的功能相近，但是其他功能还是差别挺大的。 

安装KDE, GNOM或其他桌面环境，再安装一个st, 可以满足我的需求， 虽然性能和内存占用会多一些， 但是前期可以少一些折腾不必要的东西，将精力集中在做更需要做的事情上。打造自己的工作流， 本就是一个长期的工程。所以， 也没必要着急。


