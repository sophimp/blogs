
---
title: Compose 路由框架
date: 2022-10-13 16:21
tags: Compose, Router
categories: Compose
description: 
---

路由对于应用开发, 属于基础设施，是必不可少的。
在Android端，接触的第一个路由还是Arouter, 后面就是各个大厂的路由都开源出来, android 官方推出 jetpack Navigation。
再接着响应式编程热门起来, Flutter 平台比较流行的是GetX, 使用起来确实很舒畅。
而Compose起步晚一些，jetbrains 还没有将Navigation 移植到跨平台，在github 上找到一个开源框架[Tlaster/PreCompose](https://github.com/Tlaster/PreCompose)。
Arouter, GetX 之于我在开发中也仅仅是使用，Navigation 连学都没有学会， 而最近学习 [Tlaster/PreCompose](https://github.com/Tlaster/PreCompose) 也同样困绕着我。
我就很纳闷，是我的学习能力太差了？太笨了？还是学习过程本就是如此？然而在我学会使用某些技术的时候，也能体会到原作者的思想。也能感受到一些奥妙之处。所以，即使不聪明，也可以排队笨的因素。
我觉得还是心态问题，不能静下心来学习。
既然选择Compose来做自己的产品，那么在Compose这个新平台上，硬刚一次学习态度，碰到需要而没有开源的框架，就造轮子，与之前那单途而废的学习带来的自卑感来一一了结。

## 跨平台

Jetpack Compose 只使用于Andoird, 我看好Compose 主要一个因素是其跨平台的能力, 因此不选Jetpack Compose

路由的代码也不好两各自分开写，所以必须找一个可跨平台的方案，实在不行，就自己写一个简易的路由。

## 参考资料

[a-comprehensive-hundred-line-navigation-for-jetpack-desktop-compose](https://proandroiddev.com/a-comprehensive-hundred-line-navigation-for-jetpack-desktop-compose-5b723c4f256e)




