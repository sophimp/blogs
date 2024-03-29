---
title: 一次JNI调试记录
uuid: 171
status: publish
date: 2019-07-21 15:23:27
tags:JNI Debug, Android
categories:
- Android
description: 使用 gsm语音库时，在armv8 平台遇到的问题，记录下来解决的过程，涉及到jni调试的小技巧，jni 后续还有持续学习的机会。
---

## android ndk编程

在gsm语音监听库编译arm64-v8a库时， 总是会出现闪退

这样的闪退, android studio 的logcat也看不出日志， 所以还是要使用adb logcat 将日志存储在文件中分析

首先尝试了在 cmake 中添加 -std-gnu99 -g 使so 库可调试，看看是不是因为标准的问题, 这个时候就显示出gui 工具的局限性。根本debug不了 

直接运行so 库， 使用gdb调试呢？ 这个方法虽然可行， 但是一时间感觉不能保存现场， 现在看来并不是不好做， 也只是两个文件路径而已，且都己经保存在了本地。 再加上gdb也不熟悉， 所以此方法就暂时搁置了。

然后就从日志入手， 日志只有一些堆栈的信息， backtrace stack, 给了地址和so 库的名字，这样明显是跟java中直接定位出代码位置是一样的么。
所以，理论上是有工具翻译出出错的代码位置的。

网上搜索， 必然是有的， 直接在ndk 包中的 linux/llvm/prebuilt/x86_64/ 下的 addr2line 工具，addr2line -f -e <name.so> <addr> 然后就能定位出代码位置， 
需要加 -g 的参数，.so 库才会记录位置信息. 其他 .elf, .a 是同样的

一时间发版本， 也没有心思去深入研究，只是根据这个地址找到了出错的位置， 原来是数据超出范围了. word16 的数据，只能处理 0 - 0x7ffffff 大小的数据，现在全变成负数了， 直接将入参改成 word32 也并没有效果，所以这时候还是犯了数据类型转换的错误，
虽然规避了超出范围不abort, 但是声音就完全失真了，为了发版本， 也只是改到这里， 下一次，有环境的时候，可以再验证一下类型转换后能否可行。 猜测是arm64-v8a平台采集的数据，已经将声音数据范围扩展了，这个库也是10年前的库了, 中间没有再维护

这个过程，也算是体会到了ndk 下开发的调试过程， 其实最终的基本功还是linux下c/c++ 的开发gdb调试过程, 后面再加强学习， 先记录如此。

