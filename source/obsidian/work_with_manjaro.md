
---
title: 主机配置
date: 2023-02-12 12:39
tags: 
categories: 
description: 
---

# 背景

折腾了一圈系统，从archlinux 转到manjaro, 说是manjaro 基于arch, 但是现在已经跟arch 背离很远了。

之所以转到manjaro, 主要是现在折腾的时间少了，更主要的时间需要用来开发产品。折衷选择manjaro, 先用着试试吧。

看来也是少不了折腾

## manjaro

还是装一个开箱即用的系统省事一些，manjaro 挺好的，节省了前期的折腾时间，后面遇到问题再折腾就是了，没有遇到问题不折腾

- 安装

	是比archlinux 简单得多。

- 显卡

	mhwd 工具管理

	video-linux, video-modesetting, video-mesa, 优先选择video-linux, 
	不能同时安装，同时安装后，开不了机，可能过live环境来拯救;
	拯求的思路是通过chroot 命令进入到系统环境，通过mhwd 卸载掉其他两个，再重新安装一下video-linux

	archlinux 有 arch-chroot, manjaro 下没有
	使用原始的 chroot 需要挂载 proc, sys, dev, 再挂载系统根目录

- openvpn 

	公司的开发环境需要

- 翻墙

	clash for windows

	开启tun 模式
	系统还需要手动开启全局代理
	firefox 还需要再额外开启浏览器代理, chrome 不需要

- pacman

安装软件
+ `pacman -S (软件名)`：安装软件，若有多个软件包，空格分隔
+ `pacman -S --needed （软件名）`：安装软件，若存在，不重新安装最新的软件
+ `pacman -Sy (软件名)`：安装软件前，先从远程仓库下载软件包数据库
+ `pacman -Sv (软件名)`：输出操作信息后安装 
+ `pacman -Sw (软件名)`：只下载软件包，而不安装 
+ `pacman -U (软件名.pkg.tar.gz)`：安装本地软件包 
+ `pacman -U (http://www.xxx.com/xxx.pkg.tar.xz)`：安装一个远程包# 卸载软件 
+ `pacman -R (软件名)`：只卸载软件包不卸载依赖的软件 
+ `pacman -Rv (软件名)`：卸载软件，并输出卸载信息 
+ `pacman -Rs (软件名)`：卸载软件，并同时卸载该软件的依赖软件 
+ `pacman -Rsc (软件名)`：卸载软件，并卸载依赖该软件的程序 
+ `pacman -Ru (软件名)`：卸载软件，同时卸载不被任何软件所依赖# 搜索软件 
+ `pacman -Ss (关键字)`：在仓库搜索包含关键字的软件包 
+ `pacman -Sl `：显示软件仓库所有软件的列表 
+ `pacman -Qs (关键字)`：搜索已安装的软件包 
+ `pacman -Qu`：列出可升级的软件包 
+ `pacman -Qt`：列出不被任何软件要求的软件包 
+ `pacman -Q (软件名)`：查看软件包是否已安装 
+ `pacman -Qi (软件包)`：查看某个软件包详细信息 
+ `pacman -Ql (软件名)`：列出软件包所有文件安装路径# 软件包组 
+ `pacman -Sg`：列出软件仓库上所有软件包组 
+ `pacman -Qg`：列出本地已经安装的软件包组和子软件包 
+ `pacman -Sg (软件包组)`：查看软件包组所包含的软件包 
+ `pacman -Qg (软件包组)`：查看软件包组所包含的软件包# 更新系统 
+ `pacman -Sy`：从服务器下载最新的软件包数据库到本地 
+ `pacman -Su`：升级所有已安装的软件包 
+ `pacman -Syu`：升级整个系统# 清理缓存 
+ `pacman -Sc`：清理未安装的软件包文件 
+ `pacman -Scc`：清理所有的缓存文件

- 常用工具

git, vim, zsh 已经自带

tmux 配置找不到了

idea ultimate 可用破解

android-sdk, openjdk

图床工具
    picgo

网盘云
    坚果云，基本上够用了
    再加上阿里云

洛雪音乐

GoldenDict

[wiki openvpn](https://wiki.archlinux.org/title/OpenVPN_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)#%E5%90%AF%E5%8A%A8_OpenVPN)

首先，安装 networkmanager-openvpn。 
然后，go to the Settings menu and choose Network. Click the plus sign to add a new connection and choose VPN. From there you can choose OpenVPN and manually enter the settings, or you can choose to import the client configuration file if you have already created one. If you followed the instructions in this article then it will be located at /etc/openvpn/client.conf. To connect to the VPN simply turn the connection on.

使用过程中的一些痛点及时记录下来，有时间有精力就解决掉，没有的话，还挖个坑，这些都是可行的。

最终还是换回了windows, 有了wsl2，linux的需求也够了

