
## jvm

    内存模型
    类加载机制
    jvm 性能调优
    字节码
    内存回收

    我所理解的虚拟机: 适配了在各种系统上的系统函数， 将这些工作由一个有实力的公司统一做一遍， 然后实现代码共享。虚拟机的机器码对应字节码，jdk 实现对应的jre库
    跳出来看， 一个虚拟机开启一个进程，虚拟机初始化的过程即是加载jre的过程， 后面的再加载类的时候，根据字节码再转换成对应系统的机器码  
    内存回收有几种策略
    常用的性能调优方案
    字节码， 内存模型， 现在已不是认知问题
    类加载机制， 真得看下源码？ 类加载到虚拟机， 要做些什么工作

## 深入理解java虚拟机:JVM高级特性与最佳实践
1. 走近java
    - java背景，发展史， 未来发展方向
    - 自编译jdk, java develop kit, java 语言, api, 虚拟机, java se 与虚拟机统称为 jre

2. 自动内存管理
    - 方法区，堆， 虚拟机栈， 本地方法栈， 程序计数器, 执行引擎， 本地库接口
    - 分代年龄, 偏向锁，
    - OOM, Stack OOM, Perm OOM
    - jhat, 引用与直接地址
    - Garbage Collection
        引用计数器
        可达性
        强引用，软引用， 弱引用， 虚引用
        finalize 是对C/C++ 程序员的一种妥协， 历史遗留问题
        标记清理， 标记整理， 分代收集， 复制算法
        枚举根节点， 安全点, 安全区域
        Stop-The-World
        最短回收停顿时间
        浮动垃圾
        Serial, Serial Old, ParNew, Parallel scavenge, parallel old, cms, g1
    - 虚拟机性能监控与故障处理工具
        jstat, jstack, jhat, jps, jinfo, jmap, jconsole, visualvm

3. 虚拟机执行子系统
    -

4. 程序编译与代码优化
    - 

5. 高效并发
    - 
