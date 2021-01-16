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

## dagger2
### 是什么
Dagger2 是一个依赖注入框架, hilt 是为了简便dagger的使用， 省去一些模板代码。
现在使用一个框架默认最简的操作都是使用注解了么？

[google Android 依赖注入文档](https://developer.android.com/training/dependency-injection/manual?hl=zh-cn)
[官方user guide](https://dagger.dev/dev-guide/android)


### 为什么

findViewById, 实例化一个对象这些操作，都属于一些模板代码。都可以优化成注解来简化使用, 减少出错的机率。

dagger 哲学

通常应用于Android代码的许多模式与其他Java代码的模式相反，即使有效的Java中的许多建议也被认为不适用于Android。 
为了实现惯用代码和可移植代码的目标， Dagger 依靠ProGuard对已编译的字节码进行后处理， 
这使得Dagger可以散发出在服务器和Android上看起来感觉自然的源代码，
同时使用不同的工具链来生成两种环境中都能高效执行的字节码。

Dagger 的明确目标是确保其生成的Java源代码始终与ProGuard优化兼容。

ProGuard又是什么,
	开源的java和kotlin优化器

### 怎么做

依赖注入的一条原则： 一个类不应该感知到被注入的任何细节。

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

## Hilt
### 是什么
1. 目标
	* 使Dagger相关的基础架构更简单地应用到Android应用中。
	* 创建一个标准的组件和作用域集, 简化设置，提高可读/可理解性， 以及应用间共享代码。
	* 提供一个简单的方法供不同的构建类型(testing, debug, release)绑定。

2. 概览
hilt 是基于Dagger, 自动生成Dagger的设置代码。这避免手动编写Dagger的模板代码，只专注于创建变量，以及在哪里注入。
hilt 会生成 Dagger的Components依赖视图，并自动注入Android的类中(Activities 和 Fragments)

3. 如何自动生成Components呢？
根据传入的类路径。通过hilt 注解，决定使用哪个Component, 在哪个Android Framework 类中去生成注入代码。 

4. 如何生成注入代码扩展framework类呢？ 
对于gardle 构建的Android工程，在底层使用 bytecode transformation 来扩展

5. 测试
Hilt 会像生产模式中一样生成 Dagger components, 有专门的测试工具来帮助添加或者替换成测试绑定。

6. 优点
减少模板代码
	hilt 鼓励使用一个全局的binding namespace, 可以简单地知道哪一个binding definition 被使用， 而不必去追溯从哪个activity或fragment注入
解耦构建依赖
	Dagger components 有所有安装的modules引用依赖。这会导致依赖臃肿，降低编译速度。解决这个问题自然会涉及接口和非安全的强制转换。
	hilt 在底层自动生成所有的接口，类型转换，module/interface 列表，保证了module/entry点发现，使运行时的非安全类型转换变得安全。
简化配置
	应用开发会有不同的编译构建配置，如生产环境和开发环境。不同的功能特性意味着不同的modules, 在常规的Dagger构建中， 不同的modules集意味着不同的componenttree, 这会导致很多重复的配置部分。
	因为hilt是自动生成这块代码，因此更加方便添加和移除那些依赖。
改良测试
	Dagger是难于测试的，是因为上面提到的配置问题。同理对于测试的依赖配置，hilt也有专门的工具来自动生成, 从而减少了tests中的模板代码的编写(由hilt自动生成), 通过与在生产环境中实例化方式一样实例化测试环境中的代码， 使测试更加健壮。

标准化components
	使components的层次结构标准化。

7. 单一系统设计(monolithic system)

单独的绑定空间 Single binding key space
	保持bindings只为特有的代码使用，推荐使用限定注解(qulifier annotation)通过限制可见性来保护, 或者使用SPI插件强制分隔代码。

简单的配置 Simplicity for Configuration
更少的代码生成 Less generated code
更快的lint检查， 延迟启动 fastlint and start up latency

8. Dagger SPI
hook Dagger's annotation processor, 访问同一个graph model

SPI plugin 原理
继承BindingGraphPlugin, @AutoService可以做到使用ServiceLoader加载, 
当Dagger在classpath中检测到了 SPI plugin， 会调用 visitGraph(BindingGraph, DiagnosticReporter) 去遍历Dagger编译生成的合法的@Component, 
如果所有的视图依赖检测通过, 都合法，Dagger 会继续使用visitGraph 去遍历所有的module, component, subcomponent 是否有错误。 在这种情况下，BindingGraph 可能包含有MissingBinding 节点。 

BindingGraph 被实现成 com.google.common.graph.Network, Network 中节点表示components, bindings, missing bindings这些节点。边代表父-子component 的依赖关系。 具体的实现看[BindingGraph JavaDoc](https://dagger.dev/api/latest/dagger/model/BindingGraph.html)

9. Hilt gradle插件
	使用插件不必在@HiltAndroidApp注解后面带上Application要继承的类。

### 使用
@HiltAndroidApp
	所有使用hilt的应用都有一个Application类加上@HiltAndroidApp 注解, 在需要依赖注入的变量前加上@Injected, 即可以调用super.onCreate()后使用
@AndroidEntryPoint
	Activity, Fragment, View, Service, BroadcastReceiver
	ViewModel 使用@HiltViewModel
	在 Fragment#onCreate 方法中调用 setRetainInstace(true) 会在configuration changes 时保持实例，而不是销毁再创建。
	
	Hilt Fragment 不能设计retained, 因为它持有Component引用， 而Component 持有 Activity引用, 这会造成内存泄漏。 另外， scope bindings 和 providers在Fragment retained的情况下也同样会造成内存泄漏。

	BoradcastReceiver 不需要DaggerComponent, 共用SignletonComponent。

@Inject
	用于构建函数, 或字段 
@Module
@InstallIn
@Component
	注解一个interface, 会自动生成DaggerXXXComponent类， 提供create方法，可以调用 interface 中的方法。使用hilt gralde plugin, 这些都会自动生成。
	生命周期,  绑定对象的 create 与 destory方法, 标示着成员变量什么时候可以用。 

[component 层次结构](https://dagger.dev/hilt/component-hierarchy.svg)

| Component | Scope | Created at | Destoryed at| Default Bindings|
|:--:|:--:|:--:|:--:| :--: |
| SingletonComponent | @Singleton | Application#oncreate() | Application#onDestroy() | Application | 
| ActivityRetainedComponent | @ActivityRetainedScoped | Activity#onCreate() | Activity#onDestroy() | Application |
| ViewModelComponent | @ViewModelScoped | ViewModel created | ViewModel destroyed | SavedStateHandle |
| ActivityComponent |  @ActivityScoped | Activity#onCreate() | Activity#onDestroy() | Application, Activity |
| FragmentComponent | @FragmentScoped | Fragment#onAttach() | Fragment#onDestroy() | Application, Activity, Fragment |
| ViewComponent | @ViewScoped | View#super() | View destroyed | Application, Activity, View |
| ViewWithFragmentComponent | @ViewScoped | View#super() | View destroyed | Application, Activity, Fragment, View |
| ServiceComponent | @ServiceScoped | Service#onCreate() | Service#onDestroy() | Application, Service |

注意，注解了@FragmentScoped 的Fragments 都有自己的FragmentComponent实例, @FragmentScoped 表示在其注入的Fragment中的相关依赖。

Scope Annotation 是有花销的, 因此仅在代码正确性所需要情况下才使用。 如果仅仅是因为想提升性能, 首先确认当前应用性能是不是一个问题，其次优先考虑使用@Reusable来替代component scope。

@Binds
@Provide

### 改造模板LoginActivity

使用hilt来改造模板Activity, 


