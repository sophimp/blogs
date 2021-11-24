---
title: Jetpack-MVVM
date: 2021-11-24 11:39:58
tags:
- jetpack
- mvvm
categories:
- jetpack
description: Jetpack 推崇使用MVVM模式，再加上后续的Composed的响应式编辑，更是mvvm的集大成体现。mvvm的思想确实更能解耦，使代码更清晰。
---

# MVVM

数据变化，UI自动更新

# jetpack 中的角色

## LifecycleOwner(Activity, Fragment)

Activity, Fragment 仍旧是显示层, 将Lifecycle 抽象了出来 LifecycleOwner

如何将ViewModel 的生命周期联系起来

LifecycleRegistry -> Lifecycle, LifecycleEventObserver -> LifecycleObserver, LifecycleOwner, 

LifecycleRegistry 被ComponentActivity, FragmentActivity, Fragment 持有，
LifecycleRegistry 也是被观察者，FastSafeIterableMap缓存所有LifecycleObserver, 在生命周期函数中调用handleLifecycleEvent来通知所有的LifecycleEventObserver(由ObserverWithState包装), 

LifecycleOwner提供一个接口获取 LifecycleRegistry, 上层可以通过getLifecycle()注册监听生命周期

## ViewModel

为Activity, Fragment 准备和管理数据, 不访问UI树，不持有Activity 或 Fragment引用
生命周期应与所属 LifecycleOwner 一致, 这是如何做到的(LifeCycle是如何与Activity,Fragment集成的)
ViewModel 不持有Activity 或 Fragment引用，实现的方式是传入的ViewModelStoreOwner是Activity或Fragment中的成员变量mViewModelStore
mViewModelStore在通过ViewModelProvider创建实例的时候缓存

ViewModelStore 用来缓存ViewModels, 一个ViewModelStoreOwner 可以拥有多个ViewModel, 但是生命周期都是与ViewModelStoreOwner保持一致的

ViewModelStoreOwner 用来获取ViewModel, 第一次获取时,lazyinit

NonConfigurationInstances, ComponentActivity静态内部内，持有ViewModelStore, 所以，这个NonConfigurationInstances是原有的OnSaveInstance机制吗？ 
看源码是这样的，onRetainNonConfigurationInstance()是由系统调用，Called by the system, as part of destroying an activity due to a configuration change, when it is known that a new instance will immediately be created for the new configuration. 
典型的场景就是橫竖屏切换, 所以ViewModel可以解决横竖屏切换的实现在这里，在onRetainNonConfigurationInstance()返回切换前屏幕的Activity实例, 切换后再由getLastNonConfigurationInstance获取，得到ViewModelStore, 从而得到ViewModels

通过ViewModelProvider 获得的ViewModel, 具有owner的生命周期(作为owner的成员变量)
``` java
new ViewModelProvider(activity).get(ViewModelSub.class)
```


## LiveData

Data的Observer, 数据变化的监听和通知接口

