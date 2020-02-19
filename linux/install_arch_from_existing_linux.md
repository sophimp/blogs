
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

4. 挂载分区

    
5. 这才叫做编辑器嘛


## 总结

从已存在的linux系统中安装archlinux, 可见linux的自由与灵活, 也可发现linux各发行版本在本质上都是通的, 只是对系统环境的选择(内核配置, 应用软件, 应用仓库, 包管理器等等) 所定位的目标人群不一样, 因此衍发出各自的哲学. 

看这种技巧性的教程， 还是看视频效率高些， 至少是先知道怎么用， 也能确定用起来， 后面再研究， 就更快一些。 知道需求和原理， 再思考实现思路就更容易一些。 



