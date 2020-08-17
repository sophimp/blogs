---
title: 安装Archlinux
date: 2020-02-19 01:56:22
tags: 
- archlinux
categories: 
- Linux
description: 使用了一段时间gentoo, 太考验机器性能和网速了，移动，铁通，长城这些网络对开发来说是真得不友好， 访问国外的网站速度太慢了，且不稳定，因此，再折腾一下archlinux，有了gentoo的安装基础，archlinux的安装并未起多少波折, 对于所谓的安装启动盘环境理解的更深了。 
---

## 从已在存在的 ubuntu系统中安装archlinux

参考[arch 官方文档Install_Arch_Linux_from_existing_Linux](https://wiki.archlinux.org/index.php/Install_Arch_Linux_from_existing_Linux_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))
这里记录某些步骤注意的一些点. 

1. 下载准备 arch-bootstrap

	[下载地址(清华镜像源)](https://mirrors.tuna.tsinghua.edu.cn/archlinux/iso);
	可以选择其他的镜像源

2. 使用bootstrap 创建chroot

```bash
	# 解压 arch-bootstrap 包, 注意要使用root权限
	cd /tmp
	tar xzf <path-to-arch-bootstrap-image>/archlinux-bootstrap-2020.02.01-x86_64.tar.gz

	# 选择mirrors,(将国内的镜像移到上面)

	# 进入chroot
	# 若安装了 4 或更高版本的bash
	/tmp/root.x86_64/bin/arch-chroot /tmp/root.x86_64

	# 若无(与上面二选一)
	cd /tmp/root.x86_64
    cp /etc/resolv.conf etc
    mount --rbind /proc proc
    mount --rbind /sys sys
    mount --rbind /dev dev
    mount --rbind /run run
	#（假设 /run 存在）
    chroot /tmp/root.x86_64 /bin/bash
```

3. 使用chroot环境 

到这里基本上就与 官方arch install guide 从 U盘引进入chroot前的步骤是一致的, 当然还要确定当前的linux系统是连外网的. 

后面的步骤与install guide 从挂载分区开始， 然后至系统配置。
    
    使用哪种方式进入chroot环境， 还得看有无arch-bootstarp环境， arch-chroot 也就是将底下的命令封装起来了。 

    在进入chroot前，要挂载安装系统的分区， 这里有一个场景， 由于是从ubuntu系统中装archlinux, 装ubuntu时， 也就分了三个分区，/boot, /root, /swap. 现在/root分区(/dev/sda2)， 已经被挂载了， 不能重新挂载在 /mnt 下， 也就进入不了chroot环境 ， 这个时个要怎么办呢?
    我的做法是先将/dev/sda2重新分区， 留出20G的空间， 先装archlinux， 顺便备份一下ubuntu上的资料，（20G不够， 按需分配， 资料太多， 就得另找硬盘备份), 然后再引导进入archlinux, 将/dev/sda2再格式化， 然后将整个archlinux系统拷贝过去， 

5. 装系统

	如果按官网的推荐的pacstrap来装系统， 装grub引导程序的时候， 也得按官方教程走

	如果不按官网的教程走， 在进入chroot环境后， 需要再挂载一次/boot 用于装grub, 因此要再使用 `pacman -S inux Linux-firmware` 再安装一次linux内核， 这样就会在/boot下找到内核相关的三个文件, 然后再安装引导程序. 

安装引导程序

安装配置网络

	配置一下wifi, 有网线的话
 
图形环境 

	显卡配置，总感觉卡卡的， 但是下载又不卡， 这到底是怎么回事。 

	手动配置， lighdm, dwm, st

lighdm

	如何开机启动, 
	提前加载环境变量，在xprofile下配置， 语法与 .xinitrc 一样

字体，本地化
	
	如何在中文和英文的环境下更加高效，不可能只用中文或只用英文， 两种文化都不能放弃。 


工具学习 

	dwm, st, vim 基本配置，插件. vim不能太依赖插件， 一切小trick 主要还是靠自身脚本就可以实现

	snippets, 

dw 使用

	如何操控， 定制自己的一套习惯。 
	theiceboy修改的快捷键

	win键替换了原来的alt键，修改了statusbar方向

	窗口跳转 
		win+e/u
	不退出刷新dww
		这个是编译生成新，能实现不关闭已打开的窗口，应用新的dwm吗？ 
	修改当前tab的布局 
		不支持， 所有的都是
	将当前应用移到其他桌面 
		win + shift + 数字
	焦点窗口放大，缩小
		win + space
	主窗口与栈窗口互换
		没找到此功能， 只找到向master 加减窗口的

	快速启动 

st 使用

	字体, 下载一个monaco, 不能纠结aur 上没有的
	背景, 暂时先使用theiceboy的
	快捷键,

kde桌面使用

	没心思折腾dwm, st 了， 电脑的性能有， 桌面环境也省心， 主要是连续折腾， 工作进度受影响了。 
	所以， 还是换一个kde, 省点心吧。 但是发现， 安装kde也并不省心。  
	
```sh
	sudo pacman -S plasma kdebase  # 只包含kde 的基础包
	sudo pacman -S xf86-input-libinput xf86-input-synaptics xf86-video-intel xf86-video-vesa  #这些也必须安，驱动键盘鼠标， 触摸板， 否则进入桌面驱动不了
	sudo pacman -S lightdm lightdm-gte-greeter # 加一个启动登陆， 不用每次都startx
```
	网络连接也出问题了， 在arhcwiki 上学一学 iw, wpa_supplicant 的使用，解决无线网络连接的问题, 无线要选扫描， 使用root用户连接。 

	输入法怎么也不能切换了呢？ 重新安装fcitx, fcitx-im, kcm-fcitx, 重启系统， 输入法可用。  可以通过fcitx-dignose 诊断当前环境哪里出错了，所有的包，配置都安装好， 工作还不能正常， 重启系统试试 。 或重启KDE, 

	![打造五笔单字词库](../linux/fcitx-wubi-setting.md)。 输入环境终于打造好了。 

	konsole 配置, 也是摸索了一翻。 
	
	lightdm 的配置, 要配置 greeter-seession 和 session-wrapper， 再加入开机启动

网络连接

	路由有线连接， 只需开机启动dhcpcd即可

	无线连接， 需学会使用 ip iw， wpa 工具

	搜索wifi, 连接wifi，修改静态ip, mask

	端口转发
	开启wifi热点

	官方教程是使用 networkmanager, 先按这个走一遍
	nm-connection-editor, 图形界面
	network-manager-applet, 提供系统拖盘

```sh

	# 安装 networkmanager, nm-connection-editor, network-manager-applet

	# 添加daemon, 启动NetworkManager
	systemctl enable NetworkManager
	systemctl start NetworkManager

	# 显示附近的 wifi:
	nmcli device wifi list

	# 连接 wifi:
	nmcli device wifi connect SSID password password

	#连接到隐藏的 wifi:
	nmcli device wifi connect SSID password password hidden yes

	#通过 wlan1 wifi 网卡(interface)连接 wifi:
	nmcli device wifi connect SSID password password ifname wlan1 profile_name

	#断开一个网卡(interface)上的连接:
	nmcli device disconnect ifname eth0

	#重新连接一个被标记为“已断开”的网卡：
	nmcli connection up uuid UUID

	#显示一个所有连接过的网络的UUID的列表:
	nmcli connection show

	# 查看所有网络设备及其状态:
	nmcli device

	#关掉 wifi:
	nmcli radio wifi off

```

使用 iw, iwconfig, wpa_supplicant 来管理，连接wifi

```sh
	# 查看当前服务状态

	wpa_passphrase <MYSSID> <passphrase> > wpa_supplication.conf
	wpa_supplicant -B -i <interface(wlan0)> -C wpa_supplication.conf

	ip link
	ip link set <interface> up|down

	iw dev wlan0 scan

	ip address show
	ip address add <address/prefix_len> <broadcast> dev <interface>
	ip address del <address/prefix_len> dev <interface>

```

添加同步源

/etc/pacman.conf
	pacman的主同步源， 可以添定自定义的server, 本地server

```cfg
[archlinuxcn]
SigLevel = Optional TrustAll
Server = http or ftp
```

/etc/pacman.d/mirrors

	core, extra, community 同步源的配置文件, 选择China下的镜像，取消注释, 
	一般选 清华(tuna.tsinghua), 中科大(ustc), 上海交大(sjtug.sjtu), 浙大(zju)
	网易(163) 阿里(aliyun) 的都是http的， 现在已经不建议使用了

/etc/makepkg.conf

	makepkg 的配置文件， 使用makepkg 进行源码安装， 替代make, 安装完的包可同步到 pacman 统一管理

yay

	yay 替代了 yaourt
	安装yay, 先得在/etc/pacman.conf 中配置 archlinuxcn源， 否则还找不到

```cfg
[archlinuxcn]
SigLevel = Optional TrustAll
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch
```

	添加 aur 源
	yay --aururl "https://aur.tuna.tsinghua.edu.cn"

pacman 常用命令及技巧

	设计理念

```sh
	pacman -Qs fuzzy-package-name #查找已安装

	pacman -Ss fuzzy-package-name #查找软件包
```

	
## 总结

从已存在的linux系统中安装archlinux, 可见linux的自由与灵活, 也可发现linux各发行版本在本质上都是通的, 只是对系统环境的选择(内核配置, 应用软件, 应用仓库, 包管理器等等) 所定位的目标人群不一样, 因此衍发出各自的哲学. 

看这种技巧性的教程， 还是看视频效率高些， 至少是先知道怎么用， 先用起来， 后面再研究， 更高效一些。 知道需求和原理， 再思考实现思路就更容易一些。 

学习每一个工具的使用， 也要时间成本，然后，真正了解掌握操作系统的每一个环节，本身就是一件很有成就的事情。 

这个文档一遍还完不成，得再折腾几遍安装才行。 昨天折腾一天的， 今天再复盘就不行了 2020年 02月 20日 星期四 14:06:22 CST

分盘这里， 确实要先备份数据，数据无价。 

折腾系统的过程， 也是逐步完善能用电脑做什么的过程, 是要先熟悉系统都包括什么，然后才能更好的利用。将日常使用的流程丰富起来， 做更多的事， 同时不断优化， 自动化，能力越来越大， 责任越来越大。 这本就是人活着的意义? 

也许不该将精力放在这上面？ 
安装一个桌面系统先用着，将更多的注意力放在vim, 开发技能的学习上？ 
事情也不是这样的，学习也并不是一定都是为了有用，而是因为喜欢， 因为开心。 折腾这些玩意， 在面试的时候确实不能加分， 但是抵不住我在用操作系统的时候，心里有底气。
这个事情还是得折腾，就不能完全交给dm来搞定， 亲力亲为达到心中有数，后面再拿来开箱即用. 
时区，locale, 语言， 网络， 软件管理，自动小脚本， 这些不是一朝一夕完成的， 是这两天我太心急了，在工作时间搞这些，搞不定就要耽误工作， 耽误计划了。 
目前目的基本达到了， 先回到正轨，系统再慢慢调教，必须得调教。 各方面都调教， 达到心意合一。 

将家里的gentoo也换arch了， 后面换了配置高点的主机， 再折腾gentoo, 网络慢， 编译慢， 搞gentoo是有些伤不起，其实这样看来，arch已经能满足目前的需求了， 看源码嘛，再另下 载关联起来也不是多大个事。没有必要， 也没有精力还去研究每个工具。大多数工具， 开箱即使， 操作系统， 本来也就是个工具。 

