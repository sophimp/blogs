---
title: archlinux - 日常生活与工作使用记录
date: 2020-08-13 14:39:30
tags:
- Linux
- archlinux

categories:
- Linux
description: archlinux的使用日常，踩的坑，设计的想法，对linux系统里各种概念的学习，都记录于此，以便于后续的整理
---

# 现状与想法

使用archlinux开发与工作，断断续续也有一年多的时间了, 到目前为止，由刚开始的各种束手束脚, 到现在初步尝到了定制性高的甜头，现在的感觉就是手里有个锤子，哪里都想敲一敲。

用archlinux折腾到日常使用习惯这个标准，就能学习很多关于linux的知识，这也是强制使用archlinux的原因，刚一开始，难免各种不适应，想进入桌面，想看个图片，听个歌都需要折腾很久, 这个环节难免是容易受挫的，但是就算再多，也是有限的，真正折腾个遍，这个时间花费是值得的。

最近(Tue Nov 23 11:48:24 2021 Tuesday)折腾 软路由, NAS, 断了几个月的archlinux又捡了起来，再次折腾archlinux, 难免还是各种束手束脚，但是再次折腾上手还是要比刚开始的时候快很多，而且也有了更深一步的理解，所谓软路由系统, NAS系统，内核也是基于linux的，所以这些系统的能力，其他基于linux内核的系统也应该都能做到。

linux下的软件基本上都可以提供cli, 有了cli, 做自动化的事情就方便得多

# 概念

DE: Desktop Environment

GPIO
CPIO: 复制文件工具，可以将

## dd

可以制作U盘镜相

## SELinux

文件系统

## i2c

## bootloader

# 日常使用工具

## 装完系统后
只能进tty, 而且我的电脑，开机经常不能正常开机，非得按电源键多几次才能正确开机，是电源键的原因么？趁此换一个机箱试试, 也需要多盘位的机箱

pacman 添加国内的源，网速要快很多

添加非root用户，可以使用sudo 提权
	useradd username
	passwd username
	usermode -aG wheel username
	vim /etc/sudoers


桌面 DE (desktop environment)

	pacman -S xorg xfce4 xfce4-goodies
	配置.xinitrc
	startxfce4 就可以进入桌面`

登陆管理dm(display manager), 开机启动

	登陆管理器也是单独的软件，选择lightdm, 
	systemctl enable lightdm.service
	greeter
	配置文件 .xprofile

远程桌面控制
	
	xrdp, /usr/bin/dbus-launch

	open ssh 9010

中文环境
	先最简单地按装一款字体，后续再定制美化
	输入法
	旧有硬盘的挂载

滚动升级
	
	使用 sudo pacman -Syy 启动不了了
	升级了 linux 内核包，需要重新 grubmkconfig 生成一下
	如果忘记了，只能重新U盘引导，chroot 再重新升级一下
	需要将这个事情自动化, 不能每次滚动升级都检查一下有没有linux包吧。

genfstab

	这个需要将常挂载的盘都先挂载好，才会自动生成fstab
	之前一直纠结为什么/boot不能自动添加上去

raid磁盘阵列

docker 部署 单网口软路由

samba服务，是否可以做到文件共享，自动备份

图片管理


内网穿透，动态DNS解析
交换机到了就可以尝试了

影音系统

温度监控

日常工具配置
zsh, vim配置

gitlab搭建

自动下载工具

图书馆

