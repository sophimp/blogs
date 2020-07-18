---
title: Hexo + github + gitpage 搭建blog
date: 2020-07-18 23:47:43
tags: 搭建
description: hexo + github + gitpage 搭建个人博客， 想法的记录， 思考过程的展现， 以及配置的展示。 
---

## 使用 Hexo + github + gitpage 搭建博客

一直以为gitpage 很麻烦， 真正搞出来了才发现并不是很麻烦， 想想也是， 博客系统而已, 能有多麻烦呢？ 打开gitpage 服务而已。

gitpage 用来搭建blog是个不错的选择，官方也支持的。 

具体的教程网上很多了， 这里将我参考的到教程写出来。 

next 5.0 与 next 6.0 + 差别已经有了， 至少没了 `source/css/custom/` 文件夹了。 但是大部分还是可以参考的， 我可以将这部分差异记录下来。 写此博客使用的版本是 next 7.8.0版本

在hexo 官方文档上，trival 是不必须的。手动部署也不是多大个事。 

### hexo安装

首先参考 [github 项目readme](https://github.com/next-theme/hexo-theme-next)	安装好 hexo 环境. 

这里我采用了博客源文件与部署文件分两个仓库的， 没有选用两个分支。 

### next 配置
主要几个选择因素:

1. 不能搞得太花哩胡哨的， 因为github 的访问速度毕竟还是慢一些。但是js 动态特效还好， 文件并不是多大。
2. 整体的界面保持简洁， 保持影响阅读体验的良好。

决策:

布局， 习惯将目标及个人信息放在左边
背景加了动态效果

新版的 excerpt 配置， 需要填写 description 字段
