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
将一切与生命周期有关的业务逻辑全都剥离出去，完全解耦。
1. 
2. 

### 原理分析
Lifecycle, 观察者模式。
观察注册好理解, 关键是在哪个地方触发, 如何触发?

Lifecycle是如何感知Activity, Fragment, Service的生命周期的?

jetpack 到底是一个扩展包套件，如何做到系统级支持？

	并未做到系统级支持， 同样是走定制Activity的套路，新版的Android Studio创建代码模板默认支持并引入相关的库罢了。 
	系统级的四大组件生命周期及优化是另一帮人做的，Jetpack 套件的开发算是中间件开发的那一帮人，

Lifecycle那么多库，如何去分析整个框架, 为什么要去分那么多的库呢？

	单一职责原责， 库分得多，功能单一，复用性会增加，定制性也会增加， 但是会增加前期的学习成本（相对小白而言， 一旦学会了这套理念，再看相关代码或者定制就更加方便）。 
	先从示例代码中查看， Android Studio 4.1.1创建的LoginActivity 模板代码就用上Lifecycle 框架。
	一时间分不清各个库都是干什么用的， 就先将所有库都依赖进来，这样方便根据示例跟踪代码。
	前期的“复杂”是为了后续扩展维护的简单。 所以新手的首要任务是克服前期的复杂。

	Lifecycle, LifeycyclerOwner, LifecycleObserver, LifecyclerEventObserver 在 lifecycle-common包中
	LifecycleRegistry 在 lifecycle-runtime中, 
	LiveData 在 lifecycle-livedata-core 中, 

Lifecycle的复用性如何？ 
	jetpack中应用到了Activity, Fragment的生命周期， 也结合了 ViewModel, LiveData 实现了 MVVM
