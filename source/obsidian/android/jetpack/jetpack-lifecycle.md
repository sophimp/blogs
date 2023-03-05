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
Lifecycle是如何感知Activity, Fragment, Service的生命周期的?  观察者模式。
观察注册好理解, 关键是在哪个地方触发, 如何触发?
在 Fragment 与 FragmentActivity 中有LifecycleRegistry 实例，通过handleLifecycleEvent在生命周期函数中触发生命周期事件。 上层应用继承自Fragment 和 AppCompatActivity : FragmentActivity。便扔有了这种能力。

jetpack 到底是一个扩展包套件，如何做到系统级支持？

	并未做到系统级支持， 同样是走定制Activity的套路，新版的Android Studio创建代码模板默认支持并引入相关的库罢了。 
	系统级的四大组件生命周期及优化是另一帮人做的，Jetpack 套件的开发算是中间件开发的那一帮人，

Lifecycle那么多库，如何去分析整个框架, 为什么要去分那么多的库呢？

	单一职责原责， 库分得多，功能单一，复用性会增加，定制性也会增加， 但是会增加前期的学习成本（相对小白而言， 一旦学会了这套理念，再看相关代码或者定制就更加方便）。 
	先从示例代码中查看， Android Studio 4.1.1创建的LoginActivity 模板代码就用上Lifecycle 框架。
	一时间分不清各个库都是干什么用的， 就先将所有库都依赖进来，这样方便根据示例跟踪代码。
	前期的“复杂”是为了后续扩展维护的简单。 所以新手的首要任务是克服前期的复杂。

	Lifecycle, LifecyclOwner, LifecycleObserver, LifecyclerEventObserver 在 lifecycle-common包中, 
	LifecycleRegistry 在 lifecycle-runtime中, 使用组合的方式，在Fragment 和 FragmentActivity 拥有实例通过handleLifecycleEvent来触发周期事件。
	LiveData 在 lifecycle-livedata-core 中， 
	LifecyclerOwner由Fragment 和 FragmentActivity继承, 用来获取 Lifecycle 实例 LifeycycleRegistry。 LifecyclerRegistry 通过addObserver 来添加观察者LifecycleObserver。 LifecycleObserver 通过注解 OnLifecycleEvent 来监听事件，由 ClassesInfoCache 在addObserver时候缓存缓存监听方法。 addObserver 由上层应用选择调用, 如果使用LiveData框架， 由LiveData的observe方法来调用。 LiveData 也是一个观察者模式，在添加 Lifecycle的生命周期观察者的同时，也添加数据的观察者LifecycleBoundObserver。既然LiveData也是观察者模式， 添加方法是observe, 那么也必定有触发方法。LiveData 为abstract类， 由MutableLiveData暴露postValue, setValude 方法，MutableLiveData 实例由ViewModel实例（调用者自行继随实现), 通过setValue来触发数据发生变化。 LiveData 也会与Lifecycle结合，感知生命周期来决定是否通知Observer, 因此LiveData内部也拥有Lifecycle的观察者。 这里LiveData很巧妙, 使用了LifecycleBoundObserver 将 LifecycleObserver包装了一层，两个观察者合二为一，在LifecyclerBoundObserver中处理完自己的逻辑， 再转发出去。处理LifecyclerObserver的事件。 

	(这里需要一张图, 待补)

	使用方式:
	继承ViewModel, 实现在view与ui刷新的逻辑, viewModel 中监听生命周期方法
	Activity/Fragment 继承AppCompatActivity/Fragment, 通过ViewModelProvider来实例化一个具有Scope的实例, 官方示例将代码又细分了好多， LoginRepository, LoginDatasource, 这就是根据具体的业务来分割。 
	再根据控件的监听事件来触发Observer方法，其次， 在各控件的监听事件中也有相应的业务。 

	优势分析:
	解耦更强，依赖倒置, 不要让我来找你， 改变成你做完了通知我。

Lifecycle的复用性如何？ 
	jetpack中应用到了Activity, Fragment的生命周期， 也结合了 ViewModel, LiveData 实现了 MVVM, 也有一个类分一个包的？ 这样真得好么？ 或许到了系统层的框架就很有必要了？ 
	官方的示例有很好的借荐性， 但是在空闲之余，也不是不可以考虑有没有优化的空间。 

mvc, mvp, mvvm(model, view, view model)
	主要区别在于控制UI的思想。
	所谓的mvvm， 核心思想是感知。 感知状态的变化，感知数据的变化。再根据变化来更新UI, 处理业务。这里运用了依赖倒置的原则，灵活性更强一些。 
	而mvc是面向过程的思想来控制UI，简单直接，但是业务一旦复杂，扩展性差，易维护性差。
	mvp 是基于mvc的基础上， 抽象出来接口，增加了代码的易维护性和扩展性， 但是避免不了随着业务的复杂， presenter 也会变得庞大。 
	不管是哪种架构，最主要的还是编译的原则，依赖倒置，开闭，解耦。


