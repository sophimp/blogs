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

公司有此相关业务，借此机会学习一下 raw socket 在 IPv6 上的 TCP 通信。 

## 当前的进度

找了此相关的示例(), 但都是基于 IPv4 的，移植到IPv6 上，in6_addr 找不到, 

## jni开发

搭建 JNI 环境

jni 函数注册的方法不只一种, 还可以动态注册

## IPv6 协议

[发送IPv6](http://www.pdbuchan.com/rawsock/tcp6_ll.c)

直接将此程序拿过来是可以直接编译成功的, 目的只需发送 TCP SYN 包即可。

## root权限的获取

