
## 面试知识总结积累

    能分享传授他人的知识， 才是真正的95%掌握的知识

    答不上来, 是一种失败, 积累的一个过程, 也恰恰说明了在舒适区里太久了, 之前几家公司的面试怎么进的? 有一定混的成份. 

    好运气的作用就止起不了决定性作用了, 关键还是技术能力.

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

- java 基础
    - 集合
    - 多线程
    - 算法, 数据结构
    - java 8 特性, lambda 表达式
    - 泛型, 类型擦除
    - 

- android 四大组件
    - Activity
        窗口, 事件管理器
    - Service
    - Broadcast
        > 静态, 动态, 有序, 粘性, 本地, 
        > LocalBroadcastReceiver 将exported设置为false, 增加相应的权限, 指定包名
    - ContentProvider
        > 内容提供者, 可跨进程数据通信, 底层是采用binder机制, 使访问数据更安全, 简洁, 高效, 统一了数据访问形式

- 自定义控件, 布局, 资源管理
    * 有了四大组件, 加上java基础, 会些控件, 布局, 基本上就可以写android 应用了
    * 这样就算是初始级程序员了吧.

- Binder机制

    跨进程通信机制, 也可以理解成是一种内核驱动, 具体实现, 系统层层已经实现了, IBinder 主要是通过内存映射实现只拷贝一次数据实现进程间数据共享, 具体到应用层实现, Service 端需实现业务接口继承至IInterface, 实现Stub实例,通过queryLocalInterface()调用业务能力, 然后将结果写回replay, onBind方法中初始化Stub, 业务接口, 并绑定bind.attachInterface, 返回binder实例, client通过bindService, 在serviceConnection 回调中获得 service端的binder 实例, 通过命令字, transact 调用业务能力. 

    引用接口是为了让业务更清晰, 客户端与服务端直接通过命令字, 将参数,以及返回值都传入, 所以还要定义一套业务接口

- AIDL机制

    基于Binder机制, 实现IPC通信
    具体使用方法, 服务端定义 aidl 接口文件, 编译, 会自动生成对应的java 接口文件继承IInterface, 并生成两个内部类Stub 继承Binder, 实现AIDL接口, Proxy 实现AIDL接口, 在AndroidManifest.xml文件中注册服务, 声明为remote(取个名字而已). 

    客户端拷贝aidl文件, 注意包名保持一致, 编译生成AIDL文件, 绑定远程服务, 在ServiceConnection 回调中, 能过aidl.stub.asInterface()获取到AIDL远程实例

    数据流向

- tcp/ip 三次握手, 四次挥手

    三手握手是保证数据的安全, 有序, 可靠.  首先客户端发送一次 sync_num, 状态变了 SYN_SEND, 客户端回一次sync_num+1, 并携带一次ack, 客户端收到后, 再一次回ack+1, 此时通信建立,  状态变为established

    四次挥手, 客户端发送结束传输指令fin, 服务端收到后, 由于此时不能确定服务端是否会向客户端发送数据(上一个请求的数据还未完全返回，网络延时的重发), 所以此时先回ack, 然后服务端在数据发送完后， 主动再发一个关闭的指令到客户端， 客户端收到后, 回一个ack确认关闭，服务端收到后, 设置状态为关闭连接

- 非静态内部类调用外部类的方法, 这一过程发生了什么？
    
- LRU算法
    
- 竟然有些回忆不起来了， 感觉是越来越没戏了。 荔枝FM， 估计没戏了

- 性能优化， 网络优化

- view 自定义控件应该注意些什么
    * requestLayout

## IM方向
1. 什么都是正在学, 也说明不了什么问题， 哎， 人当然不会招一个还正在学的技术人员

2. 

