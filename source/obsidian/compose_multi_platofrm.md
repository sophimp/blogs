---
title: compose multi platform - 开篇
date: 2021-09-20 16:52 
tags: Compose, 跨平台
categories: Compose 

description: 
---

## 背景
Compose 跨平台，有公司应用了吗？ 我要做第一个吃螃蟹的人吗？
jetpack compose 与 compose-jb
不是一个团队
jetpack compose 是google 领先, 主要支持android开发，
compose-jb 是由 Jetbrains 公司主导，google compose android 团队支持，社区驱动。

## 为什么选compose multi platform

到目前为止flutter 开发过一款产品，flutter 确实很好用，就语言部分，kotlin 可能语法糖多一些，但是 dart 语言，凭心而论，写起来也很舒畅。
而且flutter 先发势, pub.dev 上也有很多现成的库，全新的应用，使用flutter 开发，确实可以很快跨平台满足交付。

那为什么还选择 compose 呢？

1. 生态

上面虽然pub.dev 有很多现成的库，但是很多也是依赖于原生做的桥接。与原生平台能力交互的工作，所有的跨平台都需要学习原生平台的开发。
但是原生平台能力相关的库，还是kotlin 的生态要足一些，因为兼容java库, kmp 的跨平台也是比 flutter 要做的工作少得多。

2. 这次我想当先驱者

在有限的工作生涯里，学习什么技术都是奔着工作，热门去的。开发使用的都是第三方库。这次我想按自己的想法走, 虽然compose UI相关的控件还不丰富, 但是我想做回先驱者，造自己的轮子。

compose 目前对iOS的适配可能工作量要多一些，但是我前期的目标人群恰恰是PC端与Android端

如果再选择 compose multi platform 来开发， desktop的进度肯定很慢，所以还是可以先在 idea里将 android的开发完

还是需要一次性到位，现在不痛苦一点，后面会更痛苦，搞desktop得痛苦也不过是前面的工程配置进度慢一点，然后公共库少一些

大不了都自己造轮子，或者不用框架，已经有人用compose desktop做出来应用了，所以，技术上应该是可以实现的

## 该怎么去学

以项目驱动，先复刻一个图床应用？

通读文档？这个效率还是太低

## SlotTable

核心还是SlotTable存储数据

jvm 还是非常有必要的，做一些二维的工具页面是足够了, 所以，这肯定是一个趋势, 
不管如何，至少是能解决我现在的问题的, 一人精力有限，还是需要编写同一套代码，多端同时运行的能力

性能的瓶颈就在SlotTable 的Diff 上，频繁的话，就会卡

## gradle 脚本配置

gradle 的配置，也是各种迷糊

## kmp
kotlin multi platofrm 

kotliin 本身也有跨平台的库，语法还有所不一样

## 可用库

现在还只是做一些toolbox的工具应用吗？不是，可以做出来很复杂的应用了
TwidereX

## 如何发布第三方库
