---
title: xposed模块开发
uuid: 226
status: publish
date: 2020-10-31 10:58:45
tags: xposed, SRE
categories: SRE
description: xposed框架是安卓逆向领域里的一个标志性的工具了，本文介绍xposed框架，以及其模块开发
---

### xposed是什么

xposed是注入Zygote进程而实现的hook框架。只可以hook java层不可以hook jni层。

### xposed现状 

xposed原始库已停止了维护
原始库
[SuperSu Root管理]()
[xposed]()
[xposedBridge](https://github.com/rovo89/XposedBridge/) xposed模块开发库
[XposedInstaller ]() 用于与xposed及其模块交互管理

目前有新的库基于原始库在持续更新
[Masgisk](https://github.com/topjohnwu/Magisk) Root管理，同时也支持类似于Xposed模块的功能
[EdXposed ](https://github.com/ElderDrivers/EdXposed) Magsiks的xposed支持模块, 基于riru框架实现，从Android 9.0(P)开始开发，利用YAFA(SandHook)hook框架，提供了与原xposed模块一致的api.
[EdXposedManager]() 对标XposedInstaller, 用于与xposed及其模块交互管理
[Riru框架](https://github.com/RikkaApps/Riru) 注入Zygote进程，为了使模块代码运行在应用或者系统服务中，EdXposed模块是基于此模块实现。 

### xposed模块

[XposedFrameworkAPI](https://api.xposed.info/reference/packages.html) 由 XPosedBridge提供, 
[官方教程](https://github.com/rovo89/XposedBridge/wiki/Development-tutorial) 
[XDA论坛讨论区](https://forum.xda-developers.com/xposed/development)

- xposed模块开发注意事项

[官方文档](https://github.com/rovo89/XposedBridge/wiki/Development-tutorial)

xposed api目前最新是82, 一般api的版本号是要与xposed的版本号对应的。但如果新发布的api对以前作了兼容，刚可以在新版本的xposed框架中使用旧版本的api, 如xposed90框架可以使用xposed 82 api

如果想使用模块支持Lollipop(Android 4.x) xposed api 及框架必须使用 54 版本。

在app/build.gradle中添加
```groovy
repositories{
	// 添加阿里云代理
	maven { url "https://maven.aliyun.com/repository/jcenter" }
}
dependencies {
	// 使用provide, 在代码里只会有引用， 真正的实现放在xposed框架里。
    provided 'de.robv.android.xposed:api:82'
	provided 'de.robv.android.xposed:api:82:sources'
}
```
注意: 必须得关掉InstantRun

在AndroidManifest.xml中
```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="de.robv.android.xposed.mods.tutorial"
    android:versionCode="1"
    android:versionName="1.0" >

    <uses-sdk android:minSdkVersion="19" />

    <application
        android:icon="@drawable/ic_launcher"
        android:label="@string/app_name" >
        <meta-data
            android:name="xposedmodule"
            android:value="true" />
        <meta-data
            android:name="xposeddescription"
            android:value="此模块的功能描述, 可在XposedManager中的模块里看到" />
        <meta-data
            android:name="xposedminversion"
            android:value="82" />
    </application>
</manifest>
```

assets文件夹下的xposed_init得标明入口类的引用


### xposed框架定制

暂时不必定制XposedBridge, 当前EdXposed 90 与 XPosedBridge api 82 是兼容的， 可以支持到Android 10.0, 至于后面兼不兼容， 持续关注, 后面肯定是要跟着EdXposed 的脚步走， 那个时候的XposedBridge api 肯定也会同时发布的。

后续看逆向需求， 如果app的反xposed情况严重的情况下，再重新定制一套Xposed框架。
