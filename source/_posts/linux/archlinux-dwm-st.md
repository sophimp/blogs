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

内容滚动

	打 [mouse scroll patch](https://st.suckless.org/patches/scrollback/)

### tmux

[tmux是什么](https://www.ruanyifeng.com/blog/2019/10/tmux.html)

tmux是会话与终端窗口实现解绑的工具，tmux 是用来管理终端窗口的，从终端窗口里启动, 而 dwm 是用来管理整个系统应用窗口的，它们动态窗口管理的理念是一样的， 但是作用的对象不一样。

如果使用vim的话，那么在linux下，基本上使用终端的时间在80%. 所以，tmux 是一个很常用的工具， 也很有必要将终端再管理起来。 

因此我的方案是使用 DE(KDE/GNOME/Manjaro) + st + tmux, 日常工作流在窗口切换上基本上就很效率了。

打造自己的工作流， 是一个长期的工程, 着急不来。前期能依附现有的工具最好，先将精力集中在更重要的事情上， 但是时间战线拉长的话，操作系统是绕不开的一座山。因此，有空就爬一点，慢慢的就征服了这座山。

tmux 的配置在 ~/.tmux.conf
使用 tmux 打开vim, ESC键回到normal模式有延时， 需要在 .tmux.conf 添加
```conf
set -g escape-time 20
```

启动鼠标混轮:
`ctrl+b : ` 进入命令模式
```sh
set -g mouse on
```
