---
title: Android NDK
date: 2020-03-16 17:48:12
tags:
- JNI
- NDK
- Android
categories:
- Android
description: JNI 框架的学习, 学了一部分，整理以前的旧文章，先留个坑，后续再填吧。 
---

## android ndk

NDK 存在的原由:

- 进一步提升设备性能, 以降低延迟, 或进行密集型应用,  如游戏物理引擎
- 重复使用自己或其他开发者的C/C++库

NDK编程目前有三个编译系统

- 传统GNU makefile 的nkd-build
- cmake
- 独立工具链,用于其他编译系统集成, 或基于 configure 的项目搭配使用


先学习 ndk-build:

## Android.mk 

Android.mk 用于描述向编译系统描述源文件和共享库, 实际上是编译系统解析一次或多次的微小GNU makefile片段. 
用于定义Application.mk, 编译系统和环境变量所未定义的项目范围设置. 它还可以替代特定模块的项目范围设置 .

[makefile语法小结](../common/makefile_study.md)

Android.mk 必须先定义 LOCAL_PATH 变量: 

    LOCAL_PATH := $(call my-dir) // 编译系统提供的宏函数 my-dir 将返回当前目录(Android.mk本身所在的目录)路径.

    include $(CLEAR_VARS) // clear_vars 指向一个特殊的GNU makefile, 后者会清除 LOCAL_XXX 变量

    LOCAL_MODULE := lib-name // 要编译模块存储的库名称, 每个模块中使用一次此变量, 模块名唯一,且不含空格

    LOCAL_SRC_FILES := *.c  // 列举源文件, 多个文件以空格分开

    include $(BUILD_SHARED_LIBRARY) // build_shared_library 变量指向一个makefile, 收集最近include以来在LOCAL_XXX变量中定义的所有信息

变量和宏

    编译系统提供了许多可在Android.mk中使用的变量. 其中许多已预先赋值, 许多需自行赋值
    NDK编译系统保留了以 LOCAL_ , PRIVATE_ , NDK_ 或 APP_ 开头的名称, 小写名称 my-dir, 自行定义的变量建议MY_开头

    include 变量 可引用脚本能力, 达到多次调用一个脚本

        CLEAR_VARS
        BUILD_SHARED_LIBRARY
        BUILD_STATIC_LIBRARY
        PREBUILT_SHARED_LIBRARY
        PREBUILT_STATIC_LIBRARY

    目标信息变量

        TARGET_ARCH // arm, arm64, x86, x86_64
        TARGET_PLATFORM // android-22
        TARGET_ARCH_ABI // armeabi-va7, arm64-v8a, x86, x86_64
        TARGET_ABI  // android-22-arm64-v8a

    模块描述变量

        每个模块描述都应遵守以下基本流程: 使用clear_vars 初始化或取消定义模块相关的变量, 为用于描述模块的变量赋值, 使用Build_xxx确定输出的库类型(调置NDK编译系统使用适当的编译脚本).

        LOCAL_PATH  // 即使Android.mk 描述了多个模块, 也只需定义一次, 不会被clear_vars清除
        LOCAL_MODULE    // 存储模块编译出库的名称
        LOCAL_MODULE_FILENAME   //可选变量, 替换编译系统默认生成的名称
        LOCAL_SRC_FILES     // 生成模块时所用的源文件列表, 编译系统会自动计算依赖关系. 可以使用相对(LOCAL_PATH)路径和绝对路径(可移植性差) 
        LOCAL_CPP_EXTENSION // 指明.cpp以外的扩展名
        LOCAL_CPP_FEATURES  //  指明代码依赖特定C++功能, 如rtti, frtti, fexceptions
        LOCAL_C_INCLUDES    // 指定相对于NDK root 目录的路径列表, 添加编译(c,c++, assembly)时的搜索路径, 在LOCAL_CFLAGS, LOCAL_CPPFLAGS前定义此变量
        LOCAL_CFLAGS        // 指定编译c/c++源码时传递的的编译标记 -I<path>
        LOCAL_CPPFLAGS      // 只指定cpp传递的编译标记, 出现在 LOCAL_CFLAGS 后面
        LOCAL_STATIC_LIBRARIES  // 如果当前模块是共享库或可执行文件, 此变量将强制这些库链接到生成的二进制文件, 如果当前模块是静态库, 只是传递作用, 指名依赖当前模块的其他模块也会依赖列出的库
        LOCAL_SHARED_LIBRARIES  // 列出械模块在运行时依赖的共享模块
        LOCAL_WHOLE_STATIC_LIBRARIES    //  表示链接器将相关的模块视为完整归档, 多个静态之间存在循环依赖关系时, 强制编译系统将静态库中的所有的静态文件添加到最终二进制文件, 但是生成可执行文件不会发生这种情况. 
        LOCAL_LDLIBS    // 编译共享库或可执行文件时使用的额外链接器标记, 使用-l前缀传递特定系统库的名称\
        LOCAL_LDFLAGS   // 编译系统在编译共享库或可执行文件时使用的其他链接器标记. 如x86/arm 上使用ld.fbd链接器
        LOCAL_ALLOW_UNDEFINED_SYMBOLS   // 可以帮助捕获编译时遇到的"符号未定义错误"
        LOCAL_ARM_MODE  // 默认情况下在thumb模式下生成arm目标二进制文件, 每条指令16位宽, 并与thumb/目录中的STL库关联
        LOCAL_ARM_NEON  // 仅在armeabi-v7a 目标上有意义, 允许在C/C++源码中使用ARM Advanced SIMD(NEON)编译内建函数, 以及在Assembly文件中使用NEON指令
        LOCAL_DISABLE_FORMAT_STRING_CHECKS  // 默认情况下, 在编译代码时保护格式字符串, 设置为ture时,停用
        LOCAL_EXPORT_CFLAGS     // 此变量用于记录一组c/c++编译器标记, 这些标记添加将通过 LOCAL_STATIC_LIBRARIES 或 LOCAL_SHARED_LIBRARIES 变量使用此模块的任何其他模块的 LOCAL_CFLAGS 定义中
        LOCAL_EXPORT_CPPFLAGS   // 与local_export_cflags 相同, 仅适用于c++标记
        LOCAL_EXPORT_C_INCLUDES // 此变量与local_export_cflags 相同, 但适用于include路径
        LOCAL_EXPORT_LDFLAGS    //  与local_export_clfags相同, 适用于 链接器标记
        LOCAL_EXPORT_LDLIBS     // export 对应的属性就相当于gralde中的 api 属性, 依赖模块可以感知到被依赖模块的export变量
        LOCAL_SHORT_COMMANDS    // 会强制编译系统将 @ 语法用于中间对象文件或链接库的归档, 会减慢编译速度
        LOCAL_THIN_ARCHIVE      // 编译静态库时, 生成一个瘦归档, 即一个库文件, 不包含对象文件, 而只包含它通常包含的实际对象的文件路径, 这对于减少编译的输出大为有用, 但是这样的库无法移动, 都是相对路径
        LOCAL_FILTER_ASM        // 看不太明白, 暂时先不记录了, 先有个印象, 用到的时候再说吧

NDK提供的函数宏

    使用 $(call <function>) 可以对这些宏求值, 将返回文本信息

    my-dir 
        返回系统系统解析脚本时包含的最后一个makefile的路径, 因此, 包含其他文件后就不应该调用 my-dir
    all-subdir-makefiles
        返回当前 my-dir 路径所有子目录中的Android.mk的文件列表, 默认情况下, ndk 只在Android.mk的文件所在目录查找文件, 此函数可以为编译系统提供深度嵌套的源目录层次结构.
    this-makefile
        返回当前makefile 的路径
    parent-makefile
        返回包含树中父makefile的路径(包含makefile的makefile路径)
    grand-parent-makefile
        返回包含树中祖父makefile的路径(包含父makefile的makefile路径)
    import-module
        用于按模块名称查找和包含模块的Android.mk文件, 如 $(call import-module,<name>)


共享库和静态库的区别

local_ldlibs 额外链接器? 类似于class loader 不同的链接器负责加载的库也不一样? 


## Application.mk 

指定了 ndk-build 的项目范围设置. 其中许多参数也具有模块等效项, 如 APP_CFLAGS 对应于 LOCAL_CFLAGS. 无论何种情况下, 特定于模块的选项都将优先于应用范围选项. 

变量 

    APP_ABI : armeabi-v7a, armeabi-v8a, x86, x86_64, all
    APP_ASFLAGS: 要传递项目中每个汇编文件(.s, .S文件) 的汇编器标记
    APP_ASMFLAGS: 对于所有YASM 源文件(.asm, 仅限于 x86/x86_64), 要传递给 YASM 的标记
    APP_BUILD_SCRIPT: 默认情况下, 是与Application.mk同目录(根目录)下的Android.mk文件, 若要从其他位置加载, 需设置为绝对路径
    APP_CFLAGS: 为项目中所有的c/c++编译传递的标记
    APP_CLANG_TIDY: 为项目中所有模块启用clang-tidy, 默认处于停用状态
    APP_CLANG_TIDY_FLAGS: 为项目中所有clang-tidy要传递的标记
    APP_CONLYFLAGS: 只为c编译传递标记, 不作用于c++
    APP_CPPFLAGS: 只为c++编译传递标记, 不作用于c
    APP_CXXFLAGS: cpp_cppflags 优先于 cpp_cxxflags
    APP_DEBUG: 要编译可调试的应用, 设为true
    APP_LDFLAGS: 关联可执行文件和共享库时要传递的标记
    APP_MANIFEST: AndroidManifest.xml 的绝对路径, 默认情况下, $(APP_PROJECT_PATH)/AndroidManifest.xml
    APP_MODULES: 要编译的模块显式列表, 默认情况下, ndk-build 将编译所有模拟的共享库, 可执行文件和依赖项, 仅当项目使用静态库, 项目仅包含静态库,或在app_modules 中指定了静态库时, 才会编译静态库
    APP_OPTIM: 变量定义为release 或 debug, 默认是release, 发布模式会启用优化, 并可能生成无法与调试程序一起使用的文件. 
    APP_PLATFORM: 声明编译此应用所面向的Android API级别, 并对应于应用的minSdkVersion, NDK不包含Android每个api 级别的库, 省略了不包含新的原生API版本以节省ndk中的空间, 以下列优先级降序使用api: 匹配app_platform 版本, 低于app_platform 的下一个可用级别, ndk支持的最低级别
    APP_PROJECT_PATH: 项目根目录的绝对路径
    APP_SHORT_COMMANDS: 等效Android.mk的 APP_SHORT_COMMANDS
    APP_STL: 应用于c++的标准库
    APP_STRIP_MODE: 传递给strip 的参数
    APP_THIN_ARCHIVE: 等效于Android.mk的参数
    APP_WRAP_SH: 要包含此应用中的wrap.sh 文件路径, 每个abi存在此变量的变体, warp_sh_armeabi-v7a ...

什么时clang-tidy
什么是strip

## android.bp

## jni 框架

	为解决一个so 库不可以在子线程中创建的问题， 系统学习一下jni

### 目的

	jni 框架， 实现原理，调用原则, 解决如上问题。

### Introduction

	JNI, java native  programming interface, 允许java 虚拟机中的java 代码调用其他语言写的代码，如(c/c++, assembly汇编)

使用场景
	* java se 库不包括平台依赖的特性
	* 使用已有的其他语言的库， 不必重复造轮子。 
	* 你想使用汇编实现一个高效的有严格时间限制的代码

使用jni可以做的事
	* create, inspect, and update java对象(strings, arrays);
	* 调用java代码
	* 捕获或抛异常
	* 加载类并获得类信息
	* 执行运行时检查
	* 使用invocation API 嵌入任一native程序到java VM, 

JRI
	* Java Runtime Interface


### Design Overview

[官方文档](https://docs.oracle.com/javase/8/docs/technotes/guides/jni/spec/intro.html)

### JNI Types and Data Structures

### JNI Functions

### The Invocation API

### 问题解决

问题描述:
java中开启子线程， 调用jni方法， 会发生闪退， 在主线程中就可以. 
jni方法的参数比较多， 且包含二维数组，大小为 9*16384

解决过程:
由此问题想系统地再学习一遍 jni 框架， 然后看了第一章就看不下去了， 后面再慢慢看吧。 

查询大量blog, 在子线程中访问不到env, 是在jni中通过pthread_create创建的线程访问不到， 这个时候要通过jvm, 缓存全局对象。

现在我遇到的问题是在java中开启子线程，调用jni方法， 这种调用并不会影响 env 的访问, 
jni与java线程是分开的， 但是jni调用的env 是与线程绑定的。 所以在java的子线程里调用jni, 拿到的env是可以直接用的。 
为何通过env 找不到二维数组呢？ 猜测是因为在java中， 二维数组过大， 或二维数组本身就在堆内存中存放， 所以， 是以引用与主线程MainActivity绑定的。
jni代码写的也有问题， 二维数组过大， 9*16384, 且有4个， 以栈的形式存储， 闪退应该是直接爆了。 

阅读了代码发现， 并不用在栈上再开辟一个二维数组，通过 env->GetDoubleArrayElements 得到一个指针， 直接可以访问到， 且代码逻辑里也是直接按一维数组来使用的。 所以，全部都改了了一维数组， 且不必再声明局部变量或在堆上另开辟内存。

这里也想到， C语言的二维数组内存排放也是线性的， 所以按一维数组来读也是没有错的。

为什么在主线程就没有问题了， 猜测主线程栈的大小是比较大的吧, 且二维数组的对象本来就是与MainActivity绑定的， 所以可以访问到。 

暂时先解决了问题， jni框架， 后续再找时间学习吧。

