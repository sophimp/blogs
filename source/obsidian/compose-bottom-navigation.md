---
title: compose-BottomNavigation
date: 2022-09-09 17:00 
tags:
- Compose
- BottomNavigation
categories:
- JetpackCompose
description: material compose BottomNavigation, 底部导航栏
---

## BottomNavigation

底部页面导航栏

我的需求：

	选中突出
	动态布局
	切换过渡动画
	信息Badge

官方库够用了

## 使用

Compose 如何动态布局

LiveData 里如何使用@Composable
添加 runtime-livedata 库

compose-compiler, 配置 composeOptions

编译报错:

1. void org.jetbrains.kotlin.gradle.dsl.KotlinJvmOptions.setUseIR(boolean)
版本不匹配, AS, gradle-plugin, compose, compose-compiler, kotlin 都更新到当前稳定版本

```kotlin
composeOptions {
	kotlinCompilerExtensionVersion = "1.3.0"
}
kapt("")
```



