
## linux 操作与运维系列 

玩 homelab 

linux 相关的安全，比较热门的工具，服务配置，相关的肯定要经常搞起来，趁机记录起来，也便于后续查看

记录一些与linux 自带工具相关的

## 关于各linux发行版

也接触过不少，gentoo, archlinux, ubuntu, centos, Deepin

主要是生态的差异，核心还是思想，跟内核相关基本是通用的。

这里主要记录跟系统相关的知识

## 操作系统相关的各个操作

- 文件系统

- 内存管理

- 服务管理

- 进程管理

- corn 进程

- grub

- 安全

ssh 

	日志查看 /var/log/auth.log
	修改默认端口, 腾讯云同样需要开放
	防止暴力破解, 屏蔽IP, fail2ban
	禁止root登录
	修改登录名
	防火墙配置, 暂时不用配置
	谢盖默认端口，使用fail2ban 就可以屏蔽大多数的攻击了。

- dm, wm 

- terminal

zsh 配置

```sh
	sudo apt-get install zsh-autosuggestions zsh-syntax-highlighting zsh-theme-powerlevel9k
	source /usr/share/powerlevel9k/powerlevel9k.zsh-theme
	source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
	source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
```

