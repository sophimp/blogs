---
title: Jetpack - Lifecycle
date: 2021-01-08 15:05:45
tags:
- Jetpack
- Lifecycle
categories:
- Android
description: Lifecycle 是一个生命周期感知组件， 可执行操作来响应另一个组件的生命周期状态的变化。
---

### 介绍
[官方文档](https://developer.android.com/topic/libraries/architecture/lifecycle)
[版本信息](https://developer.android.com/jetpack/androidx/releases/lifecycle)
```gradle
dependencies {
    def lifecycle_version = "2.2.0"
    def arch_version = "2.1.0"

    // ViewModel
    implementation "androidx.lifecycle:lifecycle-viewmodel-ktx:$lifecycle_version"
    // LiveData
    implementation "androidx.lifecycle:lifecycle-livedata-ktx:$lifecycle_version"
    // Lifecycles only (without ViewModel or LiveData)
    implementation "androidx.lifecycle:lifecycle-runtime-ktx:$lifecycle_version"

    // Saved state module for ViewModel
    implementation "androidx.lifecycle:lifecycle-viewmodel-savedstate:$lifecycle_version"

    // Annotation processor
    kapt "androidx.lifecycle:lifecycle-compiler:$lifecycle_version"
    // alternately - if using Java8, use the following instead of lifecycle-compiler
    implementation "androidx.lifecycle:lifecycle-common-java8:$lifecycle_version"

    // optional - helpers for implementing LifecycleOwner in a Service
    implementation "androidx.lifecycle:lifecycle-service:$lifecycle_version"

    // optional - ProcessLifecycleOwner provides a lifecycle for the whole application process
    implementation "androidx.lifecycle:lifecycle-process:$lifecycle_version"

    // optional - ReactiveStreams support for LiveData
    implementation "androidx.lifecycle:lifecycle-reactivestreams-ktx:$lifecycle_version"

    // optional - Test helpers for LiveData
    testImplementation "androidx.arch.core:core-testing:$arch_version"
}
```
### 使用场景
将一切与生命周期有关的业务逻辑全都剥离出去，完全解耦
1. 
2. 

### 原理分析
Lifecycle, 观察者模式。
观察注册好理解, 关键是在哪个地方触发, 如何触发?

Lifecycle是如何感知Activity, Fragment, Service的生命周期的?

jetpack 到底是一个扩展包套件，如何做到系统级支持？

	并未做到系统级支持， 同样是走定制Activity的套路，新版的Android Studio创建代码模板默认支持并引入相关的库罢了。 
	系统级的四大组件生命周期及优化是另一帮人做的，Jetpack 套件的开发算是中间件开发的那一帮人，

