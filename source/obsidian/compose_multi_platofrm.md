---
title: compose multi platform
date: 2021-09-20 16:52 
tags:
- Compose 
- Multi-platform
categories:
- Compose 

description: Compose 跨平台，有公司应用了吗？ 我要做第一个吃螃蟹的人吗？
---

## 背景
jetpack compose 与 compose-jb
不是一个团队
jetpack compose 是google 领先, 主要支持android开发，
compose-jb 

## 想法

如果再选择 compose multi platform 来开发， desktop的进度肯定很慢，所以还是可以先在 idea里将 android的开发完

还是需要一次性到位，现在不痛苦一点，后面会更痛苦，搞desktop得痛苦也不过是前面的工程配置进度慢一点，然后公共库少一些

大不了都自己造轮子，或者不用框架，已经有人用compose desktop做出来应用了，所以，技术上应该是可以实现的

## SlotTable

核心还是SlotTable存储数据

jvm 还是非常有必要的，做一些二维的工具页面是足够了, 所以，这肯定是一个趋势, 
不管如何，至少是能解决我现在的问题的, 一人精力有限，还是需要编写同一套代码，多端同时运行的能力

性能的瓶颈就在SlotTable 的Diff 上，频繁的话，就会卡

## gradle 脚本配置

## kmp
kotlin multi platofrm 

kotliin 本身也有跨平台的库，语法还有所不一样

## 可用库

现在还只是做一些toolbox的工具应用吗？



