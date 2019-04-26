
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

## 根基不稳

    很有必要将会的东西写出来了, 为了面试，也为了练习写博客， 会的都不会写， 何况是不会的？

    写不出来， 就是真的会了吗？

    这样搞下去， 根基肯定不稳

