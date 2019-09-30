
## gentoo

刚好最近搞android 系统，对于内核编译一知半解， bootloader, grub, fstab, 这些都重新再学习一遍， 所以， 搞一搞gentoo, 一是巩固， 而是为mokee 移植， 打下基础.

安装gentoo 的感觉: linux就是一个文件系统, 有了内核, 安装了正确的驱动, U盘里的系统也是可以玩的. 这就需要grub 来负责引导加载, 或通过BIOS 来控制. 

到了这一步, 系统安装的思路就清晰了, 既然, 也可以直接从U盘加载系统, 那就说明, 只要相应的文件结构存在, 那么这个系统就是可以运行的. 

所以, 一个系统启动盘, 就是一个简易的可运行的操作系统环境, 先通过加载这个系统, 然后操作磁盘, 安装一个新的系统环境到磁盘里, 然后再从磁盘启动就OK了, 所以, 当然也可以从本地磁盘中去安装系统, 一个磁盘, 当然也可以存在多个系统. 

winpe是如此, recovery 是如此, gentoo 的最简单U盘镜像也是如此. 

先将磁盘分区格式化, 然后挂载, chroot, 这可能就是在当前的系统环境下, 临时增加一个新的用户, 不仅仅是新用户这么简单, 连安装文件, 新的系统环境也变成了新的挂载点. 具体的技术细节, 还有待学习. 

后续的安装过程: 安装/替换内核, 生成 ram 文件系统. 安装系统工具及软件, 继续完善系统环境. 


## 具体流程:


## abstract

portage 

并不是移植的意思， 是一个软件包管理系统, 使用 emerge software-name 安装

ebuild 脚本, portage 可执行脚本， 用来安装软件包

USE 配置, portage 安装软件的配配置

stage3

OpenRC, systemd
[OpenRC](https://wiki.gentoo.org/wiki/OpenRC)

OpenRC 是一个基于依赖项的 init 系统，它维护与提供系统兼容的init 程序，通常位于 /sbin/init 中。它不作为 /sbin/init 文件的替换。OpenRC 与 Gentoo init 脚本 100% 兼容，这意味着可以找到一种解决方案来运行主 Gentoo 存储库中的数十个守护进程。然而，OpenRC 并非设计为由 Gentoo Linux 专用使用，可用于其他发行版和 BSD 系统。

cgroups 支持, 进程管理, 并行启动服务, 硬件启动脚本运行. 

[systemd](https://wiki.gentoo.org/wiki/Systemd)

systemd 是一种现代的 SysV 风格的 init 和 rc 替代 Linux 系统。它在 Gentoo 中作为替代 init 系统支持。


