---
title: Dagger2-Hilt
date: 2021-01-11 17:42:26
tags:
- Jetpack
- Dagger2
categories:
- Android
description: Dagger2 是一个依赖注入框架, 以前也是收square开发的项目， 现在由google维护， 集成到了Jetpack套件中，依赖注入框架，还是能节省不少模板代码的。 Dagger2的使用相对复杂，没有流行起来，因此又出了一个hilt框架， 基于dagger, 省去使用dagger创建模板代码的部分，使用注解代替。
---

### 是什么
Dagger2 是一个依赖注入框架, hilt 是为了简便dagger的使用， 省去一些模板代码。
现在使用一个框架默认最简的操作都是使用注解了么？

[google Android 依赖注入文档](https://developer.android.com/training/dependency-injection/manual?hl=zh-cn)
[官方user guide](https://dagger.dev/dev-guide/android)

### 为什么

findViewById, 实例化一个对象这些操作，都属于一些模板代码。都可以优化成注解来简化使用, 减少出错的机率。

### 怎么做

构造函数注入
字段注入

生成中间代码, 在编译过程中， Dagger会检查代码并执行以下操作:
* 构建并验证依赖关系图, 确保:
	* 每个对象的依赖关系都可以得到满足， 从而避免RuntimeException
	* 不存在任何依赖循环， 从而避免出现无限循环。
* 生成在运行时用于创建实际对象以及其依赖类项的类。

最佳做法摘要:
* @Inject 进行构造函数注入， 向Dagger图中添加类型， 使用@Binds告知Dagger接口应采用哪种实现， 使用@Provides 告知 Dagger 如何提供您的项目所不具备的类。
* 只在在组件中声明一次模块
* 根据注解的使用生命周期, 为作用域注解命名。

总结:
所谓的依赖就是一个类的实例化必须依赖另一个类先实例化，而另一个先实例化的类也可能会依赖于其他类先实例化， 这样就会形成一个依赖链，如果同时多个实例对象依赖实例化， 就形成依赖图。典型的例子就是 IO 的类家族依赖。
Dagger 所做的事就是将这个依赖创建对象的模板方法自动化。通过@Component 注解的类作为与上层应用沟通的接口人，同时管理依赖图, 维护依赖的生命周期。
那么简单的使用流程即时， @Inject 标注依赖注入的目标， @Module, @Provider 提供项目所不具备的类(系统或第三方框架), @Component 标注生成依赖图，上层应用通过调用此类的方法来获取具体对象。
@Component 支持域注解，实现单例模式。
多模块的注解使用

hilt 使用

@HiltAndroidApp
@AndroidEntryPoint
@Inject
@Module
@InstallIn
@Component
@Binds
@Provide

为什么
### 改造模板LoginActivity

使用hilt来改造模板Activity, 


