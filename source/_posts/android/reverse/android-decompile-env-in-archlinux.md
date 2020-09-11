---
title: Android逆向(1) - archlinux 下的环境搭建及前置知识
date: 2020-08-19 15:30:22
tags:
- android逆向
categories:
- Android
description: Android 逆向技术学习，本文记录在archlinux 下进行android逆向的环境搭建过程, 及需要提前了解的一些概念知识，便于后续的心理模型构建。
---

### 准备工具

| 名称 | 作用 | 
|:--:|:--:|
| apktool | 用于查看, 解压, 再编译apk |
| jadx | dex 反编译器 |
| ida | 可交互式的反汇编器 |
| dex2jar | <++> |
| platform tools | <++> |
| frida | <++> |
| xposed | hook框架, 可用于hook系统,app的api |
| ddms | <++> |
| wireshark | 抓包分析工具 |
| <++> | <++> |
| <++> | <++> |
| <++> | <++> |
| <++> | <++> |

安装指令

```sh
# 请先安装
yay -S android-apktool
```

使用指令

### apk 组成

资源文件

classes.dex
	存放所有java 文件编译的字节码。 

oat 后缀的文件: 使用dex2oat翻译后的本地机器码文件

签名
	
### dalvik 和 art 虚拟机

首先， 不管是 dalvik 还是 art, apk 中所有的代码还是放在 classes.dex 中. 
区别是:
1. dalvik 是实时将 classes.dex 中的java字节码转换成机器码, 而 art 是安装时就转换成机器码。 
	对于此不同点，art 的优点是字节码加载快，缺点是安装速度慢， 占用更多的磁盘空间， 但对于现在的手机来说， 这点空间是小意思。
2. art 对内存回收做了优化
3. art 对内存利用率做了优化

所以， 不管是dalvik 还是 art, classes.dex 还是通用的字节码文件， 反译出来是 smalli 语言

