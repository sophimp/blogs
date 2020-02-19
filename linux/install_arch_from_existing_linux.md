
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

	后面的步骤也与install guide 进入chroot后面的步骤大致一致, 只是对于debian系统在安装时可能会出现的以下错误(直接复制文档):

	/dev/shm
```bash
	pacstrap /mnt base
	# ==> Creating install root at /mnt
	# mount: mount point /mnt/dev/shm is a symbolic link to nowhere
	# ==> ERROR: failed to setup API filesystems in new root
	#	Debian 中，/dev/shm 指向 /run/shm。而在基于 Arch 的 chroot 中，/run/shm 并不存在，因而链接失效。创建 /run/shm 目录可修复此错误：
	mkdir /run/shm
```

	/dev/pts

```sh
	# While installing archlinux-2015.07.01-x86_64 from a Debian 7 host, the following error prevented both pacstrap and arch-chroot from working:
	
	pacstrap -i /mnt
	#mount: mount point /mnt/dev/pts does not exist
	#==> ERROR: failed to setup chroot /mnt
	#Apparently, this is because these two scripts use a common function. chroot_setup()[1] relies on newer features of util-linux, which are incompatible with Debian 7 userland (see FS#45737).
	#The solution for pacstrap is to manually execute its various tasks, but use the regular procedure to mount the kernel filesystems on the target directory ("$newroot"):
	
	# newroot=/mnt
	mkdir -m 0755 -p "$newroot"/var/{cache/pacman/pkg,lib/pacman,log} "$newroot"/{dev,run,etc}
	mkdir -m 1777 -p "$newroot"/tmp
	mkdir -m 0555 -p "$newroot"/{sys,proc}
	mount -t proc /proc "$newroot/proc"
	mount --rbind /sys "$newroot/sys"
	mount --rbind /run "$newroot/run"
	mount --rbind /dev "$newroot/dev"
	pacman -r "$newroot" --cachedir="$newroot/var/cache/pacman/pkg" -Sy base base-devel ... ## add the packages you want
	cp -a /etc/pacman.d/gnupg "$newroot/etc/pacman.d/"       ## copy keyring
	cp -a /etc/pacman.d/mirrorlist "$newroot/etc/pacman.d/"  ## copy mirrorlist

```

## 总结

从已存在的linux系统中安装archlinux, 可见linux的自由与灵活, 也可发现linux各发行版本在本质上都是通的, 只是对系统环境的选择(内核配置, 应用软件, 应用仓库, 包管理器等等) 所定位的目标人群不一样, 因此衍发出各自的哲学. 


