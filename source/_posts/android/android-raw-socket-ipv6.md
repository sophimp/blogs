---
title: Android raw socket in ipv6
date: 2020-07-29 13:42:43
tags: 
- TCP 
- Raw Socket
- IPv6
categories:
- Android
description: 使用raw socket 实现 IPv6 的 tcp 通信, 验证可否使用raw socket 直接使用 volte 的ipv6呢？ 
---

## 背景

在使用LTE-4G的IPv6地址时，移动运营商的IPv6 不可被ping， 而每台手机开始volte的情况下， 会有两个IPv6 地址。
因此探究一下 raw socket 在 IPv6 上的 TCP 通信，是否可以使用 VoLTE的IPv6 呢？ 是否可控TCP SYN包长呢？ 

## IPv6 协议

找到一个 [发送IPv6](http://www.pdbuchan.com/rawsock/tcp6_ll.c) 示例代码, 
直接将此程序拿过来放到Android JNI 是可以直接编译成功的。但是出现了此问题

```
socket() failed to get socket descriptor for using ioctl()
send raw tcp failed

type=1400 audit(0.0:806): avc: denied { create } for scontext=u:r:untrusted_app_25:s0:c512,c768 tcontext=u:r:untrusted_app_25:s0:c512,c768 
tclass=packet_socket permissive=1
```

这应该就是raw socket 所需 root权限的日志。 

如何获取root权限？ 
1. 使用 magisk 的root, 如何去在app时申请root?
	有magisk 版本可以主动将app提权
	而现在使用的版本， 是自动检测， 有时候就会出现怎么着都不弹窗的提示, 且就算有 root权限， 也可能不能调用api, 这是SEAndroid 的机制
	所以希望还是放在SEAndroid 上

2. 改 selinux 的 te文件, 只有定制ROM吗? 
	修改了 untrustedted_app.te 文件，rom 编译不过去了, 看来简单的添加te 并不行。 
	
3. 关闭selinux是否可行? 

方法一:
```sh
	# 此方法重启后失效
	adb shell setenforce 0  # 设置成permissive 模式
	adb shell setenforce 1  # 设置成enforce 模式
	adb shell getenforce	# 查看当前权限状态
```
	这种方法对于raw socket并不起作用, 日志已经表示了permissive=1

方法二:
	重新编译内核, 去掉 CONFIG_SECURITY_SELINUX=y

## root权限的获取

[SE-Linux 问题解决-untrusted_app_25](https://blog.csdn.net/su749520/article/details/80284543)

修改 system/sepolicy/ 下的 untrusted_app_25.te， 编译都过不了,  编译内核时中断

	neverallow untrusted_app_25 base_typeattr_9 (packet_socket (ioctl read write create getattr setattr lock relabelfrom relabelto append map bind connect listen accept getopt setopt shutdown recvfrom sendto name_bind))

	neverallow check failed at .../built_plat_sepolicy:9633 from system/sepolicy/private/app_neverallows.te:72

	Falied to build policydb

	到这里，只搜索，也看不懂内容了， 系统学习SEAndroid

更多SEAndroid 解析， 有必要单独分析分析，单独写一篇或一个系列吧{%post_link android/android-selinux-1 %}

解决了 raw socket 权限的问题, 接下来socket()打开失败，程序可以正常编译， 但是socket打不开是何原因？ 

## raw socket 

socket 创建不成功

android 使用4G上网， 走的是基带吗？ 基带有网卡功能吗？

支不支持wifi下的socket通信? 

ip电话是如何实现的?

ping通ping不通是因为有限制的NAT技术吗？ 

打电话与发短信又走的是哪个通道? 能否利用这个通道? 

	协议不一样，NAT搞的也是端口绑定，电话和短信应该是没有端口之说的, 使用的是号码。

Voip电话
	
	网络电话是如何实现的, 电话网系统(PSTN)

volte 漏洞

	IP_VoLTE, IP_Data, 确实可以使用两个地址互相访问，现在漏洞已经修复了吗？
	如何使用这两个ip, 在/proc/下并没有看到rmnet0, rmnet1, 但是可以在/proc/net/route 下看到rmnet0_data, rmnet1_ims

	努比亚8.1还不支持ipv6, 先移植一个9.0, 为volte做准备

