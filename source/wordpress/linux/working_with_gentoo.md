---
title: gentoo使用记录
uuid: 309
status: publish
date: 2019-11-29 07:19:45
tags: Gentoo, Linux
categories: Linux
description: gentoo使用了2个多月， 更新再编译实在等不了，不过这一折腾过程是有收益的，以后有机会肯定会再玩一玩， 然后现在更重要的是提升生存技能。 
---

## 概念

整个 portage 用python写的

portage

	是一个架构，gentoo的工作就是通过portage来完成的， 用来配置，安装, 管理应用

	1. configuration directives

	全局的默认的配置			/usr/share/portage/config/make.globals
	不同架构的默认配置文件指向  /etc/portage/make.profile
	用户定制的配置文件			/etc/portage/make.conf 这个文件会覆盖上面两个默认配置， 配置的示例在 /usr/share/portage/config/make.conf.example
	系统存放的profile路径		/var/db/repos/gentoo, 

	2. 用户配置 

	在/etc/portage 中修改配置文件， 不鼓励直接覆盖环境变量

	用户可创建的文件/文件夹
	* package.mask
		portage永不安装的应用
	* package.umask
		gentoo 开发者非常不建议安装(默认mask)的软件， 可以通过这里打开
	* package.accpet_keywords
		不适合当前系统架构的应用可以通过此配置强制安装
	* package.use 
		为每个应用配置特定的 use flags, 而不影响其他应用

ebuild

	是用来管理所有应用的版本信息的， 对应有一个仓库， 同步的软件源为 gentoo-portage

gentoo
	
	自身有一个软件源，GENTOO_MIRRORS, 这个是用来下载什么的呢？ 应用是从gentoo, gentoo-portage 哪个镜像里下载呢？ 

## 任务列表

1. 正常安装

	emerge --search 搜索

	emerge -av 安装

	可以临时带USE, 也可以全局配置. 在/etc/portage/mask(unmask)

2. mask, unmask

	屏蔽/不屏蔽 特定的版本

3. 安装稳定版本

	根据make.conf中的 ACCEPT_KEYWORDS 来判断的, ACCEPT_KEYWORDS="amd64"是稳定版本, ACCEPT_KEYWORDS="~amd64", 是测试版本

4. 安装 binary 版本

5. 日志查看

6. 进程查看

	ps -ano, 查看所有运行进程

7. 网络查看
	
	ping, route, netstat

8. 将ntfs 格式化成ext4, 并将两个分区合并

	ntfs 直接使用 mkfs.ext4 /dev/sdb6 来格式化， 倒时可以格式化成功， 但是使用fdisk -l 查看的时候， 还是显示的 ntfs格式。 但是可以使用ext4挂载上， 可以创建文件。 
	显示ntfs信息是因为 sdb的索引问题吗？ 实际删除sdb就可以了？ 

	使用fdisk来分区
	fdisk -u /dev/sdb, 可以查看sdb下的所有分区。这样一来， /dev/sdb就不可以再重写了， 那么就会一直有 /dev/sdb1 W95 Ext'd (LBA) 的分区提示，可不可以删除sdb1呢？ 应该是可以的， 因为操作的是/dev/sdb

	然后就好办了， 可以查看到/dev/sdb下的所有分区， 就直接按命令来操作， d, 删除，n 创建，w 保存， 然后再mkfs.ext4 /dev/sdb6格式化。 

9. 滚动更新

```sh
# 更新软件仓库
emerge --sync # 调用 rsync 增量更新

emerge-webrsync # 使用web请求方式更新， 针对防火墙阻止了rsync更新的方式

配置镜像
在/etc/portage/make.conf 中GENTOO_MIRRORS
在/etc/portage/repos.conf/gentoo.conf 中配置 sync-uri=

清华的镜像也是慢， 换成科大的， 貌似好点，就差点因为这个， 要换archlinux了， 网速实现太慢， 没法玩。 

# 更新 portage树
emerge --update --deep --with-bdeps=y --newuse --ask @world

```
	emerge --sync 在换了镜像源后， 之前的sync不起作用？ 为何在emerge --sync 已经sync后， 再update 还是不行呢？ 这样的表现推测原因是换了源，清空之前的同步？ 还是因为太久没有同步了。 
	已经 emerge --sync 三次了。 

10.
 
11. 

## 复盘

Mon Feb 10 10:10:17 CST 2020

	搞gentoo持续的周期, 从2019.9.10 开始, 刚好5个月了. 最开始由移植nx611j 开始起念头, 也不过是5个月, 至少gentoo现在是可以使用了. 结果看上去也没那么糟.

	最开始想学gentoo, 是对linux有一个更好的了解, 继而对移植android 更加得心应手, 最好发现远远没有那么简单. 

	就像最开始学习网络一样, 学得做黑客, 学习网络是必不可少的, 其实实际应用中, 也不过是对路由器的简单配置, vpn 的配置. 现在多了一些网络相关的开发.  黑客的成长之路, 网络仅仅一段. 

	现在想对gentoo的学习做一个复盘, 到目前为止, 知识点还是散的, gentoo的下一步学习, 也停滞了三个月了, 这样一算, 真正用来学习gentoo的时间, 也不过是2个月. 但是因为学习gentoo而分心学习其他的知识也是必不可少的. 最根本的原因, 我的基础太薄弱了, 要补的东西太多了. 

Sat 15 Feb 2020 10:57:10 PM CST

	好险因为网络问题，抛弃gentoo, 去折腾archlinux 了， 但是打开archlinux 同样也是很慢， 下载也很慢. 编译可以忍受， 网络慢是真受不了， 网络慢不可控， 经常会失败。 
	怎么就忘记了镜像了呢？
	gentoo 下载有一个镜像， 是在make.conf 中配置 GENTOO_MIRRORS, 
	gentoo-portage同样有一个镜像, 是在 /etc/portage/repos.conf/gentoo.conf 中配置 sync-uri

	今天滚动升级， 距离上次升级已经过了119天了。这段时间学习 apue, 疫情，春节，是有很多天没碰电脑了， 昨天立了一个目标，先坚持一个月， 不再碰娱乐的项目：刷剧，刷直播，刷知乎，刷八卦， 玩游戏。
	今天已经坚持一天了，这种感觉也体会过， 时间变多了， 一天的时间变长了， 干活不拖拉了， 也还有时间学会习， 思考了。 这是一个好的开始。 
	一天的时间， 令人烦燥的时间点太多了， 过一会就会变得无所适从， 不知道下一步该干些什么了。 也是没谁了。 

	gentoo的环境目前也算是可以用了， 接下来继续配置一下开发环境。 边开发边折腾吧。 现在直接折腾awesome，目标太不明确， 效率太低，基本的使用套路已经清楚。 就以配置开发环境来建任务列表。 
	不管是使用体验上的， 还是开发必须的环境。 任务名称都记录下来， 致于实现与否， 看优先级。 


