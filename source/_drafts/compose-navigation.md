---
title: compose-Navigation
date: 2022-09-09 17:00 
tags:
- Compose
- Navigation
categories:
- Compose

description: 导航库, 也是路由库，跨平台, 不能使用官方的库
---

## Navigation

路由功能，与底部导航功能还是有所区别

Router 需求：
	
	状态保存
	栈操作
	过场动画

底部导航需求：

	选中突出
	动态布局
	切换过渡动画
	信息Badge

技术选择

	放弃Decompose, 使用PreCompose, Moelcule 更合口味

	ViewModel 是如何保证作用域的？ 绑定作用域？



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



