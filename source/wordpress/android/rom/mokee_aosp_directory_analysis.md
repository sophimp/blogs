---
title: Mokee 与 aosp 工程文件的分析
uuid: 264
status: publish
date: 2019-05-22 17:53:56
tags: Mokee, ROM
categories: ROM
description: aosp支持的机型还是比较少，mokee 是基于LineageOS 的国内汉化版，支持更多的机型，本文开始研究mokee, 首先还是弄清楚每个文件夹的作用。 
---

通过文件夹对比, 了解整个工程结构, aosp的开发流程, mokee系统做了哪些事情

- mokee nexus 5x:

android     bootable        compatibility  development  frameworks  libnativehelper  packages          prebuilts  test
Android.bp  bootstrap.bash  cts            device       hardware    Makefile         pdk               sdk        toolchain
art         build           dalvik         doc          kernel      mokee-sdk        platform_testing  syntax     tools
bionic                      developers     external     libcore     out              plugin            system     vendor

- aosp sargo:

Android.bp   bootable        developers                       frameworks       Makefile          projectFilesBackup   tools
             bootstrap.bash  development                      gen              out               projectFilesBackup1  vendor
             build           device                           hardware         packages          sdk
             compatibility   external                         kernel           pdk               system
art          cts             extract-google_devices-sargo.sh  libcore          platform_testing  test
bionic       dalvik          extract-qcom-sargo.sh            libnativehelper  prebuilts         toolchain

- 不同之处:

android :

    default.xml, snippets/mokee.xml 记录的是整个工程的应用路径,名称,分组

    分组有 pdk, aosp, tools, nopresubmit, vts, darwin, pdk-fs, pdk-cw-fs...  

    应用文件包有 packages, frameworks, prebuilts, pdk, external, art, bionic, cts, dalvik, bootable, device, developers, development, hardware, system, test, tools, mokee-sdk, vendor, 
    基本上每个文件夹下都是应用

    这些配置文件是在什么时候加载的呢? 

    pdk, bionic, cts 代表啥

gen:
    aosp 编译完生成的 aidl 文件

mokee-sdk:
    mokee 额外开发的, 涉及的内容还是挺多的 

- 相同之处:

android.bp:
    [android最新的编译系统](http://gityuan.com/2018/06/02/android-bp/)

    用来替代android.mk, 纯粹的配置, 没有分支, 循环等流程控制, 不能做算数逻辑运算, 如果需要控制逻辑, 只能使用go语言写
    Ninja, 是一个编译框架, 一般不会手动修改, 是由android.bp 转换成ninja格式来编译
    Soong, 类似于Makefile编译系统的核心, 负责Android.bp语义解析, 并将之转换成ninja文件
    Blueprint, 生成, 解析Android.bp的工具, 是Soong的一部分,是由golang写的项目, android7.0以后, prebuilts/go 为golang的运行环境
    kati, 专为Android开发的一个基于golang 和 C++ 的工具, 主要是将 Android.mk 转换成ninja 文件, 代码路径是 build/kati, 编译后的产物是kati

art:
    art 虚拟机

bionic: 
    由google 开发的c标准库, 用于android嵌入系统上, 用来取代glibc, 不依赖于BSD kernel, 但是由BSD 授权条款运行于linux上

bootable: 
    recovery, recovery-twrp

bootstrap.bash:
    环境变量配置脚本

build: 
    编译工具合集, blueprint, kati, soong, make

compatibility: 
    cdd(Compatibility Definition Document) 文档, 每一个版本都会有一个cdd, 代表Android 兼容性的"政策"方向

cts: 
    兼容性测试套件, 是一个自动化测试工具, 免费的商业级测试, CTS 验证程序是手动测试工具,对CTS的补充
    签名测试, 平台API测试, Dalvik测试, 平台数据测试, 平台Intent, 平台权限, 平台资源

dalvik: 
    虚拟机, 为何与art同时存在? dalvik 支持JIT, 但是会拖慢系统速度, 现已被 ART 虚拟机取代. 但是为了兼容, 所以两者目前都可以用, 可以选择. ART, 安装慢点, Dalvik 运行慢, 所以要看取舍. 

developers: 
    提供给开发者的一些demos, samples

development: 
    系统自带的一些测试应用, 工具, 模板

device: 
    对应不同芯片编译的一些Android.mk 文件, 基本上每个模块也都有readme, 在哪里, 什么时机用到呢?

external: 
    外部依赖库的位置

frameworks: 
    基于系统服务层与应用层之间, 用于提供给应用层sdk? 按已有的经验基本上看到的源码就是在framework 层

hardware: 
    硬件层, 有的只是提供头文件, 没有源码, 就那是动态链接库了
    Camera, 蓝牙, Audio, Graphics... 

kernel: 
    在mokee 中直接有源码, 在aosp 中只是配置文件 
    kernel 层已经包含了驱动, 各vendor 硬件一般只需要实现 HAL 层即可

libcore: 
    核心库, json, art, dalvik, benchmarks

libnativehelper: 
    看名知意, 本地库工具库

out: 
    编译完输出目录

packages: 
    系统应用工程目录

pdk: 
    platform development kit
    帮助芯片商, OEM 移植新的发布版本, 包含了开发android HAL的必要组件
    这里mokee 与 aosp 是一样的

platform_testing: 
    全平台的测试, 与多个android services 交互, 或者 HAL layers, Instrumentation Test, Native Test, CTS

prebuilts: 
    编译脚本的运行环境

sdk: 
    这个sdk, 与framework 又有何区别?
    一些sdk tools 移到了 tool/base, tool/swt
    sdk manager, ddms, avd manager 这些项目工程

system: 
    操作系统源代码

    初步理解是与 kernel, art, HAL, 打交道, 初始化虚拟机, 编写基于 binder, jni, wifi, bluetooth, 这些硬件的功能, 然后通过jni, 提供framework 层, 使用java调用.
    java调用硬件的能力, 都在system 这里已经使用c++实现了, 通过jni调用

test: 
    vts 测试框架

toolchain: 
    开发使用的工具链, GNU的编译器, 链接器, 汇编器等等 

tools: 
    各种第三方的工具, apk sign, app bundle, app zip, fat32, gradle, log analysis.

vendor:
    各手机厂商(包括第三方的开源组织)定制的内容
    mokee 中有预置的apk, 针对Telephony, Camera 定制的cpp
    aosp 中直接就是qcom 的 *.so
