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

	NAT是一方面， 没有active也是一方面, 禁ping也是有可能的

打电话与发短信又走的是哪个通道? 能否利用这个通道? 

	打电话与发短信使用的是Lte ipv6地址， 但都是经过ip协议来传输的
	NAT搞的也是端口绑定，电话和短信应该是没有端口之说的, 使用的是号码。

	使用NetworkInterface 可以查看网口， 可以使用

	socket的bind方法可以选择网口。 

Voip电话
	
	网络电话是如何实现的, 电话网系统(PSTN)

volte 漏洞

	IP_VoLTE, IP_Data, 确实可以使用两个地址互相访问，现在漏洞已经修复了吗？
	如何使用这两个ip, 在/proc/下并没有看到rmnet0, rmnet1, 但是可以在/proc/net/route 下看到rmnet0_data, rmnet1_ims

	mokee8.1还不支持ipv6, 先移植一个9.0

Android 如何指定网口发送数据? 
	貌似从Java层面可以做到？ Socket 有bind接口， 绑定本地网卡ip 发送。

如何向sip服务器发送数据？ 

	volte的ipv6 可以从 /proc/net/if_inet6 中查看
	sip服务器地址可以从 /proc/net/ipv6_route 中查看

	通过路由列表可以发送到任何ip

	然而如何区分哪个是sip服务器呢？ 哪个又是volte的ipv6呢？ 人眼可以通过系统的显示来差异化区分，程序如何判断？ 

	发送sip包如何继续通信? 


如何拿到signaling bearer

	先打一个电话或者发一条短信可行吗？ 
	初步尝试，并不可行，

	使用Data网口，可以同时ping通 目标的两个ip
	使用VoLTE网口， 同时ping不通 目标的两个ip
	但是TCP包只有同时为Data网口ip才有响应
	移动作为目标两个ip都ping不通，

	华为手机没有root权限查不到VoLTE网口IP

如何使用这个signaling beaer通信


## 有用的链接

[Android 使用指定网口收发数据](https://zhuanlan.zhihu.com/p/26864594)
[VoLTE Log 分析与主要SIP消息介绍](https://www.it619.net/index.php?edition-view-318-1.html)
[破解并修复VoLTE: 利用隐藏的数据通道和错误的实现方式](http://drops.xmd5.com/static/drops/papers-10259.html)
[How to : Raw Socket in IPv6](https://blog.apnic.net/2017/10/24/raw-sockets-ipv6/)
[VoLTE注册流程详解](https://www.it619.com/forum.php?mod=viewthread&tid=429)
[解决VoLTE IPv6 ping显示unreachable的问题](http://www.suoniao.com/article/43496)
