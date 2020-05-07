
## android 性能优化实践

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

