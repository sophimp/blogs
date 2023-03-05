---
title: Android逆向(2) - 加固，脱壳技术
date: 2020-09-14 20:46:32
tags:
- Android逆向
- SRE
categories:
- 逆向工程
description: 要逆向分析一个app，得先搞到可反编译的dex, 因此，脱壳是必须的。
---

## 目标

了解常用的加密技术，手段，及脱壳技术

1. 加壳技术

加壳的目的
	防止逆向分析: 防止核心代码被反编译
	防止二次打包: 校验完整性，签名， 防止盗版
	防止调试和注入: 动态调试，注入获取关键数据
	防止应用数据获取: 加密敏感数据
	防止协议直接被盗刷: 加密协议通信

常见的加固厂商
	360/娜迦/梆梆
	爱加密/阿里
	百度/腾讯/网秦/通付盾

常见的加固方式
	类加载技术 
	方法替换技术
	vmp 虚拟机技术

加固厂商特征
	娜迦 libddog.so,libfdog.so
	通付盾 libegis.so
	网秦 libnqshield.so
	盛大 libapssec.so
	瑞星 librsprotect.so
	网易 libnesec.so
	几维 asset/dex.dat, kdpdata.so, libkdp.so, libkwscmm.so

脱壳手法
	修改系统源码, 这个应该破解一切？ 
	通过hook方式对关键函数进行脱壳
	开源工具zjdroid, dexhunter 脱壳
	利用IDA或者GDB动态调试进行脱壳

加固技术的发展历程
	第一代 DEX加密
		proguard 混淆， 其他弱加密
		对抗反编译(添加垃圾代码)
		DEX字符串加密
		静态DEX整体加解密
		自定义DexClassLoader

	第二代 dex抽取与so库加密

2. 静态分析

	静态分析主要就是指在不运行程序的前提下进行程序的逆向分析。
	涉及到的工具: android killer, jeb, jadx

	o1eidtor, dex分析工具

3. 脱壳实例

xposed 模块和frida
[脱壳原理总结](https://bbs.pediy.com/thread-263290.htm)

4. 抓包分析

tcpdump 
	一般用来抓tcp, udp包, 用于不走代理的app抓包, 能抓到https， 但是看不到

fiddler, 
	可以抓http, https 的包, 需要安装证书。 
	虽然可以解密看到https的内容， 但是https本身传输的数据也会加密， 这个时候就得逆向软件来解密了。 

wireshark
	最新版本可以直接调用app上的tcpdump 来抓包， 一般作用是用来分析包。 

抓包容易，关键还是分析, 工具的使用, 分析得有思路
抓包主要提供一个辅助分析的作用， 一般传输的内容都是加密的， 但是可以通过url来辅助搜索逆向代码。

