
---
title: 博客的折腾记录
date: 2022-12-19 20:38
tags: 
categories: 
description: 
---

# 博客的折腾记录

文字是永不过时的表达方式，blog无疑是一个很好的窗口。
很多人基本的表达能力都是不过关的，写blog无疑是一个不错的途径。
各平台的限制太多，自己的博客自由度相对要高很多。

什么是废话，什么又是有用的话，说话的逻辑
## 搭建

具体的搭建教程我不再写了，网上有很多比较好的教程, 这里就记录下我在折腾过程中的一些思考与关键点吧。

折腾了hexo, hugo, 最终还是选择了wordpress。

博客的核心是文章，以markdown的格式记录，迁移到其他的平台成本都不高。

服务器，域名，linux操作，器docker, docker-compose, nginx, mysql, wordpress 搭建这些技能的学习与搭建到可访问的过程暂且不表。
后续有时间再慢慢填。

框架与体系知识，docker 与 非docker的应用配合, docker NPM, certbot

- 版块设计

相比于基本的博客搭建，更难的是版块的设计与持续的输出。
前期没有其他想法的时候，就先选一个自己认可的博主照抄。我这里选择[Bense](https://blognas.hwb0307.com/)的

主题选 argon, 评论是自带的

基本的版块：

	主页， 关于， 友人链接, 留言板，历史归档，技术，随笔，教育

	学习地图，后续如果教程多的话，可以考虑搭建一个文档式的
	右边的导航栏

## 证书

```sh
certbot 
crontab -e 
restart docker
```
泛域名: acme.sh [Letsencrypt 泛域名 SSL 证书免费申请](https://cloud.tencent.com/developer/article/2142931?from=15425&areaSource=102001.1&traceId=yoy4ZbewZHqjxBZrxbUgm)

acme.sh 生成证书， 放到一个公共的目录
nginx.conf 再引用配置

acme.sh 存在sudo , --force
不推荐使用sudo, root确实会有不少问题
也没有自动添加crontab, 添加到非root用户上了
泛域名的没有签名成功

```sh
# 生成证书
acme.sh --issue -d "example.com" --nginx --force
# 安装证书
acme.sh --install-cert -d "example.com" --key-file /home/ubuntu/ssl/example.com.key.pem --fullchain-file /home/ubuntu/ssl/example.com.cert.pem
```

自动刷新证书: 
```crontab
0 0 1 * * /home/ubuntu/.acme.sh/acme.sh --renew -d "example.com" -d "*.example.com" --yes-I-know-dns-manual-mode-enough-go-ahead-please --force
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

