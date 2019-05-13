
## 面试知识总结积累

    既然每半年都要保持面试一次， 那么， 之前做的工作， 当然也得积累起来

    能分享传授他人的知识， 才是真正的95%掌握的知识

## android 
1. 原生技术
- activity, broadcast, fragment, view, ViewGroup都没什么问题, 需要更进一步源码分析
- service, ContentProvider, 这些主要是跟数据库和多线程相关， 可以开发， 但是应用场景，不能保证高效

## language 
- java, kotlin
- c/c++
- c#, python
- lua

## architecture
1. android framework
2. mvp, mvc, mvvm
3. eventbus
4. rxjava
5. 

## operate system
1. csapp
2. linux 内核
3. unix 下高级编程
4. jvm
5. 游戏引擎架构
    育碧游戏公司， Yilo Yip
6. window 编程艺术

## computer graphics
1. demo

    作品很重要， 但也不能因为没有作品， 就踏不出这一步吧？ 

## refactor, optimization
- 重构是什么？ 已有的重构经验， 不过是将更垃圾的代码改到现有的水平， 改成这样有没有更好，哪里更好？ 有何量化标准?
- 更易阅读， 维护
- 更适应公司的业务发展， 能快速响应不同商家的版本发布
- 效率更高，有什么手段去验证, 这个应试是

## major open source
- ffmpeg

## 插件化开发
1. 原理

2. 框架
    Altas
    DoidPlugin
    [Small](https://blog.csdn.net/wangbaochu/article/details/50518536)
    Dynamic-load-apk
    Direct-Load-apk
    Android-Plugin-Framework
    DynamicAPK

3. 热更新与插件化是一个原理是不是一个原理呢？

## 热更新
1. 原理:

    - 通过分包dex方案加载新的补丁 

        新的patch.dex需要拷入到原有的dex之前
        同一个dex之中的类调用会有 CLASS_ISPREVERIFIED 检测, 通过在每个类中引入另一个AntiLazyLoad.class, 放在hack.dex之中

    - 如何打补丁包呢？
        将每次发布的所有class生成md5缓存， 还有一份mapping混淆文件
        后续版本中使用-applymapping选项， 应用到正式的mapping文件中,然后比较md5，将不同的class文件打包

    - 侵入式打包
    - 类替换
    - so替换
    - 资源替换
    - 全平台支持
    - 补丁包大小

2. 框架
    Hotfix
    Andfix
    Tinker
    QFix
    Amigo
    Robust
    Sophix

## 性能优化 

    快, 稳, 省, 小
    卡顿, 内存泄漏, 代码质量和逻辑, 安装包过大

1. UI 
    * 优化布局, 多层嵌套的情况下, 优先使用Relative, 在Linear 与 Relative 都可用的情况下, 选择Linear, 更复杂的情况, 使用Constraint
    * 布局配合include, merge, ViewStub 提高复用率, 减少嵌套, 按需加载, ConstraintLayout在RecyclerView中表现并不好
    * 减少重叠绘制的背景层数
    * 自定义控件代理帧动画, 减少onDraw的次数, 在onDraw中不作创建对象, 少使用循环操作, 减少整屏刷新的频率
    * 辅助分析UI的工具, Profile, GPU过渡绘制分析, GPU呈现模式分析
    * 流畅的标准, 一帧16ms, ANR 5秒, BroadcastReceiver, 10秒, service, 20秒

2. 内存
    * 内存泄漏, 内存抖动(频繁的GC回收), OOM
    * LeakCanary工具可辅助,  Profiler, Heap Viewer
    * jvm 内存回收机制, 分代收集, 分区收集, 新生代, 老年代, 永久代, 复制算法, 标记-整理, 标记-清除算法
    * jvm 小工具, jps, jstat, jinfo, jmap, jstack, javap, jcmd, jconsole, jvisualvm
    * GC root对象: 方法区(类静态引用的对象, 常量引用的对象), 虚拟机栈(本地变量表中)引用的对象, 本地方法栈JNI中引用的对象
    * 内存泄漏几种场景, 单例引用Activity的Context, 集合强引用未使用对象, 匿名内部类/非静态内部类
    * 强引用, 虚拟机GC不会碰, 软引用, 内存空间不足时回收, 弱引用, 不管内存够不够, GC的时候都会回收, 虚引用, 不怎么用
    * 资源未关闭, 造成内存泄漏, I/O资源, Broadcast 忘记unregister, service 忘记stopSelf, EventBus忘记unregister
    * bitmap, 压缩, 及时释放, 替换成Drawable, WebP格式, svg图片
    * 插件化, 随用随下
    * 线程优化, 使用线程池

    回过头来再看, 之前说的一些东西,就是很直白的意思, 线程池, 一直以为很神秘, 知道了内存的限制与CPU调度的开销, 线程就是为此而生

3. 网络
    * 减少网络请求的次数
    * 缓存的必要性
    * 断点续传
    * 反序列化

4. 电量
    * 能使用wifi, 不使用移动网络
    * 其他性能优化手段也是电量优化的一部分

5. 启动
    * 冷起动, 初始创建主线程, 创建application 和 activity, 加载布局, 初始绘制
    * 热起动, acitivity 被销毁, 但在内存常驻时, 与冷起动都会显示闪屏页, 重走activity生命周期, 减少了对象初始化分配内存, 加载布局等工作
    * 暖起动, 返回键返回马上又打开, 启动时间更短
    * 减少application 与activity创建过程中的耗时操作, 延时加载

    闪屏页, 不可控, 但是必须有, 随着硬件性能的提升, 显示时间越来越短, 可以设置windowBackground来控制闪屏页背景
    网上的教程质量参差不齐, 闪屏页不能作网络加载之类的逻辑, 其实是指的启动页, 配置有Launcher的activity

## 根基不稳
1. 事件分发机制
    核心对象 Activity -> ViewGroup -> View
    activity: dispatchTouchEvent -> ViewGroup
    ViewGroup: dispatchTouchEvent -> onInterceptTouchEvent -> onTouchEvent
    View: dispatchTouchEVent -> onTouchEvent -> performClick -> onClick
    核心方法 dispatchTouchEvent, onInterceptTouchEvent, onTouchEvent

2. 

## IM方向
1. 

