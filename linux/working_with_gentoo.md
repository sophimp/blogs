
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


## 复盘

Mon Feb 10 10:10:17 CST 2020

搞gentoo持续的周期, 从2019.9.10 开始, 刚好5个月了. 最开始由移植nx611j 开始起念头, 也不过是5个月, 至少gentoo现在是可以使用了. 结果看上去也没那么糟.

最开始想学gentoo, 是对linux有一个更好的了解, 继而对移植android 更加得心应手, 最好发现远远没有那么简单. 

就像最开始学习网络一样, 学得做黑客, 学习网络是必不可少的, 其实实际应用中, 也不过是对路由器的简单配置, vpn 的配置. 现在多了一些网络相关的开发.  黑客的成长之路, 网络仅仅一段. 

现在想对gentoo的学习做一个复盘, 到目前为止, 知识点还是散的, gentoo的下一步学习, 也停滞了三个月了, 这样一算, 真正用来学习gentoo的时间, 也不过是2个月. 但是因为学习gentoo而分心学习其他的知识也是必不可少的. 最根本的原因, 我的基础太薄弱了, 要补的东西太多了. 


