
## 概念

整个 portage 用python写的

portage

	是一个架构，gentoo的工作就是通过portage来完成的， 用来配置，安装, 管理应用

ebuild 

	仓库的配置文件

repository 

	本地的源码仓库

## 如何滚动更新

```sh
# 更新软件仓库
emerge --sync # 调用 rsync 增量更新

emerge-webrsync # 使用web请求方式更新， 针对防火墙阻止了rsync更新的方式

# 更新 portage树
emerge --update --deep --with-bdeps=y --newuse --ask @world

```

## 安装软件

1. 正常安装

2. mask

3. unmask

4. 安装稳定版本

5. 安装 binary 版本

6. 日志查看

7. 进程查看

8. 网络查看


## portage

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



