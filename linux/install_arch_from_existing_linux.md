
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
	不退出重启dwm
	修改当前tab的布局 
		不支持， 所有的都是
	将当前应用移到其他桌面 
		win + shift + 数字
	焦点窗口放大，缩小
		win + space
	主窗口与栈窗口互换

	快速启动 

st 使用

	字体, 下载一个monaco, 不能纠结aur 上没有的
	背景, 暂时先使用theiceboy的
	快捷键,

壁纸


pacman 常用命令及技巧

	设计理念

	
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

