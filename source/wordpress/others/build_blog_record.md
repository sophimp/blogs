
---
title: 博客的折腾记录 (不定时更新)
date: 2022-12-19 20:38
uuid: 448
status: publish
tags: Blog
categories: 折腾
description: 
---

# 博客的折腾记录

> 文字是永不过时的表达方式，blog无疑是一个自由的窗口。
> 很多人基本的表达能力都是不过关的，写blog无疑是一个不错的练习途径。
> 各平台的限制太多，自己的博客自由度相对要高很多。

## 搭建

具体的搭建教程我不再写了，网上有很多比较好的教程, 这里就记录下我在折腾过程中的一些思考与关键点吧。

折腾了hexo, hugo, 最终还是选择了wordpress。

主要考虑点: 

成熟，资料多，
对blog而言，性能足够
提供了 api, 结合[markdown 发布到wordpress脚本](https://github.com/skywind3000/markpress) 可以不登陆wordpress发表文章， 工作流挺流畅的
博客的核心是文章，以markdown的格式记录，后续即使有需求迁移到其他的平台, 迁移成本也很低。

服务器，域名，linux操作，器docker, docker-compose, nginx, mysql, wordpress 搭建这些技能的学习与搭建到可访问的过程暂且不表。
后续有时间再慢慢填。

服务器是选择了海外的腾讯云，域名也是在腾讯云上申请的

需要的技能，docker玩法, nginx配置，ssl证书，wordpress 搭建

- 版块设计

相比于基本的博客搭建，更难的是版块的设计与持续的输出。
前期没有其他想法的时候，就先选一个自己认可的博主照抄。我这里选择[Bense](https://blognas.hwb0307.com/)的

主题选 argon, 评论是自带的

基本的版块：

	主页， 关于， 友人链接, 留言板，历史归档，技术，随笔，教育

	学习地图，后续如果教程多的话，可以考虑搭建一个文档式的
	右边的导航栏

## 证书

使用acme.sh 工具， 这个工具很强大， [github 开源](https://github.com/acmesh-official/acme.sh), 而且集成了主流的云厂商

acme.sh 的安装参考官方 README

acme.sh 生成证书， 放到一个公共的目录, nginx.conf 再引用配置
这样的好处是不会污染默认配置

由于我的nginx是root启动， 如果带上 `--nginx` 参数来自动识别nginx配置，就必须使用 sudo, 
acme.sh 不推荐使用root权限, 非要使用 可加上 `--force` 参数,

但是想要签名泛域名，还是需要手动来配置nginx, 使用 `--nginx` 自动添加，并不能自动添加泛域名

使用 acme.sh 添加泛域名有手动与自动的方式，可参考
我这里使用的自动的方式 使用腾讯云的api, [acme.sh How to use DNS API](https://github.com/acmesh-official/acme.sh/wiki/dnsapi#dns_dp)

> tips: 
>	1. 泛域名的申请可以不必使用root权限
>	2. 主要步骤: 配置 DP_Id, DP_Key, 然后 带上 `--dns dns_dp` 即可
>	3. zsh 写通配符域名要加上 引号, 不然识别不了
>	4. acme.sh 识别不了命令，需要alias 到acme.sh 安装目录


```sh
# 生成证书
acme.sh --issue --dns dns_dp -d "your_domain.com" -d "*.your_domain.com"

# 安装证书
acme.sh --install-cert -d "example.com" --key-file /your_public_path/your_domain.com.key --fullchain-file /your_ssl_intall_path/your_domain.com.fullchain.cer
```

然后再nginx中配置 ssl 路径时引用 上面安装的 your_ssl_install_path

自动刷新证书:
命令是将生成证书的命令 `--issue` 换成 `--renew` 即可
每月一号自动刷新一次
```crontab
0 0 1 * * acme.sh --issue --dns dns_dp -d "your_domain.com" -d "*.your_domain.com"
```

http 自动跳转 https:
```conf
	return      301 https://$server_name$request_uri;      # 这是nginx最新支持的写法
```

## 访问统计监控

umami

## 美化

慢慢完善，加一个群里，瞄两眼的时候，有时间就试试。

## 备份

自动化是首要需求
便于迁移， 专业不是搞这个的，因此不想在这些基本的技能上浪费太多的时间。

