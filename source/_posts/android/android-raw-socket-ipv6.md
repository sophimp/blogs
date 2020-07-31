---
title: Android raw socket in ipv6
date: 2020-07-29 13:42:43
tags: 
- Android 
- raw socket
- ipv6
categories:
- Android
description: 使用raw socket 实现 IPv6 的 tcp 通信
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
2. 改 selinux 的 te文件, 只有定制ROM吗? 

## root权限的获取

[SE-Linux 问题解决-untrusted_app_25](https://blog.csdn.net/su749520/article/details/80284543)

更多Android SELinux 解析， 有必要单独分析分析，请看{% android/android-selinux-1 %}


