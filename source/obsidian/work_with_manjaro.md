
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

- 开发工具

git, vim, zsh 已经自带

tmux 配置找不到了

idea ultimate 可用破解

android-sdk, openjdk


洛雪音乐软件
好像这些也够开发用了

[wiki openvpn](https://wiki.archlinux.org/title/OpenVPN_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)#%E5%90%AF%E5%8A%A8_OpenVPN)

首先，安装 networkmanager-openvpn。 
然后，go to the Settings menu and choose Network. Click the plus sign to add a new connection and choose VPN. From there you can choose OpenVPN and manually enter the settings, or you can choose to import the client configuration file if you have already created one. If you followed the instructions in this article then it will be located at /etc/openvpn/client.conf. To connect to the VPN simply turn the connection on.

