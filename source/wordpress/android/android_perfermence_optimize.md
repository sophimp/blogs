---
title: Android 性能优化
uuid: 168
status: publish
date: 2019-07-25 16:13:27
tags: 优化, Android
categories: Android
description: 性能忧化的概念，思路，及工具使用。
---

## 性能优化

### 协议通信重构

就重构来说， 也经历了好几个项目了， 以前对重构一直也没有感觉， 只是看见代码逻辑混乱，代码风格丑陋， 然后按着自己的思维方式重新实现一番。但是在整个过程中， 没有涉及到算法， 没有注重内存，没有用上复杂的设计模式， 所以，这样的重构，总给我一种虚得感觉。

重构是为了什么呢？ 下意识里，还是为了高效，运行的高效。 然而经历得多了，才发现，人与人是有差距的， 见到更多屎一样的代码。对于重构有了更深一层次的理解. 重构， 不仅仅是运行的高效， 易于扩展， 易于维护，逻辑清晰，良好的编码风格(排版，命名，分包，框架，易读)，稳定的技术选型， 这些都是重构的内容。 重构不是炫技， 而是为了解决问题。因此，此次重构, 是有效的， 并不是无意义的。当然，更考验技术，更深一层次的还是运行效率与稳定性的优化。

在重构过程中， 遇到了一些基础性的问题， 费了很多时间，对基础的重要性认识也更强了。 byte 流转 int, long, float之类技巧， 这些就与具体的编译器实现有关。类型强转与逻辑操作(与或非) 的关系, 类型强转只是将位数变化了， 但是不会改变数的大小，如 (byte)-128 强转成 int 还是-128, 只不过由8位变成32位(64位机器上), 如果想将-128的符号位也算成数字的非符号部分, 就得先通过与操作，按位将高位扩展为零, 符号位自然变成非符号位的数字一部分. 这个问题也遇见了很多次， 但是还在这上面栽了， 一旦基础没打劳，待出问题的时候， 在整个逻辑链中找错误的工作量无形中扩大了， 而且基础如果没有那个意识，还很难去过能调试手段去定位该问题， 因为压根就不会往上面想。最后只能一步一步地日志，看哪一步的预期与想象中的不一致，然后再找原因。

协议通信框架， nio 编程，mina框架， netty 框架， 这些都有必要去学习一下。还是很有意识的，真正使用起框架，是能做成一些事情，但是对于能力的提升上， 还是没有增加多少底气.

通过这几次重构，对于接口编程也有更深一步体验， 定好入接口， 出接口，其他怎么实现，就是模块内部的事情，既解耦，逻辑也更简单，更可同步进行开发。

所以，retrofit, 后端的接口反射， 是可以理解的，一个接口，只有一个实现类的话， 那么通过接口， 就可以反射， 实现出实现类，这样可以让编程的逻辑更加简单， 实际体验也更加是这样。往往只简单一小步，更多的人使用， 那效果就是一个大的优化。再长时间反复用， 那就更是一个了不起的优化。这些正是自动化， 简单化思维.

目前实践了两种方式的协议解析，主动式设备的协议也并不是我开始喷得那样一无是处，结合tcp的整包发送实践， 也一样可以达到很好的效果。每个协议包，tag值，都有通用性. 

### 多线程问题

Handler, ExecutorService 线程池，在高并发的时候， 很容易陷入死锁状态，全都睡眠，当然这可能与我的使用方式有关，也说明了，所谓的官方本身也不可靠。 
多线程问题还有深入研究的空间，模拟这样多客户端与服务端通信的场景，然后将多线程的问题彻底吃透，现在我也是有这个能力的。
使用 netty 框架模拟，先搞明白使用，将多线程的问题分析完，后面有余力再分析一下netty的框架，借这个思想，去学一学epoll之类的c/c++网络框架。网络和多线程先学到此。
当再有人问，你自认为做过比较有难度的工作是什么样的？ 这一方面可以拿出来说一说。

在此重构过程中， 遇到多线程的问题是， 有5个客户端同时发送数据， 想只用一个线程来解析数据， 但是在每次接收到数据后handler.post(), Executors.execute()， 一会解析线程就挂了。
分析此次挂的过程， 学会了使用 android studio profiler 工具，使用感受放在下一段说。最开始线程并不是挂， 而是状态一直running, 但是就是不再解析，最后通过profiler record一段cpu 状态，才发现是在线程中的逻辑，进入了死循环。这算是一个低级错误， 又是基础不扎实，导致浪费大量时间的典型案例. 
修复完死循环的逻辑，再使用单线程解析还是过一会挂死， 这一次的状态是线程sleeping, 但是开了三个线程一起解析，在解析过程加上synchronized, 到目前为止还算工作良好。简单看了下源码， handler, threadpool, 内部每一个execute 也是先放到一个BlockingQueue中缓存着，每次都有lock, wait操作， 所以问题可能出在BlockingQueue, 也可能出在线程池的内部机制，暂未深入研究。当然也可能是我自己写的 循环队列有问题？放在多线程验证中一起验证。
多线程也并没有那么可怕，懂得机理， 分析一下源码，也并不能浪费多少时间。

### profiler 使用

cpu, memory, network

cpu里可以录制一段cpu工作过程，sample java method , 采样java 方法的调用过程, 可以看到每个线程中调用的java方法过程.
还可以 trace java methods, 跟踪java 方法的调用时机

dump 内存，是一个不错的方法， android profiler也可以加载本地的dump 文件， dump 的内存文件也可以通过ida来分析，还有很多工具未使用到呢？ 后续遇到再搞， 已然不能成为一个障碍了

memory 可以查看当前程序运行过程中，内存使用状况

### android 性能优化实践

1. 内存忧化
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

3. 网络

2. UI忧化
    * 优化布局, 多层嵌套的情况下, 优先使用Relative, 在Linear 与 Relative 都可用的情况下, 选择Linear, 更复杂的情况, 使用Constraint
    * 布局配合include, merge, ViewStub 提高复用率, 减少嵌套, 按需加载, ConstraintLayout在RecyclerView中表现并不好
    * 减少重叠绘制的背景层数
    * 自定义控件代理帧动画, 减少onDraw的次数, 在onDraw中不作创建对象, 少使用循环操作, 减少整屏刷新的频率
    * 辅助分析UI的工具, Profile, GPU过渡绘制分析, GPU呈现模式分析
    * 流畅的标准, 一帧16ms, ANR 5秒, BroadcastReceiver, 10秒, service, 20秒

3. 网络忧化
    * 减少网络请求的次数
    * 缓存的必要性
    * 断点续传
    * 反序列化

4. 启动优化 
    * 冷起动, 初始创建主线程, 创建application 和 activity, 加载布局, 初始绘制
    * 热起动, acitivity 被销毁, 但在内存常驻时, 与冷起动都会显示闪屏页, 重走activity生命周期, 减少了对象初始化分配内存, 加载布局等工作
    * 暖起动, 返回键返回马上又打开, 启动时间更短
    * 减少application 与activity创建过程中的耗时操作, 延时加载

5. 电量优化
    * 能使用wifi, 不使用移动网络
    * 其他性能优化手段也是电量优化的一部分

